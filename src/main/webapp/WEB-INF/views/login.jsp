<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<%-- 
목적
- 단일 로그인 화면에서 JWT 발급 + 세션 로그인 동시 확보.
- 관리자 분기는 CustomLoginSuccessHandler에서 처리.

흐름
1) 사용자가 아이디·비밀번호 제출
2) /api/login 로 JWT 요청 → 성공 시 localStorage.accessToken 저장
3) 즉시 같은 자격으로 /login(formLogin) 제출 → 세션 생성
4) SavedRequest 또는 /user/welcome 으로 이동

부트스트랩
- 서버 세션 있으면 즉시 /user/welcome
- 세션 없고 localStorage 토큰 유효하면 /user/welcome
--%>

<div id="main-container" class="container-fluid">
	<div class="auth-wrap d-flex justify-content-center">
		<form id="sessionLoginForm" method="post" action="/login"
			autocomplete="off"
			class="card shadow-sm rounded-4 p-4 auth-card needs-validation"
			novalidate>
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />
			<h3 class="mb-2 fw-semibold text-center">로그인</h3>
			<p class="text-secondary small text-center mb-3">서비스를 사용하려면 로그인해
				주세요</p>

			<!-- 서버 측 인증 실패 경고 -->
			<div id="login-alert" class="alert alert-danger py-2 small d-none"
				role="alert"></div>

			<div class="mb-3">
				<label class="form-label">아이디</label> <input type="text"
					class="form-control" name="acntId" placeholder="학번 또는 아이디" required>
				<div class="invalid-feedback">아이디를 입력하세요.</div>
			</div>

			<div class="mb-3">
				<label class="form-label">비밀번호</label> <input type="password"
					class="form-control" name="password" placeholder="비밀번호" required>
				<div class="invalid-feedback">비밀번호를 입력하세요.</div>
			</div>

			<button type="submit" id="login-btn" class="btn btn-primary w-100">로그인</button>
		</form>
	</div>
</div>
</main>

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

<%@ include file="footer.jsp"%>
<script>
/*
[목적/의도]
- 단일 로그인 jsp 화면에서 세션(formLogin)과 JWT 상태를 동시에 처리.
- JWT 유효 시 로딩 오버레이와 5초 카운트다운 후 React SPA(/app)로 자동 이동.
- 세션 인증만 존재 시 기존 페이지(/debug/debuging)로 유지 이동.
- 관리자 페이지 이동시 "리액트 서버 작동"해야하는 제반사항 존재.

[데이터 흐름]
1) 초기 진입: 서버 세션 여부(serverAuthenticated) 확인 → 있으면 /debug/debuging 이동.
2) JWT 확인: localStorage.accessToken 존재 시 /api/check2 POST로 유효성 검증 → valid면 오버레이 표시·카운트다운 후 /app 이동, invalid면 토큰 제거.
3) 폼 제출: HTML5 제약검사 통과 시 /login 제출로 세션 생성.
4) 서버 오류: /login?error 쿼리 감지 시 상단 경고 표시.

[계약]
- /api/check2
  입력: { "barer": string }  // 오탈자 포함 계약을 그대로 유지
  헤더: Content-Type: application/json;charset=UTF-8
  반환: "valid" | 기타 텍스트
  오류: 네트워크 또는 4xx/5xx → 토큰 유지 불가 시 제거.
- /login
  입력: form-urlencoded(acntId, password, _csrf)
  반환: 성공 시 SavedRequest 또는 /user/welcome로 리다이렉트(서버 정책에 따름).

[파라미터 명세]
- localStorage.key: "accessToken" (string, 필수 아님, JWT 원문)
- WELCOME_URL: string, 세션 인증 성공 시 이동 경로. 기본 "/debug/debuging".
- REACT_APP_URL: string, SPA 루트. 기본 "/app".
- REDIRECT_DELAY_MS: number, 카운트다운 총 지연. 기본 5000.

[보안·안전 전제]
- JWT는 로컬 저장소에 존재. XSS 방지 전제 필요. 모든 텍스트 삽입은 textContent로만 처리.
- CSRF는 세션 로그인 경로에만 적용. /api/**는 JWT 검증으로 한정.
- 실패 시 토큰 정리(localStorage.removeItem)로 유효하지 않은 세션 상태 방치 금지.

[유지보수자 가이드]
- /api/check2 계약이 바뀌면 body 필드명("barer")와 응답 파싱 로직을 함께 수정.
- 오버레이 텍스트는 i18n 대상. DOM id 변경 시 showOverlay, updateCountdown, hideOverlay 내 선택자 함께 수정.
- 네트워크 실패 시 침묵 실패를 유지. UX 정책 변경 시 catch 블록에 사용자 메시지 추가 가능.

[근거]
- HTML5 form.checkValidity와 Bootstrap .invalid-feedback로 클라이언트 제약검사 구현.
- Spring Security 표준 오류 쿼리 /login?error 감지로 실패 안내.
*/

const WELCOME_URL = "/debug/debuging";
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

    // 200이 아닌 경우도 실패 처리
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
  form.submit(); // 기본 form 제출. submit 이벤트 재발생 없음
}

document.addEventListener("DOMContentLoaded", async () => {
  // 서버 세션만 존재할 때
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
</script>

