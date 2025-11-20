<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%@ include file="index-header.jsp"%>
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
</head>
<body>

<style>
.navbar-landing.main-header {
  background-color: #272A3A !important;
}
/* 헤더 회원가입 버튼 – 살짝 밝은 톤 */
.navbar-util .btn-outline-signup {
    background-color: rgba(15, 23, 42, 0.25);
    border: 1px solid rgba(148, 163, 184, 0.7);
    color: #e5e7eb;
}

</style>
<%--
  [뷰 목적]
  - 하나의 로그인 화면에서 세션(formLogin) + JWT 상태를 동시에 관리.
  - 비밀번호 UX 팁(보기/숨기기, Caps/Num 표시, 규칙 안내)을 적용해 로그인 오류를 줄이고 사용자가 스스로 검증할 수 있게 함.

  [동작 흐름]
  1) 초기 진입
     - 서버 세션 존재(serverAuthenticated=true) 시: 바로 /debug/debuging 로 이동.
     - 세션 없으면 localStorage.accessToken 확인 → /api/check2 로 검증 후 유효하면 /app 으로 자동 이동.
  2) 로그인 시도
     - 사용자가 아이디(acntId), 비밀번호(password)를 입력.
     - HTML5 checkValidity로 클라이언트 검증 → 실패 시 Bootstrap invalid-feedback 표시.
     - 성공 시 /login 으로 form 제출 → 세션 생성.
  3) 오류 처리
     - /login?error 파라미터 존재 시: 상단 경고 메시지 노출.
  4) 보조 기능
     - “아이디 찾기”: /account/find-id 팝업 오픈.
     - “비밀번호 재설정”: /account/reset-pw 팝업 오픈.
     - 비밀번호 입력: 보기/숨기기 + Caps/Num 표시 + 규칙 안내.

  [원리/구조]
  - 인증 구조
    · JWT: React SPA(/app) 용, /api/check2 로 유효성 검증 후 자동 리다이렉트.
    · 세션: JSP 기반 화면(/debug/debuging) 용, /login formLogin 처리.
  - 비밀번호 UX 구조
    · 규칙 텍스트(PASSWORD_RULE_TEXT)를 로그인 화면에서도 항상 노출.
    · 보기/숨기기(toggleLoginPassword)로 오타 검증 가능.
    · Caps/Num 상태 표시(capsIndicator, numIndicator)로 비의도 입력 방지.
--%>

<main class="main-content-with-header">
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
	        서비스를 사용하려면 로그인하세요
	      </p>
	
	      <!-- 서버측 인증 실패 경고: SPRING_SECURITY_LAST_EXCEPTION 또는 errorMessage 사용 가능 -->
	      <%-- JSTL 사용 시:
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
	
	      <!-- 비밀번호 (보기/숨기기 + Caps/Num + 규칙 안내) -->
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
	            aria-describedby="passwordFeedback passwordRuleText capsIndicator numIndicator"
	          />
	          <button type="button"
	                  class="btn btn-outline-secondary"
	                  id="toggleLoginPassword"
	                  tabindex="-1">
	            보기
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
	
	<!-- JWT 오버레이 -->
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
</main>

<script>
/*
  [비밀번호 입력 헬퍼]
  - 보기/숨기기 토글 + Caps/Num Lock 상태 표시를 한 번에 처리.
  - 동일 패턴을 비밀번호 재설정 팝업에서도 재사용 가능.
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
      toggleBtn.textContent = isPassword ? "숨기기" : "보기";
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
      // 일부 브라우저에서 getModifierState 비지원이면 조용히 무시
    }
  };

  input.addEventListener("keydown", updateModifierState);
  input.addEventListener("keyup", updateModifierState);
  input.addEventListener("focus", (e) => updateModifierState(e));
  input.addEventListener("blur", () => {
    if (caps) caps.classList.add("d-none");
    // Num Lock 안내는 blur 시 유지해도 되지만 여기서는 그대로 둠
  });
}

/*
  [로그인/토큰 처리 메타]

  [목적/의도]
  - 하나의 jsp에서 세션 로그인(/login)과 JWT 유지(/api/check2)를 동시에 관리.
  - JWT가 이미 유효하면 굳이 로그인 폼을 다시 입력시키지 않고 React SPA(/app)로 바로 전환.

  [데이터 흐름]
  1) 초기 로드
     - serverAuthenticated=true → /debug/debuging 로 즉시 이동.
     - serverAuthenticated=false → localStorage.accessToken 확인.
  2) JWT 체크
     - accessToken 존재 → /api/check2 로 POST { "barer": token } 전송.
     - 응답이 "valid" 이면 오버레이 + 카운트다운 후 /app 이동.
     - 그 외(에러/invalid)면 accessToken 삭제 후 로그인 폼 유지.
  3) 폼 제출
     - HTML5 checkValidity 통과 시 /login 으로 제출.
     - 실패 시 .was-validated 부여 → Bootstrap invalid-feedback 노출.
  4) 오류 안내
     - /login?error 쿼리 있으면 상단 경고 문구 출력.

  [계약]
  - /api/check2
    · 요청 body: { "barer": string } (오탈자 포함 계약 유지).
    · 응답: HTTP 200 + "valid" 텍스트이면 성공, 그 외는 실패로 간주.
  - /login
    · 요청: acntId, password, _csrf (form-urlencoded).
    · 응답: SavedRequest 또는 /user/welcome 등으로 리다이렉트(서버 정책).

  [보안·안전 전제]
  - JWT는 localStorage 에 저장되므로 XSS 방지 전제가 필요. DOM 삽입은 textContent 사용.
  - CSRF는 세션 로그인(/login)에만 적용, /api/** 는 JWT 인증 경로로 분리.
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

  // 서버 세션만 존재할 때: JSP/세션 기반 화면으로 이동
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