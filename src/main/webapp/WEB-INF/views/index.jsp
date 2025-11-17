<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>대덕대학교 메인 포털</title>

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

<%@ include file="index-header.jsp"%>
<main>
    <!-- 히어로 -->
    <section class="hero-section">
        <div class="container">
            <div class="hero-layout">
                <div class="hero-copy">
                    <div class="hero-kicker">스마트 캠퍼스 통합 포털</div>
                    <h1 class="hero-title">
                        창의적 인재와 함께 미래 캠퍼스를<br />
                        만들어 가는 대덕대학교
                    </h1>
                    <p class="hero-desc">
                        입학·학사·장학·대학생활·연구 정보를 한 화면에서 연결하는
                        대덕대학교 메인 포털입니다. 재학생, 예비대학생, 동문 모두를 위한
                        캠퍼스 허브를 목표로 합니다.
                    </p>

                    <div class="hero-search-wrap">
                        <input type="text"
                               class="hero-search-input"
                               placeholder="예) 장학금, 학사일정, 입학전형, 도서관 검색 등" />
                        <button type="button" class="hero-search-btn">
                            캠퍼스 통합 검색
                        </button>
                    </div>

                    <div class="hero-quick-links">
                        <button type="button" class="btn btn-sm">
                            재학생 안내
                        </button>
                        <button type="button" class="btn btn-sm">
                            예비대학생 안내
                        </button>
                        <button type="button" class="btn btn-sm">
                            동문·일반인 서비스
                        </button>
                    </div>
                </div>
                <%-- 필요 시 우측 비주얼(슬라이드) 영역 추가 예정: .hero-visual --%>
            </div>
        </div>
    </section>

    <!-- 기존 How It's Work 영역 -->
    <section class="how-section">
        <div class="container">
            <h2>How It's Work</h2>
            <p class="lead">
                대덕대학교 메인 포털에서 입학, 학사, 장학, 대학생활 정보를 한 번에
                확인하고, 나에게 맞는 서비스를 빠르게 찾을 수 있습니다.
            </p>

            <div class="how-steps">
                <div class="how-step">
                    <div class="how-step-icon">①</div>
                    <div class="how-step-title">회원 가입 / 로그인</div>
                    <div class="how-step-text">
                        포털 계정을 등록하고 재학생·예비대학생·동문 등 사용자 유형을
                        선택합니다.
                    </div>
                </div>
                <div class="how-step">
                    <div class="how-step-icon">②</div>
                    <div class="how-step-title">맞춤 정보 확인</div>
                    <div class="how-step-text">
                        학적과 관심 정보에 맞춰 학사일정, 장학, 공지, 비교과 프로그램을
                        한 번에 확인합니다.
                    </div>
                </div>
                <div class="how-step">
                    <div class="how-step-icon">③</div>
                    <div class="how-step-title">포털/서비스 연결</div>
                    <div class="how-step-text">
                        학사 포털, LMS, 도서관, 취업지원 등 주요 시스템으로 즉시 이동할
                        수 있습니다.
                    </div>
                </div>
                <div class="how-step">
                    <div class="how-step-icon">④</div>
                    <div class="how-step-title">캠퍼스 라이프 활용</div>
                    <div class="how-step-text">
                        공지, 행사, 비교과, 커뮤니티를 통해 대덕대학교의 캠퍼스 생활을
                        적극적으로 경험합니다.
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<%@ include file="index-footer.jsp"%>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

<!-- 헤더 스크롤 배경 전환 -->
<script>
  document.addEventListener("scroll", function () {
    var header = document.querySelector(".main-header");
    if (!header) return;

    if (window.scrollY > 20) {
      header.classList.add("is-scrolled");
    } else {
      header.classList.remove("is-scrolled");
    }
  });
  
  document.addEventListener('DOMContentLoaded', function () {
    const heroSection = document.querySelector('.hero-section');
    if (!heroSection) return;

    // Spring Boot 정적 리소스 기준: /src/main/resources/static/images/background/**
    const basePath = '${pageContext.request.contextPath}/images/background/';

    // 컨트롤러에서 model.addAttribute("background_images", List<String>) 로 넘겨준 값 사용
    const backgroundFiles = [
      <c:forEach var="img" items="${background_images}" varStatus="st">
        '${img}'<c:if test="${!st.last}">,</c:if>
      </c:forEach>
    ].filter(function (name) {
      return !!name; // null/빈 문자열 방지
    });

    if (!backgroundFiles.length) {
      console.warn('[hero-bg] background_images 비어 있음, 랜덤 배경 비활성');
      return;
    }

    const backgroundUrls = backgroundFiles.map(function (name) {
      return basePath + name;
    });

    // 프리로드
    backgroundUrls.forEach(function (src) {
      const img = new Image();
      img.src = src;
    });

    function setRandomBackground() {
      const idx = Math.floor(Math.random() * backgroundUrls.length);
      const url = backgroundUrls[idx];

      heroSection.style.backgroundImage =
        'linear-gradient(to bottom, rgba(15,23,42,0.45), rgba(15,23,42,0.35)), url("' + url + '")';
      heroSection.style.backgroundSize = 'cover';
      heroSection.style.backgroundPosition = 'center center';
      heroSection.style.backgroundRepeat = 'no-repeat';
    }

    // 최초 1회 + 10초 주기 변경
    setRandomBackground();
    setInterval(setRandomBackground, 10000);
  });
</script>

</body>
</html>
