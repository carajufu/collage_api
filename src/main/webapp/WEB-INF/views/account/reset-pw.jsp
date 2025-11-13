<!-- /WEB-INF/views/account/reset-pw.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>비밀번호 재설정</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- 팝업 전용 기본 폰트 / Bootstrap / Icons -->
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/pretendard/dist/web/static/pretendard.css" />
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

<%--
    [뷰 레벨 요약]

    1) 코드 의도
       - 로그인 화면의 "비밀번호 재설정" 링크를 새 창(window.open)으로 띄우는 전용 팝업 화면.
       - 이메일 + 아이디 + 메일로 받은 인증코드를 검증한 뒤, 사용자가 직접 새 비밀번호를 설정하게 함.
       - 자동 생성 비밀번호는 제공하지 않고, 규칙 안내 + Caps 상태 표시 + 보기/숨기기 버튼으로 UX 보조.
       - 추가 정책:
         · 인증코드 검증(백엔드 /api/account/email/verify 성공) 전까지 새 비밀번호/확인 필드는 readonly 유지.
         · 새 비밀번호와 확인 입력이 서로 일치하지 않으면 안내 텍스트로 즉시 피드백.
         · 둘이 일치하고 전체 검증을 통과하면 submit 직전에 confirm 창으로 최종 동의 확인.

    2) 데이터 흐름
       - 사용자가 이메일(email), 아이디(acntId), 인증코드(code),
         새 비밀번호(newPassword), 새 비밀번호 확인(newPasswordConfirm)을 입력.
       - [코드 발송 버튼]
         · 최초 클릭 =>> fetch("/api/account/email/send") 로 JSON({email, acntId}) POST.
         · 서버에서 임시 인증코드 생성 후 이메일 발송, 성공 여부를 문자열 또는 상태 코드로 응답.
         · 성공 시:
           - resetPwResult 영역에 성공 메시지 출력.
           - 버튼 텍스트를 "코드 발송" =>> "인증 코드 확인" 으로 변경.
           - 내부 상태 플래그(codeSent)를 true 로 설정.
       - [인증 코드 확인 버튼(두 번째 이후 클릭)]
         · JSON({email, acntId, code}) 를 /api/account/email/verify 로 전송.
         · 서버에서 세션에 저장된 인증코드와 TTL, 컨텍스트(email, acntId)를 재검증.
         · "OK" 수신 시:
           - codeVerified = true
           - 새 비밀번호/확인 입력 필드 readonly 해제 + 포커스 + 스크롤 다운.

       - [비밀번호 변경 버튼]
         · HTML5 checkValidity() + Bootstrap .was-validated 로 클라이언트 검증.
         · 비밀번호/확인 불일치 시 setCustomValidity 로 실패 처리 + 안내 텍스트 노출.
         · 인증코드 미검증(codeVerified=false)인 경우 submit 차단 + 안내 메시지 출력.
         · 위 조건을 모두 통과하면 window.confirm("비밀번호를 변경하시겠습니까?") 로 최종 확인 후 submit.

    3) 계약(Contract)
       - POST /api/account/email/send
         · Content-Type: application/json;charset=UTF-8
         · Body: { "email": string, "acntId": string }
         · Response: "OK"(성공) | 그 외 문자열 또는 오류 코드.
       - POST /api/account/email/verify
         · Content-Type: application/json;charset=UTF-8
         · Body: { "email": string, "acntId": string, "code": string }
         · Response: "OK"(성공) | 그 외 문자열 또는 오류 코드.
       - POST /api/account/password/reset
         · Content-Type: application/x-www-form-urlencoded
         · Form: email, acntId, code, newPassword, _csrf
         · Response: 컨트롤러에서 반환하는 문자열 코드("OK", "INVALID_PARAM" 등).
           현재 구현은 ResponseEntity<String> 기반 REST 응답이므로,
           팝업에서는 비밀번호 변경 성공 후 "OK" 텍스트 페이지로 전환됨.

    4) 파라미터 명세(프론트 기준)
       - rpwEmail (input[name=email], type=email)
         · 필수, 로그인 계정에 등록된 이메일 주소.
       - rpwId (input[name=acntId], type=text)
         · 필수, 로그인 아이디.
       - rpwCode (input[name=code], type=text)
         · 필수, 이메일로 전달된 1회용 인증코드.
       - rpwNew (input[name=newPassword], type=password, readonly 초기화)
         · 필수, PASSWORD_RULE_TEXT 에 제시된 규칙을 만족해야 함.
       - rpwNewConfirm (비밀번호 확인용, readonly 초기화)
         · 필수, rpwNew 와 값이 동일해야 함.
       - resetPwResult (div)
         · 선택, 이메일 발송/검증 결과 메시지 표시용.
       - pwMismatchHelp (div)
         · 선택, 비밀번호/확인 불일치 시 텍스트 안내 표시.

    5) 보안·안전 전제
       - HTTPS 환경 전제, 이메일/아이디/코드는 서버에서 다시 검증해야 함(클라이언트 검증은 편의).
       - 인증코드는 서버 저장 시 만료 시간과 시도 횟수 제한을 두어 무작위 대입 공격 방지.
       - 비밀번호 저장은 단방향 해시(BCrypt 등) + 적절한 work factor 사용.
       - 필요 시 AJAX 요청에도 CSRF 헤더 추가(X-CSRF-TOKEN) 권장.

    6) 유지보수자 가이드
       - URL 변경 시: form action, fetch URL("/api/account/email/send", "/api/account/email/verify") 모두 동시에 수정.
       - PASSWORD_RULE_TEXT 변경 시: 백엔드 검증 로직과 동일하게 유지해야 함.
       - resetPwResult / pwMismatchHelp 영역은 향후 서버-side 메시지 렌더링에도 재사용 가능.
  --%>

<style>
body {
  margin: 0;
  background-color: #f5f7fb;
  font-family: "Pretendard", system-ui, -apple-system, BlinkMacSystemFont,
    "Segoe UI", sans-serif;
}

.popup-wrapper {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.popup-card {
  width: 100%;
  max-width: 480px;
  background-color: #ffffff;
  border-radius: 16px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
  padding: 32px 32px 24px;
}

.popup-title {
  font-size: 20px;
  font-weight: 700;
  text-align: center;
  margin-bottom: 6px;
  color: #111827;
}

.popup-subtitle {
  font-size: 13px;
  text-align: center;
  color: #6b7280;
  margin-bottom: 20px;
  line-height: 1.5;
}

.form-label {
  font-size: 13px;
  font-weight: 600;
  color: #374151;
  margin-bottom: 6px;
}

.form-control {
  font-size: 14px;
  height: 44px;
  border-radius: 10px;
  border-color: #d1d5db;
}

.form-control:focus {
  border-color: #2563eb;
  box-shadow: 0 0 0 1px rgba(37, 99, 235, 0.25);
}

.form-control::placeholder {
  color: #9ca3af;
  font-size: 13px;
}

.form-text,
.invalid-feedback {
  font-size: 12px;
}

.input-group .btn {
  font-size: 13px;
  border-radius: 10px;
}

.btn-primary {
  height: 44px;
  border-radius: 999px;
  font-weight: 600;
  font-size: 14px;
  background-color: #2563eb;
  border-color: #2563eb;
}

.btn-primary:hover {
  background-color: #1d4ed8;
  border-color: #1d4ed8;
}

.popup-footer-text {
  margin-top: 10px;
  font-size: 12px;
  color: #9ca3af;
  text-align: center;
}
</style>
</head>
<body>
  <c:set var="PASSWORD_RULE_TEXT"
          value="8~20자리, 영문 대/소문자·숫자·특수문자 중 2종류 이상 조합" />

  <div class="popup-wrapper">
    <div class="popup-card">
      <!-- 상단 타이틀/설명 -->
      <h1 class="popup-title">비밀번호 재설정</h1>
      <p class="popup-subtitle">
        등록된 이메일과 아이디, 인증코드를 확인한 뒤<br>새 비밀번호를 직접 설정합니다.
      </p>

      <!-- 메인 폼: 비밀번호 변경 요청 -->
      <form id="resetPwForm" class="needs-validation" method="post"
            action="/api/account/password/reset" novalidate>
        <!-- CSRF 토큰: Spring Security -->
        <input type="hidden" name="${_csrf.parameterName}"
               value="${_csrf.token}" />

        <!-- 이메일 -->
        <div class="mb-3">
          <label for="rpwEmail" class="form-label">등록 이메일</label>
          <input id="rpwEmail" name="email" type="email"
                 class="form-control"
                 required autocomplete="email" />
          <div class="invalid-feedback">이메일을 입력하세요.</div>
        </div>

        <!-- 아이디 -->
        <div class="mb-3">
          <label for="rpwId" class="form-label">아이디</label>
          <input id="rpwId" name="acntId" type="text"
                 class="form-control"
                 required autocomplete="username"
                 value="${param.acntId}" />
          <div class="invalid-feedback">아이디를 입력하세요.</div>
        </div>

        <!-- 인증코드 + 발송 버튼 -->
        <div class="mb-3">
          <label for="rpwCode" class="form-label">인증코드</label>
          <div class="input-group">
            <input id="rpwCode" name="code" type="text"
                   class="form-control" required />
            <button type="button" class="btn btn-outline-secondary"
                    id="btnSendCode">코드 발송</button>
          </div>
          <div class="invalid-feedback">인증코드를 입력하세요.</div>
        </div>

        <!-- 결과 메시지 (메일 발송/검증 결과 표시용) -->
        <div id="resetPwResult"
             class="alert alert-info py-2 small mt-3 d-none"
             role="status"></div>

        <!-- 새 비밀번호: 보기/숨기기 + Caps 표시 + 규칙 안내
             - 초기 상태: readonly (인증코드 검증 전까지 입력 불가)
        -->
        <div class="mb-3">
          <label for="rpwNew" class="form-label">새 비밀번호</label>
          <div class="input-group">
            <input id="rpwNew" name="newPassword" type="password"
                   class="form-control" required readonly
                   autocomplete="new-password"
                   aria-describedby="pwRuleText pwCaps" />
            <button type="button" class="btn btn-outline-secondary"
                    id="toggleResetPassword" tabindex="-1">보기</button>
          </div>

          <div class="form-text mt-1" id="pwRuleText">
            <c:out value="${PASSWORD_RULE_TEXT}" />
          </div>

          <div class="small mt-1">
            <span id="pwCaps" class="text-danger d-none">Caps Lock 켜짐</span>
          </div>

          <div class="invalid-feedback">새 비밀번호를 입력하세요.</div>
        </div>

        <!-- 새 비밀번호 확인: 비밀번호 일치 여부 검증 -->
        <div class="mb-3">
          <label for="rpwNewConfirm" class="form-label">새 비밀번호 확인</label>
          <input id="rpwNewConfirm" name="newPasswordConfirm" type="password"
                 class="form-control" required readonly
                 autocomplete="new-password" />
          <!-- 실시간 일치 여부 안내 텍스트(불일치 시 활성화) -->
          <div id="pwMismatchHelp"
               class="form-text text-danger d-none">
            새 비밀번호와 확인 입력이 서로 일치하지 않습니다.
          </div>
          <div class="invalid-feedback">
            새 비밀번호와 동일하게 입력해 주세요.
          </div>
        </div>

        <!-- 버튼 영역 -->
        <div class="d-grid gap-2 mt-3">
          <button type="submit" class="btn btn-primary">비밀번호 변경</button>
          <button type="button" class="btn btn-outline-secondary"
                  onclick="window.close()">닫기</button>
        </div>
      </form>

      <div class="popup-footer-text">
        비밀번호 변경 완료 후에는<br>기존 비밀번호로 더 이상 로그인할 수 없습니다.
      </div>
    </div>
  </div>

  <!-- Bootstrap JS: CDN 사용 (404 방지) -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

  <script>
  /*
    [스크립트 전역 설명]

    1) 코드 의도
       - 팝업 크기/위를 중앙으로 맞추고, 폼 검증과 비밀번호 보조 기능(보기/숨기기, Caps 상태 표시)을 제공.
       - "코드 발송" 버튼 클릭 시 이메일 인증 코드를 요청하고, 성공/실패 결과를 화면에 표시.
       - 이후 버튼 텍스트가 "인증 코드 확인" 으로 전환된 상태에서 다시 클릭하면
         사용자가 입력한 인증코드를 백엔드(/api/account/email/verify)로 보내 검증.
       - 인증코드 검증 성공 시:
         · 새 비밀번호/확인 입력 필드 readonly 해제
         · 비밀번호 입력 필드로 포커스 이동
         · 비밀번호 입력 영역으로 스크롤 자동 이동
       - 새 비밀번호와 확인 입력이 서로 다르면:
         · HTML5 customValidity 로 검증 실패 처리
         · pwMismatchHelp 텍스트를 통해 불일치 안내
       - 둘이 일치하고 전체 검증 통과 후:
         · submit 직전에 window.confirm 으로 "비밀번호를 변경하시겠습니까?" 확인.

    2) 데이터 흐름(프론트)
       - window.load =>> resizeTo / moveTo 로 팝업 440x630 중앙 정렬.
       - form.submit =>>
         · validatePasswordMatch() 로 일치 여부 갱신
         · checkValidity()
         · 인증코드 미검증(codeVerified=false) 시 submit 차단
         · 모든 검증 통과 후 confirm 창에서 취소 시 submit 차단.
       - setupPasswordHelpers =>> keydown/keyup/focus/blur 이벤트로 Caps 상태 UI 반영.
       - btnSendCode.click =>>
         · 1차: /api/account/email/send 로 JSON POST, 성공 시 codeSent=true + 버튼/메시지 업데이트.
         · 2차: /api/account/email/verify 로 JSON POST, 성공 시 codeVerified=true + 비밀번호 필드 readonly 해제, 자동 스크롤.
  */

  // 1. 팝업 크기 고정 및 중앙 정렬
  window.addEventListener("load", function () {
    try {
      const w = 440;
      const h = 630;
      console.log("[reset-pw] window.load =>> resizeTo", w, h);
      window.resizeTo(w, h);
      window.moveTo(
        Math.round((screen.availWidth - w) / 2),
        Math.round((screen.availHeight - h) / 2)
      );
    } catch (e) {
      console.warn("[reset-pw] window control is blocked by browser policy:", e);
    }
  });

  // 2. 비밀번호 도움 기능: 보기/숨기기 + Caps 상태 표시
  function setupPasswordHelpers(pwInputId, toggleBtnId, capsId, numId) {
    /*
      [함수 의도]
      - 단일 비밀번호 input 에 대해:
        · 보기/숨기기 토글 버튼을 연결하고,
        · CapsLock/NumLock 상태를 선택적으로 표시.

      [파라미터]
      - pwInputId : 비밀번호 input 요소의 id (필수)
      - toggleBtnId : 보기/숨기기 버튼 id (옵션, 없으면 토글 기능 생략)
      - capsId : CapsLock 상태를 표시할 span id (옵션)
      - numId : NumLock 상태를 표시할 span id (옵션, 현재 화면에서는 사용하지 않음)

      [계약]
      - 지정된 id 요소가 없으면 해당 기능은 조용히 skip.
    */

    const input     = document.getElementById(pwInputId);
    const toggleBtn = document.getElementById(toggleBtnId);
    const capsSpan  = capsId ? document.getElementById(capsId) : null;
    const numSpan   = numId ? document.getElementById(numId) : null;

    if (!input) {
      console.warn("[reset-pw] setupPasswordHelpers: input not found:", pwInputId);
      return;
    }

    // 보기/숨기기 토글
    if (toggleBtn) {
      toggleBtn.addEventListener("click", () => {
        const isPassword = input.type === "password";
        input.type = isPassword ? "text" : "password";
        toggleBtn.textContent = isPassword ? "숨기기" : "보기";
        console.log(
          "[reset-pw] toggle password visibility:",
          isPassword ? "show" : "hide"
        );
        input.focus();
      });
    }

    // Caps/Num 상태 표시
    const updateState = (e) => {
      try {
        if (capsSpan && e.getModifierState) {
          const capsOn = e.getModifierState("CapsLock");
          capsSpan.classList.toggle("d-none", !capsOn);
          console.log("[reset-pw] CapsLock =", capsOn);
        }
        if (numSpan && e.getModifierState) {
          const numOn = e.getModifierState("NumLock");
          numSpan.classList.toggle("d-none", !numOn);
          console.log("[reset-pw] NumLock =", numOn);
        }
      } catch (err) {
        console.warn("[reset-pw] updateState error:", err);
      }
    };

    input.addEventListener("keydown", updateState);
    input.addEventListener("keyup", updateState);
    input.addEventListener("focus",  updateState);
    input.addEventListener("blur", () => {
      if (capsSpan) capsSpan.classList.add("d-none");
    });
  }

  // 3. 메인 초기화: 폼 검증 + 코드 발송/인증 fetch + 비밀번호 일치 체크
  (function () {
    /*
      [초기화 블록 의도]
      - resetPwForm, btnSendCode, resetPwResult, rpwNew, rpwNewConfirm, pwMismatchHelp 요소를 한 번만 조회.
      - 폼 submit 시:
        · validatePasswordMatch() 호출로 비밀번호/확인 일치 여부를 customValidity 에 반영.
        · HTML5 checkValidity() + .was-validated 로 기본 검증 수행.
        · codeVerified=false 이면 submit 차단 후 안내.
        · 모든 검증을 통과한 뒤 confirm 창에서 사용자가 "취소" 선택 시 submit 차단.
      - "코드 발송" 버튼에 비동기 fetch 핸들러 부착.
      - codeSent, codeVerified 플래그로 "발송 전/후", "인증 성공 여부" 상태를 구분.
      - 비밀번호/확인 input 은 초기 readonly=true, verify 성공 시 readonly=false 로 전환.
    */

    const form           = document.getElementById("resetPwForm");
    const btnSendCode    = document.getElementById("btnSendCode");
    const resultBox      = document.getElementById("resetPwResult");
    const pwInput        = document.getElementById("rpwNew");
    const pwConfirmInput = document.getElementById("rpwNewConfirm");
    const pwMismatchHelp = document.getElementById("pwMismatchHelp");

    // 인증 메일 발송/검증 상태 플래그
    let codeSent = false;
    let codeVerified = false;

    if (!form) {
      console.error("[reset-pw] resetPwForm not found");
      return;
    }

    // 새 비밀번호/확인 입력 필드는 초기 상태에서 readonly 유지
    if (pwInput) {
      pwInput.readOnly = true;
    }
    if (pwConfirmInput) {
      pwConfirmInput.readOnly = true;
    }

    // 비밀번호/확인 일치 여부 검증 함수
    const validatePasswordMatch = () => {
      if (!pwInput || !pwConfirmInput) return;

      const pw1 = pwInput.value || "";
      const pw2 = pwConfirmInput.value || "";

      // 확인 필드가 비어 있으면 customValidity 초기화만 수행
      if (!pw2) {
        pwConfirmInput.setCustomValidity("");
        if (pwMismatchHelp) {
          pwMismatchHelp.classList.add("d-none");
        }
        return;
      }

      if (pw1 !== pw2) {
        // 불일치: HTML5 검증 실패 + 안내 텍스트 표시
        pwConfirmInput.setCustomValidity("비밀번호가 일치하지 않습니다.");
        if (pwMismatchHelp) {
          pwMismatchHelp.textContent =
            "새 비밀번호와 확인 입력이 서로 일치하지 않습니다.";
          pwMismatchHelp.classList.remove("d-none");
        }
        console.warn("[reset-pw] password mismatch");
      } else {
        // 일치: customValidity 초기화 + 안내 텍스트 숨김
        pwConfirmInput.setCustomValidity("");
        if (pwMismatchHelp) {
          pwMismatchHelp.classList.add("d-none");
        }
        console.log("[reset-pw] password match");
      }
    };

    // 비밀번호/확인 입력 시마다 일치 여부 재검증
    if (pwInput && pwConfirmInput) {
      pwInput.addEventListener("input", validatePasswordMatch);
      pwConfirmInput.addEventListener("input", validatePasswordMatch);
    }

    // 3-1. 폼 검증 + 이메일 인증 여부 + 최종 확인창
    form.addEventListener("submit", function (e) {
      // 먼저 비밀번호/확인 일치 여부 customValidity 반영
      validatePasswordMatch();

      const isValid = form.checkValidity();
      console.log(
        "[reset-pw] form.submit =>> checkValidity =",
        isValid,
        "codeVerified =",
        codeVerified
      );

      // HTML5 기본 필수값 검증
      if (!isValid) {
        e.preventDefault();
        e.stopPropagation();
        form.classList.add("was-validated");
        return;
      }

      // 인증코드 검증이 완료되지 않은 상태라면 submit 차단
      if (!codeVerified) {
        e.preventDefault();
        e.stopPropagation();

        if (resultBox) {
          resultBox.textContent =
            "비밀번호 변경 전 이메일 인증을 완료해 주세요. '코드 발송' 버튼으로 인증을 진행하세요.";
          resultBox.className = "alert alert-warning py-2 small mt-3";
          resultBox.classList.remove("d-none");
        }

        form.classList.add("was-validated");
        console.warn("[reset-pw] submit blocked: code not verified");
        return;
      }

      // 여기까지 왔으면:
      //  - HTML5 검증 통과
      //  - 비밀번호/확인 일치
      //  - 이메일 인증 완료(codeVerified=true)
      // 최종 확인창으로 사용자에게 한 번 더 의사 확인
      const ok = window.confirm("비밀번호를 변경하시겠습니까?");
      if (!ok) {
        e.preventDefault();
        e.stopPropagation();
        console.log("[reset-pw] submit cancelled by user confirm dialog");
        return;
      }

      form.classList.add("was-validated");
    });

    // 3-2. 비밀번호 보기/숨기기 + Caps 상태 표시
    setupPasswordHelpers("rpwNew", "toggleResetPassword", "pwCaps", null);

    // 3-3. "코드 발송" / "인증 코드 확인" 버튼 클릭 시 동작
    if (btnSendCode) {
      btnSendCode.addEventListener("click", async () => {
        const emailInput = document.getElementById("rpwEmail");
        const idInput    = document.getElementById("rpwId");
        const codeInput  = document.getElementById("rpwCode");

        const email  = (emailInput?.value || "").trim();
        const acntId = (idInput?.value || "").trim();
        const code   = (codeInput?.value || "").trim();

        console.log("[reset-pw] btnSendCode.click =>> payload", {
          email,
          acntId,
          codeSent,
          code
        });

        // 최소 전제: 이메일 + 아이디 모두 입력되어야 발송/검증 허용
        if (!email || !acntId) {
          console.warn("[reset-pw] email or acntId is empty");
          if (resultBox) {
            resultBox.textContent =
              "아이디와 등록 이메일을 먼저 입력해 주세요.";
            resultBox.className = "alert alert-warning py-2 small mt-3";
            resultBox.classList.remove("d-none");
          }
          return;
        }

        // 이미 코드가 발송된 상태라면: 입력한 인증코드를 서버로 보내 검증
        if (codeSent) {
          console.log("[reset-pw] code already sent, try verify");

          if (!code) {
            console.warn("[reset-pw] verification requested but code is empty");
            if (resultBox) {
              resultBox.textContent =
                "이메일로 받은 인증코드를 위 칸에 입력한 뒤 다시 '인증 코드 확인'을 눌러 주세요.";
              resultBox.className = "alert alert-warning py-2 small mt-3";
              resultBox.classList.remove("d-none");
            }
            return;
          }

          btnSendCode.disabled = true;

          try {
            const res = await fetch("/api/account/email/verify", {
              method: "POST",
              headers: {
                "Content-Type": "application/json;charset=UTF-8"
                // 필요 시 CSRF 헤더 추가:
                // "X-CSRF-TOKEN": "<c:out value='${_csrf.token}'/>"
              },
              body: JSON.stringify({ email, acntId, code })
            });

            const text = (await res.text()).trim();
            console.log(
              "[reset-pw] /api/account/email/verify =>> status",
              res.status,
              "body:",
              text
            );

            if (res.ok && (text === "OK" || text === "")) {
              // 인증 성공 상태 반영
              codeVerified = true;

              if (resultBox) {
                resultBox.innerHTML =
                  "인증코드가 확인되었습니다.<br/>새 비밀번호를 입력한 뒤 비밀번호 변경 버튼을 눌러 주세요.";
                resultBox.className = "alert alert-success py-2 small mt-3";
                resultBox.classList.remove("d-none");
              }

              btnSendCode.textContent = "인증 완료";
              btnSendCode.classList.remove("btn-outline-secondary");
              btnSendCode.classList.add("btn-outline-success");
              btnSendCode.setAttribute(
                "aria-label",
                "이메일 인증코드가 정상적으로 확인되었습니다."
              );

              // 인증 완료 후에는 버튼 비활성화(추가 클릭 불필요)
              btnSendCode.disabled = true;
              console.log(
                "[reset-pw] verify success =>> button text changed to '인증 완료'"
              );

              // 새 비밀번호 / 확인 입력 필드 readonly 해제 + 포커스 + 스크롤 이동
              if (pwInput) {
                pwInput.readOnly = false;
                pwInput.focus();
              }
              if (pwConfirmInput) {
                pwConfirmInput.readOnly = false;
              }

              try {
                if (pwInput) {
                  pwInput.scrollIntoView({
                    behavior: "smooth",
                    block: "center"
                  });
                }
              } catch (e) {
                console.warn("[reset-pw] scrollIntoView not supported:", e);
              }
            } else {
              // 인증 실패
              codeVerified = false;

              if (resultBox) {
                resultBox.textContent =
                  "인증코드가 올바르지 않거나 만료되었습니다. 메일의 코드를 다시 확인해 주세요.";
                resultBox.className = "alert alert-danger py-2 small mt-3";
                resultBox.classList.remove("d-none");
              }

              btnSendCode.textContent = "인증 코드 확인";
              btnSendCode.classList.remove("btn-outline-success");
              btnSendCode.classList.add("btn-outline-secondary");
              btnSendCode.removeAttribute("aria-label");
              btnSendCode.disabled = false;

              // 실패 시 비밀번호 필드는 다시 readonly 유지
              if (pwInput) {
                pwInput.readOnly = true;
              }
              if (pwConfirmInput) {
                pwConfirmInput.readOnly = true;
              }
            }
          } catch (err) {
            console.error("[reset-pw] email verify error:", err);
            codeVerified = false;

            if (resultBox) {
              resultBox.textContent =
                "네트워크 오류로 인증코드 확인에 실패했습니다.";
              resultBox.className = "alert alert-danger py-2 small mt-3";
              resultBox.classList.remove("d-none");
            }

            btnSendCode.textContent = "인증 코드 확인";
            btnSendCode.classList.remove("btn-outline-success");
            btnSendCode.classList.add("btn-outline-secondary");
            btnSendCode.removeAttribute("aria-label");
            btnSendCode.disabled = false;

            // 오류 시 비밀번호 필드는 다시 readonly
            if (pwInput) {
              pwInput.readOnly = true;
            }
            if (pwConfirmInput) {
              pwConfirmInput.readOnly = true;
            }
          }

          return;
        }

        // 여기까지 왔으면 아직 코드 발송 전 상태 => 메일 발송 요청
        btnSendCode.disabled = true;

        try {
          const res = await fetch("/api/account/email/send", {
            method: "POST",
            headers: {
              "Content-Type": "application/json;charset=UTF-8"
              // 필요 시 CSRF 헤더 추가:
              // "X-CSRF-TOKEN": "<c:out value='${_csrf.token}'/>"
            },
            body: JSON.stringify({ email, acntId })
          });

          const text = (await res.text()).trim();
          console.log(
            "[reset-pw] /api/account/email/send =>> status",
            res.status,
            "body:",
            text
          );

          if (res.ok && (text === "OK" || text === "")) {
            // 발송 성공 상태 반영
            codeSent = true;

            if (resultBox) {
              resultBox.textContent =
                "인증코드를 이메일로 발송했습니다. 메일함에서 코드를 확인한 뒤 위 입력란에 입력해 주세요.";
              resultBox.className = "alert alert-success py-2 small mt-3";
              resultBox.classList.remove("d-none");
            }

            // 버튼 역할/스타일 전환: "코드 발송" =>> "인증 코드 확인"
            btnSendCode.textContent = "인증 코드 확인";
            btnSendCode.classList.remove("btn-outline-secondary");
            btnSendCode.classList.add("btn-outline-success");
            btnSendCode.setAttribute(
              "aria-label",
              "이메일로 받은 인증코드를 입력했는지 확인하는 버튼입니다."
            );

            // 발송 성공 후에는 다시 클릭 가능해야 하므로 disabled 해제
            btnSendCode.disabled = false;

            console.log(
              "[reset-pw] send code success =>> button text changed to '인증 코드 확인'"
            );
          } else {
            // 실패 시 상태/스타일 복구
            codeSent = false;

            if (resultBox) {
              resultBox.textContent =
                "메일 발송에 실패했습니다. 잠시 후 다시 시도해 주세요.";
              resultBox.className = "alert alert-danger py-2 small mt-3";
              resultBox.classList.remove("d-none");
            }

            btnSendCode.textContent = "코드 발송";
            btnSendCode.classList.remove("btn-outline-success");
            btnSendCode.classList.add("btn-outline-secondary");
            btnSendCode.removeAttribute("aria-label");

            // 실패했으니 다시 눌러볼 수 있도록 해제
            btnSendCode.disabled = false;
          }
        } catch (err) {
          console.error("[reset-pw] email send error:", err);
          codeSent = false;

          if (resultBox) {
            resultBox.textContent =
              "네트워크 오류로 메일 발송에 실패했습니다.";
            resultBox.className = "alert alert-danger py-2 small mt-3";
            resultBox.classList.remove("d-none");
          }

          btnSendCode.textContent = "코드 발송";
          btnSendCode.classList.remove("btn-outline-success");
          btnSendCode.classList.add("btn-outline-secondary");
          btnSendCode.removeAttribute("aria-label");

          // 예외 상황에서도 다시 시도 가능하게
          btnSendCode.disabled = false;
        } finally {
          // codeSent=true 인 경우에는 위에서 이미 disabled=false 처리됨
          if (!codeSent) {
            btnSendCode.disabled = false;
          }
        }
      });
    } else {
      console.warn("[reset-pw] btnSendCode not found");
    }
  })();
  </script>
</body>
</html>
