<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../header.jsp"%>

<!-- ================================================================== -->
<!-- [code-intent] 학생 대시보드: 수강 카드 + 학적 진행률 + 캠퍼스 소식 + 학사 일정 캘린더 -->
<!-- [data-flow] 서버(Model) → 카드/테이블/캘린더 UI → 학생이 현재 학사 상태·일정 한눈에 파악 -->
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
 * 공통 레이아웃 / 카드 스킨
 * =================================================================== */

/* 대시보드 루트 row 좌우 패딩 (header 의 .px-5 와 충돌 없음) */
.dashboard-row {
    padding-right: 1rem !important;
    padding-left: 1rem !important;
}

/* 메인/사이드 컬럼 비율 및 상단 여백 최소화 */
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
    }
    .dashboard-side-col {
        padding-left: 1.5rem;
    }
}

/* 대시보드 공용 내부 카드 (body_1/body_2) */
.card-body_1,
.card-body_2 {
    background-color: #fff;
    border-radius: .75rem;
    box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .09);
    margin-top: 0 !important;
    margin-bottom: 4px !important;
    height: auto !important;
    padding-left: 1.28rem;
    padding-right: 1.28rem;
}

/* 메인 컨테이너 높이 */
#main-container.container-fluid {
    height: auto;
    min-height: calc(100vh - 120px);
    padding-top: 12px;
    padding-bottom: 12px;
}

/* =====================================================================
 * 수강 중인 강의 카드 영역
 * =================================================================== */

/* 상단 수강 카드 row 여백 */
.lecture-row {
    margin-top: .25rem;
    margin-bottom: .25rem;
}

/* 래퍼 카드: 그림자만, 외곽 라인 제거 */
.lecture-card-wrapper {
    border: 0;
    box-shadow: 0 .5rem 1.5rem rgba(15, 23, 42, .08);
    border-radius: 1rem;
}

/* 개별 수강 카드: 평면 + 연한 보더 */
.lecture-card-item {
    box-shadow: none !important;
    border: 1px solid #e5e7eb;
    border-radius: .9rem;
    max-width: 260px;
    width: 100%;
    padding: 0.6rem 1rem;
    cursor: pointer;
}

/* 카드 텍스트 */
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

/* =====================================================================
 * 학적 진행률 카드
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

/* 테이블 외곽은 유지, 행 사이만 옅게 */
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

/* 학적 이행 테이블 행/폰트 */
.academic-progress-table .progress-metric-label {
    font-weight: 600;
    text-align: left;
    white-space: nowrap;
}

.academic-progress-table tbody tr > td {
    padding-top: .55rem;
    padding-bottom: .55rem;
}

/* 진행률 바 + 메타 텍스트 */
.academic-progress-table .progress {
    height: 0.6rem;
    border-radius: 999px;
    background-color: #edf1f7;
}

.academic-progress-table .progress-meta {
    font-size: .75rem;
    color: #6c757d;
}

/* 충족/미충족 Pill */
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
 * 캠퍼스 소식 카드
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
    overflow: hidden;
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

/* 테이블 스킨 */
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
    overflow: hidden;
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
 * 학사 일정 미니 캘린더 카드
 * =================================================================== */

.academic-card {
    background-color: #fff;
    border-radius: 1rem;
    box-shadow: 0 .5rem 1.5rem rgba(15, 23, 42, .08);
    margin-top: 0 !important;
    margin-bottom: 10px !important;
    padding: 2px 8px 4px;
    height: auto !important;
    max-height: none !important;
    overflow: visible !important;
    display: flex;
    flex-direction: column;
}

/* 미니 캘린더 컨테이너 */
.calendar-container {
    margin: 0;
    padding: 0.5rem 1rem 0.75rem 1rem;
    background-color: #ffffff;
}

/* FullCalendar 기본 폰트 축소 */
.timetable-container .fc,
.calendar-container .fc {
    font-size: 0.78rem;
}

/* 오늘 날짜 스타일 */
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

/* 날짜 선택 하이라이트 */
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

.fc .fc-toolbar.fc-header-toolbar {
    margin-bottom: 0.5em;
}

/* 미니 캘린더에서 prev/next 등 버튼 숨김 (헤더만 중앙 타이틀용) */
.academic-card .calendar-container .fc-button-group,
.academic-card .calendar-container .fc-header-toolbar .fc-toolbar-chunk:first-child {
    display: none;
}

.academic-card .calendar-container .fc-header-toolbar {
    justify-content: center;
}

/* dayGrid 이벤트 스타일 */
.fc-daygrid-event {
    border-radius: 4px;
    padding: 1px 4px;
    border: 0;
    font-size: 0.72rem;
    line-height: 1.2;
    font-weight: 500;
}

/* 타입별 색상 (셀 안) */
.fc-daygrid-event.type-TASK {
    background-color: rgba(34, 197, 94, 0.12);
    border-left: 3px solid #22c55e;
    color: #166534;
}
.fc-daygrid-event.type-PROJECT {
    background-color: rgba(249, 115, 22, 0.12);
    border-left: 3px solid #f97316;
    color: #9a3412;
}
.fc-daygrid-event.type-COUNSEL {
    background-color: rgba(14, 165, 233, 0.12);
    border-left: 3px solid #0ea5e9;
    color: #075985;
}
.fc-daygrid-event.type-COUNSEL_SLOT {
    background-color: rgba(56, 189, 248, 0.12);
    border-left: 3px solid #38bdf8;
    color: #0369a1;
}
.fc-daygrid-event.type-ENROLL_REQ {
    background-color: rgba(99, 102, 241, 0.12);
    border-left: 3px solid #6366f1;
    color: #3730a3;
}
.fc-daygrid-event.type-ADMIN_REGIST {
    background-color: rgba(168, 85, 247, 0.12);
    border-left: 3px solid #a855f7;
    color: #6b21a8;
}
.fc-daygrid-event.type-HOLIDAY {
    background-color: rgba(239, 68, 68, 0.12);
    border-left: 3px solid #ef4444;
    color: #b91c1c;
}

/* 캘린더 하단 리스트 */
.calendar-event-list {
    border-top: 1px solid #e5e7eb;
    margin-top: .5rem;
    padding-top: .25rem;
    font-size: 0.75rem;
    line-height: 1.35;
    max-height: 300px;
    overflow-y: auto;
}

.calendar-event-list-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: .25rem;
}

.calendar-event-list-item {
    display: flex;
    align-items: flex-start;
    padding: .22rem .5rem;
    margin-bottom: .18rem;
    border-radius: .45rem;
    border: 1px solid #e5e7eb;
    background-color: #ffffff;
}

.calendar-event-list-item:last-child {
    margin-bottom: 0;
}

.calendar-event-list-item .type-strip {
    width: 4px;
    border-radius: 999px;
    margin-right: .6rem;
    flex-shrink: 0;
}

.calendar-event-list-item-body {
    flex: 1;
}

.calendar-event-time {
    font-size: 0.75rem;
    min-width: 38px;
    font-weight: 600;
    margin-right: .35rem;
}

.calendar-event-title {
    font-size: 0.78rem;
    font-weight: 500;
}

.calendar-event-meta {
    color: #6b7280;
    font-size: 0.7rem;
    margin-top: 1px;
}

.calendar-event-list-header .badge {
    font-size: 0.70rem;
    padding: .25rem .55rem;
}

/* 리스트형 이벤트: 카드 테두리 제거 + 상단 구분선만 */
.calendar-event-list-item.type-TASK,
.calendar-event-list-item.type-PROJECT,
.calendar-event-list-item.type-COUNSEL,
.calendar-event-list-item.type-COUNSEL_SLOT,
.calendar-event-list-item.type-ENROLL_REQ,
.calendar-event-list-item.type-ADMIN_REGIST,
.calendar-event-list-item.type-HOLIDAY {
    border: none !important;
    box-shadow: none !important;
    border-radius: 0;
    padding: 6px 10px;
    border-top: 2px solid #e5e7eb;
    padding-bottom: 0.1rem;
}

/* 타입별 색상 (리스트) */
.calendar-event-list-item.type-TASK .type-strip { background-color: #22c55e; }
.calendar-event-list-item.type-PROJECT .type-strip { background-color: #f97316; }
.calendar-event-list-item.type-COUNSEL .type-strip { background-color: #0ea5e9; }
.calendar-event-list-item.type-COUNSEL_SLOT .type-strip { background-color: #38bdf8; }
.calendar-event-list-item.type-ENROLL_REQ .type-strip { background-color: #6366f1; }
.calendar-event-list-item.type-ADMIN_REGIST .type-strip { background-color: #a855f7; }
.calendar-event-list-item.type-HOLIDAY .type-strip { background-color: #ef4444; }

/* 달력 자체 높이 */
.academic-card #calendar {
    height: 350px;
}

/* 공통 card-title 미세 튜닝 */
.card-title {
    font-size: 14px;
    margin: -8px 0px 2px -8px;
}
.px-5 {
    padding-right: 0rem!important;
    padding-left: 0rem!important;
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
/* 수강 카드 그리드: 상하/좌우 간격 동일하게 */
.lecture-card-wrapper .row.g-3 {
    --bs-gutter-x: 1.5rem;   /* 좌우 카드 간격 */
    --bs-gutter-y: 0.1rem;   /* 상하 카드 간격 */
}
.g-3, .gy-3 {
    --vz-gutter-y: 0rem !important;
    --vz-gutter-x: 1.9rem !important;
}
.card-body_1, .card-body_2 {
    background-color: #fff;
    border-radius: .75rem;
    box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .09);
    margin-top: -10px !important;
    margin-bottom: -6px !important;
    height: auto !important;
    padding-left: 0.28rem !important;
    padding-right: 0.28rem !important;
}
.calendar-container {
    padding: 1.8rem 1.8rem 1.8rem 1.8rem !important;
    background-color: #ffffff;
}
.academic-card {
    background-color: #fff;
    border-radius: 1rem;
    box-shadow: 0 .5rem 1.5rem rgba(15, 23, 42, .08);
    margin-top: 0 !important;
    margin-bottom: 10px !important;
    padding: -1px 0px 0px !important;
    height: auto !important;
    max-height: none !important;
    overflow: visible !important;
    display: flex;
    flex-direction: column;
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
                                <p class="text-muted mb-0">현재 수강 중인 강의가 없습니다.</p>
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

                    <!-- 아래 일정 리스트 영역 -->
                    <div id="calendar-event-list" class="calendar-event-list mt-3"></div>
                    <div id="calendar-loading" class="calendar-loading">일정을 불러오는 중...</div>
                </div>

                <!-- 공용 툴팁 (위치 이동 가능, ID 유지) -->
                <div id="event-tooltip" class="event-tooltip"></div>
            </div>
        <!-- </div> -->
    </div>
</div>

<%@ include file="../../footer.jsp"%>

<script>
/* ======================================================================
 * 학생 대시보드 전용 JS
 * - initLectureCards  : 수강 카드 클릭 → 상세 학습 페이지 이동
 * - initCalendar      : FullCalendar + 일자별 리스트 싱크
 * - initCampusNews    : 캠퍼스 소식 탭 → AJAX 테이블 렌더
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
        const tooltipEl = document.getElementById("event-tooltip");
        const eventListEl = document.getElementById("calendar-event-list");

        if (!calendarEl) return;

        const eventCache = {};       // 기간별 이벤트 캐시
        const typeVisibility = {};   // 타입별 on/off (legend 에서 사용, 없으면 전부 on)
        let selectedDateStr = null;  // YYYY-MM-DD
        let syncQueued = false;      // dayCell 높이 동기화 예약 플래그

        function setLoading(visible) {
            if (!loadingEl) return;
            loadingEl.classList.toggle("visible", !!visible);
        }

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: "dayGridMonth",
            locale: "ko",
            height: 400,
            contentHeight: 360,
            expandRows: true,
            headerToolbar: {
                left: "prev,next today",
                center: "title",
                right: "dayGridMonth,timeGridWeek,timeGridDay,listWeek"
            },
            dayMaxEvents: true,
            dayMaxEventRows: true,
            eventTimeFormat: { hour: "2-digit", minute: "2-digit", hour12: false },

            eventContent: function (arg) {
                const e = arg.event;
                let html = "";

                if (!e.allDay && e.start) {
                    html += "<span class='fc-time'>" + formatAmPm24Time(e.start) + "</span> ";
                }
                html += "<span class='fc-title'>" + escapeHtml(e.title || "") + "</span>";
                return { html: html };
            },

            slotLabelContent: function (arg) {
                return formatAmPm24Time(arg.date);
            },

            events: function (info, successCallback, failureCallback) {
                const startDate = info.startStr.substring(0, 10);
                const endDate = info.endStr.substring(0, 10);
                const cacheKey = startDate + "|" + endDate;

                if (eventCache[cacheKey]) {
                    successCallback(eventCache[cacheKey].map(applyTypeToEventDisplay));
                    queueSyncDayCellHeights();
                    return;
                }

                const url = "/api/schedule/events"
                    + "?start=" + encodeURIComponent(startDate)
                    + "&end=" + encodeURIComponent(endDate);

                setLoading(true);

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
                            eventCache[cacheKey] = [];
                            successCallback([]);
                            return;
                        }

                        const events = data.map(function (e) {
                            const type = e.type || "";
                            if (!(type in typeVisibility)) {
                                typeVisibility[type] = true; // 처음 보는 타입은 기본 ON
                            }

                            const baseTitle = e.title || "";
                            const title = buildTitle(type, baseTitle);

                            const fcEvent = {
                                id: e.id,
                                title: title,
                                start: e.startDate,
                                end: e.endDate,
                                allDay: !!e.allDay,
                                extendedProps: {
                                    rawTitle: baseTitle,
                                    displayTitle: title,
                                    type: type,
                                    place: e.place,
                                    target: e.target,
                                    memo: e.memo || ""
                                },
                                classNames: type ? ["type-" + type] : []
                            };

                            return applyTypeToEventDisplay(fcEvent);
                        });

                        eventCache[cacheKey] = events;
                        successCallback(events);
                    })
                    .catch(function (error) {
                        console.error("[Calendar] events load error", error);
                        failureCallback(error);
                    })
                    .finally(function () {
                        setLoading(false);
                        queueSyncDayCellHeights();
                    });
            },

            datesSet: function () {
                queueSyncDayCellHeights();
            },

            eventDidMount: function () {
                queueSyncDayCellHeights();
            },

            dateClick: function (info) {
                setSelectedDate(info.dateStr);
            },

            eventsSet: function () {
                if (!selectedDateStr) {
                    const today = calendar.getDate();
                    selectedDateStr = today.toISOString().slice(0, 10);
                }
                highlightSelectedDate();
                renderEventList(selectedDateStr);
            },

            eventClick: function (info) {
                const dateStr = info.event.startStr.slice(0, 10);
                setSelectedDate(dateStr);
            }
        });

        calendar.render();

        window.addEventListener("resize", queueSyncDayCellHeights);

        // legend 가 있으면 타입 필터 토글 (없으면 no-op)
        document.querySelectorAll(".legend-item[data-type]").forEach(function (item) {
            const type = item.getAttribute("data-type");
            if (!(type in typeVisibility)) {
                typeVisibility[type] = true;
            }

            item.addEventListener("click", function () {
                const enabled = typeVisibility[type] !== false;
                const next = !enabled;
                typeVisibility[type] = next;
                item.classList.toggle("disabled", !next);
                applyTypeFilterToRenderedEvents();
                queueSyncDayCellHeights();
            });
        });

        function setSelectedDate(dateStr) {
            selectedDateStr = dateStr;
            highlightSelectedDate();
            renderEventList(dateStr);
        }

        function queueSyncDayCellHeights() {
            if (syncQueued) return;
            syncQueued = true;
            requestAnimationFrame(function () {
                syncQueued = false;
                syncDayCellHeights();
                killCalendarScroll();
            });
        }

        function killCalendarScroll() {
            const scrollers = calendarEl.querySelectorAll(".fc-scroller");
            scrollers.forEach(function (el) {
                el.style.overflow = "visible";
            });
        }

        // 같은 주의 dayCell 높이를 맞춰 grid 찌그러짐 방지
        function syncDayCellHeights() {
            const view = calendar.view;
            if (!view || view.type.indexOf("dayGrid") !== 0) return;

            const frames = calendarEl.querySelectorAll(".fc-daygrid-day-frame");
            if (!frames.length) return;

            frames.forEach(f => { f.style.height = "auto"; });

            let max = 0;
            frames.forEach(f => {
                if (f.offsetHeight > max) max = f.offsetHeight;
            });
            if (!max) return;

            frames.forEach(f => { f.style.height = max + "px"; });
        }

        function applyTypeToEventDisplay(evt) {
            const p = evt.extendedProps || {};
            const t = p.type;

            if (t === "LECTURE") {
                evt.display = "none"; // 시간표 이벤트는 이 미니 캘린더에서 숨김
            } else if (!t || typeVisibility[t] !== false) {
                evt.display = "auto";
            } else {
                evt.display = "none";
            }
            return evt;
        }

        function applyTypeFilterToRenderedEvents() {
            calendar.getEvents().forEach(function (e) {
                const t = e.extendedProps && e.extendedProps.type;
                if (t === "LECTURE") {
                    e.setProp("display", "none");
                } else if (!t || typeVisibility[t] !== false) {
                    e.setProp("display", "auto");
                } else {
                    e.setProp("display", "none");
                }
            });
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

        function sameDate(a, b) {
            return a.getFullYear() === b.getFullYear()
                && a.getMonth() === b.getMonth()
                && a.getDate() === b.getDate();
        }

        function formatRange(start, end, allDay) {
            if (!start) return "-";
            const s = toDate(start);
            const e = end ? toDate(end) : null;

            if (allDay) {
                if (!e) return formatDate(s);
                const eAdj = new Date(e.getTime() - 24 * 60 * 60 * 1000);
                if (sameDate(s, eAdj)) return formatDate(s);
                return formatDate(s) + " ~ " + formatDate(eAdj);
            }

            const sLabel = formatAmPm24Time(s);
            if (!e) return sLabel;

            const eLabel = formatAmPm24Time(e);
            if (sameDate(s, e)) {
                return sLabel + " ~ " + eLabel;
            }
            return formatDate(s) + " " + sLabel + " ~ " +
                   formatDate(e) + " " + eLabel;
        }

        function highlightSelectedDate() {
            if (!selectedDateStr) return;

            const dayCells = calendarEl.querySelectorAll(".fc-daygrid-day");
            dayCells.forEach(function (cell) {
                const cellDate = cell.getAttribute("data-date");
                if (!cellDate) return;

                if (cellDate === selectedDateStr) {
                    cell.classList.add("fc-day-selected");
                } else {
                    cell.classList.remove("fc-day-selected");
                }
            });
        }

        function renderEventList(dateStr) {
            if (!eventListEl) return;
            selectedDateStr = dateStr;

            const events = calendar.getEvents().filter(function (ev) {
                return ev.startStr && ev.startStr.slice(0, 10) === dateStr;
            });

            if (events.length === 0) {
                eventListEl.innerHTML =
                    "<div class='calendar-event-list-header'>" +
                    "<span class='badge bg-light text-muted'>" + dateStr + " 일정</span>" +
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
                                "<span class='calendar-event-time'>" + timeLabel + "</span>" +
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
                    "<span class='badge bg-light text-muted'>" + dateStr + " 일정</span>" +
                    "<span class='text-muted small'>" + events.length + "건</span>" +
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
