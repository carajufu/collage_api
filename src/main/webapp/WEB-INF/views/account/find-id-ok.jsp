<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>아이디 찾기 결과</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- 폰트 / Bootstrap -->
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/pretendard/dist/web/static/pretendard.css" />
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />

  <style>
    body {
      margin: 0;
      font-family: Pretendard, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background-color: #f5f7fb;
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
      max-width: 420px;
      background-color: #ffffff;
      border-radius: 16px;
      border: 1px solid #e5e7eb;
      box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
      padding: 28px 28px 24px;
      text-align: center;
    }

    .popup-title {
      font-size: 20px;
      font-weight: 700;
      color: #111827;
      margin-bottom: 12px;
    }

    .popup-message {
      font-size: 14px;
      color: #374151;
      margin-bottom: 12px;
      line-height: 1.6;
    }

    .popup-id-link {
      font-weight: 700;
      color: #2563eb;
      text-decoration: underline;
      cursor: pointer;
    }

    .btn-primary {
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

    .popup-subtext {
      margin-top: 12px;
      font-size: 12px;
      color: #9ca3af;
    }
  </style>
</head>
<body>
<div class="popup-wrapper">
  <div class="popup-card">
    <h1 class="popup-title">아이디 찾기 결과</h1>

    <c:choose>
      <c:when test="${not empty resultMessage}">
        <p class="popup-message">
          회원님의 아이디는
          <!-- 클릭 시 아이디를 클립보드에 복사 -->
          <span id="foundIdText"
                class="popup-id-link"
                onclick="copyUserId()">
            [${resultMessage}]
          </span>
          입니다.
        </p>
    	<p class="popup-subtext">
          &#8251; 아이디를 클릭하면 복사됩니다.
        </p>
      </c:when>
      <c:otherwise>
        <p class="popup-message">
          입력하신 정보와 일치하는 회원 정보를 찾을 수 없습니다.
        </p>
      </c:otherwise>
    </c:choose>

    <button type="button" class="btn btn-primary w-100" onclick="window.close();">
      닫기
    </button>

    <p class="popup-subtext">
      창이 닫히지 않으면 브라우저의 상단 탭을 직접 닫아 주세요.
    </p>
  </div>
</div>

<script>
  // span 안의 텍스트에서 대괄호/공백 제거 후 클립보드로 복사
  function copyUserId() {
    const el = document.getElementById("foundIdText");
    if (!el) return;

    const raw = el.textContent || "";
    const id = raw.replace(/[\[\]\s]/g, ""); // [USER123] → USER123

    if (!id) return;

    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(id).then(() => {}).catch(() => {
          fallbackCopy(id);
        });
      } else {
        fallbackCopy(id);
      }
    }

  // 구형 브라우저 대비 폴백
  function fallbackCopy(text) {
    const ta = document.createElement("textarea");
    ta.value = text;
    ta.style.position = "fixed";
    ta.style.left = "-9999px";
    document.body.appendChild(ta);
    ta.select();
    try {
      document.execCommand("copy");
      alert("아이디가 클립보드에 복사되었습니다.");
    } catch (e) {
      alert("복사에 실패했습니다. 직접 선택해서 복사해 주세요.");
    } finally {
      document.body.removeChild(ta);
    }
  }
</script>
</body>
</html>
