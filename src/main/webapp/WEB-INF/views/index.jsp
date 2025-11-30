<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ include file="index-header.jsp"%>
    <title>대덕대학교 메인 포털</title>
    
    <!-- 메인페이지 전용 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/main-pages.css" />
<style>
	/* ============================================
	   0. 공통 레이아웃 / 타이포
	   ============================================ */
	.news-section,
	.section-main-bbs,
	.section-main-events,
	#research-section {
	    padding: 4rem 0;
	}

	/* 메인 섹션 공통 타이틀 (뉴스/공지/학사일정/행사/학술) */
	.research-section-title {
	    font-size: 1.9rem;
	    font-weight: 450;
	}

	/* 섹션 타이틀 텍스트 링크 공통 스타일 */
	.section-title-link {
	    color: inherit;
	    text-decoration: none;
	}
	.section-title-link:hover {
	    color: inherit;
	    text-decoration: underline;
	}

	/* 공통 2줄 말줄임 처리 */
	.text-truncate-2 {
	    overflow: hidden;
	    display: -webkit-box;
	    -webkit-line-clamp: 2;
	    -webkit-box-orient: vertical;
	}

	/* 공통 3줄 말줄임 처리 */
	.line-clamp-3 {
	    display: -webkit-box;
	    -webkit-line-clamp: 3;
	    -webkit-box-orient: vertical;
	    overflow: hidden;
	}

	/* ============================================
	   1. 메인 게시판(공지사항 + 학사일정) 레이아웃
	   ============================================ */

	.section-main-bbs .main-bbs-container {
	    max-width: 1250px;
	    margin-inline: auto;
	    padding-left: -4.75rem;
	    padding-right: -4.75rem;
	}

	/* 공지/학사일정 컬럼 gutter 조정 */
	.section-main-bbs .row {
	    --bs-gutter-x: 2rem;
	}

	/* 메인 게시판 카드 공통 모서리 */
	.section-main-bbs .card {
	    border-radius: 14px;
	}

	/* 공지/학사일정 카드 헤더 상하 패딩 */
	.section-main-bbs .card-header {
	    padding-top: 0.8rem;
	    padding-bottom: 0.8rem;
	}

	/* 공지/학사일정 리스트 행 패딩 */
	.section-main-bbs .list-group-item {
	    padding-top: 0.35rem;
	    padding-bottom: 0.55rem;
	}

	/* 공지 썸네일(아이콘/이미지) */
	.section-main-bbs .main-bbs-thumb {
	    width: 64px;
	    height: 64px;
	    object-fit: cover;
	    border-radius: 0.9rem;
	    background-color: #0f172a;
	    flex-shrink: 0;
	}

	/* 공지 한 행 전체 레이아웃 */
	.section-main-bbs .main-bbs-item {
	    display: flex;
	    align-items: flex-start;
	    gap: 0.75rem;
	}

	/* 공지 텍스트 영역 래퍼 */
	.section-main-bbs .main-bbs-body {
	    flex: 1 1 auto;
	    min-width: 0;
	}

	/* 공지사항 카드 전체 틀(높이 고정) */
	.section-main-bbs .main-bbs-card {
	    width: 100%;
	    height: 420px;
	    min-height: 420px;
	    display: flex;
	    flex-direction: column;
	    background: transparent;
	    padding: 0;
	    box-shadow: none;
	}

	/* 공지 상단 부제 영역 */
	.section-main-bbs .main-bbs-card-header {
	    flex: 0 0 auto;
	    padding: 4px 0 8px;
	    margin: 0 4px 4px;
	    border: 0;
	}

	/* 공지사항 실제 흰색 카드(스크롤 포함) */
	.main-bbs-card .main-bbs-inner {
	    flex: 1 1 auto;
	    display: flex;
	    flex-direction: column;
	    background: #ffffff;
	    border-radius: 18px;
	    box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
	    padding: 14px 18px 14px;
	    box-sizing: border-box;
	}

	/* 공지 리스트 스크롤 영역 */
	.main-bbs-card .main-bbs-list {
	    flex: 1 1 auto;
	    height: 100%;
	    margin-bottom: 0;
	    overflow-y: auto;
	    overflow-x: hidden;
	    padding-right: 4px;
	    box-sizing: border-box;
	}

	/* ============================================
	   1-2. 메인 학사일정 카드 레이아웃
	   ============================================ */

	.section-main-bbs .main-calendar-card {
	    position: relative;
	    width: 112%;
	    height: 470px;
	    min-height: 470px;
	    display: flex;
	    flex-direction: column;
	    background: transparent;
	    padding: 0 46px;
	    box-shadow: none;
	}

	.section-main-bbs .main-calendar-card .card-header {
	    flex: 0 0 auto;
	    padding: 4px 0 8px;
	    margin: 0 4px 4px;
	    border: 0;
	}

	/* 학사일정 탭(nav-link) 폰트/패딩 */
	.main-calendar-card .main-calendar-tabs .nav-link {
	    font-size: 0.85rem;
	    padding-inline: 0.75rem;
	}

	/* 학사일정 탭 active 상태 */
	.main-calendar-card .main-calendar-tabs .nav-link.active {
	    background-color: #0d6efd;
	    color: #fff;
	}

	/* 학사일정 리스트 항목 경계선 */
	.main-calendar-card .list-group-item {
	    border: 0;
	    border-top: 1px solid rgba(148, 163, 184, 0.35);
	}

	/* YYYY.MM 라벨 행 레이아웃 */
	.main-calendar-card .calendar-month-row {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    gap: 1.25rem;
	    margin-top: 0.25rem;
	    margin-bottom: 10px;
	}

	/* 초기 서버 렌더 월 라벨 숨김용(data-year/month) */
	.main-calendar-card #miniCalendarMonthLabel {
	    min-width: 120px;
	    text-align: center;
	    font-weight: 600;
	    line-height: 2.3;
	}

	/* 최종 표시용 월 라벨 스타일 */
	.main-calendar-card .calendar-month-label {
	    font-weight: 700;
	    font-size: 1rem;
	    letter-spacing: 0.04em;
	    color: #0f172a;
	}

	/* 학사일정 내부 흰색 카드 */
	.main-calendar-card .main-calendar-inner {
	    position: relative;
	    flex: 1 1 auto;
	    min-height: 0;
	    display: flex;
	    flex-direction: column;
	    background: #ffffff;
	    border-radius: 18px;
	    box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
	    padding: 5px 8px 8px;
	    box-sizing: border-box;
	}

	/* 리스트 + 좌우 화살표 한 줄 레이아웃 */
	.main-calendar-card .main-calendar-row {
	    position: relative;
	    display: flex;
	    align-items: flex-start;
	    gap: 0.75rem;
	    flex: 1 1 auto;
	    min-height: 0;
	    padding: 0.5rem 0 1rem;
	}

	/* 학사일정 화살표 공통 스타일 */
	.main-calendar-card .calendar-arrow {
	    position: absolute;
	    top: 50%;
	    transform: translateY(-50%);
	    width: 34px;
	    height: 34px;
	    flex: 0 0 34px;
	    border-radius: 999px;
	    border: none;
	    background: #0f172a;
	    color: #f9fafb;
	    display: inline-flex;
	    align-items: center;
	    justify-content: center;
	    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.45);
	    padding: 0;
	    cursor: pointer;
	    z-index: 5;
	}

	.main-calendar-card .calendar-arrow i {
	    font-size: 18px;
	}

	.main-calendar-card .calendar-arrow:hover {
	    background: #111827;
	}

	/* 학사일정 이전/다음 화살표 위치 */
	.main-calendar-card .calendar-arrow-prev {
	    left: -55px;
	}
	.main-calendar-card .calendar-arrow-next {
	    right: -55px;
	}

	/* 학사일정 리스트 UL(스크롤 영역) */
	.main-calendar-card .main-calendar-list {
	    width: 100%;
	    box-sizing: border-box;
	    flex: 1 1 auto;
	    min-height: 0;
	    height: 100%;
	    max-height: none;
	    margin-bottom: 0;
	    overflow-y: auto;
	    overflow-x: hidden;
	    padding-right: 4px;
	}

	/* 학사일정 리스트 내 flex 영역 너비 보정 */
	.main-calendar-card .main-calendar-item .flex-grow-1 {
	    min-width: 0;
	}

	/* 공지/학사일정 리스트 스크롤바 공통 */
	.main-bbs-card .main-bbs-list::-webkit-scrollbar,
	.main-calendar-card .main-calendar-list::-webkit-scrollbar {
	    width: 6px;
	}
	.main-bbs-card .main-bbs-list::-webkit-scrollbar-track,
	.main-calendar-card .main-calendar-list::-webkit-scrollbar-track {
	    background: transparent;
	}
	.main-bbs-card .main-bbs-list::-webkit-scrollbar-thumb,
	.main-calendar-card .main-calendar-list::-webkit-scrollbar-thumb {
	    background: #cbd5f5;
	    border-radius: 999px;
	}

	/* 학사일정 비어 있을 때 리스트 아이템 스타일 */
	.main-calendar-empty {
	    border: 0;
	    background-color: #f9fafb;
	}

	/* 빈 상태 래퍼 레이아웃 */
	.calendar-empty-wrapper {
	    display: inline-flex;
	    flex-direction: column;
	    align-items: center;
	    gap: 0.35rem;
	}

	/* 빈 상태 아이콘 크기(텍스트보다 약간 크게) */
	.calendar-empty-icon {
	    font-size: 1.5rem;
	}

	/* 빈 상태 안내 문구 텍스트 */
	.calendar-empty-text {
	    font-size: 1.2rem;
	    font-weight: 500;
	}

	/* ============================================
	   2. 학교 행사 단일 포스터 카드(index-event-card)
	   ============================================ */

	.index-event-card {
	    max-width: 280px;
	    margin-inline: auto;
	    border-radius: 1rem;
	    border: none;
	    background: #0f172a;
	    color: #fff;
	}

	.index-event-thumb-wrap {
	    padding: 1rem 1rem 0.5rem;
	}

	.index-event-thumb {
	    position: relative;
	    width: 100%;
	    padding-top: 135%;
	    border-radius: 0.9rem;
	    overflow: hidden;
	    background: #020617 center/cover no-repeat;
	}

	.index-event-body {
	    padding: 0.75rem 1.25rem 1.1rem;
	    text-align: center;
	}

	.index-event-title {
	    font-size: 0.98rem;
	    font-weight: 600;
	    margin-bottom: 0.25rem;
	}

	.index-event-desc {
	    font-size: 0.8rem;
	    color: rgba(248, 250, 252, 0.7);
	    min-height: 2.4em;
	}

	/* ============================================
	   3. 학교 행사 포커 카드 캐러셀(event-card)
	   ============================================ */

	.section-main-events {
	    /* 섹션 공통 패딩만 사용 */
	}

	.event-carousel {
	    position: relative;
	    max-width: 920px;
	    margin: 0 auto;
	    padding: 35px 55px;
	}

	/* 포스터 카드 트랙(카드 높이 10% 확대 반영) */
	.event-card-track {
	    position: relative;
	    list-style: none;
	    margin: 0;
	    padding: 0;
	    height: 310px; /* 확대 */
	}

	/* 개별 행사 카드 컨테이너(10% 확대) */
	.event-card {
	    position: absolute;
	    top: 0;
	    left: 50%;
	    width: 220px;  /* 확대 */
	    height: 320px; /* 확대 */
	    transform: translateX(-50%);
	    transition:
	        transform 0.35s ease,
	        opacity 0.35s ease,
	        z-index 0.35s ease;
	    opacity: 0;
	    pointer-events: none;
	}

	.event-card-inner {
	    position: relative;
	    background: #020617;
	    border-radius: 22px;
	    overflow: hidden;
	    height: 100%;
	    box-shadow: 0 20px 40px rgba(15, 23, 42, 0.45);
	}

	.event-card-thumb {
	    position: absolute;
	    inset: 0;
	}

	.event-card-thumb img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	    display: block;
	}

	.event-card-body {
	    position: absolute;
	    left: 0;
	    right: 0;
	    bottom: 0;
	    padding: 14px 14px 16px;
	    background: linear-gradient(to top, rgba(15, 23, 42, 0.94), rgba(15, 23, 42, 0));
	    text-align: left;
	}

	.event-card-title {
	    font-size: 1rem;  
	    font-weight: 600;
	    color: #f9fafb;
	    margin-bottom: 4px;
	}

	.event-card-desc {
	    font-size: 0.90rem;  
	    color: rgba(226, 232, 240, 0.9);
	    line-height: 1.35;
	    margin-bottom: 0;
	}

	/* 중앙 포커스 카드 (data-pos="0") */
	.event-card[data-pos="0"] {
	    transform: translateX(-50%) scale(1.05);
	    z-index: 5;
	    opacity: 1;
	    pointer-events: auto;
	}

	/* 양 옆 1단계 카드 (data-pos="1", "-1") */
	.event-card[data-pos="1"] {
	    transform: translateX(calc(-50% + 209px)) scale(0.95);
	    z-index: 4;
	    opacity: 1;
	}
	.event-card[data-pos="-1"] {
	    transform: translateX(calc(-50% - 209px)) scale(0.95);
	    z-index: 4;
	    opacity: 1;
	}

	/* 양 옆 2단계 카드 (data-pos="2", "-2") */
	.event-card[data-pos="2"] {
	    transform: translateX(calc(-50% + 363px)) scale(0.88);
	    z-index: 3;
	    opacity: 0.95;
	}
	.event-card[data-pos="-2"] {
	    transform: translateX(calc(-50% - 363px)) scale(0.88);
	    z-index: 3;
	    opacity: 0.95;
	}

	/* 오른쪽/왼쪽 스택 카드 */
	.event-card[data-pos="right-stack"] {
	    transform: translateX(calc(-50% + 473px)) scale(0.78) rotateY(-15deg);
	    z-index: 2;
	    opacity: 0.7;
	}
	.event-card[data-pos="left-stack"] {
	    transform: translateX(calc(-50% - 473px)) scale(0.78) rotateY(15deg);
	    z-index: 2;
	    opacity: 0.7;
	}

	/* 행사 캐러셀 화살표 공통 스타일 */
	.event-arrow {
	    position: absolute;
	    top: 50%;
	    transform: translateY(-50%);
	    width: 34px;
	    height: 34px;
	    border-radius: 999px;
	    border: none;
	    background: #0f172a;
	    color: #f9fafb;
	    display: inline-flex;
	    align-items: center;
	    justify-content: center;
	    cursor: pointer;
	    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.45);
	    z-index: 10;
	}

	.event-arrow:hover {
	    background: #111827;
	}

	.event-arrow-prev {
	    left: -130px;
	}
	.event-arrow-next {
	    right: -130px;
	}

	/* ============================================
	   4. 학술 논문 리서치 캐러셀
	   ============================================ */

	.research-carousel .research-card {
	    background: #ffffff;
	    border-radius: 1.5rem;
	    box-shadow: 0 20px 45px rgba(15, 23, 42, 0.18);
	    overflow: hidden;
	}

	.research-image-wrap {
	    min-height: 260px;
	    height: 100%;
	}

	.research-image-wrap img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	    display: block;
	}

	.research-body {
	    background: #ffffff;
	}

	.research-body .research-meta {
	    font-size: 0.85rem;
	    letter-spacing: 0.04em;
	    text-transform: uppercase;
	}

	.research-body .research-title {
	    font-size: 1.4rem;
	    font-weight: 600;
	    line-height: 1.4;
	}

	.research-body .research-desc {
	    font-size: 0.95rem;
	}

	.research-carousel .carousel-control-prev,
	.research-carousel .carousel-control-next {
	    width: 3.5rem;
	}

	.research-carousel .carousel-control-prev-icon,
	.research-carousel .carousel-control-next-icon {
	    filter: invert(1);
	}

	/* ============================================
	   5. 메인 학사일정 legend 타입 토글
	   ============================================ */

	.section-main-bbs .main-legend {
	    display: flex;
	    flex-wrap: wrap;
	    gap: 0.75rem;
	    align-items: center;
	}

	/* ============================================
	   6. hero 섹션 배경 및 딤 레이어
	   ============================================ */

	.hero-section {
	    position: relative;
	    overflow: hidden;
	    background-size: cover;
	    background-position: center center;
	    background-repeat: no-repeat;
	}

	.hero-section > .container {
	    position: relative;
	    z-index: 1;
	}

	.hero-bg-layer {
	    position: absolute;
	    inset: 0;
	    z-index: 0;
	    background: rgba(15, 23, 42, 0.75);
	    opacity: 0.02;
	    transition: opacity 0.9s ease-in-out;
	    pointer-events: none;
	}

	/* ============================================
	   7. 섹션 상단 View More 링크 버튼
	   ============================================ */

	.section-link-more {
	    position: relative;
	    display: inline-flex;
	    align-items: center;
	    gap: 0.25rem;
	    font-size: 0.9rem;
	    font-weight: 600;
	    letter-spacing: 0.03em;
	    margin-right: 18px;
	    color: #3284fa;
	    text-decoration: none;
	    border: none;
	    background: none;
	    padding: 4px 0;
	    cursor: pointer;
	}

	.section-link-more::after {
	    content: "+";
	    display: inline-block;
	    font-size: 1.7em;
	    margin-left: 0.02rem;
	    transform: rotate(0deg);
	    transform-origin: center center;
	    transition: transform 0.4s ease-out, opacity 0.4s ease-out;
	    opacity: 0.9;
	}

	.section-link-more:hover::after {
	    transform: rotate(180deg);
	    opacity: 1;
	}

	/* 공지사항 | 학사일정 가운데 세로 구분선 */
	.main-bbs-row-divider {
	    position: relative;
	}
	.main-bbs-row-divider::before {
	    content: "";
	    position: absolute;
	    top: 16px;
	    bottom: 16px;
	    left: 50%;
	    width: 3px;
	    background: #e3e6ee;
	}
	.main-bbs-row-divider > .col-xl-6:first-child,
	.main-bbs-row-divider > .col-lg-6:first-child,
	.main-bbs-row-divider > .col-md-6:first-child {
	    padding-right: 2.5rem;
	}
</style>


</head>
<body>

<!-- 
히어로 / 대형 백그라운드: 1920 x 1080
뉴스 메인: 1000 x 750
행사 포스터: 600 x 800
논문 이미지: 1200 x 700
작은 아이콘/썸네일: 128 x 128 또는 192 x 192
 -->
<main>
    <!-- 히어로 -->
    <section class="hero-section">
        <div class="container">
            <div class="hero-layout">
                <div class="hero-copy">
                    <div class="hero-kicker">스마트 캠퍼스 통합 포털</div>
                    <h1 class="hero-title">
                        창의적 인재와 함께 미래 캠퍼스를<br /> 만들어 가는 대덕대학교
                    </h1>
                    <p class="hero-desc">
                        입학·학사·장학·대학생활·연구 정보를 한 화면에서 연결하는 대덕대학교 메인
                        포털입니다. 재학생, 예비대학생, 동문 모두를 위한 캠퍼스 허브를 목표로 합니다.
                    </p>

                    <form id="globalSearchForm"
                          class="hero-search-wrap"
                          action="<c:url value='/search' />"
                          method="get">
                        <input type="text"
                               name="q"
                               class="hero-search-input"
                               placeholder="예) 장학금, 학사일정, 입학전형, 도서관 검색 등" />
                        <button type="submit" class="hero-search-btn">
                            캠퍼스 통합 검색
                        </button>
                    </form>

                    <div class="hero-quick-links">
                        <button type="button" class="btn btn-sm">재학생 안내</button>
                        <button type="button" class="btn btn-sm">예비대학생 안내</button>
                        <button type="button" class="btn btn-sm">동문·일반인 서비스</button>
                    </div>
                </div>
                <%-- 필요 시 우측 비주얼(슬라이드) 영역 추가 예정: .hero-visual --%>
            </div>
        </div>
    </section>

    <!-- 대내외 뉴스 섹션 -->
    <section class="news-section">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="research-section-title mb-0">대덕 뉴스</h2>
                <a href="${cPath}/news" class="section-link-more">View More</a>
            </div>

            <c:if test="${not empty news_bbs}">
                <c:set var="firstNews" value="${news_bbs[0]}"/>

                <div class="row g-5 align-items-stretch">
                    <!-- 좌측 썸네일 (클릭 시 게시판 상세 이동) -->
                    <div class="col-lg-5">
                        <a href="${cPath}/bbs/detail?bbscttNo=${firstNews.bbscttNo}"
                           class="d-block rounded-3 overflow-hidden shadow-sm text-decoration-none">
                            <div class="ratio ratio-4x3 bg-light">
                                <c:choose>
                                    <c:when test="${not empty firstNews.fileGroupNo}">
                                        <img src="${pageContext.request.contextPath}/images/news/${firstNews.fileGroupNo}.png"
                                             alt="<c:out value='${firstNews.bbscttSj}'/>" />
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${cPath}/images/news/default.jpg"
                                             alt="<c:out value='${firstNews.bbscttSj}'/>" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </a>
                    </div>

                    <!-- 우측 헤드라인/리스트 -->
                    <!-- 헤드라인 제목 클릭 시 게시판 상세 이동 -->
                    <div class="col-lg-7">
                        <div class="h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="badge bg-primary rounded-pill mb-3 px-3 py-2">
                                    캠퍼스·대내외 뉴스
                                </div>
                                <h3 class="h4 fw-bold mb-3">
                                   <a href="${cPath}/bbs/detail?bbscttNo=${firstNews.bbscttNo}"
                                       class="text-decoration-none text-dark">
                                        <c:out value="${firstNews.bbscttSj}"/>
                                    </a>
                                </h3>
                                <p class="text-muted mb-0 line-clamp-3">
                                    <c:out value="${firstNews.bbscttCn}"/>
                                </p>
                            </div>

                            <!-- 나머지 뉴스 목록: 각 제목 클릭 시 게시판 상세 이동 -->
                            <ul class="list-unstyled mt-4 mb-0">
                                <c:forEach var="item" items="${news_bbs}" varStatus="st" begin="1" end="4">
                                    <li class="d-flex justify-content-between align-items-baseline py-2 border-top border-light-subtle">
                                        <a href="${cPath}/bbs/detail?bbscttNo=${item.bbscttNo}"
                                           class="flex-grow-1 me-3 text-decoration-none text-body text-truncate">
                                            <c:out value="${item.bbscttSj}"/>
                                        </a>
                                        <span class="text-muted small">
                                            <fmt:formatDate value="${item.bbscttWritngDe}" pattern="MM.dd"/>
                                        </span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </section>

	<!-- 공지사항 + 학사일정 -->
	<section class="section section-main-bbs">
	    <div class="container main-bbs-container">
	        <!-- 여기 row에 클래스 하나 추가 -->
	        <div class="row gy-1 justify-content-center main-bbs-row-divider">
	            <!-- 공지사항 -->
	            <div class="col-xl-6 col-lg-6 col-md-6">
	                <div class="d-flex justify-content-between align-items-center mb-0">
	                    <h2 class="research-section-title mb-0">&nbsp;&nbsp;&nbsp;&nbsp;공지사항</h2>
	                    <a href="${cPath}/bbs/notice" class="section-link-more">View More</a>
	                </div>
	
	                <!-- 공지사항 메인 카드 래퍼 -->
	                <div class="main-bbs-card">
	                    <!-- 상단 설명 텍스트 -->
	                    <div class="card-header main-bbs-card-header">
	                        <p class="card-subtitle text-muted mb-0">
	                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;학사·등록·장학 등 주요 안내
	                        </p>
	                    </div>
	
	                    <!-- 흰색 카드 + 스크롤 리스트 -->
	                    <div class="main-bbs-inner">
	                        <ul class="list-group list-group-flush main-bbs-list">
	                            <c:if test="${empty notices_bbs}">
	                                <li class="list-group-item main-bbs-empty text-muted">
	                                    등록된 공지사항이 없습니다.
	                                </li>
	                            </c:if>
							  <!-- 제목 클릭 시 공지 게시판 상세 이동 -->
							                                                
	                            <c:forEach var="row" items="${notices_bbs}" varStatus="st">
	                                <c:if test="${st.index lt 6}">
	                                    <li class="list-group-item">
	                                        <div class="d-flex flex-column">
	                                            <div class="d-flex justify-content-between align-items-start">
	                                              <a href="${cPath}/bbs/detail?bbscttNo=${row.bbscttNo}"
	                                                   class="main-bbs-title text-body text-truncate text-decoration-none">
	                                                    <c:out value="${row.bbscttSj}" />
	                                                </a>
	                                                <span class="text-muted main-bbs-meta ms-2">
	                                                    <fmt:formatDate value="${row.bbscttWritngDe}"
	                                                                    pattern="yyyy.MM.dd" />
	                                                </span>
	                                            </div>
	                                            <p class="text-muted mb-0 main-bbs-meta text-truncate-2">
	                                                <c:out value="${row.bbscttCn}" />
	                                            </p>
	                                        </div>
	                                    </li>
	                                </c:if>
	                            </c:forEach>
	                        </ul>
	                    </div>
	                </div>
	            </div>
	
	            <!-- 학사일정 카드 -->
	            <div class="col-xl-6 col-lg-6 col-md-6">
	                <div class="d-flex justify-content-between align-items-center mb-0">
	                    <h2 class="research-section-title mb-0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;학사일정</h2>
	                    <a href="/schedule/calendar" class="section-link-more">View More</a>
	                </div>
	
	                <!-- 학사일정 메인 카드: 백그라운드, 그림자, 패딩 포함 -->
	                <div class="main-calendar-card"
	                     data-calendar-endpoint="/api/index/calendar">
	                    <div class="card-header">
	                        <p class="card-subtitle text-muted mb-0 ps-3">
	                            학사·등록·행사 등 월간 주요 일정
	                        </p>
	                    </div>
	
	                    <!-- 흰색 내부 카드 (YYYY.MM + 리스트 + 좌우 이동 버튼) -->
	                    <div class="main-calendar-inner">
	                        <!-- 카드 내부 중앙 정렬된 YYYY.MM 라벨 -->
	                        <div class="calendar-month-row">
	                            <div id="miniCalendarMonthLabel"
	                                 class="calendar-month-label"
	                                 data-year="${currentYear}"
	                                 data-month="${currentMonth}">
	                                ${currentYear}.
	                                <fmt:formatNumber value="${currentMonth}" pattern="00"/>
	                            </div>
	                        </div>
	
	                        <!-- 좌우 화살표 + 일정 리스트 -->
	                        <div class="main-calendar-row">
	                            <!-- 이전 달 -->
	                            <button type="button"
	                                    class="calendar-arrow calendar-nav calendar-arrow-prev"
	                                    data-year="${prevYear}"
	                                    data-month="${prevMonth}">
	                                <i class="ri-arrow-left-s-line"></i>
	                            </button>
	
	                            <!-- 일정 리스트: 서버 렌더 + AJAX 공통 타겟 -->
	                            <ul class="list-group list-group-flush main-calendar-list flex-grow-1">
	                                <c:if test="${empty academicSchedules}">
	                                    <li class="list-group-item main-calendar-item main-calendar-empty text-muted text-center py-5">
	                                        <div class="calendar-empty-wrapper">
	                                            <i class="ri-calendar-line calendar-empty-icon" aria-hidden="true"></i>
	                                            <div class="calendar-empty-text">
	                                                등록된 학사일정이 없습니다.
	                                            </div>
	                                        </div>
	                                    </li>
	                                </c:if>
	
	                                <c:forEach var="sch" items="${academicSchedules}" varStatus="st">
	                                    <c:if test="${st.index lt 6}">
	                                        <c:set var="calGroup"
	                                               value="${sch.type eq 'ADMIN_REGIST' ? 'REGI'
	                                                        : (sch.type eq 'ADMIN_EVENT' ? 'EVENT' : 'ACAD')}"/>
	
	                                        <li class="list-group-item d-flex main-calendar-item"
	                                            data-event-type="${sch.type}"
	                                            data-cal-group="${calGroup}">
	                                            <div class="me-3 text-center" style="min-width:4.5rem;">
	                                                <div class="fw-semibold fs-6">
	                                                    <fmt:parseDate value="${sch.startDate}"
	                                                                   pattern="yyyy-MM-dd"
	                                                                   var="startDateObj" />
	                                                    <fmt:formatDate value="${startDateObj}" pattern="MM.dd" />
	                                                </div>
	                                            </div>
	                                            <div class="flex-grow-1">
	                                                <div class="fw-semibold mb-1 text-truncate">
	                                                    <c:out value="${sch.title}"/>
	                                                </div>
	                                                <p class="mb-0 text-muted small text-truncate">
	                                                    <c:out value="${sch.memo}"/>
	                                                </p>
	                                            </div>
	                                        </li>
	                                    </c:if>
	                                </c:forEach>
	                            </ul>
	
	                            <!-- 다음 달 -->
	                            <button type="button"
	                                    class="calendar-arrow calendar-nav calendar-arrow-next"
	                                    data-year="${nextYear}"
	                                    data-month="${nextMonth}">
	                                <i class="ri-arrow-right-s-line"></i>
	                            </button>
	                        </div>
	                    </div>
	                </div>
	            </div>
	            <!-- 학사일정 섹션 종료 -->
	
	        </div>
	    </div>
	</section>


    <!-- 학교 행사 -->
    <section class="section-main-events">
        <div class="container-xxl">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="research-section-title mb-0">학교 내외부 행사</h2>
                <a href="${cPath}/bbs/list?bbsCode=2" class="section-link-more">View More</a>
            </div>

        <div class="event-carousel">
            <button class="event-arrow event-arrow-prev" type="button">
                <i class="ri-arrow-left-s-line"></i>
            </button>

            <ul class="event-card-track">
	            <!-- 카드 전체 클릭 시 게시판 상세 이동 -->
                <c:forEach var="item" items="${events_bbs}" varStatus="st">
                    <li class="event-card" data-index="${st.index}">
                        <div class="event-card-inner">
                           <a href="${cPath}/bbs/detail?bbscttNo=${item.bbscttNo}"
                               class="d-block h-100 text-decoration-none text-reset">
                                <div class="event-card-thumb">
                                    <c:choose>
                                        <c:when test="${not empty item.fileGroupNo}">
                                            <div class="poster-wrapper">
                                                <img src="${pageContext.request.contextPath}/images/event/${item.fileGroupNo}.png"
                                                     alt="<c:out value='${item.bbscttSj}'/>"
                                                     class="poster-img"/>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${cPath}/images/event/default.jpg"
                                                 alt="<c:out value='${item.bbscttSj}'/>" />
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="event-card-body">
                                    <h5 class="event-card-title">
                                        <c:out value="${item.bbscttSj}" />
                                    </h5>
                                    <p class="event-card-desc">
                                        <c:out
                                            value="${fn:length(item.bbscttCn) > 30
                                                     ? fn:substring(item.bbscttCn,0,30).concat('...')
                                                     : item.bbscttCn}" />
                                    </p>
                                </div>
                            </a>
                        </div>
                    </li>
                </c:forEach>
            </ul>

            <button class="event-arrow event-arrow-next" type="button">
                <i class="ri-arrow-right-s-line"></i>
            </button>
        </div>
        </div>
    </section>

    <!-- 학술·논문 -->
    <section class="section" id="research-section">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="research-section-title mb-0">학술·논문</h2>
                <a href="${cPath}/bbs/3/list" class="section-link-more">View More</a>
            </div>

            <div id="researchCarousel"
                 class="carousel slide research-carousel"
                 data-bs-ride="carousel"
                 data-bs-interval="8000">

                <div class="carousel-inner">
	                <!-- 좌측 썸네일 (클릭 시 게시판 상세 이동) -->
	                                
                    <c:forEach var="paper" items="${papers_bbs}" varStatus="st">
                        <div class="carousel-item <c:if test='${st.first}'>active</c:if>">
                            <div class="row g-0 align-items-stretch research-card">
                                <div class="col-lg-5 col-md-6">
                                    <div class="research-image-wrap">
                                        <a href="${cPath}/bbs/detail?bbscttNo=${paper.bbscttNo}"
                                           class="d-block h-100">
                                            <c:choose>
                                                <c:when test="${not empty paper.fileGroupNo}">
                                                    <img src="${pageContext.request.contextPath}/images/research_act/${paper.fileGroupNo}.png"
                                                         alt="<c:out value='${paper.bbscttSj}'/>">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${cPath}/images/research_act/default.jpg"
                                                         alt="연구 대표 이미지">
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </div>
                                </div>

                                <!-- 우측 연구 제목/요약 -->
                                <!-- 제목 클릭 시 게시판 상세 이동 -->
                                <div class="col-lg-7 col-md-6">
                                    <div class="research-body h-100 d-flex flex-column justify-content-center p-4 p-lg-5">
                                        <div class="research-meta text-muted mb-2">
                                            Research ·
                                            <fmt:formatDate value="${paper.bbscttWritngDe}" pattern="yyyy.MM.dd"/>
                                        </div>
                                        <h3 class="research-title mb-3">
                                            <a href="${cPath}/bbs/detail?bbscttNo=${paper.bbscttNo}"
                                               class="text-reset text-decoration-none">
                                                <c:out value="${paper.bbscttSj}"/>
                                            </a>
                                        </h3>
                                        <p class="research-desc text-muted mb-0 line-clamp-3">
                                            <c:out value="${paper.bbscttCn}"/>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <button class="carousel-control-prev" type="button"
                        data-bs-target="#researchCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button"
                        data-bs-target="#researchCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </div>
    </section>

</main>

<%@ include file="index-footer.jsp"%>

<!-- Bootstrap JS -->
<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
    crossorigin="anonymous"></script>
<script>
/**
 * index.jsp 공통 스크립트
 * 1) 통합 검색 폼 검증
 * 2) 헤더 스크롤 배경 전환
 * 3) 히어로 섹션 랜덤 배경
 * 4) 메인 학사일정 카드 (이전/다음 월 AJAX + 범례 필터)
 * 5) 학교 행사 포커 캐러셀
 */

document.addEventListener('DOMContentLoaded', function () {

    /* -------------------------------------------------------
     * 1 통합 검색 폼 검증
     *  - 공백 검색 방지
     * ----------------------------------------------------- */
    (function () {
        const form  = document.getElementById('globalSearchForm');
        if (!form) return;

        const input = form.querySelector('input[name="q"]');
        if (!input) return;

        form.addEventListener('submit', function (e) {
            if (!input.value.trim()) {
                e.preventDefault();
                alert('검색어를 입력해주세요.');
                input.focus();
            }
        });
    })();

    /* -------------------------------------------------------
     * 2 히어로 섹션 랜덤 배경 (어두워졌다가 새 이미지로)
     *  - 10초마다: 현재 이미지 유지 → 딤 레이어 서서히 1 → 새 이미지로 교체 → 딤 0
     * ----------------------------------------------------- */
    (function () {
        const heroSection = document.querySelector('.hero-section');
        if (!heroSection) return;

        const basePath = '${pageContext.request.contextPath}/images/background/';

        const backgroundFiles = [
            <c:forEach var="img" items="${background_images}" varStatus="st">
            '${img}'<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ].filter(function (name) {
            return !!name;
        });

        if (!backgroundFiles.length) {
            console.warn('[hero-bg] background_images 비어 있음, 랜덤 배경 비활성');
            return;
        }

        const backgroundUrls = backgroundFiles.map(function (name) {
            return basePath + name;
        });

        // 미리 로드
        backgroundUrls.forEach(function (src) {
            const img = new Image();
            img.src = src;
        });

        // 딤 레이어 준비
        let dimLayer = heroSection.querySelector('.hero-bg-layer');
        if (!dimLayer) {
            dimLayer = document.createElement('div');
            dimLayer.className = 'hero-bg-layer';
            heroSection.prepend(dimLayer);
        }

        let currentIndex = -1;
        let isTransitionRunning = false;
        let phase = 'idle'; // 'darkening' | 'brightening'

        function pickNextIndex() {
            if (backgroundUrls.length <= 1) return 0;
            let idx = Math.floor(Math.random() * backgroundUrls.length);
            if (idx === currentIndex) {
                idx = (idx + 1) % backgroundUrls.length;
            }
            return idx;
        }

        function applyBackground(url) {
            heroSection.style.backgroundImage =
                'linear-gradient(to bottom, rgba(15,23,42,0.45), rgba(15,23,42,0.35)), url("' + url + '")';
        }

        function handleTransitionEnd(event) {
            if (event.propertyName !== 'opacity') return;

            if (phase === 'darkening') {
                // 완전히 어두워진 시점 → 새 이미지로 교체
                const nextIdx = pickNextIndex();
                const nextUrl = backgroundUrls[nextIdx];
                currentIndex = nextIdx;
                applyBackground(nextUrl);

                phase = 'brightening';

                // 다음 프레임에서 다시 밝게
                requestAnimationFrame(function () {
                    dimLayer.style.opacity = '0';
                });
            } else if (phase === 'brightening') {
                // 밝기 회복 완료
                dimLayer.removeEventListener('transitionend', handleTransitionEnd);
                phase = 'idle';
                isTransitionRunning = false;
            }
        }

        function startBackgroundTransition() {
            if (isTransitionRunning) return;
            isTransitionRunning = true;
            phase = 'darkening';

            dimLayer.addEventListener('transitionend', handleTransitionEnd);

            // 딤 레이어 점점 1 → 어두워지는 구간
            requestAnimationFrame(function () {
                dimLayer.style.opacity = '1';
            });
        }

        // 초기 1회: 그냥 이미지만 세팅 (어두워졌다 밝아지는 효과 없이)
        (function init() {
            const firstIdx = pickNextIndex();
            currentIndex = firstIdx;
            applyBackground(backgroundUrls[firstIdx]);
            dimLayer.style.opacity = '0';
        })();

        // 10초마다 전환
        setInterval(startBackgroundTransition, 10000);
    })();
    /* -------------------------------------------------------
     * 3 메인 학사일정 카드
     *  - /api/index/calendar AJAX로 월별 일정 조회
     *  - 범례 클릭 시 해당 type 숨김/표시
     *  - 초기 진입 시 서버 렌더 결과에 바로 필터만 적용
     * ----------------------------------------------------- */
    (function () {
        const card = document.querySelector('.main-calendar-card');
        if (!card) return;

        const endpoint    = card.getAttribute('data-calendar-endpoint');
        const monthLabel  = card.querySelector('#miniCalendarMonthLabel');
        const listEl      = card.querySelector('.main-calendar-list');
        const prevBtn     = card.querySelector('.calendar-arrow-prev');
        const nextBtn     = card.querySelector('.calendar-arrow-next');
        const legendItems = card.querySelectorAll('.legend-item');

        if (!endpoint || !monthLabel || !listEl) {
            console.warn('[index-calendar] 필수 요소 누락');
            return;
        }

        // 숨김 처리된 type 코드 집합
        const hiddenTypes = new Set();

        // type 코드 정규화 (공백 제거 + 대문자 통일)
        function normalizeType(raw) {
            return (raw || '').trim().toUpperCase();
        }

        function escapeHtml(str) {
            return String(str == null ? '' : str)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function getCurrentYearMonth() {
            const y = parseInt(monthLabel.getAttribute('data-year'), 10);
            const m = parseInt(monthLabel.getAttribute('data-month'), 10);
            return {
                year: isNaN(y) ? new Date().getFullYear() : y,
                month: isNaN(m) ? new Date().getMonth() + 1 : m
            };
        }

        function updateMonthLabel(year, month) {
            const mm = month < 10 ? '0' + month : '' + month;
            monthLabel.setAttribute('data-year', year);
            monthLabel.setAttribute('data-month', month);
            monthLabel.textContent = year + '. ' + mm;
        }

        // hiddenTypes 상태를 실제 DOM에 반영
        function applyLegendFilter() {
            const rows = listEl.querySelectorAll('.main-calendar-item');
            rows.forEach(function (row) {
                const t = normalizeType(row.dataset.eventType);
                row.style.display = (t && hiddenTypes.has(t)) ? 'none' : '';
            });
        }

     	// AJAX 응답 렌더링 (부트스트랩 list-group 스타일과 일치)
		function renderEvents(events) {
		    listEl.innerHTML = '';
		
		    if (!events || !events.length) {
		        const emptyRow = document.createElement('li');
		        emptyRow.className =
		            'list-group-item main-calendar-item main-calendar-empty text-muted text-center py-5';
		        emptyRow.innerHTML = `
		            <div class="calendar-empty-wrapper">
		                <i class="ri-calendar-line calendar-empty-icon" aria-hidden="true"></i>
		                <div class="calendar-empty-text">
		                    등록된 학사일정이 없습니다.
		                </div>
		            </div>
		        `;
		        listEl.appendChild(emptyRow);
		        return;
		    }
		    
            events.forEach(function (ev) {
                const row = document.createElement('li');
                row.className = 'list-group-item d-flex main-calendar-item';

                // type 코드 정규화해서 data-event-type 에 저장
                const typeKey = normalizeType(ev.type);
                row.dataset.eventType = typeKey;

                let dateLabel = ev.startLabel || '';
                if (!dateLabel && ev.startDate && ev.startDate.length >= 10) {
                    const mm = ev.startDate.substring(5, 7);
                    const dd = ev.startDate.substring(8, 10);
                    dateLabel = mm + '.' + dd;
                }

                row.innerHTML =
                    '<div class="me-3 text-center" style="min-width:4.5rem;">' +
                        '<div class="fw-semibold fs-6">' + escapeHtml(dateLabel) + '</div>' +
                    '</div>' +
                    '<div class="flex-grow-1">' +
                        '<div class="fw-semibold mb-1 text-truncate">' +
                            escapeHtml(ev.title || '') +
                        '</div>' +
                        '<p class="mb-0 text-muted small text-truncate">' +
                            escapeHtml(ev.memo || '') +
                        '</p>' +
                    '</div>';

                listEl.appendChild(row);
            });

            applyLegendFilter();
        }

        // 월 변경 → API 호출
        function loadMonth(year, month) {
            const url = endpoint
                + '?year=' + encodeURIComponent(year)
                + '&month=' + encodeURIComponent(month);

            fetch(url, {
                method: 'GET',
                headers: { 'Accept': 'application/json' },
                credentials: 'same-origin'
            })
                .then(function (res) {
                    if (!res.ok) throw new Error('calendar http ' + res.status);
                    return res.json();
                })
                .then(function (data) {
                    updateMonthLabel(year, month);
                    renderEvents(data);
                })
                .catch(function (err) {
                    console.error('[index-calendar] fetch 실패', err);
                });
        }

        function moveMonth(delta) {
            const ym = getCurrentYearMonth();
            let y = ym.year;
            let m = ym.month + delta;

            if (m <= 0) {
                m += 12;
                y -= 1;
            } else if (m > 12) {
                m -= 12;
                y += 1;
            }
            loadMonth(y, m);
        }

        if (prevBtn) {
            prevBtn.addEventListener('click', function (e) {
                e.preventDefault();
                moveMonth(-1);
            });
        }
        if (nextBtn) {
            nextBtn.addEventListener('click', function (e) {
                e.preventDefault();
                moveMonth(1);
            });
        }

        // 범례 클릭 시 type 토글
        legendItems.forEach(function (item) {
            const typeKey = normalizeType(item.getAttribute('data-type'));
            if (!typeKey) return;

            // 정규화된 type 코드 저장 (디버깅용)
            item.dataset.typeKey = typeKey;

            item.addEventListener('click', function () {
                if (hiddenTypes.has(typeKey)) {
                    hiddenTypes.delete(typeKey);
                    item.classList.remove('legend-disabled');
                } else {
                    hiddenTypes.add(typeKey);
                    item.classList.add('legend-disabled');
                }
                applyLegendFilter();
            });
        });

        // 서버에서 처음 렌더한 li 도 type 정규화 + 클래스 부여
        (function initServerRendered() {
            const rows = listEl.querySelectorAll('[data-event-type]');
            rows.forEach(function (row) {
                const key = normalizeType(row.getAttribute('data-event-type'));
                row.dataset.eventType = key;
                row.classList.add('main-calendar-item');
            });
            applyLegendFilter();
        })();

    })();

    /* -------------------------------------------------------
     * 4 학교 행사 포커 캐러셀
     *  - data-pos 값(left-stack, -2, -1, 0, 1, 2, right-stack) 갱신
     * ----------------------------------------------------- */
    (function () {
        const track = document.querySelector('.event-card-track');
        if (!track) return;

        const cards = Array.from(track.querySelectorAll('.event-card'));
        const total = cards.length;
        if (total === 0) return;

        let activeIndex = 0;

        function updatePositions() {
            cards.forEach(function (card, idx) {
                const diffRaw = idx - activeIndex;
                let diff = ((diffRaw % total) + total) % total;

                let pos;
                if (diff === 0) {
                    pos = 0;
                } else if (diff === 1 || diff === total - 1) {
                    pos = diff === 1 ? 1 : -1;
                } else if (diff === 2 || diff === total - 2) {
                    pos = diff === 2 ? 2 : -2;
                } else {
                    pos = (diff < total / 2) ? 'right-stack' : 'left-stack';
                }
                card.setAttribute('data-pos', String(pos));
            });
        }

        function move(step) {
            activeIndex = (activeIndex + step + total) % total;
            updatePositions();
        }

        updatePositions();

        const prevBtn = document.querySelector('.event-arrow-prev');
        const nextBtn = document.querySelector('.event-arrow-next');

        if (prevBtn) {
            prevBtn.addEventListener('click', function () {
                move(-1);
            });
        }
        if (nextBtn) {
            nextBtn.addEventListener('click', function () {
                move(1);
            });
        }
    })();
});

/* -----------------------------------------------------------
 * 5 헤더 스크롤 배경 전환
 *  - 스크롤 위치에 따라 .is-scrolled 클래스 토글
 * --------------------------------------------------------- */
document.addEventListener('scroll', function () {
    var header = document.querySelector('.main-header');
    if (!header) return;

    if (window.scrollY > 25) {
        header.classList.add('is-scrolled');
    } else {
        header.classList.remove('is-scrolled');
    }
});
</script>

</body>
</html>