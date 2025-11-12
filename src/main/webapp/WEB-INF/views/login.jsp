<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <form id="sessionLoginForm" method="post" action="/login" autocomplete="off" class="card shadow-sm rounded-4 p-4 auth-card">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      <h3 class="mb-2 fw-semibold text-center">로그인</h3>
      <p class="text-secondary small text-center mb-4">서비스를 사용하려면 로그인해 주세요</p>

      <div class="mb-3">
        <label class="form-label">아이디</label>
        <input type="text" class="form-control" name="acntId" placeholder="학번 또는 아이디" required>
      </div>

      <div class="mb-3">
        <label class="form-label">비밀번호</label>
        <input type="password" class="form-control" name="password" placeholder="비밀번호" required>
      </div>

      <button type="submit" id="login-btn" class="btn btn-primary">로그인</button>
    </form>
  </div>
</div>
</main>
<%@ include file="footer.jsp"%>

<script>
const WELCOME_URL = "/user/welcome";

// 서버 세션 존재 여부를 JSP에서 직접 주입
const serverAuthenticated = <%= (request.getUserPrincipal() != null) ? "true" : "false" %>;

document.addEventListener("DOMContentLoaded", async () => {
  if (serverAuthenticated) {
    location.replace(WELCOME_URL);
    return;
  }

  const token = localStorage.getItem("accessToken");
  if (!token) return;

  try {
    const res = await fetch("/api/check2", {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=UTF-8" },
      body: JSON.stringify({ "barer": token }) // 서버 계약 유지
    });
    const result = (await res.text()).trim();
    if (result === "valid") {
      location.replace(WELCOME_URL);
    } else {
      localStorage.removeItem("accessToken");
    }
  } catch (_) {
    // 무시하고 로그인 화면 유지
  }
});

// 하이브리드 로그인: JWT 발급 → 세션 로그인
document.getElementById("sessionLoginForm").addEventListener("submit", async (e) => {
  e.preventDefault();

  const form = e.currentTarget;
  const btn = document.getElementById("login-btn");
  btn.disabled = true;

  const acntId = form.querySelector('[name="acntId"]').value.trim();
  const password = form.querySelector('[name="password"]').value;

/*   // 1) JWT 발급 시도(실패해도 세션 로그인은 진행)
  try {
    const res = await fetch("/api/login", {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=UTF-8" },
      body: JSON.stringify({ acntId, password })
    });
    if (res.ok) {
    	const token = (await res.text()).trim(); 

        //if (token && token !== "null" && token.length > 20) {
          
        	//localStorage.setItem("accessToken", token);
        }
    }
  } catch (_) {
    // 토큰 실패는 무시하고 세션 로그인 진행
  } */

  // 2) 세션 로그인 진행
  form.submit(); // HTMLFormElement.submit()은 submit 이벤트 재발생 없음
});
</script>
