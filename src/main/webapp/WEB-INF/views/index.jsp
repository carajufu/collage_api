<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<style>
    /* ============================================
       0. 공통 레이아웃 / 타이포
       - hero 제외 메인 섹션 상·하 padding 통일 (약 64px)
       - 섹션 타이틀 폰트 스타일 통합
       ============================================ */
    .news-section,
    .section-main-bbs,
    .section-main-events,
    #research-section {
        padding: 4rem 0;
    }

    .research-section-title {
        font-size: 1.9rem;
        font-weight: 450;
    }

    /* 공통 2줄 말줄임 유틸리티 */
    .text-truncate-2 {
        overflow: hidden;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
    }

    /* 공통 3줄 말줄임 (연구 요약 등) */
    .line-clamp-3 {
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    /* ============================================
       1. 메인 게시판(공지사항 + 학사일정) 레이아웃
       - 가로 폭 1200px로 고정해서 중앙 정렬
       - 카드 라운드/패딩 일관화
       ============================================ */
    .section-main-bbs .main-bbs-container {
        max-width: 1200px;
        margin-inline: auto;
    }

    .section-main-bbs .card {
        border-radius: 14px;
    }

    .section-main-bbs .card-header {
        padding-top: 0.8rem;
        padding-bottom: 0.8rem;
    }

    .section-main-bbs .list-group-item {
        padding-top: 0.35rem;
        padding-bottom: 0.55rem;
    }

    /* 게시판 목록 썸네일 (필요 시 사용) */
    .section-main-bbs .main-bbs-thumb {
        width: 64px;
        height: 64px;
        object-fit: cover;
        border-radius: 0.9rem;
        background-color: #0f172a;
        flex-shrink: 0;
    }

    .section-main-bbs .main-bbs-item {
        display: flex;
        align-items: flex-start;
        gap: 0.75rem;
    }

    .section-main-bbs .main-bbs-body {
        flex: 1 1 auto;
        min-width: 0;
    }

    /* 학사일정 카드 내 탭, 날짜 컬럼 가독성 보정 */
    .main-calendar-card .main-calendar-tabs .nav-link {
        font-size: 0.85rem;
        padding-inline: 0.75rem;
    }

    .main-calendar-card .main-calendar-tabs .nav-link.active {
        background-color: #0d6efd;
        color: #fff;
    }

    .main-calendar-card .list-group-item {
        border: 0;
        border-top: 1px solid rgba(148, 163, 184, 0.35);
    }

    /* ============================================
       2. 학교 행사 카드(포스터 스타일) – 예비용
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
       3. 학교 행사 – 포커 카드 캐러셀(event-card)
       ============================================ */
    .section-main-events {
        /* 전체 섹션 padding 은 위 공통 rule 사용 */
    }

    /* 트랙 전체 */
    .event-carousel {
        position: relative;
        max-width: 920px;
        margin: 0 auto;
        padding: 40px 60px;
    }

    /* 카드 컨테이너 */
    .event-card-track {
        position: relative;
        list-style: none;
        margin: 0;
        padding: 0;
        height: 260px;
    }

    /* 개별 카드 공통 */
    .event-card {
        position: absolute;
        top: 0;
        left: 50%;
        width: 180px;
        height: 260px;
        transform: translateX(-50%);
        transition:
            transform 0.35s ease,
            opacity 0.35s ease,
            z-index 0.35s ease;
        opacity: 0;
        pointer-events: none;
    }

    /* 포스터 카드 내부 */
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
        font-size: 0.9rem;
        font-weight: 600;
        color: #f9fafb;
        margin-bottom: 4px;
    }

    .event-card-desc {
        font-size: 0.78rem;
        color: rgba(226, 232, 240, 0.9);
        line-height: 1.35;
        margin-bottom: 0;
    }

    /* 위치별 스타일 – 중앙 / 바로 양옆 / 그 다음 / 스택 */
    .event-card[data-pos="0"] {
        transform: translateX(-50%) scale(1.05);
        z-index: 5;
        opacity: 1;
        pointer-events: auto;
    }

    .event-card[data-pos="1"] {
        transform: translateX(calc(-50% + 190px)) scale(0.95);
        z-index: 4;
        opacity: 1;
    }

    .event-card[data-pos="-1"] {
        transform: translateX(calc(-50% - 190px)) scale(0.95);
        z-index: 4;
        opacity: 1;
    }

    .event-card[data-pos="2"] {
        transform: translateX(calc(-50% + 330px)) scale(0.88);
        z-index: 3;
        opacity: 0.95;
    }

    .event-card[data-pos="-2"] {
        transform: translateX(calc(-50% - 330px)) scale(0.88);
        z-index: 3;
        opacity: 0.95;
    }

    .event-card[data-pos="right-stack"] {
        transform: translateX(calc(-50% + 430px)) scale(0.78) rotateY(-15deg);
        z-index: 2;
        opacity: 0.7;
    }

    .event-card[data-pos="left-stack"] {
        transform: translateX(calc(-50% - 430px)) scale(0.78) rotateY(15deg);
        z-index: 2;
        opacity: 0.7;
    }

    /* 캐러셀 화살표 */
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
        left: -85px;
    }

    .event-arrow-next {
        right: -85px;
    }

    /* ============================================
       4. 학술·논문 리서치 캐러셀
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
        letter-spacing: .04em;
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

    .section-link-more {
        position: relative;
        display: inline-flex;
        align-items: center;
        gap: 0.25rem;
        font-size: 0.875rem;
        font-weight: 600;
        color: #6b7280;
        text-decoration: none;
        letter-spacing: 0.03em;
        margin-right: 25px;
    }

    .section-link-more::after {
        content: "+";
        display: inline-block;
        font-size: 1.6em;
        margin-left: 0.1rem;
        transform: rotate(0deg);
        transform-origin: center center;
        transition: transform 0.3s ease-out, opacity 0.3s ease-out;
        opacity: 0.8;
    }

    .section-link-more:hover {
        color: #111827;
    }

    .section-link-more:hover::after {
        transform: rotate(180deg);
        opacity: 1;
    }

    /* 공지·학사일정 카드 공통 고정 높이 */
    .section-main-bbs .main-bbs-card,
    .section-main-bbs .main-calendar-card {
        height: 360px;
        display: flex;
        flex-direction: column;
    }

    .section-main-bbs .main-bbs-card .card-header,
    .section-main-bbs .main-calendar-card .card-header {
        flex: 0 0 auto;
    }

    .section-main-bbs .main-bbs-card .list-group,
    .section-main-bbs .main-calendar-card .main-calendar-list {
        flex: 1 1 auto;
        margin-bottom: 0;
        overflow-y: auto;
    }
</style>

</head>
<body>

<%@ include file="index-header.jsp"%>


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

                    <div class="hero-search-wrap">
                        <input type="text" class="hero-search-input"
                               placeholder="예) 장학금, 학사일정, 입학전형, 도서관 검색 등" />
                        <button type="button" class="hero-search-btn">캠퍼스 통합 검색</button>
                    </div>

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
            <!-- 타이틀 라인 -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="research-section-title mb-0">대덕 뉴스</h2>
            	<a href="${cPath}/news" class="section-link-more">View More</a>
            </div>

            <c:if test="${not empty news_bbs}">
                <c:set var="firstNews" value="${news_bbs[0]}"/>

                <div class="row g-5 align-items-stretch">
                    <!-- 좌측 썸네일 -->
                    <div class="col-lg-5">
                        <a href="${pageContext.request.contextPath}/news/detail/${firstNews.bbscttNo}"
                           class="d-block rounded-3 overflow-hidden shadow-sm">
                            <div class="ratio ratio-4x3 bg-light">
                                <c:choose>
                                    <c:when test="${not empty firstNews.fileGroupNo}">
                                        <img src="${pageContext.request.contextPath}/images/news/${firstNews.fileGroupNo}.png"                                             alt="<c:out value='${firstNews.bbscttSj}'/>" />
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
                    <div class="col-lg-7">
                        <div class="h-100 d-flex flex-column justify-content-between">
                            <div>
                                <div class="badge bg-primary rounded-pill mb-3 px-3 py-2">
                                    캠퍼스·대내외 뉴스
                                </div>
                                <h3 class="h4 fw-bold mb-3">
                                    <a href="${pageContext.request.contextPath}/news/detail/${firstNews.bbscttNo}.png"
                                       class="text-decoration-none text-dark">
                                        <c:out value="${firstNews.bbscttSj}"/>
                                    </a>
                                </h3>
                                <p class="text-muted mb-0 line-clamp-3">
                                    <c:out value="${firstNews.bbscttCn}"/>
                                </p>
                            </div>

                            <ul class="list-unstyled mt-4 mb-0">
                                <c:forEach var="item" items="${news_bbs}" varStatus="st" begin="1" end="4">
                                    <li class="d-flex justify-content-between align-items-baseline py-2 border-top border-light-subtle">
                                        <a href="${pageContext.request.contextPath}/news/detail/${item.bbscttNo}"
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
	        <div class="row gy-1 justify-content-center">
	
	            <!-- 공지사항 (BBS_CODE = 1) -->
	            <div class="col-xl-6 col-lg-6 col-md-6">
	                <!-- ==== 타이틀 라인(뉴스 섹션과 동일 양식) ==== -->
	                <div class="d-flex justify-content-between align-items-center mb-0">
	                    <h2 class="research-section-title mb-0">공지사항</h2>
 						<a href="${cPath}/bbs/notice" class="section-link-more">View More</a>
	                </div>
	
	                    <div class="card-header">
	                        <p class="card-subtitle text-muted mb-0">
	                            학사·등록·장학 등 주요 안내
	                        </p>
	                    </div>
	
	                    <ul class="list-group list-group-flush">
	                        <c:if test="${empty notices_bbs}">
	                            <li class="list-group-item main-bbs-empty text-muted">
	                                등록된 공지사항이 없습니다.
	                            </li>
	                        </c:if>
	
	                        <!-- 최신 5개만 -->
	                        <c:forEach var="row" items="${notices_bbs}" varStatus="st">
	                            <c:if test="${st.index lt 5}">
	                                <li class="list-group-item">
	                                    <div class="d-flex flex-column">
	                                        <div class="d-flex justify-content-between align-items-start">
	                                            <a href="#"
	                                               class="main-bbs-title text-body text-truncate">
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
	
	            <!-- 학사일정 카드 -->
	            <div class="col-xl-6 col-lg-6 col-md-6">
	                <!-- ==== 타이틀 라인(뉴스 섹션과 동일 양식) ==== -->
	                <div class="d-flex justify-content-between align-items-center mb-0">
	                    <h2 class="research-section-title mb-0">학사일정</h2>
	                    <a href="${cPath}/calendar" class="section-link-more">View More</a>
	                </div>
	
	                <div class="main-calendar-card">
	                    <div class="card-header">
	                        <p class="card-subtitle text-muted mb-0">
	                            학사·등록·행사 등 월간 주요 일정
	                        </p>
	                    </div>
	
	                    <div class="px-3 pt-3">
	                        <div class="d-flex justify-content-between align-items-center mb-2">
	                            <a href="${cPath}/?year=${prevYear}&month=${prevMonth}"
	                               class="btn btn-sm btn-outline-secondary rounded-pill px-2">‹</a>
	
	                            <div class="fw-semibold fs-5">
	                                ${currentYear}.
	                                <fmt:formatNumber value="${currentMonth}" pattern="00"/>
	                            </div>
	
	                            <a href="${cPath}/?year=${nextYear}&month=${nextMonth}"
	                               class="btn btn-sm btn-outline-secondary rounded-pill px-2">›</a>
	                        </div>
	
	                        <ul class="nav nav-pills main-calendar-tabs mb-3">
	                            <li class="nav-item">
	                                <a class="nav-link active" href="#" data-cal-type="ACAD">학사일정</a>
	                            </li>
	                            <li class="nav-item">
	                                <a class="nav-link" href="#" data-cal-type="REGI">등록일정</a>
	                            </li>
	                            <li class="nav-item">
	                                <a class="nav-link" href="#" data-cal-type="EVENT">행사일정</a>
	                            </li>
	                        </ul>
	                    </div>
	
	                    <ul class="list-group list-group-flush main-calendar-list">
	                        <c:if test="${empty academicSchedules}">
	                            <li class="list-group-item text-muted">
	                                등록된 학사일정이 없습니다.
	                            </li>
	                        </c:if>
	
	                        <c:forEach var="sch" items="${academicSchedules}" varStatus="st">
	                            <c:if test="${st.index lt 6}">
	                                <li class="list-group-item d-flex">
	                                    <div class="me-3 text-center" style="min-width:4.5rem;">
	                                        <div class="fw-semibold fs-6">
	                                            <fmt:formatDate value="${sch.schdlDate}" pattern="MM.dd"/>
	                                        </div>
	                                    </div>
	                                    <div class="flex-grow-1">
	                                        <div class="fw-semibold mb-1 text-truncate">
	                                            <c:out value="${sch.schdlTitle}"/>
	                                        </div>
	                                        <p class="mb-0 text-muted small text-truncate">
	                                            <c:out value="${sch.schdlDesc}"/>
	                                        </p>
	                                    </div>
	                                </li>
	                            </c:if>
	                        </c:forEach>
	                    </ul>
	                </div>
	            </div>
	
	        </div>
	    </div>
	</section>


    <!-- 학교 행사 (BBS_CODE = 2) -->
    <section class="section-main-events">
        <div class="container-xxl">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="research-section-title mb-0">학교 행사</h2>
                <a href="${cPath}/bbs/list?bbsCode=2" class="section-link-more">View More</a>
            </div>

            <div class="event-carousel">
                <button class="event-arrow event-arrow-prev" type="button">
                    <i class="ri-arrow-left-s-line"></i>
                </button>

                <ul class="event-card-track">
                    <c:forEach var="item" items="${events_bbs}" varStatus="st">
                        <li class="event-card" data-index="${st.index}">
                            <div class="event-card-inner">
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
                                        <c:out value="${fn:length(item.bbscttCn) > 30 ? fn:substring(item.bbscttCn,0,30).concat('...') : item.bbscttCn}" />
                                    </p>
                                </div>
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

    <!-- 학술·논문 (BBS_CODE = 3) -->
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
                    <c:forEach var="paper" items="${papers_bbs}" varStatus="st">
                        <div class="carousel-item <c:if test='${st.first}'>active</c:if>">
                            <div class="row g-0 align-items-stretch research-card">
                                <!-- 좌측 썸네일 -->
                                <div class="col-lg-5 col-md-6">
                                    <div class="research-image-wrap">
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
                                    </div>
                                </div>

                                <!-- 우측 연구 제목/요약 -->
                                <div class="col-lg-7 col-md-6">
                                    <div class="research-body h-100 d-flex flex-column justify-content-center p-4 p-lg-5">
                                        <div class="research-meta text-muted mb-2">
                                            Research ·
                                            <fmt:formatDate value="${paper.bbscttWritngDe}" pattern="yyyy.MM.dd"/>
                                        </div>
                                        <h3 class="research-title mb-3">
                                            <a href="${cPath}/bbs/3/detail/${paper.bbscttNo}"
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

                <!-- 좌/우 화살표 -->
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
  // 헤더 스크롤 배경 전환
  document.addEventListener("scroll", function () {
    var header = document.querySelector(".main-header");
    if (!header) return;

    if (window.scrollY > 20) {
      header.classList.add("is-scrolled");
    } else {
      header.classList.remove("is-scrolled");
    }
  });

  // 히어로 섹션 랜덤 배경
  document.addEventListener('DOMContentLoaded', function () {
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

    setRandomBackground();
    setInterval(setRandomBackground, 10000);
  });

  // 학교 행사 포커 캐러셀
  document.addEventListener('DOMContentLoaded', function () {
      const track  = document.querySelector('.event-card-track');
      if (!track) return;

      const cards  = Array.from(track.querySelectorAll('.event-card'));
      const total  = cards.length;
      if (total === 0) return;

      let activeIndex = 0; // 가운데 카드 인덱스

      function updatePositions() {
          cards.forEach(function (card, idx) {
              const diffRaw = idx - activeIndex;
              let diff = ((diffRaw % total) + total) % total; // 0 ~ total-1

              let pos;
              if (diff === 0) {
                  pos = 0; // center
              } else if (diff === 1 || diff === total - 1) {
                  pos = diff === 1 ? 1 : -1;
              } else if (diff === 2 || diff === total - 2) {
                  pos = diff === 2 ? 2 : -2;
              } else {
                  if (diff < total / 2) {
                      pos = 'right-stack';
                  } else {
                      pos = 'left-stack';
                  }
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
  });
</script>

</body>
</html>
