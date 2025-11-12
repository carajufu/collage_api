package kr.ac.collage_api.controller;

import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import kr.ac.collage_api.config.jwt.TokenProvider;
import kr.ac.collage_api.security.RequestTokenResolver;
import kr.ac.collage_api.service.TokenService;
import kr.ac.collage_api.service.impl.CustomUser;
import kr.ac.collage_api.service.impl.UserDetailServiceImpl;
import kr.ac.collage_api.vo.CreateAccessTokenRequestVO;
import kr.ac.collage_api.vo.CreateAccessTokenResponseVO;
import kr.ac.collage_api.vo.AcntVO;

/*
TokenApiController

[코드 의도]
- 인증 흐름을 두 갈래로 제공.
  1) 사용자명/비밀번호 → 세션 검증 후 액세스 토큰(JWT, 서명된 클레임 토큰) 발급
  2) 전달받은 액세스 토큰으로 사용자 조회 및 유효성 검증
- 계약 유지 최우선. 기존 응답 포맷과 HTTP 상태 코드를 보수적으로 유지.

[데이터 흐름(입력→가공→출력)]
- /api/login        : 입력(acntId, password) → AuthenticationManager 인증 → TokenService 발급 → 토큰 문자열
- /api/check        : 입력(Authorization: Bearer, barer) → TokenProvider.getAuthentication → "valid"/"invalid"
- /api/check2       : 입력(JSON: barer) → 동일 검증 → "valid"/"invalid"
- /api/token        : 입력(refreshToken) → 현재 미구현 → 501 + null 페이로드
- /api/token/login  : 입력(Authorization: Bearer 또는 JSON: barer) → TokenProvider 파싱 → UserDetails 로드 → AcntVO
- /api/token/login(GET) : 동일하되 헤더만 사용

[계약(전제·에러·성공조건)]
- 성공: 유효 자격증명 시 토큰 발급 또는 계정 정보(AcntVO) 반환.
- 실패: 기존 계약 유지. /api/login 은 null 문자열을 200 OK 바디로 반환. /api/token 은 501.
- 토큰 키명 "barer" 철자 유지(하위 호환).

[파라미터 명세]
- 헤더 Authorization(String, 선택): "Bearer <JWT>" 형식 우선 사용.
- 바디/폼 barer(String, 선택): 대체 소스. RequestTokenResolver 가 우선순위 처리.
- /api/login 바디: AcntVO(acntId:String 필수, password:String 필수).
- 반환
  - /api/login: String | null
  - /api/check, /api/check2: "valid" | "invalid" (text/plain)
  - /api/token: CreateAccessTokenResponseVO(accessToken:String|null), 501
  - /api/token/login: AcntVO | null

[보안·안전 전제]
- 토큰 원문 로그 금지. 마스킹 유틸(RequestTokenResolver.mask) 필수 사용.
- 본 컨트롤러는 검증·서명 로직을 직접 수행하지 않음. TokenProvider 에 위임.
- CORS(교차 출처 리소스 공유, Cross-Origin Resource Sharing): @CrossOrigin("*")는 개발 편의. 운영 시 도메인 제한 권장(계약 불변성에는 영향 없음).

[유지보수자 가이드]
- 계약을 깨지 않으려면 시그니처와 콘텐츠 타입 고정 유지.
- "barer" 키 변경 금지. 신규 키 추가 시 병행 지원 후 단계적 마이그레이션.
- 토큰 스키마 확장 시 RequestTokenResolver 우선순위만 조정.

[전문용어 첫 등장 풀이]
- 베어러 토큰(Bearer token, HTTP 인증 토큰 전달 규격): Authorization 헤더에 토큰을 담아 전송하는 방식.
- JWT(JSON Web Token, 서명된 클레임 토큰): 서버 서명으로 위변조 방지된 JSON 클레임 묶음.
- AuthenticationManager(인증 관리자): 사용자 자격검증을 수행하는 스프링 시큐리티 구성요소.
- Principal(프린시펄, 인증 주체): 인증된 사용자 식별자.

[근거]
- Spring Security 6.x 구성 관례, HTTP Authorization 베어러 스킴 관례.
*/

@Slf4j
@RestController
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // 프록시/개발 편의. 운영 분리 시 도메인 지정.
public class TokenApiController {

    private final AuthenticationManager authenticationManager;
    private final UserDetailServiceImpl detailServiceImpl;
    private final TokenProvider tokenProvider;
    private final TokenService tokenService;
    private final RequestTokenResolver tokenResolver;

    /**
     * /api/login
     * 사용자명/비밀번호로 인증 후 액세스 토큰 발급
     *
     * 데이터 흐름:
     * - 입력: { acntId, password }
     * - 처리: AuthenticationManager.authenticate → TokenService.issueAccessToken
     * - 출력: 토큰 문자열. 실패 시 null (계약 유지)
     *
     * 계약:
     * - consumes: application/json
     * - produces: text/plain
     * - HTTP 200 고정. 바디 값으로 성공/실패 식별
     *
     * 보안:
     * - 토큰 로그 마스킹 필수
     */
    @PostMapping(
        value = "/api/login",
        consumes = MediaType.APPLICATION_JSON_VALUE,
        produces = MediaType.TEXT_PLAIN_VALUE
    )
    public String login(@RequestBody AcntVO request) {
        final String acntId = request.getAcntId();
        final String rawPw  = request.getPassword();
        log.info("[/api/login] attempt acntId={}", acntId);
        try {
            authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(acntId, rawPw)
            );
            String accessToken = tokenService.issueAccessToken(acntId);
            log.info("[/api/login] issued token(masked)={}", tokenResolver.mask(accessToken));
            return accessToken; // 기존 계약 유지: 문자열 토큰
        } catch (Exception ex) {
            log.info("[/api/login] failed acntId={} reason={}", acntId, ex.getMessage());
            return null; // 기존 계약 유지
        }
    }

    /**
     * /api/check
     * 토큰 유효성 점검(헤더 또는 폼 파라미터)
     *
     * 데이터 흐름:
     * - 입력: Authorization: Bearer <JWT> 또는 barer 폼 파라미터
     * - 처리: TokenProvider.getAuthentication(token) null 여부
     * - 출력: "valid" | "invalid" (text/plain)
     */
    @PostMapping(value = "/api/check", produces = MediaType.TEXT_PLAIN_VALUE)
    public String checkToken(String barer, HttpServletRequest req) {
        String token = tokenResolver.resolve(req, barer, null);
        log.info("[/api/check] token(masked)={}", tokenResolver.mask(token));
        return isValid(token) ? "valid" : "invalid";
    }

    /**
     * /api/check2
     * 토큰 유효성 점검(JSON 바디 버전)
     *
     * 데이터 흐름:
     * - 입력: JSON { "barer": "<JWT>" }
     * - 처리/출력: /api/check 와 동일
     *
     * 계약:
     * - consumes: application/json
     * - produces: text/plain
     * - 키명 "barer" 유지(하위 호환)
     */
    @PostMapping(
        value = "/api/check2",
        consumes = MediaType.APPLICATION_JSON_VALUE,
        produces = MediaType.TEXT_PLAIN_VALUE
    )
    public String checkToken2(@RequestBody Map<String, Object> map, HttpServletRequest req) {
        String bodyToken = (map != null ? (String) map.get("barer") : null); // 키명 'barer' 유지
        String token = tokenResolver.resolve(req, null, bodyToken);
        log.info("[/api/check2] token(masked)={}", tokenResolver.mask(token));
        return isValid(token) ? "valid" : "invalid";
    }

    /**
     * /api/token
     * 리프레시 기반 재발급 스텁(미구현)
     *
     * 계약:
     * - 항상 501 반환. 바디는 { "accessToken": null }
     * - 추후 구현 시에도 응답 스키마 유지 권장
     */
    @PostMapping(
        value = "/api/token",
        consumes = MediaType.APPLICATION_JSON_VALUE,
        produces = MediaType.APPLICATION_JSON_VALUE
    )
    public ResponseEntity<CreateAccessTokenResponseVO> createNewAccessToken(
        @RequestBody CreateAccessTokenRequestVO request
    ) {
        log.info("[/api/token] not-impl refresh(masked)={}",
            tokenResolver.mask(request != null ? request.getRefreshToken() : null));
        return ResponseEntity.status(501).body(new CreateAccessTokenResponseVO(null));
    }

    /**
     * /api/token/login (POST)
     * 토큰으로 사용자 세부정보 조회
     *
     * 데이터 흐름:
     * - 입력: JSON { "barer": "<JWT>" } 또는 Authorization: Bearer 헤더
     * - 처리: TokenProvider.getAuthentication → username 추출 → UserDetails 로드 → AcntVO 반환
     * - 실패: null
     *
     * 계약:
     * - consumes: application/json
     * - produces: application/json
     */
    @PostMapping(
        value = "/api/token/login",
        consumes = MediaType.APPLICATION_JSON_VALUE,
        produces = MediaType.APPLICATION_JSON_VALUE
    )
    public AcntVO tokenLogin(@RequestBody Map<String, Object> map, HttpServletRequest req) {
        String bodyToken = (map != null ? (String) map.get("barer") : null);
        String token = tokenResolver.resolve(req, null, bodyToken);
        log.info("[/api/token/login][POST] token(masked)={}", tokenResolver.mask(token));
        Authentication auth = parse(token);
        if (auth == null) return null;
        String username = ((UserDetails) auth.getPrincipal()).getUsername();
        CustomUser user = (CustomUser) detailServiceImpl.loadUserByUsername(username);
        return user.getAcntVO();
    }

    /**
     * /api/token/login (GET)
     * 헤더만으로 사용자 세부정보 조회
     *
     * 데이터 흐름:
     * - 입력: Authorization: Bearer <JWT>
     * - 처리/출력: POST 버전과 동일
     */
    @GetMapping(value = "/api/token/login", produces = MediaType.APPLICATION_JSON_VALUE)
    public AcntVO tokenLoginGet(HttpServletRequest req) {
        String token = tokenResolver.resolve(req, null, null);
        log.info("[/api/token/login][GET] token(masked)={}", tokenResolver.mask(token));
        Authentication auth = parse(token);
        if (auth == null) return null;
        CustomUser user = (CustomUser) detailServiceImpl.loadUserByUsername(auth.getName());
        return user.getAcntVO();
    }

    /* ===== 내부 유틸 ===== */

    /**
     * 토큰 유효성 검증 헬퍼
     * - TokenProvider.getAuthentication(token) 성공 여부만 본다
     */
    private boolean isValid(String token) {
        if (token == null) return false;
        try { return tokenProvider.getAuthentication(token) != null; }
        catch (Exception e) { return false; }
    }

    /**
     * 토큰 파싱 → Authentication
     * - 예외는 경고 로그 후 null로 정규화
     */
    private Authentication parse(String token) {
        if (token == null) return null;
        try { return tokenProvider.getAuthentication(token); }
        catch (Exception e) {
            log.warn("[/api/token/login] parse err: {}", e.toString());
            return null;
        }
    }
}
