<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="cPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    
    <!-- velzon layout config -->
    <script src="${cPath}/assets/js/layout.js"></script>

    <!-- velzon CSS stack -->
    <link href="${cPath}/assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/icons.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/app.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/custom.min.css" rel="stylesheet" />
    
    <title>대덕대학교-통합검색</title>
    <!-- 메인 포털 공통 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/main-portal.css" />
<style>
  /* =========================
     공통 타이포 / 레이아웃
  ========================== */
  body.search-page {
    font-family: "Pretendard", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    color: #e5e7eb;
  }

  /* =========================
     헤더 (Velzon + 검색바 센터)
  ========================== */
  .navbar-landing.main-header {
    background-color: #272A3A !important;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.45);
  }

  .navbar-landing.main-header .container-fluid {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1.5rem;
  }

  .navbar-landing.main-header .navbar-brand {
    margin-right: 0 !important;
  }

  .search-header-form {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    flex: 1 1 auto;
    max-width: 900px;
  }

  .search-header-form .search-type-select {
    background: #ffffff;
    color: #111827;
    border-radius: 8px;
    border: 1px solid #d1d5db;
    font-size: 13px;
    padding: 9px 13px;
    max-width: 130px;
  }

  .search-header-form .form-control {
    background-color: #ffffff;
    border-color: #ffffff;
    color: #111827;
    border-radius: 8px;
    font-size: 14px;
    padding: 8px 10px;
  }

  .search-header-form .form-control::placeholder {
    color: #9ca3af;
  }

  .search-header-form .btn-search {
    border-color: #22c55e;
    background-color: #22c55e;
    color: #020617;
    font-weight: 900;
    font-size: 14px;
    white-space: nowrap;
    max-width: 360px; 
  }

  .search-page .content-wrapper {
    padding-top: 80px;
  }

  /* =========================
     상단 검색 탭
  ========================== */
  .search-tabs-wrap {
    border-bottom: 1px solid rgba(75, 85, 99, 0.7);
    background: transparent;
  }

  .search-tabs {
    display: flex;
    gap: 16px;
    overflow-x: auto;
  }

  .search-tabs-link {
    position: relative;
    padding: 10px 4px 12px;
    font-size: 14px;
    color: #9ca3af;
    text-decoration: none;
    white-space: nowrap;
  }

  .search-tabs-link.is-active {
    color: #f9fafb;
    font-weight: 600;
  }

  .search-tabs-link.is-active::after {
    content: "";
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    height: 2px;
    background: #22c55e;
  }

  /* =========================
     필터 바 (추천검색어 / 정렬 / 기간 / 영역)
  ========================== */
  .search-filter-bar {
    border-bottom: 1px solid rgba(55, 65, 81, 0.8);
    padding: 12px 0;
    font-size: 13px;
    color: #111827;
  }

  .search-filter-inner {
    display: flex;
    flex-wrap: wrap;
    gap: 12px 24px;
    align-items: center;
    justify-content: space-between;
  }

  .filter-left,
  .filter-right {
    display: flex;
    flex-wrap: wrap;
    gap: 12px 16px;
    align-items: center;
  }

  .filter-label {
    font-size: 13px;
    color: #111827;
    display: flex;
    align-items: center;
    gap: 4px;
    padding: 4px 0;
    min-height: 25px;
  }

  .filter-suggest-keywords {
    display: flex;
    flex-wrap: wrap;
    gap: 3px;
    padding: 4px 0;
    min-height: 25px;
  }

  .filter-right {
    gap: 6px 8px;
    padding: 4px 0;
    min-height: 25px;
  }

  .filter-select,
  .filter-suggest-chip {
    height: 27px;
    padding: 4px 10px;
    border: 1px solid rgba(0, 0, 0, 0.3);
    border-radius: 999px;
    background: #ffffff;
    color: #111827;
    box-shadow: none;
    line-height: 1;
    font-size: 13px;
  }

  .filter-suggest-chip {
    font-size: 12px;
    cursor: pointer;
  }

  /* =========================
     메인 레이아웃
  ========================== */
  .search-main {
    padding: 25px 0 48px;
  }

  .search-main > .container {
    max-width: 1200px;
    width: 100%;
    margin: 0 auto;
  }

  .search-layout {
    display: grid;
    grid-template-columns: 220px minmax(0, 1fr) 260px;
    gap: 24px;
  }

  /* =========================
     좌측 검색 영역 (search-left-menu)
  ========================== */
  .search-left-nav {
    font-size: 14px;
  }

  .search-left-title {
    font-size: 13px;
    font-weight: 600;
    color: #111827;
    margin-bottom: 8px;
  }

  .search-left-menu {
    list-style: none;
    padding: 0;
    margin: 0;
    border-radius: 8px;
    border: 1px solid #111827;
    overflow: hidden;
    background: transparent;
  }

  .search-left-menu li a {
    display: block;
    padding: 8px 10px;
    text-decoration: none;
    color: #111827;
    font-size: 13px;
    border-bottom: 1px solid #111827;
  }

  .search-left-menu li:last-child a {
    border-bottom: none;
  }

  .search-left-menu li a.is-active {
    background: transparent;
    font-weight: 600;
    color: #111827;
  }

  /* =========================
     검색 결과 요약 + 카테고리 카드
  ========================== */
  .search-results-summary {
    margin-bottom: 16px;
    font-size: 14px;
    color: #111827;
  }

  .search-results-summary strong {
    color: #111827;
  }

  .search-category-section {
    margin-bottom: 24px;
    border-radius: 0;
    border: none;
    background: transparent;
  }

  .search-category-header {
    padding: 10px 0;
    border-bottom: none;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .search-category-title {
    font-size: 14px;
    font-weight: 600;
    color: #111827;
  }

  .search-category-count {
    font-size: 12px;
    color: #111827;
  }

  .search-category-body {
    padding: 8px 0;
    font-size: 13px;
    color: #111827;
  }

  /* =========================
     우측 인기 검색어 (탭 + 리스트)
  ========================== */
  .search-popular {
    font-size: 13px;
    color: #111827;
  }

  .search-popular-title {
    font-weight: 600;
    margin-bottom: 8px;
    color: #111827;
  }

  .popular-tabs {
    display: flex;
    gap: 8px;
    margin-bottom: 10px;
    flex-wrap: wrap;
  }

  .popular-tab {
    padding: 4px 10px;
    border-radius: 999px;
    border: 1px solid #111827;
    background-color: #ffffff;
    color: #111827;
    font-size: 12px;
    cursor: pointer;
  }

  .popular-tab.is-active {
    background-color: #16a34a;
    border-color: #16a34a;
    color: #ffffff;
  }

  .popular-list {
    list-style: none;
    margin: 0;
    padding: 0;
    display: none;
  }

  .popular-list.is-active {
    display: block;
  }

  .popular-item {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 3px 0;
    color: #111827;
  }

  .popular-rank-icon {
    width: 20px;
    height: 20px;
    border-radius: 999px;
    border: 1px solid #111827;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 11px;
    font-weight: 600;
    color: #111827;
    background: #ffffff;
  }

  .popular-keyword {
    flex: 1;
    font-size: 13px;
    color: #111827;
    text-decoration: none;
  }

  /* =========================
     반응형
  ========================== */
  @media (max-width: 1024px) {
    .search-layout {
      grid-template-columns: minmax(0, 1.4fr) minmax(0, 1fr);
    }
    .search-left-nav {
      display: none;
    }
  }

  @media (max-width: 768px) {
    .search-layout {
      grid-template-columns: minmax(0, 1fr);
    }
    .search-popular {
      display: none;
    }
  }
  /* 좌측 메뉴 폭을 한 군데에서만 조정할 수 있게 변수화 */
	:root {
	  --search-left-width: 180px;  /* 필요하면 200px, 260px 등으로 한 군데만 바꿔 사용 */
	}
	
	/* 레이아웃: 좌측 메뉴 영역을 변수 기반으로 */
	.search-layout {
	  display: grid;
	  grid-template-columns: var(--search-left-width) minmax(0, 1fr) 260px;
	  gap: 24px;
	}
	
	/* 좌측 메뉴 컨테이너에 폭 명시 (그리드랑 일치) */
	.search-left-nav {
	  font-size: 14px;
	  width: var(--search-left-width);
	}
	
	/* 기본 메뉴 스타일 유지 */
	.search-left-menu {
	  list-style: none;
	  padding: 0;
	  margin: 0;
	  border-radius: 8px;
	  border: 1px solid #111827;
	  overflow: hidden;
	  background: transparent;
	}
	
	.search-left-menu li a {
	  display: block;
	  padding: 8px 10px;
	  text-decoration: none;
	  color: #111827;
	  font-size: 13px;
	  border-bottom: 1px solid #111827;
	}
	
	/* 선택(활성) 상태: 텍스트를 더 굵게 강조 */
	.search-left-menu li a.is-active {
	  background: transparent;
	  font-weight: 2000;
	  color: #111827;
	}
	/* ===== 중앙 3컬럼 영역 구분선 ===== */
	
	/* 좌측 검색 영역 오른쪽에 세로 구분선 */
	.search-layout .search-left-nav {
	  padding-right: 16px;
	  border-right: 1px solid rgba(0, 0, 0, 0.25); /* 얇은 검은색 라인 */
	}
	
	/* 중앙 영역은 살짝 안쪽 여백만 */
	.search-layout > section {
	  padding: 0 16px;
	}
	
	/* 우측 인기 검색어 왼쪽에 세로 구분선 */
	.search-layout .search-popular {
	  padding-left: 16px;
	  border-left: 1px solid rgba(0, 0, 0, 0.25);  /* 얇은 검은색 라인 */
	}
	/* 필터 바 하단 구분선 – 세로 구분선과 동일 톤 */
	.search-filter-bar {
	  border-bottom: 1px solid rgba(0, 0, 0, 0.25);  /* 얇은 검은색 라인 */
	}
	
	/* 래퍼 폭만 바꿔서 좌우 길이 조절 */
	.search-header-form {
	  width: 90%;        /* 헤더 안에서 꽉 차게 */
	  max-width: 700px;   /* 검색창 실제 가로 길이 */
	}
	
	/* 인풋 자체 스타일 */
	.search-header-form .form-control {
	  width: 100%;        /* 래퍼 기준으로 늘어남 */
	  box-sizing: border-box;
	
	  background-color: #ffffff;
	  border-color: #ffffff;
	  color: #111827;
	  border-radius: 8px;
	  font-size: 14px;
	  padding: 8px 10px;
	}
		
</style>


</head>
<body class="search-page">

<!-- Velzon 메인 헤더: 검색창 포함 -->
<header class="navbar navbar-expand-lg navbar-landing main-header fixed-top">
  <div class="container-fluid">
    <!-- 로고 -->
    <a class="navbar-brand me-3" href="${cPath}/">
      <img src="${cPath}/images/logo/univ-logo-kor-vite-dark.svg"
           alt="대덕대학교" height="55"
           class="card-logo card-logo-dark" />
    </a>

    <!-- 전역 검색창 -->
    <form class="search-header-form" action="<c:url value='/search'/>" method="get">
      <select name="btuniv" id="btuniv" class="search-type-select">
        <option value="ALL" selected="selected">통합검색</option>
        <option value="MENU">메뉴검색</option>
        <option value="TEL">부서전화번호</option>
        <option value="WEB">웹페이지</option>
        <option value="SCHEDULE">학사일정</option>
        <option value="NOTICE">공지사항</option>
        <option value="DOC">상담자료</option>
        <option value="FAQ">학사FAQ</option>
        <option value="FORM">학생서식</option>
        <option value="SITE">홈페이지주소</option>
        <option value="PR">홍보자료</option>
        <option value="PROF_QNA">교수_상담게시판</option>
        <option value="BOOK">도서검색</option>
      </select>
			<input type="text" class="form-control" name="q"
					       placeholder="예) 장학금, 학사일정, 입학전형, 도서관 검색 등"
					       value="${fn:escapeXml(param.q)}">
		    <button type="submit" class="btn btn-success btn-search">검색</button>
    </form>

    <!-- 우측 메뉴 (필요시) -->
    <div class="ms-auto d-flex align-items-center">
      <%-- 예: 알림, 프로필 등 --%>
    </div>
  </div>
</header>

<div class="content-wrapper">
    <!-- 필터 바 -->
    <section class="search-filter-bar">
	  <div class="container">
	    <form class="search-filter-inner"
	          action="<c:url value='/search' />"
	          method="get">
	      <input type="hidden" name="cat" value="${param.cat}" />
	      <input type="hidden" name="q" value="${fn:escapeXml(param.q)}" />
                <div class="filter-left">
                    <div class="filter-suggest-keywords">
                        <span class="filter-label">추천검색어&nbsp;:&nbsp;</span>
                        <button type="button" class="filter-suggest-chip">휴학신청</button>
                        <button type="button" class="filter-suggest-chip">장학금</button>
                        <button type="button" class="filter-suggest-chip">학사일정</button>
                        <button type="button" class="filter-suggest-chip">기출문제</button>
                        <button type="button" class="filter-suggest-chip">성적증명서</button>
                        <button type="button" class="filter-suggest-chip">증명서 발급</button>
                    </div>
                </div>

                <div class="filter-right">
                    <label class="filter-label">
                        정렬&nbsp;:&nbsp;
                        <select name="sort" class="filter-select">
                            <option value="REL" ${param.sort eq 'REL' ? 'selected' : ''}>관련도순</option>
                            <option value="DATE" ${param.sort eq 'DATE' ? 'selected' : ''}>최신순</option>
                        </select>
                    </label>

                    <label class="filter-label">
                        기간&nbsp;:&nbsp;
                        <select name="period" class="filter-select">
                            <option value="ALL" ${param.period eq 'ALL' ? 'selected' : ''}>전체</option>
                            <option value="1D" ${param.period eq '1D' ? 'selected' : ''}>1일</option>
                            <option value="1W" ${param.period eq '1W' ? 'selected' : ''}>1주</option>
                            <option value="1M" ${param.period eq '1M' ? 'selected' : ''}>1개월</option>
                            <option value="1Y" ${param.period eq '1Y' ? 'selected' : ''}>1년</option>
                        </select>
                    </label>

                    <label class="filter-label">
                        영역&nbsp;:&nbsp;
                        <select name="scope" class="filter-select">
                            <option value="ALL" ${param.scope eq 'ALL' ? 'selected' : ''}>전체</option>
                            <option value="TITLE" ${param.scope eq 'TITLE' ? 'selected' : ''}>제목</option>
                        </select>
                    </label>

                    <label class="filter-label">&nbsp;&nbsp;
                        <input type="checkbox" name="keepOpt"
                               value="Y"
                               ${param.keepOpt eq 'Y' ? 'checked' : ''} />
                        옵션 유지
                    </label>
                </div>
            </form>
        </div>
    </section>

    <!-- 본문 -->
    <main class="search-main">
        <div class="container">
            <div class="search-layout">
                <!-- 좌측 카테고리 네비 -->
                <aside class="search-left-nav">
                    <div class="search-left-title">검색 영역</div>
                    <ul class="search-left-menu">
                        <li>
                            <a href="?q=${fn:escapeXml(param.q)}&cat=ALL"
                               class="${empty param.cat or param.cat eq 'ALL' ? 'is-active' : ''}">
                                통합검색
                            </a>
                        </li>
                        <li>
                            <a href="?q=${fn:escapeXml(param.q)}&cat=MENU"
                               class="${param.cat eq 'MENU' ? 'is-active' : ''}">
                                메뉴검색
                            </a>
                        </li>
                        <li>
                            <a href="?q=${fn:escapeXml(param.q)}&cat=NOTICE"
                               class="${param.cat eq 'NOTICE' ? 'is-active' : ''}">
                                공지사항
                            </a>
                        </li>
                        <li>
                            <a href="?q=${fn:escapeXml(param.q)}&cat=FAQ"
                               class="${param.cat eq 'FAQ' ? 'is-active' : ''}">
                                학사 FAQ
                            </a>
                        </li>
                        <li>
                            <a href="?q=${fn:escapeXml(param.q)}&cat=FORM"
                               class="${param.cat eq 'FORM' ? 'is-active' : ''}">
                                학생서식
                            </a>
                        </li>
                        <li>
                            <a href="?q=${fn:escapeXml(param.q)}&cat=SITE"
                               class="${param.cat eq 'SITE' ? 'is-active' : ''}">
                                사이트
                            </a>
                        </li>
                    </ul>
                </aside>

                <!-- 중앙 결과 영역 -->
                <section>
                    <div class="search-results-summary">
                        <c:choose>
                            <c:when test="${not empty param.q}">
                                <strong>"${fn:escapeXml(param.q)}"</strong>
                                에 대한 전체
                                <strong>${empty requestScope.totalCount ? 0 : requestScope.totalCount}</strong>
                                건의 검색 결과를 찾았습니다.
                            </c:when>
                        </c:choose>
                    </div>

                    <!-- 카테고리별 섹션 예시 -->
                    <div class="search-category-section">
                        <div class="search-category-header">
                            <div class="search-category-title">통합검색</div>
                            <div class="search-category-count">
                                총 ${empty requestScope.totalCount ? 0 : requestScope.totalCount} 건
                            </div>
                        </div>
                        <div class="search-category-body">
                            <c:if test="${empty param.q}">
                                검색어를 입력하시면 재학생·입학·장학·학생서비스 등 통합 결과가 표시됩니다.
                            </c:if>
                            <c:if test="${not empty param.q}">
                                <%-- TODO: 실제 검색 결과 리스트 렌더링 --%>
                                검색 결과 표시 영역입니다. (페이징, 하이라이트, 출처 등)
                            </c:if>
                        </div>
                    </div>
                </section>

                <!-- 우측 인기 검색어 -->
				<aside class="search-popular">
				    <div class="search-popular-title">인기 검색어</div>
				
				    <div class="popular-tabs">
				        <button type="button" class="popular-tab is-active" data-target="popular-realtime">실시간</button>
				        <button type="button" class="popular-tab" data-target="popular-daily">일간</button>
				        <button type="button" class="popular-tab" data-target="popular-weekly">주간</button>
				        <button type="button" class="popular-tab" data-target="popular-monthly">월간</button>
				    </div>
				
				    <!-- 실시간 -->
				    <ul class="popular-list is-active" id="popular-realtime">
				        <li class="popular-item">
				            <span class="popular-rank-icon">1</span>
				            <a href="#" class="popular-keyword">논술</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">2</span>
				            <a href="#" class="popular-keyword">전공안내</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">3</span>
				            <a href="#" class="popular-keyword">입학처</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">4</span>
				            <a href="#" class="popular-keyword">기숙사</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">5</span>
				            <a href="#" class="popular-keyword">시험범위</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">6</span>
				            <a href="#" class="popular-keyword">장학금</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">7</span>
				            <a href="#" class="popular-keyword">국가장학금</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">8</span>
				            <a href="#" class="popular-keyword">대학전공</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">9</span>
				            <a href="#" class="popular-keyword">과제물</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">10</span>
				            <a href="#" class="popular-keyword">계절학기</a>
				        </li>
				    </ul>
				
				    <!-- 일간 -->
				    <ul class="popular-list" id="popular-daily">
				        <li class="popular-item">
				            <span class="popular-rank-icon">1</span>
				            <a href="#" class="popular-keyword">논술</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">2</span>
				            <a href="#" class="popular-keyword">논술 기출</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">3</span>
				            <a href="#" class="popular-keyword">논술 2026</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">4</span>
				            <a href="#" class="popular-keyword">입학처</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">5</span>
				            <a href="#" class="popular-keyword">졸업증명서</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">6</span>
				            <a href="#" class="popular-keyword">성적증명서</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">7</span>
				            <a href="#" class="popular-keyword">수시</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">8</span>
				            <a href="#" class="popular-keyword">화학과</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">9</span>
				            <a href="#" class="popular-keyword">기숙사</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">10</span>
				            <a href="#" class="popular-keyword">상담게시판</a>
				        </li>
				    </ul>
				
				    <!-- 주간 -->
				    <ul class="popular-list" id="popular-weekly">
				        <li class="popular-item">
				            <span class="popular-rank-icon">1</span>
				            <a href="#" class="popular-keyword">졸업증명서</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">2</span>
				            <a href="#" class="popular-keyword">대학생활 길라잡이</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">3</span>
				            <a href="#" class="popular-keyword">성적증명서</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">4</span>
				            <a href="#" class="popular-keyword">증명서</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">5</span>
				            <a href="#" class="popular-keyword">기출문제</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">6</span>
				            <a href="#" class="popular-keyword">기말시험</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">7</span>
				            <a href="#" class="popular-keyword">과제물</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">8</span>
				            <a href="#" class="popular-keyword">출석수업</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">9</span>
				            <a href="#" class="popular-keyword">출석수업 자료실</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">10</span>
				            <a href="#" class="popular-keyword">시험범위</a>
				        </li>
				    </ul>
				
				    <!-- 월간 -->
				    <ul class="popular-list" id="popular-monthly">
				        <li class="popular-item">
				            <span class="popular-rank-icon">1</span>
				            <a href="#" class="popular-keyword">논술</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">2</span>
				            <a href="#" class="popular-keyword">졸업증명서</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">3</span>
				            <a href="#" class="popular-keyword">학과</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">4</span>
				            <a href="#" class="popular-keyword">수시</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">5</span>
				            <a href="#" class="popular-keyword">입학처</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">6</span>
				            <a href="#" class="popular-keyword">교수평가</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">7</span>
				            <a href="#" class="popular-keyword">과제물</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">8</span>
				            <a href="#" class="popular-keyword">자료실</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">9</span>
				            <a href="#" class="popular-keyword">입시</a>
				        </li>
				        <li class="popular-item">
				            <span class="popular-rank-icon">10</span>
				            <a href="#" class="popular-keyword">도서관</a>
				        </li>
				    </ul>
				</aside>

            </div>
        </div>
    </main>
</div>

<%@ include file="../index-footer.jsp"%>

</body>
</html>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const tabs  = document.querySelectorAll('.popular-tab');
    const lists = document.querySelectorAll('.popular-list');

    tabs.forEach(function (tab) {
      tab.addEventListener('click', function () {
        const targetId = tab.getAttribute('data-target');

        tabs.forEach(t => t.classList.remove('is-active'));
        lists.forEach(l => l.classList.remove('is-active'));

        tab.classList.add('is-active');
        document.getElementById(targetId).classList.add('is-active');
      });
    });
  });
</script>