<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>대덕대학교-로그인</title>

    <!-- Pretendard + Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/pretendard/dist/web/static/pretendard.css" />
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />

    <!-- 메인 포털 전용 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/main-portal.css" />

    <style>
        /*
          [레이아웃 목적]
          - 헤더와 푸터를 제외한 중간 영역에 로그인 카드를 세로/가로 중앙 정렬.
          - 화면 높이가 작을 때도 카드가 잘리지 않고 스크롤로 전부 보이도록 함.
        */
        .login-layout {
            /* 헤더+푸터 합산 높이를 보수적으로 160px 정도로 가정 */
            min-height: calc(80vh - 160px);
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #fdf6ee;
            padding-top: 9rem;
            padding-bottom: -8rem;
        }

        @media (max-height: 700px) {
            .login-layout {
                /* 낮은 화면에서는 위쪽 정렬로 전부 보이게 */
                align-items: flex-start;
            }
        }

        .navbar-landing.main-header {
            background-color: #272A3A !important;
        }

        /* 헤더 회원가입 버튼 고정 흰색 톤 */
        .navbar-util .btn-outline-signup {
            background-color: rgba(15, 23, 42, 0.25);
            border: 1px solid rgba(148, 163, 184, 0.7);
            color: #e5e7eb;
        }
       /* ================================
	       로그인 카드 너비 조절 포인트
	       - 아래 변수 값만 바꾸면 카드 최대 너비가 변경됨
	      ================================= */
	    :root {
	        --login-card-max-width: 380px;  /* 카드 너비 */
	    }
	
	    .auth-card {
	        width: 100%;
	        max-width: var(--login-card-max-width);
	        margin: 0 auto;                 /* 중앙 정렬 보정 */
	    }
	
	    .navbar-landing.main-header {
	        background-color: #272A3A !important;
	    }
	
	    .navbar-util .btn-outline-signup {
	        background-color: rgba(15, 23, 42, 0.25);
	        border: 1px solid rgba(148, 163, 184, 0.7);
	        color: #e5e7eb;ㄴ
	    }
    </style>
</head>
<body>

<%@ include file="index-header.jsp"%>

<%--
  [뷰 목적]
  - 하나의 로그인 화면에서 세션 기반 로그인과 JWT 상태 유지를 동시에 관리.
  - 비밀번호 UX 보조(보기 토글, Caps Lock 표시)를 제공해 오타로 인한 실패를 줄임.
  - 헤더/푸터 사이 중앙에 로그인 카드를 배치해 어떤 해상도에서도 전체가 보이게 함.

  [동작 흐름]
  1) 초기 진입
     - serverAuthenticated=true 이면 세션이 이미 있으므로 WELCOME_URL 로 즉시 이동.
     - 세션이 없으면 localStorage.accessToken 을 확인 후 /api/check2 로 검증.
  2) 토큰 검증
     - accessToken 유효하면 오버레이를 띄우고 카운트다운 후 React 앱(REACT_APP_URL)으로 이동.
     - 토큰이 없거나 invalid 이면 localStorage 에서 제거하고 로그인 폼 유지.
  3) 로그인 시도
     - 사용자가 아이디(acntId), 비밀번호(password)를 입력.
     - HTML5 checkValidity 로 클라이언트 검증 후 통과 시 /login 으로 폼 제출.
  4) 오류 처리
     - /login?error 쿼리가 있으면 상단 경고 영역에 메시지 노출.

  [계약]
  - /login
    입력 파라미터
      acntId   문자열, 필수, 아이디 혹은 학번
      password 문자열, 필수, 현재 비밀번호
      _csrf    문자열, 필수, Spring Security CSRF 토큰
    성공 시
      서버에서 SavedRequest 또는 기본 성공 URL 로 리다이렉트
    실패 시
      /login?error 쿼리와 함께 다시 이 JSP 로 돌아옴

  - /api/check2
    요청
      POST application json
      body  { "barer": "<accessToken 문자열>" }
    응답
      HTTP 200 이고 본문이 "valid" 이면 토큰 유효
      그 외 상태코드나 본문은 모두 실패로 간주하고 토큰 삭제

  [보안 전제]
  - JWT 는 localStorage 에 저장되므로 XSS 방지가 필수이며, 동적 텍스트 삽입 시 textContent 사용.
  - 세션 로그인은 CSRF 토큰을 요구하며 /api/** 경로는 JWT 인증 전용으로 분리.
--%>

<main class="main-content-with-header login-layout">
    <!-- 로그인 폼 영역 -->
    <div id="main-container" class="container-fluid">
        <div class="auth-wrap d-flex justify-content-center">
            <!-- 계약: POST /login, CSRF 필수, 파라미터 acntId·password -->
            <form
                id="sessionLoginForm"
                class="card shadow-sm rounded-4 p-4 auth-card needs-validation"
                action="/login"
                method="post"
                role="form"
                aria-label="세션 로그인 폼"
                autocomplete="off"
                novalidate
            >
                <!-- CSRF 토큰 -->
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <h3 class="mb-2 fw-semibold text-center">로그인</h3>
                <p class="text-secondary small text-center mb-3">
                    서비스를 사용하려면 로그인하세요.
                </p>

                <!-- 서버측 인증 실패 경고: SPRING_SECURITY_LAST_EXCEPTION 또는 errorMessage 사용 가능 -->
                <%-- JSTL 사용 시 예시
                <c:if test="${not empty SPRING_SECURITY_LAST_EXCEPTION or not empty errorMessage}">
                    <div id="login-alert" class="alert alert-danger py-2 small" role="alert">
                        <c:out value="${errorMessage != null ? errorMessage : SPRING_SECURITY_LAST_EXCEPTION.message}" />
                    </div>
                </c:if>
                --%>
                <div id="login-alert" class="alert alert-danger py-2 small d-none" role="alert"></div>

                <!-- 아이디 -->
                <div class="mb-3">
                    <label for="acntId" class="form-label">아이디</label>
                    <input
                        id="acntId"
                        name="acntId"
                        type="text"
                        class="form-control"
                        placeholder="학번 또는 아이디"
                        required
                        autofocus
                        inputmode="text"
                        autocapitalize="none"
                        spellcheck="false"
                        autocomplete="username"
                        aria-describedby="acntIdFeedback"
                    />
                    <div id="acntIdFeedback" class="invalid-feedback">아이디를 입력하세요</div>
                </div>

                <!-- 비밀번호 (보기 토글 + Caps Lock 표시) -->
                <div class="mb-3">
                    <label for="password" class="form-label">비밀번호</label>

                    <div class="input-group">
                        <input
                            id="password"
                            name="password"
                            type="password"
                            class="form-control"
                            placeholder="비밀번호"
                            required
                            autocomplete="current-password"
                            aria-describedby="passwordFeedback capsIndicator"
                        />
                        <button type="button"
                                class="btn btn-outline-secondary"
                                id="toggleLoginPassword"
                                tabindex="-1">
                            &nbsp;보기&nbsp;
                        </button>
                    </div>

                    <div id="passwordFeedback" class="invalid-feedback">
                        비밀번호를 입력하세요
                    </div>

                    <div class="small mt-1">
                        <span id="capsIndicator" class="text-danger d-none">Caps Lock 켜짐</span>
                    </div>
                </div>

                <!-- 보조 링크 -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="small">
                        <a href="javascript:void(0)"
                           class="text-primary text-decoration-underline"
                           onclick="openFindIdPopup()"
                           role="button">아이디 찾기</a>

                        <span class="text-secondary mx-1">|</span>

                        <a href="javascript:void(0)"
                           class="text-primary text-decoration-underline"
                           onclick="openResetPwPopup()"
                           role="button">비밀번호 재설정</a>
                    </div>
                </div>

                <!-- 제출 -->
                <button type="submit" id="login-btn" class="btn btn-primary w-100">
                    로그인
                </button>
            </form>
        </div>
    </div>
</main>

<!-- JWT 오버레이: 토큰 검증 및 자동 이동 시 사용자에게 상태를 보여주는 레이어 -->
<div id="auth-overlay"
     class="position-fixed top-0 start-0 vw-100 vh-100 d-none bg-body bg-opacity-75"
     style="z-index: 1050;">
    <div
        class="h-100 d-flex flex-column justify-content-center align-items-center text-center">
        <div class="card shadow-sm rounded-4 p-4" style="min-width: 320px;">
            <div class="mb-3">
                <div class="spinner-border" role="status" aria-hidden="true"></div>
            </div>
            <h6 id="overlay-title" class="mb-1">토큰 확인 중</h6>
            <p id="overlay-desc" class="small text-secondary mb-0">잠시만 기다려주세요</p>
        </div>
    </div>
</div>

<script>
/*
  [비밀번호 입력 헬퍼 메타]

  목적
  - 로그인 비밀번호 입력 시 보기 토글과 Caps Lock 상태 표시를 제공해 오타로 인한 실패를 줄임.
  데이터 흐름
  - 입력 필드와 토글 버튼, 상태 표시 요소를 id 로 바인딩.
  - 클릭 시 input type 을 password / text 로 전환하고 버튼 텍스트를 변경.
  - keydown, keyup 이벤트에서 getModifierState 로 Caps Lock 상태를 읽어 표시.
  계약
  - pwInputId  필수, 문자열, 비밀번호 input 요소의 id
  - toggleBtnId 선택, 문자열, 토글 버튼 id, 없으면 토글 기능은 비활성
  - capsId     선택, 문자열, Caps Lock 상태 표시 요소 id
  - numId      선택, 문자열, Num Lock 상태 표시 요소 id
*/
function setupPasswordHelpers(pwInputId, toggleBtnId, capsId, numId) {
  const input = document.getElementById(pwInputId);
  const toggleBtn = document.getElementById(toggleBtnId);
  const caps = document.getElementById(capsId);
  const num = document.getElementById(numId);

  if (!input) return;

  // 보기/숨기기 토글
  if (toggleBtn) {
    toggleBtn.addEventListener("click", () => {
      const isPassword = input.type === "password";
      input.type = isPassword ? "text" : "password";
      toggleBtn.textContent = isPassword ? "숨기기" : " 보기 ";
      input.focus();
    });
  }

  // Caps/Num Lock 표시
  const updateModifierState = (e) => {
    try {
      if (caps) {
        const capsOn = e.getModifierState && e.getModifierState("CapsLock");
        caps.classList.toggle("d-none", !capsOn);
      }
      if (num) {
        const numOn = e.getModifierState && e.getModifierState("NumLock");
        num.classList.toggle("d-none", !numOn);
      }
    } catch (_e) {
      // 일부 브라우저에서 getModifierState 를 지원하지 않는 경우 조용히 무시
    }
  };

  input.addEventListener("keydown", updateModifierState);
  input.addEventListener("keyup", updateModifierState);
  input.addEventListener("focus", (e) => updateModifierState(e));
  input.addEventListener("blur", () => {
    if (caps) caps.classList.add("d-none");
  });
}

/*
  [로그인/토큰 처리 메타]

  목적
  - 세션 기반 JSP 로그인과 JWT 기반 React 앱 진입을 한 화면에서 조정.
  - 이미 유효한 JWT 가 있으면 불필요한 로그인 과정을 생략하고 바로 React 앱으로 보냄.

  데이터 흐름
  1) DOMContentLoaded 시
     - serverAuthenticated 가 true 면 즉시 WELCOME_URL 로 이동.
     - false 면 localStorage.accessToken 을 읽어 checkJwtAndRedirect 실행.
  2) checkJwtAndRedirect
     - 토큰이 없으면 아무 것도 하지 않음.
     - 토큰이 있으면 /api/check2 로 POST 요청 후 결과가 valid 이면
       오버레이 안내와 함께 일정 시간 후 REACT_APP_URL 로 location.replace.
     - 실패 또는 예외 시 토큰 삭제 후 로그인 폼 유지.
  3) 로그인 폼 제출
     - HTML5 checkValidity 로 검증 후 유효하면 submit, 아니면 invalid-feedback 표시.
  4) hasLoginError 가 true 면 직전 실패 메시지를 상단 경고 영역에 표시.

  계약
  - WELCOME_URL  문자열, 세션 인증 사용자가 이동할 JSP 기반 초기 화면 경로.
  - REACT_APP_URL 문자열, JWT 기반 React SPA 진입 경로.
  - REDIRECT_DELAY_MS 숫자, 토큰 유효 시 React 앱으로 이동하기 전 대기 시간 밀리초.

  보안 전제
  - JWT 는 localStorage 에 저장되므로 XSS 위험이 없도록 템플릿 삽입 시 innerHTML 대신 textContent 사용.
  - /api/check2 는 CORS 허용 목록과 JWT 인증 필터 뒤에서만 허용.
*/

const WELCOME_URL = "/";
const REACT_APP_URL = "/app";
const REDIRECT_DELAY_MS = 5000;

const serverAuthenticated = <%= (request.getUserPrincipal() != null) ? "true" : "false" %>;
const hasLoginError = <%= (request.getParameter("error") != null) ? "true" : "false" %>;

function $(id) { return document.getElementById(id); }

function showOverlay(titleText, descText) {
  const ov = $("auth-overlay");
  if (titleText) $("overlay-title").textContent = titleText;
  if (descText) $("overlay-desc").textContent = descText;
  ov.classList.remove("d-none");
}
function hideOverlay() { $("auth-overlay").classList.add("d-none"); }

function showFormAlert(msg) {
  const el = $("login-alert");
  el.textContent = msg;
  el.classList.remove("d-none");
}

function updateCountdown(totalMs, onDone) {
  let remain = Math.floor(totalMs / 1000);
  const desc = $("overlay-desc");
  const tick = () => { desc.textContent = `${remain}초 후 React 페이지로 이동합니다.`; };
  tick();
  const iv = setInterval(() => {
    remain--;
    if (remain <= 0) {
      clearInterval(iv);
      onDone();
      return;
    }
    tick();
  }, 1000);
}

async function checkJwtAndRedirect() {
  const token = localStorage.getItem("accessToken");
  if (!token) return;

  showOverlay("토큰 확인 중", "저장된 로그인 토큰을 확인하고 있습니다.");
  try {
    const res = await fetch("/api/check2", {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=UTF-8" },
      body: JSON.stringify({ "barer": token }) // 서버 계약 유지
    });

    const text = await res.text();
    const result = text.trim();

    if (res.ok && result === "valid") {
      $("overlay-title").textContent = "로그인 유지 확인됨";
      updateCountdown(REDIRECT_DELAY_MS, () => location.replace(REACT_APP_URL));
      return;
    }

    // invalid 또는 비정상 응답
    localStorage.removeItem("accessToken");
    hideOverlay();
  } catch (_e) {
    // 네트워크 실패 시 조용히 오버레이 닫음
    hideOverlay();
  }
}

function handleSessionLoginSubmit(e) {
  e.preventDefault();
  const form = e.currentTarget;
  if (!form.checkValidity()) {
    form.classList.add("was-validated");
    return;
  }
  $("login-btn").disabled = true;
  form.submit();
}

document.addEventListener("DOMContentLoaded", async () => {
  // 비밀번호 UX 헬퍼 활성화
  setupPasswordHelpers("password", "toggleLoginPassword", "capsIndicator", "numIndicator");

  // 서버 세션이 이미 있으면 JSP 기반 초기 화면으로 이동
  if (serverAuthenticated) {
    location.replace(WELCOME_URL);
    return;
  }

  // 직전 로그인 실패 안내
  if (hasLoginError) {
    showFormAlert("아이디 또는 비밀번호가 올바르지 않습니다.");
  }

  // JWT 확인 및 SPA 이동 시퀀스
  await checkJwtAndRedirect();

  // 폼 제출 바인딩
  $("sessionLoginForm").addEventListener("submit", handleSessionLoginSubmit);
});

// 아이디 찾기 팝업
window.openFindIdPopup = function() {
  const width = 500;
  const height = 600;
  const left = (window.screen.width / 2) - (width / 2);
  const top = (window.screen.height / 2) - (height / 2);

  window.open(
    "/account/find-id",
    "findIdPopup",
    `width=${width},height=${height},left=${left},top=${top},scrollbars=no,resizable=no`
  );
};

// 비밀번호 재설정 팝업
window.openResetPwPopup = function() {
  const width = 500;
  const height = 600;
  const left = (window.screen.width / 2) - (width / 2);
  const top = (window.screen.height / 2) - (height / 2);

  window.open(
    "/account/reset-pw",
    "resetPwPopup",
    `width=${width},height=${height},left=${left},top=${top},scrollbars=no,resizable=no`
  );
};
</script>

<%@ include file="index-footer.jsp"%>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

</body>
</html>