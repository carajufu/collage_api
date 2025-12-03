<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../header.jsp"%>

<!-- ================================================================== -->
<!-- [code-intent] 학생 대시보드: 수강 카드 + 학적 진행률 + 캠퍼스 소식 + 학사 일정 캘린더 -->
<!-- [data-flow] 서버(Model) -> 카드/테이블/캘린더 UI -> 학생이 현재 학사 상태·일정 한눈에 파악 -->
<!-- ================================================================== -->

<!-- Pretendard + Bootstrap -->
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/pretendard/dist/web/static/pretendard.css" />

<!-- 전역 스케줄러 css -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/schedule.css" />
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/potalSchedule.css" />

<!-- FullCalendar 정적 리소스 (전역 공용) -->
<script src="${pageContext.request.contextPath}/assets/libs/fullcalendar/index.global.min.js"></script>

<style>
/* =====================================================================
 * 0. 공통 설정 / 레이아웃
 * =================================================================== */
:root {
    --primary-color: #0d6efd;   /* Bootstrap Primary Blue */
    --secondary-bg: #f8f9fa;
}

/* 메인 컨테이너 높이 */
#main-container.container-fluid {
    height: auto;
    min-height: calc(100vh - 120px);
    padding-top: 12px;
    padding-bottom: 12px;
}

/* 대시보드 루트 row 좌우 패딩 */
.dashboard-row {
    padding-right: 1rem !important;
    padding-left: 1rem !important;
}

/* 메인/사이드 컬럼 비율 */
.dashboard-main-col,
.dashboard-side-col {
    margin-top: 0;
    padding-top: 0.25rem;
}

@media (min-width: 1400px) {
    .dashboard-main-col {
        flex: 0 0 70%;
        max-width: 70%;
    }
    .dashboard-side-col {
        flex: 0 0 30%;
        max-width: 30%;
        padding-left: 1.5rem;
    }
}

/* 공용 카드 */
.card {
    border: none;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.08);
    border-radius: 12px;
}

/* 내부 body 카드 */
.card-body_1,
.card-body_2 {
    background-color: #fff;
    border-radius: .75rem;
    box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .09);
    margin-top: -10px !important;
    margin-bottom: -6px !important;
    height: auto !important;
    padding-left: 0.28rem !important;
    padding-right: 0.28rem !important;
}

/* 공통 card-title 미세 튜닝 */
.card-title {
    font-size: 14px;
    margin: -8px 0 2px -8px;
}

/* 헤더 px-5 강제 축소 */
.px-5 {
    padding-right: 0rem !important;
    padding-left: 0rem !important;
}

/* =====================================================================
 * 1. 수강 중인 강의 카드 영역
 * =================================================================== */
.lecture-row {
    margin-top: .25rem;
    margin-bottom: .25rem;
}

.lecture-card-wrapper {
    border: 0;
    box-shadow: 0 .5rem 1.5rem rgba(15, 23, 42, .08);
    border-radius: 1rem;
}

.lecture-card-item {
    box-shadow: none !important;
    border: 1px solid #e5e7eb;
    border-radius: 0.3rem;
    max-width: 260px;
    width: 100%;
    padding: .8rem .8rem;
    cursor: pointer;
}

.lecture-card-item .card-title {
    font-size: 0.95rem;
    font-weight: 600;
    margin-bottom: 0.2rem;
    white-space: nowrap;
    word-break: keep-all;
    overflow: visible;
    text-overflow: clip;
}

.lecture-card-item .card-subtitle {
    font-size: 0.82rem;
    margin-bottom: 0.1rem;
}

/* 수강 카드 그리드 간격 */
.lecture-card-wrapper .row.g-3 {
    --bs-gutter-x: 1.5rem;
    --bs-gutter-y: 0.1rem;
}

/* Velzon gutter 튜닝 */
.g-3, .gy-3 {
    --vz-gutter-y: 0rem !important;
    --vz-gutter-x: 1.9rem !important;
}

/* =====================================================================
 * 2. 학적 진행률 카드
 * =================================================================== */
.academic-progress-card {
    background-color: #ffffff;
    border-radius: .9rem;
    box-shadow: 0 .125rem .45rem rgba(15, 23, 42, .12);
    border: 0;
}

.academic-progress-card .card-body_2 {
    border-radius: .9rem;
    box-shadow: none;
    padding-top: .75rem;
    padding-bottom: .75rem;
}

.academic-progress-table {
    border-collapse: separate;
    border-spacing: 0;
}

.academic-progress-table thead th,
.academic-progress-table tbody td {
    border-top: none;
}

.academic-progress-table tbody tr + tr td {
    border-top: 0.3px solid #e5e7eb !important;
}

.progress-summary-table {
    border-color: #e5e7eb;
}

.academic-progress-table .progress-metric-label {
    font-weight: 600;
    text-align: left;
    white-space: nowrap;
}

.academic-progress-table tbody tr > td {
    padding-top: .55rem;
    padding-bottom: .55rem;
}

.academic-progress-table .progress {
    height: 0.6rem;
    border-radius: 999px;
    background-color: #edf1f7;
}

.academic-progress-table .progress-meta {
    font-size: .75rem;
    color: #6c757d;
}

.academic-progress-table .status-pill {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0.15rem 0.6rem;
    border-radius: 999px;
    font-size: .75rem;
    font-weight: 600;
}

.academic-progress-table .status-pill.met {
    background-color: #e6f4ff;
    color: #0d6efd;
}

.academic-progress-table .status-pill.not-met {
    background-color: #ffe5e7;
    color: #dc3545;
}

/* =====================================================================
 * 3. 캠퍼스 소식 카드
 * =================================================================== */
.campus-news-card {
    background-color: #ffffff;
    border-radius: .9rem;
    box-shadow: 0 .125rem .45rem rgba(15, 23, 42, .12);
    border: 0;
}

.campus-news-card .card-body_2 {
    box-shadow: none;
    border-radius: 0 0 .9rem .9rem;
    padding-top: 0;
    padding-bottom: 0.75rem;
}

.campus-news-card .campus-news-tabs {
    margin: 0;
    border-radius: .9rem .9rem 0 0;
    background-color: #eef2ff;
    border-bottom: 1px solid #e5e7eb;
}

.campus-news-card .campus-news-tab {
    flex: 1 1 0;
    border-radius: 0;
    border: 0;
    padding: 0.75rem 1rem;
    text-align: center;
    font-size: 0.9rem;
    font-weight: 500;
    color: #64748b;
    background: transparent;
}

.campus-news-card .campus-news-tab.active {
    background-color: #4f46e5;
    color: #ffffff;
    box-shadow: 0 0 0 1px rgba(79, 70, 229, 0.3);
}

.campus-news-table-wrapper {
    padding: 0.75rem 1.25rem 0.75rem;
    border-radius: 0 0 .9rem .9rem;
}

.campus-news-table {
    width: 95%;
    border-collapse: collapse;
    margin: 0;
    font-size: 0.86rem;
}

.campus-news-table thead th {
    padding: 0.6rem 0.4rem;
    font-size: 0.8rem;
    font-weight: 600;
    color: #94a3b8;
    border-bottom: 1px solid #e5e7eb;
    border-top: 1px solid #e5e7eb;
    background-color: #f9fafb;
}

.campus-news-table tbody td {
    padding: 0.55rem 0.4rem;
    border-bottom: 1px solid #f1f5f9;
    color: #1f2933;
    vertical-align: middle;
}

.campus-news-table tbody tr:last-child td {
    border-bottom: none;
}

.campus-news-table .campus-title-cell {
    max-width: 0;
    white-space: nowrap;
    text-overflow: ellipsis;
}

.campus-news-table .col-no {
    width: 48px;
    text-align: center;
}
.campus-news-table .col-writer {
    width: 120px;
    text-align: center;
}
.campus-news-table .col-date {
    width: 120px;
    text-align: center;
}
.campus-news-table .col-hit {
    width: 80px;
    text-align: center;
    white-space: nowrap;
}

.campus-news-table tbody tr:hover td {
    background-color: #f3f4ff;
}

.campus-news-table .campus-title-cell a {
    color: inherit;
    text-decoration: none;
}
.campus-news-table .campus-title-cell a:hover {
    text-decoration: underline;
}

/* =====================================================================
 * 4. 학사 일정 미니 캘린더 카드 + 로딩 레이어
 * =================================================================== */
.academic-card {
    background-color: #fff;
    border-radius: 1rem;
    box-shadow: 0 .5rem 1.5rem rgba(15, 23, 42, .08);
    margin-top: 0 !important;
    margin-bottom: 10px !important;
    padding: 0 !important;
    height: auto !important;
    max-height: none !important;
    overflow: visible !important;
    display: flex;
    flex-direction: column;
}

/* 미니 캘린더 컨테이너 */
.calendar-container {
    position: relative;
    margin: 0;
    padding: 1.8rem 1.8rem 1.8rem 1.8rem !important;
    background-color: #ffffff;
}

/* 로딩 오버레이 */
.loading-overlay {
    position: absolute;
    inset: 0;
    background: rgba(255, 255, 255, 0.75);
    z-index: 10;
    display: none;
    align-items: center;
    justify-content: center;
    border-radius: 1rem;
}
.loading-overlay.visible {
    display: flex;
}

/* FullCalendar 전체 폰트 스케일 */
.timetable-container .fc,
.calendar-container .fc {
    font-size: 0.78rem;
}

/* 헤더/요일 영역 */
.fc .fc-toolbar.fc-header-toolbar {
    margin-bottom: 0.5em;
}
.fc .fc-toolbar-title {
    font-weight: 800;
    color: #1e3a8a;
    font-size: 1.05rem;
}
.fc .fc-button-primary {
    background-color: var(--primary-color) !important;
    border-color: var(--primary-color) !important;
    box-shadow: none !important;
}
.fc .fc-daygrid-day {
    border: 1px solid #f0f0f0;
}
.fc .fc-col-header-cell {
    background-color: #eef2ff;
    font-weight: 700;
    color: #1e3a8a;
}

/* 날짜 번호 스타일 */
.fc .fc-daygrid-day-number {
    display: flex;
    align-items: center;
    justify-content: center;
    white-space: nowrap !important;
    word-break: keep-all !important;
    border-radius: 50%;
    margin: 3px;
    font-size: 10px;
    font-weight: 500;
}

/* 오늘 날짜 */
.fc-daygrid-day.fc-day-today .fc-daygrid-day-frame {
    background-color: rgba(88, 101, 242, 0.05);
}
.fc-daygrid-day.fc-day-today .fc-daygrid-day-number {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 26px;
    height: 26px;
    padding: 0 6px;
    border-radius: 999px;
    background-color: rgba(88, 101, 242, 0.9);
    color: #ffffff;
    font-weight: 500;
    font-size: 0.69rem;
}

/* 선택 날짜 */
.fc-daygrid-day.fc-day-selected .fc-daygrid-day-frame {
    background-color: rgba(30, 90, 255, 0.09);
}
.fc-daygrid-day.fc-day-selected .fc-daygrid-day-number {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 24px;
    height: 24px;
    padding: 0 6px;
    border-radius: 999px;
    background-color: #2563eb;
    color: #ffffff;
    font-weight: 600;
    font-size: 0.7rem;
}

.fc-daygrid-day-top {
    overflow: visible;
    padding-top: 4px;
}

/* 달력 높이 */
.academic-card #calendar {
    height: 350px;
}

/* ===== FullCalendar prev/next 버튼: 심플 꺾쇠 텍스트만 ===== */
.academic-card .calendar-container .fc-button-primary {
    background: transparent !important;
    border: none !important;
    box-shadow: none !important;
    padding: 0 !important;
    min-width: 0 !important;
    height: auto !important;
}

/* 기존 아이콘 숨김 */
.academic-card .calendar-container .fc-prev-button .fc-icon,
.academic-card .calendar-container .fc-next-button .fc-icon {
    display: none !important;
}

/* FullCalendar prev/next 버튼: 항상 투명 배경 */
.academic-card .calendar-container .fc-button-primary,
.academic-card .calendar-container .fc-button-primary:hover,
.academic-card .calendar-container .fc-button-primary:focus,
.academic-card .calendar-container .fc-button-primary:active,
.academic-card .calendar-container .fc-button-primary.fc-button-active {
    background: transparent !important;
    border: none !important;
    box-shadow: none !important;
}

/* 아이콘은 그대로 꺾쇠 텍스트 */
.academic-card .calendar-container .fc-prev-button .fc-icon,
.academic-card .calendar-container .fc-next-button .fc-icon {
    display: none !important;
}
.academic-card .calendar-container .fc-prev-button::after,
.academic-card .calendar-container .fc-next-button::after {
    display: inline-block;
    font-size: 3.1rem;
    line-height: 1;
    font-weight: 100;
    color: #000000;
    padding: 0.2rem;
}
.academic-card .calendar-container .fc-prev-button::after { content: "<"; }
.academic-card .calendar-container .fc-next-button::after { content: ">"; }
.academic-card .calendar-container .fc-header-toolbar {
    justify-content: center;
}
/* 선택된 이벤트 박스 아이템 하이라이트 */
.calendar-event-list-item.is-selected {
    background-color: #e0edff;
    box-shadow: 0 0 0 1px #2563eb inset;
}

.calendar-event-list-item.is-selected .calendar-event-title,
.calendar-event-list-item.is-selected .calendar-event-time {
    color: #1d4ed8;
    font-weight: 700;
}

/* =====================================================================
 * 5. dayGrid 이벤트(상단 캘린더) – 얇은 띠 모드
 * =================================================================== */

/* dayGrid 의 "+ n more" 를 단순 텍스트처럼 보이게 */
.fc-daygrid-more-link {
    pointer-events: none;   /* 클릭/hover 이벤트 막기 */
    cursor: default;        /* 손가락 커서 -> 기본 커서 */
    text-decoration: none;  /* 밑줄 제거 (있는 경우) */
}
.fc-daygrid-event {
    border-radius: 999px;
    padding: 0;
    margin: 1px 1px;
    border: 0;
    height: 4px;
    font-size: 0;
    line-height: 1;
    font-weight: 500;
    opacity: 0.9;
}
.fc-daygrid-event .fc-event-title,
.fc-daygrid-event .fc-event-time {
    display: none !important;
}

/* 타입별 색상 (캘린더 띠) */
.fc-daygrid-event.type-TASK,
.fc-daygrid-event.type-PROJECT {
    background-color: #f97316;  /* 주황: 과제/시험/평가/프로젝트 */
}
.fc-daygrid-event.type-SYSTEM {
    background-color: #6366f1;  /* 보라: 학사공지 */
}
.fc-daygrid-event.type-COUNSEL {
    background-color: #22c55e;  /* 연녹: 상담(예약) */
}
.fc-daygrid-event.type-COUNSEL_SLOT {
    background-color: #0ea5e9;  /* 청녹: 상담가능 */
}
.fc-daygrid-event.type-ENROLL_REQ {
    background-color: #38bdf8;  /* 하늘: 수강신청/정정/철회 */
}
.fc-daygrid-event.type-ADMIN_REGIST {
    background-color: #ec4899;  /* 분홍: 등록/휴학/복학/계절 */
}
.fc-daygrid-event.type-HOLIDAY {
    background-color: #ef4444;  /* 빨강: 공휴일 */
}

/* "+ n more" 를 이벤트 막대 박스 안으로 정렬 */
.fc-daygrid-day-events .fc-daygrid-more-link {
    display: block;
    margin: 0 2px;          /* 좌우 여백: 이벤트랑 맞춤 */
    padding: 0 4px;         /* 필요하면 값 조절 */
    box-sizing: border-box;
    text-align: left;       /* 가운데 말고 왼쪽 정렬하고 싶을 때 */

    pointer-events: none;   /* 클릭 막기(이전 요구사항 유지) */
    cursor: default;
    text-decoration: none;
}
.fc .fc-daygrid-day-events {
    margin-top: -6px;
}
.fc .fc-daygrid-day-number {
    display: flex;
    align-items: center;
    justify-content: center;
    white-space: nowrap !important;
    word-break: keep-all !important;
    border-radius: 48%;
    margin: 2px;
    font-size: 10px;
    font-weight: 380;
}
.fc-daygrid-day-top {
    overflow: visible;
    padding-top: 1px;
}
/* =====================================================================
 * 6. 하단 일정 리스트 – 카드형 + 시간 들여쓰기 정렬
 * =================================================================== */
.calendar-event-list {
    margin-top: 20px;
}

/* 리스트 전체 카드 */
.calendar-event-list-inner {
    background-color: #ffffff;
    border-radius: 0.85rem;
    border: 1px solid #e5e7eb;
    box-shadow: 0 .1rem .25rem rgba(15,23,42,.06);
    overflow: hidden;
}

.calendar-event-list-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 14px;
    background-color: var(--secondary-bg);
    border-bottom: 1px solid #e5e7eb;
    font-weight: 600;
}

.calendar-event-list-header .badge {
    font-size: 0.70rem;
    padding: .25rem .55rem;
}

/* 개별 일정 행 */
.calendar-event-list-item {
    position: relative;
    display: flex;
    padding: 10px 14px;
    padding-left: 1.75rem;   /* 왼쪽 색 띠 공간 */
    border-bottom: 1px solid #f3f4f6;
    transition: background-color 0.15s;
}

.calendar-event-list-item:last-child {
    border-bottom: none;
}

.calendar-event-list-item:hover {
    background-color: #f0f3f7;
}

/* 왼쪽 타입 띠 */
.calendar-event-list-item .type-strip {
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    width: 6px;
    border-radius: 0;
}

/* 시간 칼럼: 고정폭 -> "종일" 포함 정렬 기준 */
.calendar-event-time {
    display: inline-block;
    font-size: 0.9em;
    font-weight: 700;
    color: var(--primary-color);
    margin-right: 12px;
    width: 64px;       /* 들여쓰기 기준 폭 */
    flex-shrink: 0;
}

.calendar-event-title {
    font-size: 0.95em;
    font-weight: 500;
    color: #212529;
}

/* 메모: 시간 칼럼 폭만큼 들여쓰기 -> 타이틀와 수직 정렬 */
.calendar-event-meta {
    font-size: 0.8em;
    color: #6c757d;
    margin-top: 2px;
    margin-left: 64px;   /* calendar-event-time width 와 동일 */
    padding-left: 0;
}

/* 리스트 타입별 띠 색상 (상단 캘린더와 동일 팔레트) */
.calendar-event-list-item.type-TASK .type-strip,
.calendar-event-list-item.type-PROJECT .type-strip {
    background-color: #f97316;
}
.calendar-event-list-item.type-SYSTEM .type-strip {
    background-color: #6366f1;
}
.calendar-event-list-item.type-COUNSEL .type-strip {
    background-color: #22c55e;
}
.calendar-event-list-item.type-COUNSEL_SLOT .type-strip {
    background-color: #0ea5e9;
}
.calendar-event-list-item.type-ENROLL_REQ .type-strip {
    background-color: #38bdf8;
}
.calendar-event-list-item.type-ADMIN_REGIST .type-strip {
    background-color: #ec4899;
}
.calendar-event-list-item.type-HOLIDAY .type-strip {
    background-color: #ef4444;
}

/* 공휴일 리스트 행: 전체 카드도 빨간 배경 + 흰 글씨 */
.calendar-event-list-item.type-HOLIDAY {
    background-color: #ef4444;
}
.calendar-event-list-item.type-HOLIDAY .calendar-event-title,
.calendar-event-list-item.type-HOLIDAY .calendar-event-time,
.calendar-event-list-item.type-HOLIDAY .calendar-event-meta {
    color: #ffffff;
}
.academic-card .calendar-container .fc-prev-button::after, .academic-card .calendar-container .fc-next-button::after {
    display: inline-block;
    font-size: 40px !important;
    line-height: 1 !important;
    font-weight: 100 !important;
    color: #000000 !important;
    padding: 0.1rem !important;
}
</style>

<!-- ================================================================== -->
<!-- 메인 레이아웃 -->
<!-- ================================================================== -->
<div class="row dashboard-row pb-4 g-0 align-items-start">
    <!-- 좌측: 수강 카드 + 학적 진행 + 캠퍼스 소식 -->
    <div class="col-xxl-6 col-lg-6 dashboard-main-col">

        <!-- 수강 중인 강의 -->
        <div class="row lecture-row px-5">
            <div class="col-xxl-12 col-12">
                <div class="card mb-3 lecture-card-wrapper">
                    <div class="card-header d-flex align-items-center justify-content-between">
                        <h5 class="mb-0">수강 중인 강의</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty lectureList}">
                                <div class="row row-cols-xxl-4 row-cols-lg-2 row-cols-1 g-3">
                                    <c:forEach items="${lectureList}" var="lecture">
                                        <div class="col">
                                            <!-- id 중복 방지: data-lec-no + js-lecture-card 클래스로 식별 -->
                                            <div class="card card-body lecture-card-item js-lecture-card"
                                                 data-lec-no="${lecture.estbllctreCode}">
                                                <h4 class="card-title"
                                                    data-key="${lecture.lctreNm}">${lecture.lctreNm}</h4>
                                                <p class="card-subtitle"
                                                   data-key="${lecture.lctrum}">${lecture.lctrum}</p>
                                                <p class="card-subtitle"
                                                   data-key="${lecture.sklstfNm}">${lecture.sklstfNm}</p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                               <h5 class="text-muted mb-0 text-center">
						            현재 수강 중인 강의가 없습니다.
						        </h5>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- 학적 이행 진행률 카드 -->
        <div class="card academic-progress-card mt-2">
            <div class="card-body_2">
                <table class="table table-sm align-middle text-center mb-0 academic-progress-table">
                    <thead class="table-light">
                    <tr>
                        <th>항목</th>
                        <th>진행률</th>
                        <th>상태</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>총 이수학점</td>
                        <td>
                            <div class="progress" style="height: 22px;">
                                <c:set var="pntPct"
                                       value="${(requirements.totalPnt >= requirements.MIN_TOTAL_PNT)
                                             ? 100
                                             : (requirements.totalPnt * 100.0 / requirements.MIN_TOTAL_PNT)}"/>
                                <div class="progress-bar ${(requirements.totalPnt >= requirements.MIN_TOTAL_PNT) ? 'bg-primary' : 'bg-danger'}"
                                     style="width:${pntPct}%; min-width:24%;">
                                    ${requirements.totalPnt}/${requirements.MIN_TOTAL_PNT} 학점
                                </div>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${requirements.totalPnt >= requirements.MIN_TOTAL_PNT}">
                                    <span class="text-primary fw-semibold">충족</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger fw-semibold">미충족</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <td>전공필수 이수학점</td>
                        <td>
                            <div class="progress" style="height: 22px;">
                                <c:set var="majorPct"
                                       value="${(requirements.majorPnt >= requirements.MIN_MAJOR_PNT)
                                             ? 100
                                             : (requirements.majorPnt * 100.0 / requirements.MIN_MAJOR_PNT)}"/>
                                <div class="progress-bar ${(requirements.majorPnt >= requirements.MIN_MAJOR_PNT) ? 'bg-primary' : 'bg-danger'}"
                                     style="width:${majorPct}%; min-width:24%;">
                                    ${requirements.majorPnt}/${requirements.MIN_MAJOR_PNT} 학점
                                </div>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${requirements.majorPnt >= requirements.MIN_MAJOR_PNT}">
                                    <span class="text-primary fw-semibold">충족</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger fw-semibold">미충족</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <td>교양필수 이수학점</td>
                        <td>
                            <div class="progress" style="height: 22px;">
                                <c:set var="libPct"
                                       value="${(requirements.liberalPnt >= requirements.MIN_LIBERAL_PNT)
                                             ? 100
                                             : (requirements.liberalPnt * 100.0 / requirements.MIN_LIBERAL_PNT)}"/>
                                <div class="progress-bar ${(requirements.liberalPnt >= requirements.MIN_LIBERAL_PNT) ? 'bg-primary' : 'bg-danger'}"
                                     style="width:${libPct}%; min-width:24%;">
                                    ${requirements.liberalPnt}/${requirements.MIN_LIBERAL_PNT} 학점
                                </div>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${requirements.liberalPnt >= requirements.MIN_LIBERAL_PNT}">
                                    <span class="text-primary fw-semibold">충족</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger fw-semibold">미충족</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <td>외국어 이수</td>
                        <td>
                            <div class="progress" style="height: 22px;">
                                <c:set var="flPct"
                                       value="${(requirements.foreignLangCount >= requirements.MIN_FOREIGN_LANG)
                                             ? 100
                                             : (requirements.foreignLangCount * 100.0 / requirements.MIN_FOREIGN_LANG)}"/>
                                <div class="progress-bar ${(requirements.foreignLangCount >= requirements.MIN_FOREIGN_LANG) ? 'bg-primary' : 'bg-danger'}"
                                     style="width:${flPct}%; min-width:24%;">
                                    ${requirements.foreignLangCount}/${requirements.MIN_FOREIGN_LANG} 과목
                                </div>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${requirements.foreignLangCount >= requirements.MIN_FOREIGN_LANG}">
                                    <span class="text-primary fw-semibold">충족</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger fw-semibold">미충족</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <td>총 평점(GPA)</td>
                        <td>
                            <div class="progress" style="height: 22px;">
                                <c:set var="gpaPct"
                                       value="${(requirements.totalGpa >= requirements.MIN_TOTAL_GPA)
                                             ? 100
                                             : (requirements.totalGpa * 100.0 / requirements.MIN_TOTAL_GPA)}"/>
                                <div class="progress-bar ${(requirements.totalGpa >= requirements.MIN_TOTAL_GPA) ? 'bg-primary' : 'bg-danger'}"
                                     style="width:${gpaPct}%; min-width:24%;">
                                    ${requirements.totalGpa}/${requirements.MIN_TOTAL_GPA}
                                </div>
                            </div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${requirements.totalGpa >= requirements.MIN_TOTAL_GPA}">
                                    <span class="text-primary fw-semibold">충족</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger fw-semibold">미충족</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- 캠퍼스 소식 카드 -->
        <div class="card campus-news-card mt-2">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">캠퍼스 소식</h5>
                <span class="badge bg-light text-muted">
                    ${currentYear}년 ${currentMonth}월
                </span>
            </div>

            <div class="card-body_2 pt-3">
                <ul class="nav nav-pills campus-news-tabs" id="campus-news-tabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link campus-news-tab active"
                                id="campus-news-notice-tab"
                                data-bs-toggle="tab"
                                type="button"
                                role="tab"
                                aria-selected="true"
                                data-type="notice"
                                data-endpoint="/api/dashboard/notices">
                            공지사항
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link campus-news-tab"
                                id="campus-news-news-tab"
                                data-bs-toggle="tab"
                                type="button"
                                role="tab"
                                aria-selected="false"
                                data-type="news"
                                data-endpoint="/api/dashboard/news">
                            대덕 뉴스
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link campus-news-tab"
                                id="campus-news-academic-tab"
                                data-bs-toggle="tab"
                                type="button"
                                role="tab"
                                aria-selected="false"
                                data-type="academic"
                                data-endpoint="/api/dashboard/academic">
                            학사일정
                        </button>
                    </li>
                </ul>

                <!-- Ajax 결과 렌더링 영역 -->
                <div id="campus-news-list" class="mt-3"></div>
            </div>
        </div>
    </div>

    <!-- 우측: 학사 캘린더 카드 -->
    <div class="col-xxl-6 col-lg-6 dashboard-side-col">
        <div class="card academic-card">
            <div class="calendar-container">
                <div id="calendar"></div>

                <!-- 로딩 오버레이 -->
                <div id="calendar-loading" class="loading-overlay">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>

                <!-- 아래 일정 리스트 영역 -->
                <div id="calendar-event-list" class="calendar-event-list mt-3"></div>
            </div>

            <!-- 공용 툴팁 (필요 시 사용) -->
            <div id="event-tooltip" class="event-tooltip"></div>
        </div>
    </div>
</div>

<%@ include file="../../footer.jsp"%>
<script>
/* ======================================================================
 * 학생 대시보드 전용 JS
 * - initLectureCards  : 수강 카드 클릭 -> 상세 학습 페이지 이동
 * - initCalendar      : FullCalendar + 일자별 리스트 싱크 (미니 캘린더)
 * - initCampusNews    : 캠퍼스 소식 탭 -> AJAX 테이블 렌더
 * [정책] 전부 IIFE + DOMContentLoaded 안에서만 동작, 전역 오염 최소화
 * ==================================================================== */
(function () {
    "use strict";

    const ctx = "${pageContext.request.contextPath}";

    document.addEventListener("DOMContentLoaded", function () {
        initLectureCards();
        initCalendar();
        initCampusNews();
    });

    /* ---------- 공통 유틸 ---------- */

    function escapeHtml(str) {
        if (str === null || str === undefined) return "";
        return String(str)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    function toDate(v) {
        return (v instanceof Date) ? v : new Date(v);
    }

    function pad2(n) {
        return (n < 10 ? "0" : "") + n;
    }

    function formatDate(d) {
        return d.getFullYear() + "-" + pad2(d.getMonth() + 1) + "-" + pad2(d.getDate());
    }

    // "오전/오후 HH:MM" + 24시간 숫자 그대로 노출
    function formatAmPm24Time(v) {
        const d = toDate(v);
        const h = d.getHours();
        const m = d.getMinutes();
        const ampm = (h < 12) ? "오전" : "오후";
        return ampm + " " + pad2(h) + ":" + pad2(m);
    }

    // 날짜 비교용 유틸 (멀티데이 이벤트 포함)
    function toDateOnly(date) {
        return new Date(date.getFullYear(), date.getMonth(), date.getDate());
    }

    function parseDateStr(dateStr) {
        const parts = (dateStr || "").split("-");
        if (parts.length !== 3) return null;
        const y = parseInt(parts[0], 10);
        const m = parseInt(parts[1], 10) - 1;
        const d = parseInt(parts[2], 10);
        return new Date(y, m, d);
    }

    // 선택한 날짜가 이벤트 기간 안에 포함되는지 판단
    function isEventOnDate(ev, dateStr) {
        if (!ev.start) return false;

        let target = parseDateStr(dateStr);
        if (!target) return false;

        target = toDateOnly(target);
        const start = toDateOnly(ev.start);
        const hasEnd = !!ev.end;
        const endDate = hasEnd ? toDateOnly(ev.end) : null;

        // allDay 이벤트
        if (ev.allDay) {
            if (hasEnd) {
                // FullCalendar allDay: [start, end) exclusive
                return target >= start && target < endDate;
            }
            // end 없으면 하루짜리
            return target.getTime() === start.getTime();
        }

        // 시간 이벤트 + end 존재 -> [start, end] 구간
        if (hasEnd) {
            return target >= start && target <= endDate;
        }

        // 시간 이벤트 + end 없음 -> start 날짜만
        return target.getTime() === start.getTime();
    }

    /* ---------- 1) 수강 카드 클릭 핸들러 ---------- */

    function initLectureCards() {
        const cards = Array.from(document.querySelectorAll(".js-lecture-card[data-lec-no]"));
        if (!cards.length) return;

        cards.forEach(card => {
            card.addEventListener("click", evt => {
                const lecNo = evt.currentTarget.dataset.lecNo;
                if (!lecNo) return;
                location.href = ctx + "/learning/student?lecNo=" + encodeURIComponent(lecNo);
            });
        });
    }

    /* ---------- 2) 학사 일정 미니 캘린더 ---------- */

    function initCalendar() {
        const calendarEl = document.getElementById("calendar");
        const loadingEl = document.getElementById("calendar-loading");
        const eventListEl = document.getElementById("calendar-event-list");
        const tooltipEl = document.getElementById("event-tooltip"); // 현재는 미사용, 확장 여지

        if (!calendarEl || !eventListEl) return;

        // const todayStr = formatDate(new Date());
        let selectedDateStr = null;

        function setLoading(visible) {
            if (!loadingEl) return;
            loadingEl.classList.toggle("visible", !!visible);
        }

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: "dayGridMonth",
            locale: "ko",
            height: 460,
            contentHeight: 460,
            expandRows: true,
            headerToolbar: {
                left: "prev",
                center: "title",
                right: "next"
            },
            dayMaxEvents: 4,
            dayMaxEventRows: true,

            // 셀 내부는 CSS 스트립만 쓰므로 여기서는 비워서 넘김
            eventContent: function () {
                return { html: "" };
            },

            /* 5. 이벤트 타입별 컬러 정의
               요구사항:
               - 과제 · 시험 · 평가         | 주황색        -> TASK
               - 학사공지                  | 보라색        -> SYSTEM
               - 상담(예약건)              | 연녹색        -> COUNSEL
               - 상담가능(교수시간)        | 청녹색        -> COUNSEL_SLOT
               - 수강신청 · 정정/철회      | 하늘색        -> ENROLL_REQ
               - 등록 · 휴학 · 복학 · 계절학기 | 분홍색  -> ADMIN_REGIST
               - 공휴일 · 임시공휴일       | 빨간색        -> HOLIDAY
            */

            events: function (info, successCallback, failureCallback) {
                const start = info.startStr.slice(0, 10);
                const end = info.endStr.slice(0, 10);

                setLoading(true);

                const url = "/api/schedule/events"
                    + "?start=" + encodeURIComponent(start)
                    + "&end=" + encodeURIComponent(end);

                fetch(url, { method: "GET", credentials: "include" })
                    .then(function (response) {
                        if (!response.ok) {
                            throw new Error("[" + response.status + "] 일정 조회 실패");
                        }
                        return response.json();
                    })
                    .then(function (data) {
                        if (!Array.isArray(data)) {
                            console.error("[MiniCalendar] invalid response", data);
                            successCallback([]);
                            return;
                        }

                        const events = data
                            .map(function (e) {
                                const rawType = e.type || "";
                                const rawTitle = e.title || "";
                                const rawMemo  = e.memo || e.content || "";

                                // 시간표(LECTURE)는 미니 캘린더에서 제외
                                if (rawType === "LECTURE") return null;

                                // 내용 기반 타입 재분류
                                const type = inferTypeFromContent(rawType, rawTitle, rawMemo);

                                const title = buildTitle(type, rawTitle);

                                // 백엔드 필드명 방어적 매핑
                                const startVal = e.startDate || e.startDt || e.start || e.START_DT;
                                const endVal   = e.endDate   || e.endDt   || e.end   || e.END_DT;

                                return {
                                    id: e.id,
                                    title: title,
                                    start: startVal,
                                    end: endVal,
                                    allDay: !!e.allDay,
                                    extendedProps: {
                                        rawTitle: rawTitle,
                                        displayTitle: title,
                                        type: type,
                                        place: e.place,
                                        target: e.target,
                                        memo: rawMemo
                                    },
                                    classNames: type ? ["type-" + type] : []
                                };
                            })
                            .filter(Boolean);

                        successCallback(events);
                    })
                    .catch(function (error) {
                        console.error("[MiniCalendar] events load error", error);
                        failureCallback(error);
                    })
                    .finally(function () {
                        setLoading(false);
                    });
            },

            dateClick: function (info) {
                setSelectedDate(info.dateStr);
            },

            eventClick: function (info) {
                const dateStr = info.event.startStr.slice(0, 10);
                setSelectedDate(dateStr);
            },

            eventsSet: function () {
                if (!selectedDateStr) {
                    //selectedDateStr = todayStr;

                    var today = calendar.getDate();
                    selectedDateStr = today.toISOString().slice(0, 10);
                }
                highlightSelectedDate();
                renderEventList(selectedDateStr);
            }
        });

        calendar.render();

        function setSelectedDate(dateStr) {
            selectedDateStr = dateStr;
            highlightSelectedDate();
            renderEventList(dateStr);
        }

     	// 선택 날짜 배경/라벨 하이라이트
        function highlightSelectedDate() {
            if (!selectedDateStr) return;

            const dayCells = calendarEl.querySelectorAll(".fc-daygrid-day");
            dayCells.forEach(function (cell) {
                const cellDate = cell.getAttribute("data-date");
                if (!cellDate) return;

                if (cellDate === selectedDateStr) {
                    // day 셀 자체에 fc-day-selected 부여
                    cell.classList.add("fc-day-selected");
                } else {
                    cell.classList.remove("fc-day-selected");
                }
            });
        }

        function parseLabeledPairs(memo) {
            if (!memo || typeof memo !== "string") return [];
            return memo.split("|").map(function (part) {
                const s = part.trim();
                if (!s) return null;
                let key, value;
                const idx = s.indexOf(" : ");
                if (idx >= 0) {
                    key = s.substring(0, idx).trim();
                    value = s.substring(idx + 3).trim();
                } else {
                    const idxEq = s.indexOf("=");
                    if (idxEq === -1) return null;
                    key = s.substring(0, idxEq).trim();
                    value = s.substring(idxEq + 1).trim();
                }
                if (!key || !value) return null;
                return { key: key, value: value };
            }).filter(Boolean);
        }

        //  학사일정: 제목/메모 키워드로 타입 재분류
        function inferTypeFromContent(rawType, title, memo) {
            var baseType = rawType || "";
            var text = ((title || "") + " " + (memo || "")).toLowerCase();

            // 백엔드에서 이미 LECTURE/TASK/COUNSEL 등으로 온 건 그대로 사용
            if (baseType && baseType !== "SCHAFS") {
                return baseType;
            }

            // 공휴일
            if (text.indexOf("공휴일") >= 0 ||
                text.indexOf("기독탄신일") >= 0 ||
                text.indexOf("1월1일") >= 0) {
                return "HOLIDAY";
            }

            // 상담 관련
            if (text.indexOf("상담") >= 0) {
                // 상담가능(교수시간) 키워드가 따로 있다면 여기서 COUNSEL_SLOT 으로 분기 가능
                if (text.indexOf("상담가능") >= 0 ||
                    text.indexOf("상담 가능") >= 0 ||
                    text.indexOf("지도시간") >= 0) {
                    return "COUNSEL_SLOT";
                }
                return "COUNSEL";
            }

            // 수강신청/계절학기/수강료/등록/휴학·복학 등 = 행정
            if (
                text.indexOf("수강료") >= 0 ||
                text.indexOf("등록") >= 0 ||
                text.indexOf("납부") >= 0 ||
                text.indexOf("휴학") >= 0 ||
                text.indexOf("복학") >= 0 ||
                text.indexOf("수강신청") >= 0 ||
                text.indexOf("수강 신청") >= 0 ||
                text.indexOf("정정") >= 0 ||
                text.indexOf("철회") >= 0 ||
                text.indexOf("계절학기") >= 0
            ) {
                return "ADMIN_REGIST";
            }

            // 전공/부전공/교환학생/신청 기간 등: 학사 공지 성격
            if (
                text.indexOf("복수전공") >= 0 ||
                text.indexOf("부전공") >= 0 ||
                text.indexOf("교환학생") >= 0 ||
                text.indexOf("신청기간") >= 0 ||
                text.indexOf("신청 기간") >= 0
            ) {
                return "SYSTEM"; // 학사공지
            }

            // 수업평가/시험/프로젝트/팀 관련은 과제 느낌으로 묶기
            if (
                text.indexOf("수업평가") >= 0 ||
                text.indexOf("시험") >= 0 ||
                text.indexOf("평가") >= 0 ||
                text.indexOf("팀프로젝트") >= 0 ||
                text.indexOf("프로젝트") >= 0 ||
                text.indexOf("팀") >= 0
            ) {
                return "TASK";
            }

            // 기타 학사일정(SCHAFS)은 기본값을 학사공지로
            if (baseType === "SCHAFS" || !baseType) {
                return "SYSTEM";
            }

            return baseType || "SYSTEM";
        }

        function buildTitle(type, rawTitle) {
            if (!rawTitle) rawTitle = "";
            if (rawTitle.startsWith("[")) return rawTitle;

            switch (type) {
                case "LECTURE":      return "[강의] " + rawTitle;
                case "TASK":         return "[과제] " + rawTitle;
                case "PROJECT":      return "[팀프로젝트] " + rawTitle;
                case "COUNSEL":      return "[상담] " + rawTitle;
                case "COUNSEL_SLOT": return "[상담가능] " + rawTitle;
                case "ENROLL_REQ":   return "[수강신청] " + rawTitle;
                case "ADMIN_CERT":
                case "ADMIN_STATUS":
                case "ADMIN_GRAD":
                case "ADMIN_REGIST": return "[행정] " + rawTitle;
                case "SYSTEM":       return "[학사공지] " + rawTitle;
                case "HOLIDAY":      return "[공휴일] " + rawTitle;
                default:             return rawTitle;
            }
        }

        function renderEventList(dateStr) {
            if (!eventListEl) return;

            // 선택 날짜가 이벤트 기간에 포함된 모든 일정 표시
            const events = calendar.getEvents().filter(function (ev) {
                return isEventOnDate(ev, dateStr);
            });

            if (events.length === 0) {
                eventListEl.innerHTML =
                    "<div class='calendar-event-list-header'>" +
                        "<span class='badge bg-light text-muted'>📅 " + escapeHtml(dateStr) + " 일정</span>" +
                    "</div>" +
                    "<div class='text-muted small py-1'>등록된 일정이 없습니다.</div>";
                return;
            }

            events.sort(function (a, b) {
                return (a.start || 0) - (b.start || 0);
            });

            const rowsHtml = events.map(function (ev) {
                const allDay = ev.allDay;
                const start = ev.start;
                let timeLabel = "종일";

                if (!allDay && start instanceof Date) {
                    const h = String(start.getHours()).padStart(2, "0");
                    const m = String(start.getMinutes()).padStart(2, "0");
                    timeLabel = h + ":" + m;
                } else if (!allDay && typeof ev.startStr === "string") {
                    const t = ev.startStr.split("T")[1] || "";
                    timeLabel = t ? t.slice(0, 5) : "시간미정";
                }

                const title = escapeHtml(ev.title || "");
                const type = (ev.extendedProps && ev.extendedProps.type) || "";
                let memo = (ev.extendedProps && ev.extendedProps.memo) || "";

                // memo 에서 "요청일"만 제거
                let memoPairs = parseLabeledPairs(memo);
                if (memoPairs.length > 0) {
                    memoPairs = memoPairs.filter(kv => kv.key !== "요청일");
                    memo = memoPairs.map(kv => kv.key + " : " + kv.value).join(" | ");
                }

                const typeClass = type ? (" type-" + type) : "";

                return (
                    "<div class='calendar-event-list-item" + typeClass + "'>" +
                        "<div class='type-strip'></div>" +
                        "<div class='calendar-event-list-item-body'>" +
                            "<div class='d-flex align-items-center'>" +
                                "<span class='calendar-event-time'>" + escapeHtml(timeLabel) + "</span>" +
                                "<span class='calendar-event-title'>" + title + "</span>" +
                            "</div>" +
                            (memo
                                ? "<div class='calendar-event-meta'>" + escapeHtml(memo) + "</div>"
                                : ""
                            ) +
                        "</div>" +
                    "</div>"
                );
            }).join("");

            eventListEl.innerHTML =
                "<div class='calendar-event-list-header'>" +
                    "<span class='badge bg-light text-primary fw-semibold'>📅 " + escapeHtml(dateStr) + " 일정</span>" +
                    "<span class='text-muted small fw-semibold'>" + events.length + "건</span>" +
                "</div>" +
                rowsHtml;
        }
    }

    /* ---------- 3) 캠퍼스 소식 탭 ---------- */

    function initCampusNews() {
        const tabButtons = document.querySelectorAll(".campus-news-tab");
        const listContainer = document.getElementById("campus-news-list");
        if (!tabButtons.length || !listContainer) return;

        tabButtons.forEach(function (btn) {
            btn.addEventListener("click", function () {
                tabButtons.forEach(function (b) { b.classList.remove("active"); });
                this.classList.add("active");

                const endpoint = this.dataset.endpoint;
                const tabType = this.dataset.type || "notice";
                loadCampusList(endpoint, tabType);
            });
        });

        // 초기 로딩: 첫 번째 탭
        const firstEndpoint = tabButtons[0].dataset.endpoint;
        const firstType = tabButtons[0].dataset.type || "notice";
        if (firstEndpoint) {
            loadCampusList(firstEndpoint, firstType);
        }

        function loadCampusList(endpoint, tabType) {
            if (!endpoint) return;

            listContainer.innerHTML =
                "<div class='text-muted small py-3'>로딩 중...</div>";

            fetch(endpoint, { method: "GET", credentials: "include" })
                .then(function (res) {
                    if (!res.ok) throw new Error("HTTP " + res.status);
                    return res.json();
                })
                .then(function (items) {
                    listContainer.innerHTML = renderItems(items, tabType);
                })
                .catch(function (err) {
                    console.error("[CampusNews] load error", err);
                    listContainer.innerHTML =
                        "<div class='text-danger small py-3'>데이터를 불러오지 못했습니다.</div>";
                });
        }

        function renderItems(items, tabType) {
            if (!Array.isArray(items) || items.length === 0) {
                return "<div class='text-muted small py-3'>게시글이 없습니다.</div>";
            }

            const isAcademic = (tabType === "academic");

            const rowsHtml = items.slice(0, 5).map(function (item, idx) {
                const no = idx + 1;

                const titleText = escapeHtml(
                    item.bbscttSj ||
                    item.title ||
                    item.bbscttCn ||
                    item.content ||
                    ""
                );

                const writerRaw =
                    item.writer ||
                    item.bbscttWriter ||
                    item.writerName ||
                    item.author ||
                    "";
                const writer = writerRaw ? escapeHtml(writerRaw) : "";

                let hit = "";
                if (!isAcademic && typeof item.bbscttRdcnt === "number") {
                    hit = String(item.bbscttRdcnt);
                }

                let rawDate =
                    item.bbscttWritngDe ||
                    item.startDt ||
                    item.START_DT ||
                    item.startDate ||
                    "";

                let dateStr = "";
                if (typeof rawDate === "string" && rawDate) {
                    if (rawDate.indexOf("T") > 0) {
                        dateStr = rawDate.split("T")[0];
                    } else if (rawDate.indexOf(" ") > 0) {
                        dateStr = rawDate.split(" ")[0];
                    } else {
                        dateStr = rawDate;
                    }
                } else if (typeof rawDate === "number") {
                    const d = new Date(rawDate);
                    if (!Number.isNaN(d.getTime())) {
                        dateStr = formatDate(d);
                    }
                } else if (rawDate instanceof Date) {
                    dateStr = formatDate(rawDate);
                }

                const date = escapeHtml(dateStr);

                let titleCellHtml = titleText;
                if (!isAcademic) {
                    const bbscttNo = item.bbscttNo != null ? String(item.bbscttNo) : null;
                    if (bbscttNo) {
                        const href = ctx + "/bbs/detail?bbscttNo=" + encodeURIComponent(bbscttNo);
                        titleCellHtml =
                            "<a href='" + href +
                            "' class='campus-link text-decoration-none text-body'>" +
                            titleText +
                            "</a>";
                    }
                }

                if (isAcademic) {
                    return (
                        "<tr>" +
                            "<td class='col-no'>" + no + "</td>" +
                            "<td class='campus-title-cell'>" + titleCellHtml + "</td>" +
                            "<td class='col-writer'>" + writer + "</td>" +
                            "<td class='col-date'>" + date + "</td>" +
                        "</tr>"
                    );
                }

                return (
                    "<tr>" +
                        "<td class='col-no'>" + no + "</td>" +
                        "<td class='campus-title-cell'>" + titleCellHtml + "</td>" +
                        "<td class='col-writer'>" + writer + "</td>" +
                        "<td class='col-date'>" + date + "</td>" +
                        "<td class='col-hit'>" + hit + "</td>" +
                    "</tr>"
                );
            }).join("");

            const theadHtml = isAcademic
                ? (
                    "<thead>" +
                        "<tr>" +
                            "<th class='col-no'>#</th>" +
                            "<th>제목</th>" +
                            "<th class='col-writer'>작성자</th>" +
                            "<th class='col-date'>등록일</th>" +
                        "</tr>" +
                    "</thead>"
                )
                : (
                    "<thead>" +
                        "<tr>" +
                            "<th class='col-no'>#</th>" +
                            "<th>제목</th>" +
                            "<th class='col-writer'>작성자</th>" +
                            "<th class='col-date'>등록일</th>" +
                            "<th class='col-hit'>조회수</th>" +
                        "</tr>" +
                    "</thead>"
                );

            return (
                "<div class='campus-news-table-wrapper'>" +
                    "<table class='table campus-news-table mb-0'>" +
                        theadHtml +
                        "<tbody>" + rowsHtml + "</tbody>" +
                    "</table>" +
                "</div>"
            );
        }
    }
})();
</script>

