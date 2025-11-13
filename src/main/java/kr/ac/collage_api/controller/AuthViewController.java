package kr.ac.collage_api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import jakarta.servlet.http.HttpSession;
import kr.ac.collage_api.service.DitAccountService;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;

/**
 * AuthViewController
 *
 * 목적
 * - JSP 뷰 반환 전용 컨트롤러.
 * - Spring Security + JWT(jjwt 0.12.x) 
 * 						+ 세션을 충돌 없이 공존시키는 진입점.
 *
 * 역할 분리 원칙
 * 1) 실제 인증(아이디/비번 확인)과 JWT 발급은 REST API(TokenApiController)에서 처리.
 *    이 컨트롤러는 직접 인증 로직 수행하지 않음. 비밀번호도 비교하지 않음.
 *
 * 2) 요청 시 JWT가 Authorization: Bearer <토큰> 헤더로 전달되면
 *    TokenAuthenticationFilter 가 토큰 검증 후 SecurityContextHolder 에 Authentication 주입.
 *    이 컨트롤러는 SecurityContextHolder 를 읽어 현재 사용자 정보를 가져와서 JSP에 전달.
 *
 * 3) JSP는 모델(Model)과 세션(HttpSession) 둘 다 사용 가능.
 *    - model.addAttribute("acntVO", ...) 로 단발 렌더링 데이터 제공
 *    - session.setAttribute("acntVO", ...) 로 header.jsp 등 공통 레이아웃에서 재사용
 *
 * 4) 민감정보(평문 비밀번호 등)는 로그/모델/세션 어디에도 넣지 않음.
 *
 * 엔드포인트
 * - GET  /login
 *      로그인 화면만 반환.
 *      실제 로그인은 JS에서 /api/login 호출 → JWT 발급 → localStorage 저장 흐름.
 *
 * - GET  /signup
 *      회원가입 화면 반환.
 *
 * - POST /signup
 *      회원가입 처리 후 /login 으로 리다이렉트.
 *      여기서 DitAccountService.userSave() 가 비밀번호 해시(BCrypt) 포함 처리를 책임짐.
 *      컨트롤러는 비밀번호 원문을 로그로 남기지 않음.
 *
 * - GET  /user/welcome
 *      "인증된 사용자" 전용 대시보드 화면.
 *      동작 순서:
 *        1) SecurityContextHolder 에서 Authentication 읽음
 *        2) principal(username=acntId) 추출
 *        3) DB에서 계정 상세(AcntVO) 조회
 *        4) model 과 session 에 담고 JSP 렌더링
 *
 * 보안 모델
 * - SecurityConfig 에서 /user/** 는 permitAll 로 열 수 있음(개발 단계).
 *   이 컨트롤러는 내부적으로 Authentication 없으면 redirect:/login 으로 돌려보내어
 *   "화면 접근 가드" 역할을 수행.
 *   운영 단계에서 /user/** 를 authenticated 로 바꾸면 redirect 대신 Spring Security 가 401/403 응답을 주게 할 수도 있음.
 *
 * 제거된 것
 * - POST /login        (취약. 비밀번호 검증 없이 통과시키던 경로였음)
 * - POST /user/welcome (취약. 비밀번호를 로그에 남기던 경로였음)
 *
 * 결과
 * - JWT(Authorization 헤더 기반) + SecurityContextHolder + JSP(Model/Session)까지 모두 일관된 흐름으로 정리됨.
 */
@Slf4j
@Controller
public class AuthViewController {

    @Autowired
    DitAccountService ditAccountService;

    /**
     * GET /login
     *
     * 로그인 화면만 반환.
     * 실제 인증/토큰 발급은 JS -> /api/login (TokenApiController) 호출로 처리됨.
     * /api/login 성공 시 프론트는 accessToken 을 localStorage 등에 저장하고
     * 이후 요청에서 Authorization: Bearer <token> 을 붙여 보냄.
     *
     * 반환 JSP
     *   /WEB-INF/views/login.jsp
     */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    /**
     * GET /signup
     *
     * 회원가입 화면 반환.
     * 반환 JSP
     *   /WEB-INF/views/signup.jsp
     */
    @GetMapping("/signup")
    public String signupPage() {
        return "signup";
    }

    /**
     * POST /signup
     *
     * 회원가입 처리 후 /login 으로 리다이렉트.
     *
     * 흐름:
     * - 클라이언트에서 전달한 폼 파라미터(acntId, password 등)가 AcntVO 로 바인딩됨.
     *   주의: 폼의 input name 은 AcntVO 필드명과 정확히 일치해야 한다.
     *         예) <input name="acntId">  -> AcntVO.acntId
     *             <input name="password">-> AcntVO.password
     *
     * - DitAccountService.userSave(acntVO)가 내부에서 BCrypt 해싱 후 DB INSERT 및 기본 권한 부여까지 처리.
     *
     * 보안:
     * - 비밀번호 평문은 여기에 로그로 남기지 않는다.
     * - DB 저장 전 해시는 서비스 레이어에서 보장해야 한다.
     */
    @PostMapping("/signup")
    public String signup(AcntVO acntVO) {
        log.info("[AuthViewController:/signup] signup request acntId={}", acntVO.getAcntId());

        int result = this.ditAccountService.userSave(acntVO);
        log.info("[AuthViewController:/signup] userSave result={}", result);

        // 가입 완료 후 로그인 페이지로 이동
        return "redirect:/login";
    }

    /**
     * GET /debug/debuging
     *
     * 세션 인증된 사용자의 대시보드 화면.
     *
     * 동작:
     * 1) TokenAuthenticationFilter 가 Authorization 헤더의 JWT 검사
     *    → 유효하면 SecurityContextHolder.getContext().setAuthentication(auth) 수행
     *
     * 2) 여기서 SecurityContextHolder 로부터 Authentication을 읽는다.
     *    principal 은 org.springframework.security.core.userdetails.User
     *    또는 UserDetails 구현체이고 username = acntId.
     *
     * 3) 그 acntId 로 DB에서 AcntVO (계정 + 권한목록 포함)를 조회.
     *
     * 4) JSP에서 쓰도록 model 에 acntVO 로 넣고,
     *    header.jsp 등 다른 JSP에서도 재사용 가능하도록 session 에도 acntVO 저장.
     *
     * 5) 인증이 없거나 principal 을 UserDetails 로 캐스팅할 수 없으면 로그인 화면으로 리다이렉트.
     *
     * 반환 JSP
     *   /WEB-INF/views/user/welcome.jsp
     *
     * JSP 사용 예:
     *   ${acntVO.acntId}
     *   ${acntVO.authorList[0].authorNm}  // ROLE_STUDENT 등
     *
     * 세션에서도 접근 가능:
     *   ${sessionScope.acntVO.acntId}
     */

    @GetMapping("/account/find-id")
    public String findIdModal() {
        return "account/find-id";
    }

    @GetMapping("/account/reset-pw")
    public String resetPwModal() {
        return "account/reset-pw";
    }
    /**
     * GET /debug/debuging
     *
     * 세션 인증된 사용자의 대시보드 화면.
     *
     * 동작:
     * 1) TokenAuthenticationFilter 가 Authorization 헤더의 JWT 검사
     *    → 유효하면 SecurityContextHolder.getContext().setAuthentication(auth) 수행
     *
     * 2) 여기서 SecurityContextHolder 로부터 Authentication을 읽는다.
     *    principal 은 org.springframework.security.core.userdetails.User
     *    또는 UserDetails 구현체이고 username = acntId.
     *
     * 3) 그 acntId 로 DB에서 AcntVO (계정 + 권한목록 포함)를 조회.
     *
     * 4) JSP에서 쓰도록 model 에 acntVO 로 넣고,
     *    header.jsp 등 다른 JSP에서도 재사용 가능하도록 session 에도 acntVO 저장.
     *
     * 5) 인증이 없거나 principal 을 UserDetails 로 캐스팅할 수 없으면 로그인 화면으로 리다이렉트.
     *
     * 반환 JSP
     *   /WEB-INF/views/user/welcome.jsp
     *
     * JSP 사용 예:
     *   ${acntVO.acntId}
     *   ${acntVO.authorList[0].authorNm}  // ROLE_STUDENT 등
     *
     * 세션에서도 접근 가능:
     *   ${sessionScope.acntVO.acntId}
     */

    @GetMapping("/debug/debuging")
    public String welcomePage(Model model, HttpSession session) {

        // 현재 요청 스레드에 바인딩된 인증 정보 추출
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // 인증이 없거나 예상 타입이 아니면 로그인 페이지로 돌려보냄
        if (authentication == null || !(authentication.getPrincipal() instanceof UserDetails)) {
            log.info("[AuthViewController:/user/welcome] no valid authentication -> redirect:/login");
            return "redirect:/login";
        }

        // principal 은 TokenAuthenticationFilter -> TokenProvider.getAuthentication() 에서 세팅한 UserDetails
        UserDetails principal = (UserDetails) authentication.getPrincipal();
        String acntId = principal.getUsername(); // JWT의 subject 로 들어간 값과 동일
        log.info("[AuthViewController:/debug/debuging] authenticated acntId={}", acntId);

        // DB에서 계정 상세(권한 목록 포함)를 다시 읽어온다.
        // DitAccountMapper.findById() 는 ACNT + AUTHOR 조인으로 authorList 채우는 구조여야 한다.
        AcntVO acntVO = this.ditAccountService.findById(acntId);
        log.info("[AuthViewController:/debug/debuging] acntVO ={}", acntVO);

        // JSP 1회 렌더링용
        model.addAttribute("acntVO", acntVO);

        // 세션에도 저장해서 header.jsp 등 공통 레이아웃에서도 접근 가능하게 함
        session.setAttribute("acntVO", acntVO);

        // /WEB-INF/views/user/welcome.jsp 렌더
        return "debug/debuging";
    }
}
