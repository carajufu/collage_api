package kr.ac.collage_api.config;

import java.io.IOException;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.collage_api.config.jwt.TokenProvider;
import lombok.extern.slf4j.Slf4j;

/*
TokenAuthenticationFilter

[코드 의도]
- HTTP 요청에서 베어러 토큰(Bearer token, HTTP 인증 토큰 전달 규격)을 추출해
  서명 검증 후 SecurityContext(보안 컨텍스트, 현재 요청의 인증 상태 저장소)에 Authentication(인증 객체) 설정.
- 세션 기반 인증과 공존. 기존 컨텍스트가 있으면 덮어쓰지 않음.

[데이터 흐름(입력→가공→출력)]
- 입력: Authorization 헤더 "Bearer <JWT>"
- 가공: 토큰 파싱 → TokenProvider.validToken → TokenProvider.getAuthentication
- 출력: 성공 시 SecurityContextHolder.getContext().setAuthentication(authentication)
       실패·없음 시 체인 그대로 진행

[계약(전제·에러·성공조건)]
- 성공: 유효 토큰이면 Authentication 주입. 컨트롤러 진입 시 @PreAuthorize 등에서 권한 사용 가능.
- 실패: 예외 삼키고 통과. 최종 엔트리포인트가 401 또는 403 결정.
- 프리플라이트 OPTIONS, 정적 리소스, 공개·교환 엔드포인트는 필터 생략(shouldNotFilter).

[파라미터 명세]
- 요청 헤더 Authorization(String, 선택): "Bearer <JWT>" 형식. 대소문자 무시.
- 내부 상수:
  - HEADER_AUTHORIZATION = "Authorization"
  - SCHEME_BEARER = "bearer"

[보안·안전 전제]
- 토큰 원문 로그 금지. 반드시 마스킹 로그만 출력.
- 기존 세션 인증을 보존. 컨텍스트가 이미 채워져 있으면 무시.
- 검증·파싱 로직은 TokenProvider로 위임. 필터는 오케스트레이션만 담당.

[유지보수자 가이드]
- 우회 목록(shouldNotFilter)은 SecurityConfig의 authorizeHttpRequests 규칙과 중복·충돌 없도록 관리.
- 교환 엔드포인트(/api/admin/exchange)는 반드시 우회 목록 유지. 교환 흐름 간섭 금지.
- TokenProvider 인터페이스 변경 시 validToken, getAuthentication 시그니처 동기화.

[전문용어 첫 등장 풀이]
- JWT(JSON Web Token, 서명된 클레임 토큰): 위변조 방지용 서명 포함 JSON 클레임 묶음.
- SecurityContext(보안 컨텍스트): 현재 쓰레드 요청 범위의 인증·권한 상태 저장소.
- Authentication(인증 객체): principal(인증 주체)와 authorities(권한 목록) 등 인증 정보 묶음.

[근거]
- Spring Security 6.x OncePerRequestFilter 패턴 및 Bearer 스킴 처리 관례.
*/

@Slf4j
public class TokenAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private TokenProvider tokenProvider;
    // TokenProvider: 토큰 서명·만료 검증, Authentication 복원 유틸

    private static final String HEADER_AUTHORIZATION = "Authorization"; // 표준 인증 헤더
    private static final String SCHEME_BEARER = "bearer"; // Bearer 스킴(대소문자 무시)

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {

        // 프리플라이트 즉시 통과
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            filterChain.doFilter(request, response);
            return;
        }

        // 헤더 존재만 로그(원문 노출 금지)
        final String authorizationHeader = request.getHeader(HEADER_AUTHORIZATION);
        if (authorizationHeader != null) {
            log.debug("[TAF] Authorization header present");
        }

        // "Bearer <token>" 파싱
        final String token = resolveBearerToken(authorizationHeader);

        // 토큰 없음 → 즉시 패스
        if (token == null) {
            filterChain.doFilter(request, response);
            return;
        }

        log.debug("[TAF] token(masked)={}", mask(token));

        // 기존 인증 보존(세션 등)
        if (SecurityContextHolder.getContext().getAuthentication() == null) {
            try {
                if (tokenProvider.validToken(token)) { // 서명·만료 검증
                    Authentication authentication = tokenProvider.getAuthentication(token);
                    if (authentication != null) {
                        SecurityContextHolder.getContext().setAuthentication(authentication);
                        log.debug("[TAF] context set. principal={}, authorities={}",
                                authentication.getName(), authentication.getAuthorities());
                    } else {
                        log.debug("[TAF] authentication null from provider");
                    }
                } else {
                    log.debug("[TAF] invalid token (validToken=false)");
                }
            } catch (Exception ex) {
                // 예외 삼키고 체인 진행(최종 엔트리포인트에서 401/403 판단)
                log.debug("[TAF] token validation error: {}", ex.toString());
            }
        }
        // 이거 있어야 JWT 체인 동작
        filterChain.doFilter(request, response);
    }

    // Bearer 파서
    private String resolveBearerToken(String header) {
        if (header == null)
            return null;
        int sp = header.indexOf(' ');
        if (sp <= 0)
            return null;
        String scheme = header.substring(0, sp).trim().toLowerCase(Locale.ROOT);
        if (!SCHEME_BEARER.equals(scheme))
            return null;
        String token = header.substring(sp + 1).trim();
        return token.isEmpty() ? null : token;
    }

    // 토큰 마스킹
    private String mask(String token) {
        if (token == null || token.length() <= 20)
            return "<null/short>";
        return token.substring(0, 10) + "..." + token.substring(token.length() - 6);
    }

    /**
     * 공개/정적·교환 경로 BYPASS
     * - 성능·로그 절감 및 교환 플로우 간섭 방지
     */
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String uri = request.getRequestURI();
        if ("OPTIONS".equalsIgnoreCase(request.getMethod()))
            return true;

        return
        // 정적
        uri.startsWith("/static/")
                || uri.startsWith("/adminlte/")
                || uri.startsWith("/images/")
                || uri.startsWith("/js/")
                || uri.startsWith("/css/")
                || uri.equals("/favicon.ico")
                || uri.startsWith("/.well-known/")
                // 화면
                || uri.equals("/login")
                || uri.equals("/signup")
                // SPA(React) 번들
                || uri.equals("/app")
                || uri.startsWith("/app/")
                || uri.startsWith("/assets/")
                // 공개 API
                || uri.startsWith("/api/login")
                || uri.startsWith("/api/check")
                || uri.startsWith("/api/token")
                || uri.equals("/api/admin/exchange") 
                	// 교환 엔드포인트 간섭 금지
                || uri.startsWith("/error");
    }
}
