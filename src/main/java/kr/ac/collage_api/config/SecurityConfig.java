package kr.ac.collage_api.config;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;
import org.springframework.security.web.authentication.DelegatingAuthenticationEntryPoint;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.http.HttpStatus;

// CORS
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.LinkedHashMap;
import java.util.List;

import kr.ac.collage_api.service.impl.UserDetailServiceImpl;
import kr.ac.collage_api.security.AdminHandoverCodeStore;

// CustomLoginSuccessHandler(로그인 성공 이후 권한값으로 분기하여
// 관리자=권한코드 핸드오버, 일반=세션 유지 흐름을 실행하는 성공 처리기임)
import kr.ac.collage_api.security.CustomLoginSuccessHandler;

/**
 * SecurityConfig
 *
 * 목적
 * - Spring Security 6.x 와 JJWT 0.12.x 를 동시에 운용 가능한 보안 설정.
 *
 * 보안 모델
 * 1) API 요청 → JWT 인증
 * - Authorization(HTTP 요청에 인증 정보를 담는 표준 헤더임): Bearer <JWT>
 * - TokenAuthenticationFilter 가 토큰 검증 후 Authentication 주입
 * - 세션 없어도 동작
 *
 * 2) JSP 요청 → 세션 인증
 * - /login 폼 제출(formLogin) 성공 시 스프링 시큐리티가 세션(HttpSession: 서버가 사용자별 상태를 보관하는
 * 저장소임)에 인증 상태 저장
 * - 이후 JSP는 세션 기반 상태를 재사용 가능
 *
 * 3) 세션 정책
 * - SessionCreationPolicy.IF_REQUIRED(요청 처리에 세션이 필요할 때만 생성하는 정책임)
 * - 브라우저 로그인 흐름은 세션 유지 가능, REST 호출(JWT)만 하는 경우는 세션 없이도 정상 동작
 *
 * 4) URL 접근 정책
 * - /login, /signup 등 화면 라우트와 토큰 발급/검증 API는 permitAll
 * - 그 외 anyRequest() 는 인증 필요
 * → 인증은 "세션 기반" 또는 "Bearer JWT 기반" 둘 중 하나로 충족 가능
 *
 * 5) 필터 순서
 * - TokenAuthenticationFilter 를 UsernamePasswordAuthenticationFilter 앞에 둠
 * [근거] 요청에 JWT가 오면 먼저 Authentication 세팅해서 이후 체인에서 이미 인증된 상태로 처리
 *
 * 6) CSRF(Cross-Site Request Forgery: 사용자의 세션을 악용해 의도치 않은 요청을 보내게 만드는 공격임)
 * - [수정 추가: 목적] JSP 폼 보호는 유지하되, /api/** 는 헤더 기반이므로 CSRF 검사 제외
 * - [근거] 세션/쿠키 경로만 CSRF 위험. Authorization 헤더 기반 요청은 타 도메인서 임의 설정 불가.
 *
 * 정리
 * - JSP는 여전히 /login 으로 세션 로그인 가능
 * - API는 Authorization 헤더만으로 동작 가능
 * - 둘은 충돌하지 않고 공존
 *
 * 추가 흐름 설명
 * 요청 생명주기 개요
 * 1 정적 리소스 web.ignoring 에 해당되면 보안 필터 미적용 즉시 서빙
 * 2 그 외는 SecurityFilterChain 진입
 * 2.1 TokenAuthenticationFilter 실행
 * - Authorization 헤더에서 Bearer 토큰 추출
 * - 검증 통과 시 SecurityContext 에 인증 주입
 * - 이 시점 이후 authorizeHttpRequests 의 anyRequest authenticated 통과
 * 2.2 JWT 미보유 또는 무효면 UsernamePasswordAuthenticationFilter 단계로 진행
 * - POST /login 일치 시 DaoAuthenticationProvider 로 자격 검증
 * - 성공 시 세션 생성 후 SavedRequest 있으면 해당 URL 로 복귀
 * 2.3 둘 다 없으면 경로에 따라 엔트리포인트 분기:
 * - /api/** → 401/403 상태코드(JSON 기대)
 * - 그 외 → /login 리다이렉트 (SavedRequest 복귀)
 */
@Configuration
@EnableWebSecurity(debug = false)
@EnableMethodSecurity
public class SecurityConfig implements WebMvcConfigurer {

    @Autowired
    DataSource dataSource; // DB 사용 환경임을 명시. 현재 설정 내부에서 직접 쓰진 않지만 유지.
    @Autowired
    UserDetailServiceImpl detailServiceImpl; // 사용자 계정/권한 조회 서비스 (UserDetailsService 구현)

    // [CORS 설정 Bean], 리액트 호환성 핵심 설정 코드
    // - 목적: Vite 개발 서버(5173) 등 프런트 도메인에서 /api 호출 허용
    // - 근거: JWT 헤더 기반. 쿠키 미사용 → allowCredentials(false)
    // - 흐름: 모든 경로에 대해 Authorization, Content-Type, Accept 허용

    @Bean // CORS 설정 Bean(교차 출처 요청 허용 정책 객체를 스프링 컨테이너에 등록)
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration c = new CorsConfiguration();
        // CorsConfiguration(요청 출처·메서드·헤더 허용 규칙을 담는 객체)

        c.setAllowedOrigins( // Origin(요청을 보낸 출처: 프로토콜+호스트+포트) 화이트리스트 지정
                List.of("http://localhost:5173", "http://127.0.0.1:5173")
        // 리액트 개발 서버만 허용
        );

        c.setAllowedMethods( // HTTP Method(요청 동사) 허용 목록
                List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
        // OPTIONS(프리플라이트 사전 요청) 포함
        );

        c.setAllowedHeaders( // Request Header(클라이언트가 보낼 헤더) 허용 목록
                List.of("Authorization", "Content-Type", "Accept")
        // Authorization(헤더 기반 JWT), Content-Type, Accept 허용
        );

        c.setAllowCredentials(false);
        // Credentials(쿠키/HTTP 인증정보 동반 전송) 비활성화: 헤더 기반 인증 전제

        c.setMaxAge(3600L);
        // Max-Age(프리플라이트 결과 캐시 시간, 초) 3600초 동안 브라우저가 재질문 생략

        UrlBasedCorsConfigurationSource s = new UrlBasedCorsConfigurationSource();
        // CorsConfigurationSource(URL 패턴→정책 매핑 소스)

        s.registerCorsConfiguration("/**", c);
        // URL 패턴 "/**"(전체 경로)에 정책 c 적용(운영은 "/api/**"로 축소 권장)

        return s;
        // HttpSecurity.cors().configurationSource(...)가 참조하여 응답 헤더 Access-Control-* 세팅
    }

    @Bean
    public SecurityFilterChain filterChain(
            HttpSecurity http,
            TokenAuthenticationFilter tokenAuthenticationFilter, // [수정 추가] JWT 필터 주입
            CustomLoginSuccessHandler customLoginSuccessHandler // [수정 추가] 관리자 핸드오버 성공 처리기 주입
    ) throws Exception {

        // 선택적 요청 캐시: 브라우저 뷰만 대상(/api, /.well-known 제외)
        RequestMatcher cacheable = (HttpServletRequest req) -> {
            String uri = req.getRequestURI();
            return !(uri.startsWith("/api/") || uri.startsWith("/.well-known/"));
        };
        HttpSessionRequestCache requestCache = new HttpSessionRequestCache();
        requestCache.setRequestMatcher(cacheable);

        // [예외 처리 분기 엔트리포인트 구성]
        LinkedHashMap<RequestMatcher, AuthenticationEntryPoint> map = new LinkedHashMap<>();
        map.put(new AntPathRequestMatcher("/api/**"), new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED));
        DelegatingAuthenticationEntryPoint delegating = new DelegatingAuthenticationEntryPoint(map);
        delegating.setDefaultEntryPoint(new LoginUrlAuthenticationEntryPoint("/login"));

        return http
                // CORS 활성 + 명시적 소스 연결(있으면 자동 탐색되지만, 가독성, 신뢰성 목적으로 지정)
                .cors(cors -> cors.configurationSource(corsConfigurationSource())) // 프론트 5173 개발 서버 허용 헤더 기반 인증
                // JSP 폼 보호 유지, /api/** 는 CSRF 검사 제외
                .csrf(csrf -> csrf.ignoringRequestMatchers(new AntPathRequestMatcher("/api/**")))

                // 세션 정책 및 동시성 한도 설정(표준 API)
                .sessionManagement(sm -> sm
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                        .sessionConcurrency(sc -> sc.maximumSessions(2)) // 각각 테스트, 디버깅 고려. 운영은 1 권장.
                )

                // 요청 캐시: 브라우저 뷰만 SavedRequest 저장(로그인 후 원 위치 복귀)
                .requestCache(rc -> rc.requestCache(requestCache))

                // URL 권한 규칙
                .authorizeHttpRequests(auth -> auth // URL별 접근 규칙 시작
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ASYNC).permitAll() // FORWARD/ASYNC
                                                                                                          // 디스패처 요청은
                                                                                                          // 무조건 허용
                        .requestMatchers("/login", "/signup"
                        		,"/account/find-id" // 비로그인, 아이디 찾기
                        		,"/account/reset-pw" // 비로그인, 비밀번호 재설정
                        		,"/error").permitAll() // 로그인/회원가입/에러 페이지 공개
                        .requestMatchers( // 공개 API 블록 시작
                                "/api/**",
                                "/api/login", // JWT 발급 API 공개
                                "/api/check", "/api/check2", // 상태 점검 API 공개
                                "/api/token", "/api/token/login", // 토큰 검증·로그인 확인 API 공개
                                "/api/admin/exchange" // 관리자 권한코드→JWT 교환 API 공개
                        ).permitAll() // 위 열거 API 전체 permitAll
                        .requestMatchers("/app/**", "/assets/**", "/favicon.ico").permitAll() // React 번들/정적 에셋/파비콘
                                                                                              // 공개(빈화면 방지)
                        .requestMatchers("/.well-known/**").permitAll() // ACME 등 표준 경로 공개
                        .anyRequest().authenticated() // 나머지 모든 요청은 인증 필요(세션 또는 JWT)
                )

                // [수정 변경] JWT 필터를 UsernamePasswordAuthenticationFilter 앞에 추가
                // 주의: 공개 경로는 필터 내부에서 BYPASS 처리
                .addFilterBefore(tokenAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)

                // [수정 변경] 경로 기반 예외 처리 분기 적용
                .exceptionHandling(e -> e
                        .authenticationEntryPoint(delegating) // /api/** → 401, 그 외 → /login
                        .accessDeniedHandler((req, res, ex) -> {
                            // 권한 부족: API는 403 유지, 웹은 필요 시 별도 페이지 매핑 가능
                            res.sendError(HttpServletResponse.SC_FORBIDDEN);
                        }))

                // HTTP Basic 차단 (Authorization: Basic ... 은 쓰지 않음)
                .httpBasic(b -> b.disable())

                // formLogin 성공 처리기 교체: 관리자=권한코드 핸드오버, 일반=세션 유지
                .formLogin(fl -> fl
                        .loginPage("/login") // GET /login -> login.jsp
                        .loginProcessingUrl("/login") // POST /login -> 스프링 시큐리티가 직접 인증
                        .usernameParameter("acntId") // login.jsp <input name="acntId">
                        .passwordParameter("password") // login.jsp <input name="password">
                        .failureUrl("/login?error")
                        .successHandler(customLoginSuccessHandler) // 관리자 핸드오버 분기 연결
                        .permitAll())

                // logout: 세션 무효화 후 /login 으로 이동 (JWT 클라이언트는 자체 토큰 삭제 필요)
                .logout(lo -> lo
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout", "GET")) // 앵커 클릭 로그아웃 허용 테스트 시 편의
                        .logoutSuccessUrl("/login") // 로그아웃 후 로그인 페이지 복귀
                        .invalidateHttpSession(true) // 세션 무효화
                        .permitAll())

                .build();
    }

    // FullCalendar 로컬 파일 전용 매핑
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/js/fullcalendar/**")
                .addResourceLocations("classpath:/static/js/fullcalendar/");
    }

    /**
     * 정적 리소스는 보안 필터 자체를 타지 않게 무시.
     * 이유: css/js/img 등은 로그인 전에도 필요.
     *
     * /static/**, /js/** 등은 DispatcherServlet 이전에 바로 서빙되므로
     * SecurityFilterChain 인가 검사와 무관하게 열어둔다.
     */
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return web -> web.ignoring().requestMatchers(
                "/static/**", // 정적
                "/adminlte/**", // 테마
                "/images/**", // 이미지
                "/js/**", // 스크립트
                "/css/**", // 스타일
                "/favicon.ico", // 파비콘
                "/.well-known/**", // 표준 경로
                "/app/**", // 리액트 빌드 산출물 경로
                "/assets/**", // 리액트 정적 에셋
                "/resources/**" // 풀캘린더 로컬 사용
        );
    }

    /**
     * JWT 인증 필터
     *
     * TokenAuthenticationFilter 동작 요약:
     * 1) Authorization 헤더에서 Bearer 토큰 추출
     * 2) TokenProvider.validToken() 으로 서명/만료 검증
     * 3) 유효하면 TokenProvider.getAuthentication() 으로 Authentication 생성
     * 4) SecurityContextHolder에 setAuthentication()
     * 5) filterChain.doFilter(...) 로 다음 필터로 넘김
     *
     * 결과:
     * - 세션 없이도 "이미 인증된 사용자"로 인식 가능
     *
     * 구현 주의:
     * - 공개 경로(/login, /signup, /api/login, /api/check*, 정적 리소스 등)는 빠르게 BYPASS
     * - 토큰 에러는 여기서 sendError 하지 말고 체인 진행 → 최종 엔트리포인트에서 401 일관 처리
     */
    @Bean
    public TokenAuthenticationFilter tokenAuthenticationFilter() {
        return new TokenAuthenticationFilter();
    }

    /**
     * AuthenticationManager
     *
     * DaoAuthenticationProvider 기반.
     * - detailServiceImpl (UserDetailsService 구현) 사용
     * -> DB에서 acntId로 사용자 조회
     * -> BCrypt로 저장된 패스워드 리턴
     * - bCryptPasswordEncoder() 로 raw password vs 해시 비교
     *
     * 사용처:
     * - formLogin 시 Spring Security 내부적으로 사용
     * - TokenApiController (/api/login) 도 직접
     * AuthenticationManager.authenticate(...) 호출해 자격 검증 가능
     */
    @Bean
    public AuthenticationManager authenticationManager(BCryptPasswordEncoder encoder) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(detailServiceImpl);
        provider.setPasswordEncoder(encoder);
        return new ProviderManager(provider);
    }

    /**
     * BCryptPasswordEncoder
     *
     * 비밀번호 저장/검증 기준.
     * - 회원가입 시 평문 비밀번호를 BCrypt로 해싱해 DB PASSWORD 컬럼에 저장
     * - 로그인 시 사용자가 제출한 평문 비밀번호와 DB 해시를 비교
     *
     * 보안 팁
     * - 기본 strength 는 합리적 기본값. 운영 환경에서 CPU 상황에 맞춰 조정 가능
     */
    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public CustomLoginSuccessHandler customLoginSuccessHandler(AdminHandoverCodeStore store) {
        return new CustomLoginSuccessHandler(store);
    }
}