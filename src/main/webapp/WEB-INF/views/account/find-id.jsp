<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<c:set var="cPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <title>아이디 찾기</title>
  	<meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- velzon layout config -->
    <script src="${cPath}/assets/js/layout.js"></script>

    <!-- velzon CSS stack -->
    <link href="${cPath}/assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/icons.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/app.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/custom.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/app.css" rel="stylesheet" />
    
  <style>
    /* 전체 배경: 연한 회색 톤 */
    body {
      margin: 0;
      background-color: #f5f7fb;
      font-family: "Pretendard", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }

    /* 팝업 전체 중앙 정렬 래퍼 */
    .popup-wrapper {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 16px;
    }

    /* 메인 카드 */
    .popup-card {
      width: 100%;
      max-width: 420px;
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
      margin-bottom: 24px;
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

    .form-text {
      font-size: 12px;
    }

    .invalid-feedback {
      font-size: 12px;
    }
/* 
    .btn-primary {
      margin-top: 8px;
      height: 44px;
      border-radius: 999px;
      font-weight: 600;
      font-size: 14px;
      background-color: #2563eb;
      border-color: #2563eb;
    } */
/* 
    .btn-primary:hover {
      background-color: #1d4ed8;
      border-color: #1d4ed8;
    } */

    .popup-footer-text {
      margin-top: 12px;
      font-size: 12px;
      color: #9ca3af;
      text-align: center;
    }

    .popup-footer-text a {
      color: #4b5563;
      text-decoration: underline;
      font-weight: 500;
    }
  </style>
  <%--
    [뷰 목적]
    - 로그인 화면의 "아이디 찾기" 링크를 새 창(window.open)으로 띄우는 전용 팝업.
    - 최소 정보(이름, 생년월일)로 계정 존재 여부/아이디를 조회하는 진입점.

    [동작 흐름]
    1) 사용자: 이름(userName), 생년월일(birthDate, YYYYMMDD) 입력.
    2) 클라이언트: required + pattern 으로 1차 검사 → 실패 시 Bootstrap invalid 표시.
    3) 서버: POST /api/auth/find-id 로 userName, birthDate, _csrf 수신 후 계정 조회.
    4) 서버: 일치 시 아이디(마스킹) 또는 안내 메시지 세팅 → 동일 JSP or 결과 화면 렌더.

    [원리/구조]
    - 인증 단계가 아니라 “조회” 단계라 비밀번호는 요구하지 않고, 입력 필드는 최소로 유지.
    - CSRF 토큰 포함 + 서버에서 동일 규칙 재검증(길이·형식) 전제.
    - UI는 Pretendard + Bootstrap5 카드 하나, 폭 약 420px 중앙 정렬 구조.
  --%>

</head>
<body>
<div class="popup-wrapper">
  <div class="popup-card">
    <!-- 타이틀/설명 -->
    <h1 class="popup-title">아이디 찾기</h1>
    <p class="popup-subtitle">
      가입 시 등록하신 이름과 생년월일을 입력해 주세요.<br>
      일치하는 계정이 있을 경우 아이디를 안내드립니다.
    </p>

    <!-- 메인 폼: POST /api/auth/find-id -->
    <form id="findIdForm"
          class="needs-validation"
          method="post"
          action="/account/find-id"
          novalidate>
      <!-- CSRF 토큰 -->
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

      <!-- 이름 -->
      <div class="mb-3">
        <label for="userName" class="form-label">이름</label>
        <input
          id="userName"
          name="userName"
          type="text"
          class="form-control"
          placeholder="이름을 입력해 주세요"
          required
        />
        <div class="invalid-feedback">이름을 입력해 주세요.</div>
      </div>

      <!-- 생년월일 -->
      <div class="mb-3">
        <label for="birthDate" class="form-label">생년월일</label>
        <input
          id="birthDate"
          name="birthDate"
          type="text"
          class="form-control"
          placeholder="YYYYMMDD 형식으로 입력해 주세요"
          pattern="\d{8}"
          required
          aria-describedby="birthHelp"
        />
        <div id="birthHelp" class="form-text">
        &nbsp;&nbsp;&nbsp;&nbsp;&#8251;&nbsp;예시 : 19931215 처럼 숫자 8자리로 입력합니다.
        </div>
        <div class="invalid-feedback">생년월일 형식이 올바르지 않습니다.</div>
      </div>

      <!-- 제출 버튼 -->
      <button type="submit" class="btn btn-primary w-100">
        아이디 찾기
      </button>
	</form>

    <!-- 하단 안내 -->
    <div class="popup-footer-text">
      입력하신 정보는 아이디 조회에만 사용되며 저장되지 않습니다.
      <br>
      잘못 오셨다면 <a href="/login" onclick="window.close(); return true;">로그인 화면</a>으로 돌아가세요.
    </div>
  </div>
</div>

<script>
  /*
    [스크립트 목적]
    - 팝업 창 크기를 적당한 440x420으로 맞추고 화면 중앙에 배치.
    - HTML5 검증(checkValidity)과 Bootstrap .was-validated 를 연결해 에러 표시.

    [흐름]
    - load: resizeTo + moveTo 시도.
    - submit: 유효성 실패 시 전송 막고 invalid-feedback 표시, 성공 시 그대로 POST.
  */

  window.addEventListener("load", function () {
    try {
      const w = 460;
      const h = 645;
      window.resizeTo(w, h);
      window.moveTo(
        Math.round((screen.availWidth - w) / 2),
        Math.round((screen.availHeight - h) / 2)
      );
    } catch (e) {
      // 창 제어 불가 브라우저는 조용히 패스
    }
  });

  (function () {
    const form = document.getElementById("findIdForm");
    if (!form) return;

    form.addEventListener("submit", function (e) {
      if (!form.checkValidity()) {
        e.preventDefault();
        e.stopPropagation();
      }
      form.classList.add("was-validated");
    });
  })();
</script>
</body>
</html>






  