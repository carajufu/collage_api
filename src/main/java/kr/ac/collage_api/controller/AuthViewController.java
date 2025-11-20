package kr.ac.collage_api.controller;

import java.io.IOException;
import java.security.Principal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.core.io.Resource;

import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.time.LocalDate;

import kr.ac.collage_api.util.BackgroundImageUtils;
import org.springframework.core.io.support.ResourcePatternResolver;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.ac.collage_api.service.DitAccountService;
import kr.ac.collage_api.service.IndexBbsService;
import kr.ac.collage_api.service.IndexScheduleEventService;
import kr.ac.collage_api.service.ScheduleEventService;
import kr.ac.collage_api.service.SpcdeHolidayService;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.CalendarEventVO;
import kr.ac.collage_api.vo.IndexBbsVO;
import kr.ac.collage_api.vo.ScheduleEventVO;
import lombok.extern.slf4j.Slf4j;

/**
 * AuthViewController
 *
 * 목적
 * - JSP 기반 "일반 사용자" 프론트엔드(학생/교수/일반 계정)의 화면 매핑 전용 컨트롤러.
 * - 관리자용 React + JWT 기반 관리자 콘솔과는 역할이 분리된 진입점.
 *
 * 역할
 * 1) 로그인, 회원가입, 아이디 찾기, 비밀번호 재설정 등 계정 관련 JSP의 뷰 이름만 반환한다.
 *    - 실제 인증(아이디/비밀번호 검증), 이메일 인증, 비밀번호 재설정 처리 로직은
 *      별도의 REST API(예: AccountApiController)와 서비스 레이어에서 수행한다.
 *    - 이 컨트롤러는 "인증 상태를 읽어서 화면에 전달"만 하고, 인증 결과를 직접 만들지 않는다.
 *
 * 2) Spring Security 세션 기반 인증과 JSP를 연결하는 뷰 어댑터 역할을 한다.
 *    - 로그인 성공 후 SecurityContextHolder 에 저장된 Authentication 을 읽어서
 *      현재 로그인한 사용자 식별자(acntId)를 가져온다.
 *    - acntId 로 DB에서 AcntVO 를 조회하고, Model/HttpSession 에 넣어 JSP 에서 사용할 수 있게 한다.
 *
 * 3) 관리자용 JWT 구조와의 관계
 *    - JWT(Authorization: Bearer <토큰>)는 "관리자 전용 React 프론트엔드"에서만 사용한다.
 *    - React 관리자는 /api/admin/** 등의 REST API 에 JSON 형태로 로그인 요청을 보내고,
 *      응답으로 accessToken/refreshToken 이 담긴 JSON 을 수신하여 localStorage 등에 저장한다.
 *    - 이 컨트롤러는 그러한 JWT 발급/응답을 다루지 않으며, 관리자 화면도 반환하지 않는다.
 *
 * 4) 공통 로그인 JSP + CustomLoginSuccessHandler + React 이관 흐름
 *    - /login JSP 는 학생/교수/관리자 모두가 사용하는 "공통 로그인 화면"이다.
 *    - POST /login 요청은 Spring Security formLogin().loginProcessingUrl("/login") 에 의해 처리된다.
 *    - 인증이 성공하면 CustomLoginSuccessHandler 가 호출되어, 사용자 권한을 기반으로 분기한다.
 *      예:
 *        - ROLE_ADMIN 포함  → 관리자 전용 React SPA 엔트리(예: /app/admin)로 리다이렉트
 *        - 그 외(학생/교수 등) → JSP 기반 기본 화면(예: / 혹은 /debug/debuging)으로 리다이렉트
 *    - CustomLoginSuccessHandler 는 "어느 프론트엔드로 보낼지"만 결정하며,
 *      관리자 JWT 토큰 발급 자체는 담당하지 않는다.
 *    - 관리자 React 쪽에서는 리다이렉트 이후, 별도의 관리자 로그인 API
 *      (예: POST /api/admin/login 또는 /api/admin/exchange 등)를 호출해서
 *      JSON 응답으로 accessToken/refreshToken 을 수신한 뒤, localStorage 등에 저장한다.
 *
 * 경계(이 컨트롤러가 하지 않는 일)
 * - JWT 생성·검증, 계정 잠금/해제, 권한 변경 등 핵심 인증 로직은 다루지 않는다.
 * - 평문 비밀번호, 토큰 값 등 민감정보는 로그/모델/세션 어디에도 저장하지 않는다.
 *
 * URL 책임 범위
 * - /login, /signup, /account/**, /debug/** 등 JSP 기반 일반 사용자/디버그 화면.
 * - React 관리자 콘솔(/app/** 등)은 별도 컨트롤러/리소스에서 처리한다.
 */
@Slf4j
@Controller
public class AuthViewController {

    @Autowired
    ResourcePatternResolver resourceResolver;
    
    @Autowired
    DitAccountService ditAccountService;
    
    @Autowired
    IndexBbsService indexBbsService;
    
    @Autowired
    SpcdeHolidayService spcdeHolidayService;
    
    @Autowired
    IndexScheduleEventService indexScheduleEventService;
   

    /**
     * GET /login
     *
     * 일반 사용자(학생/교수/관리자 포함) 공통 로그인 화면 반환.
     *
     * 인증 흐름
     * - 화면: /WEB-INF/views/login.jsp
     * - 실제 로그인 처리(아이디/비밀번호 검증, 세션 생성)는
     *   Spring Security 설정(formLogin().loginProcessingUrl("/login") 등)에 의해 수행된다.
     * - 이 메서드는 화면만 반환하고, 인증 로직에는 관여하지 않는다.
     */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    /**
     * GET /signup
     *
     * 일반 사용자 회원가입 화면 반환.
     *
     * 반환 JSP
     * - /WEB-INF/views/signup.jsp
     */
    @GetMapping("/signup")
    public String signupPage() {
        return "signup";
    }

    /**
     * POST /signup
     *
     * 일반 사용자 회원가입 처리 후 /login 으로 리다이렉트.
     *
     * 흐름
     * - 클라이언트 폼 파라미터(acntId, password 등)가 AcntVO 에 바인딩된다.
     *   주의: 폼 input name 은 AcntVO 필드명과 정확히 일치해야 한다.
     *     예) <input name="acntId">   -> AcntVO.acntId
     *         <input name="password"> -> AcntVO.password
     *
     * - DitAccountService.userSave(acntVO)가 내부에서
     *   1) 비밀번호 해시(BCrypt)
     *   2) DB INSERT
     *   3) 기본 권한 부여
     *   를 처리한다.
     *
     * 보안
     * - 비밀번호 평문은 여기서 로그로 남기지 않는다.
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
     * GET /account/find-id
     *
     * 아이디 찾기 모달(팝업) JSP 반환.
     *
     * 반환 JSP
     * - /WEB-INF/views/account/find-id.jsp
     *
     * 실제 아이디 찾기 로직(이메일/휴대폰 검증 등)은
     * 별도 REST API 가 담당하며, 이 메서드는 화면만 열어준다.
     */
    @GetMapping("/account/find-id")
    public String findIdModal() {
        return "account/find-id";
    }

    /**
     * GET /account/reset-pw
     *
     * 비밀번호 재설정 모달(팝업) JSP 반환.
     *
     * 반환 JSP
     * - /WEB-INF/views/account/reset-pw.jsp
     *
     * 실제 재설정 흐름
     * - 1단계: 사용자 식별(아이디/이메일) → 비밀번호 재설정 메일 발송 API 호출
     * - 2단계: 메일 링크 클릭 → 토큰 검증 API 호출
     * - 3단계: 새 비밀번호 설정 API 호출
     *
     * 이 메서드는 위 플로우를 위한 UI 틀만 제공하고,
     * 검증/갱신 로직은 REST 컨트롤러에서 처리한다.
     */
    @GetMapping("/account/reset-pw")
    public String resetPwModal() {
        return "account/reset-pw";
    }

    /**
     * GET /debug/debuging
     *
     * 세션 인증이 완료된 사용자의 디버그용 대시보드 화면.
     * (운영 사용자용 정식 대시보드가 아니라, 현재 인증/세션/계정 매핑이
     *  정상 동작하는지 확인하기 위한 개발·검증용 화면)
     *
     * 동작
     * 1) SecurityContextHolder 에서 Authentication 을 읽는다.
     *    - 일반 사용자 로그인은 Spring Security 세션 기반 인증으로 Authentication 이 세팅된다.
     *    - 관리자용 React + JWT 흐름은 별도 REST API 에서만 사용하며,
     *      이 뷰 컨트롤러는 JWT를 직접 다루지 않는다.
     *
     * 2) Authentication.principal 이 UserDetails(또는 구현체) 인 경우
     *    username 을 acntId 로 간주한다.
     *
     * 3) acntId 로 DB에서 AcntVO(계정 정보 + 권한 목록 포함)를 조회한다.
     *
     * 4) JSP에서 사용하도록 model 에 acntVO 를 담고,
     *    header.jsp 등 공통 레이아웃에서도 재사용할 수 있도록 session 에도 acntVO 를 저장한다.
     *
     * 5) Authentication 이 없거나 principal 이 UserDetails 타입이 아니면
     *    "로그인 상태가 아니거나 비정상"으로 판단하고 redirect:/login 으로 돌려보낸다.
     *
     * 반환 JSP
     * - /WEB-INF/views/debug/debuging.jsp
     *
     * JSP 사용 예
     *   ${acntVO.acntId}
     *   ${acntVO.authorList[0].authorNm}  // ROLE_STUDENT, ROLE_PROF 등
     *
     * 세션 예
     *   ${sessionScope.acntVO.acntId}
     */
    @GetMapping("/debug/debuging")
    public String welcomePage(Model model, HttpSession session) {

        // 현재 요청 스레드에 바인딩된 인증 정보 추출
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // 인증이 없거나 예상 타입이 아니면 로그인 페이지로 돌려보냄
        if (authentication == null || !(authentication.getPrincipal() instanceof UserDetails)) {
            log.info("[AuthViewController:/debug/debuging] no valid authentication -> redirect:/login");
            return "redirect:/login";
        }

        // principal 은 Spring Security 가 세션 기반 인증 후 세팅한 UserDetails
        UserDetails principal = (UserDetails) authentication.getPrincipal();
        String acntId = principal.getUsername();
        log.info("[AuthViewController:/debug/debuging] authenticated acntId={}", acntId);

        // DB에서 계정 상세(권한 목록 포함)를 다시 읽어온다.
        // DitAccountService.findById() 는 ACNT + AUTHOR 조인으로 authorList 를 채우는 구조여야 한다.
        AcntVO acntVO = this.ditAccountService.findById(acntId);
        log.info("[AuthViewController:/debug/debuging] acntVO ={}", acntVO);

        // JSP 1회 렌더링용
        model.addAttribute("acntVO", acntVO);

        // 세션에도 저장해서 header.jsp 등 공통 레이아웃에서도 접근 가능하게 함
        session.setAttribute("acntVO", acntVO);

        // /WEB-INF/views/debug/debuging.jsp 렌더
        return "debug/debuging";
    }
}
