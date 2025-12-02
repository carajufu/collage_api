<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../../header.jsp"%>

<!-- ================================================================== -->
<!-- [code-intent] 학생 대시보드: 수강 카드 + 학적 진행률 + 캠퍼스 소식 + 학사 일정 캘린더 한 화면 제공 -->
<!-- [data-flow] 서버(JSP Model 속성, REST API) → 카드/테이블/캘린더 UI → 학생이 현황 파악 -->
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

<!-- 전체 대시보드 래퍼: 좌우 패딩만, 세로 여백/간격 최소화 -->
<div class="row dashboard-row pb-4 g-0 align-items-start">

    <!-- 좌측 전체: 수강 카드 + 학적 진행 + 캠퍼스 소식 -->
    <div class="col-xxl-6 col-lg-6 dashboard-main-col">

        <!-- ================================================================== -->
        <!-- [code-intent] 상단 수강중 강의 카드 영역 -->
        <!-- [data-flow] lectureList(Model) → 카드 반복 렌더 → 클릭 시 추후 상세 연결 가능 -->
        <!-- ================================================================== -->
  		<!-- 수강중 과목이 없을 때 안내 -->
        <div class="lecture-row">
            <c:choose>
                <c:when test="${not empty lectureList}">
                    <div
                        class="row row-cols-xxl-2 row-cols-lg-2 row-cols-md-2 row-cols-1 g-1 lecture-grid">
                        <c:forEach items="${lectureList}" var="lecture">
                            <div class="col">
                                <div class="card card-body rounded-3 shadow-sm lecture-card"
                                    data-lec-no="${lecture.estbllctreCode}">
                                    <h4 class="card-title" data-key="${lecture.lctreNm}">
                                        ${lecture.lctreNm}</h4>
                                    <p class="card-subtitle" data-key="${lecture.lctrum}">
                                        ${lecture.lctrum}</p>
                                    <p class="card-subtitle" data-key="${lecture.sklstfNm}">
                                        ${lecture.sklstfNm}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="card card-body rounded-2 shadow-sm lecture-empty-card">
                        <div class="mb-0 lecture-empty-text text-center">
                            <h5>수강중인 과목이 없습니다.</h5>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- ================================================================== -->
        <!-- [code-intent] 학적 이행(이수학점/전공/교양/외국어) 진행률 테이블 -->
        <!-- [data-flow] Model 에서 전달된 이수/필요 학점 + rate/met 플래그 → 진행률 바 + Pill 텍스트 -->
        <!-- [rationale] "충족/미충족"을 서버에서 Boolean 으로 넘겨 UI 로직을 단순화 -->
        <!-- ================================================================== -->
        
		<table class="table table-bordered align-middle text-center">
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
						<div class="progress" style="height:22px;">
							<c:set var="pntPct"
								   value="${(requirements.totalPnt >= requirements.MIN_TOTAL_PNT)
											 ? 100
											 : (requirements.totalPnt * 100.0 / requirements.MIN_TOTAL_PNT)}" />
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
						<div class="progress" style="height:22px;">
							<c:set var="majorPct"
								   value="${(requirements.majorPnt >= requirements.MIN_MAJOR_PNT)
											 ? 100
											 : (requirements.majorPnt * 100.0 / requirements.MIN_MAJOR_PNT)}" />
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
						<div class="progress" style="height:22px;">
							<c:set var="libPct"
								   value="${(requirements.liberalPnt >= requirements.MIN_LIBERAL_PNT)
											 ? 100
											 : (requirements.liberalPnt * 100.0 / requirements.MIN_LIBERAL_PNT)}" />
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
						<div class="progress" style="height:22px;">
							<c:set var="flPct"
								   value="${(requirements.foreignLangCount >= requirements.MIN_FOREIGN_LANG)
											 ? 100
											 : (requirements.foreignLangCount * 100.0 / requirements.MIN_FOREIGN_LANG)}" />
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
						<div class="progress" style="height:22px;">
							<c:set var="gpaPct"
								   value="${(requirements.totalGpa >= requirements.MIN_TOTAL_GPA)
											 ? 100
											 : (requirements.totalGpa * 100.0 / requirements.MIN_TOTAL_GPA)}" />
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

        <!-- ================================================================== -->
        <!-- [code-intent] 캠퍼스 소식 카드 (공지/뉴스/학사일정 탭) -->
        <!-- [data-flow] 탭 클릭 → /api/dashboard/* endpoint fetch → 상위 5건 테이블 렌더 -->
        <!-- ================================================================== -->
        <div class="card campus-news-card mt-2">
            <div
                class="card-header d-flex align-items-center justify-content-between">
                <h5 class="mb-0">캠퍼스 소식</h5>
                <span class="badge bg-light text-muted"> ${currentYear}년
                    ${currentMonth}월 </span>
            </div>

            <div class="card-body_2 pt-3">
                <ul class="nav nav-pills campus-news-tabs" id="campus-news-tabs"
                    role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link campus-news-tab active"
                            id="campus-news-notice-tab" data-bs-toggle="tab" type="button"
                            role="tab" aria-selected="true" data-type="notice"
                            data-endpoint="/api/dashboard/notices">공지사항</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link campus-news-tab" id="campus-news-news-tab"
                            data-bs-toggle="tab" type="button" role="tab"
                            aria-selected="false" data-type="news"
                            data-endpoint="/api/dashboard/news">대덕 뉴스</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link campus-news-tab"
                            id="campus-news-academic-tab" data-bs-toggle="tab" type="button"
                            role="tab" aria-selected="false" data-type="academic"
                            data-endpoint="/api/dashboard/academic">학사일정</button>
                    </li>
                </ul>

                <!-- Ajax 결과 렌더링 영역 -->
                <div id="campus-news-list" class="mt-3"></div>
            </div>
        </div>
    </div>

    <!-- 우측: 학사 캘린더 카드 -->
    <!-- [code-intent] 학사 일정 미니 캘린더 + 하단 리스트로 오늘/선택일 일정 요약 -->
    <div class="col-xxl-6 col-lg-6 dashboard-side-col">
        <div class="card academic-card">
            <div class="card-body_1">
                <div class="calendar-container">
                    <div id="calendar"></div>

                    <!-- 아래 일정 리스트 영역 -->
                    <div id="calendar-event-list" class="calendar-event-list mt-3"></div>
                    <div id="calendar-loading" class="calendar-loading">일정을 불러오는
                        중...</div>
                </div>

                <!-- 공용 툴팁 (위치 이동 가능, ID 유지) -->
                <div id="event-tooltip" class="event-tooltip"></div>
            </div>
        </div>
    </div>

</div>

<%@ include file="../../footer.jsp"%>

<style>
/* =======================================================================
   학생 대시보드 전용 스타일
   - Bootstrap/Velzon 기본 컴포넌트는 그대로 두고
   - 이 페이지에서만 쓰는 클래스(.dashboard-*, .academic-card 등)에 한정해 오버라이드
   ======================================================================= */

/* 내부 중첩 카드/컨테이너는 전부 평면화 (중복 그림자 제거) */
.academic-card .card,
.academic-card .calendar-container,
.academic-card .fc-theme-standard .fc-scrollgrid {
    background: transparent !important;
    box-shadow: none !important;
    border-radius: 0 !important;
    border: 0 !important;
}

/* 최상단 수강 카드 row: 위/아래 여백 최소화 */
.lecture-row {
    margin-top: .25rem;
    margin-bottom: .25rem;
}

/* 메인 컨테이너: 헤더/푸터와 충돌 없게 뷰포트 기준 높이 */
#main-container.container-fluid {
    height: auto;
    min-height: calc(100vh - 120px);
    padding-top: 12px;
    padding-bottom: 12px;
}

/* 좌측 시간표 카드 (다른 페이지 공용 스타일 보존용) */
.timetable-container {
    background-color: #fff;
    border-radius: .75rem;
    box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .09);
    margin-top: 0 !important;
    margin-bottom: 10px !important;
    padding: 0.5rem 1.28rem 0.25rem;
    overflow: hidden;
    height: 380px !important;
}

.timetable-container #timetable {
    height: 100%;
}

.timetable-container .fc-header-toolbar {
    margin: 0 0 2px 0;
    padding: 0;
    border-radius: .75rem;
    min-height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.timetable-container .fc-toolbar-title {
    font-size: 1rem;
    font-weight: 500;
}

.timetable-container .fc-col-header-cell {
    padding-top: 0;
    padding-bottom: 0;
}

#timetable .fc-timegrid-slot {
    height: 1.4rem;
    min-height: 1.4rem;
    line-height: 1.4rem;
}

#timetable .fc-timegrid-slot-label-cushion {
    padding: 0 4px;
    font-size: 0.8rem;
}

#timetable .fc-timegrid-event {
    font-size: 0.8rem;
    line-height: 1.2;
}

.fc-event {
    position: relative;
    display: block;
    font-size: 10.2px;
    line-height: 1.0;
    border-radius: 3px;
    border: 0.8px solid #3a87ad;
}

.lecture-cards-row {
    max-height: 260px;
    overflow-y: auto;
    padding-bottom: 0 !important;
}

.card-header .fc-toolbar-chunk {
    font-size: 10.2px;
}

/* 우측: 학사 캘린더 래퍼 */
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

/* 상단/하단 카드 바디 공통 */
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

/* 대시보드 카드 내부 좌우 패딩 공통 */
.timetable-container {
    padding-left: 1.28rem;
    padding-right: 1.28rem;
}

.timetable-container .card-header,
.card-body_1 .card-header,
.card-body_2 .card-header {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.75rem;
}

.timetable-container .card-title,
.card-body_1 .card-title,
.card-body_2 .card-title {
    padding-top: 3px;
    font-size: 1.3rem;
    text-align: center;
}

.academic-card .card-body,
.card-body_2 {
    font-size: 0.86rem;
}

.campus-item-index {
    display: inline-block;
    min-width: 1.7rem;
    margin-right: 0.6rem;
    font-weight: 500;
    font-size: 0.8rem;
    color: #64748b;
}

.campus-item-title {
    font-size: 0.86rem;
}

.campus-item-date {
    font-size: 0.8rem;
}

/* 캘린더 공통 */
.calendar-containers {
    position: relative;
    margin: -2px auto;
    padding: 2px 12px;
    background-color: #ffffff;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    max-height: 360px;
}

/* 미니 캘린더 컨테이너: 위쪽 여백만 살짝 줄임 */
.calendar-container {
    margin: 0;
    padding: 0.5rem 1rem 0.75rem 1rem;
    background-color: #ffffff;
}

/* 캘린더 범례 여백 */
.calendar-container .legend {
    margin-top: 4px;
}


/* 캘린더/시간표 폰트 */
.timetable-container .fc,
.calendar-container .fc {
    font-size: 0.78rem;
}

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

.fc-daygrid-day-top {
    overflow: visible;
    padding-top: 4px;
}

.fc .fc-toolbar.fc-header-toolbar {
    margin-bottom: 0.5em;
}

.fc .fc-toolbar>*>:first-child {
    margin-left: 3px;
}

.fc-button-group {
    margin-left: -3px;
}

/* 캠퍼스 소식 카드 */
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

.campus-news-table-wrapper {
    padding: 0.75rem 1.25rem 0.75rem;
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

.campus-news-table-wrapper {
    padding: 0.75rem 1.25rem 0.75rem;
    border-radius: 0 0 .9rem .9rem;
}

.campus-news-table {
    border-radius: .6rem;
    overflow: hidden;
}

.card-title {
    font-size: 14px;
    margin: -8px 0px 2px -8px;
}

/* 학사 캘린더 하단 리스트 */
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

/* 카테고리별 색상 (리스트) */
.calendar-event-list-item.type-TASK .type-strip {
    background-color: #22c55e;
}

.calendar-event-list-item.type-PROJECT .type-strip {
    background-color: #f97316;
}

.calendar-event-list-item.type-COUNSEL .type-strip {
    background-color: #0ea5e9;
}

.calendar-event-list-item.type-COUNSEL_SLOT .type-strip {
    background-color: #38bdf8;
}

.calendar-event-list-item.type-ENROLL_REQ .type-strip {
    background-color: #6366f1;
}

.calendar-event-list-item.type-ADMIN_REGIST .type-strip {
    background-color: #a855f7;
}

.calendar-event-list-item.type-HOLIDAY .type-strip {
    background-color: #ef4444;
}

/* 메인/사이드 비율 */
@media (min-width: 1400px) {
    .dashboard-main-col {
        flex: 0 0 70%;
        max-width: 70%;
    }

    .dashboard-side-col {
        flex: 0 0 30%;
        max-width: 30%;
    }
}

/* 메인/사이드 컬럼 위 여백 최소화해서 캘린더를 위로 끌어올림 */
.dashboard-main-col,
.dashboard-side-col {
    margin-top: 0;
    padding-top: 0.25rem;
}

/* 달력 높이 */
.academic-card #calendar {
    height: 350px;
}

/* FullCalendar daygrid 이벤트 숨김(+more 제거) - 필요 시 활성화용 보관 */
/*
.fc-daygrid-event-harness {
    display: none !important;
}

.fc .fc-daygrid-day-bottom {
    display: none !important;
}
*/

/* 대시보드 루트 row 좌우 패딩 (header 의 .px-5 유틸에는 영향 없음) */
.dashboard-row {
    padding-right: 1rem !important;
    padding-left: 1rem !important;
}

/* 학적 이행 테이블 전용 스타일 */
.academic-progress-table .progress-metric-label {
    font-weight: 600;
    text-align: left;
    white-space: nowrap;
}

.academic-progress-table tbody tr>td {
    padding-top: .55rem;
    padding-bottom: .55rem;
}

/* 진행률 바: 얇고, 배경은 연한 회색 */
.academic-progress-table .progress {
    height: 0.6rem;
    border-radius: 999px;
    background-color: #edf1f7;
}

/* 진행률 숫자 라벨 */
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

/* dayGrid 이벤트 기본 스타일 (캘린더 셀 안) */
.fc-daygrid-event {
    border-radius: 4px;
    padding: 1px 4px;
    border: 0;
    font-size: 0.72rem;
    line-height: 1.2;
    font-weight: 500;
}

/* 타입별 색상: 범례/리스트와 매칭 (캘린더 셀) */
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

/* 선택한 날짜 하이라이트 (클릭한 셀) */
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

/* 수강 카드 가로 폭 + 간격 조정 */
.lecture-card {
    max-width: 260px;
    width: 100%;
    margin-left: 0;
    margin-right: 0;
    padding: 0.6rem 1rem;
}

/* 수강 카드 grid 간격 더 압축 */
.lecture-grid {
    --bs-gutter-x: 0.25rem;
    --bs-gutter-y: 0.25rem;
}

/* 학사 캘린더 툴바 버튼 숨김 (뷰 전환/prev/next) */
.academic-card .calendar-container .fc-button-group {
    display: none;
}

.academic-card .calendar-container .fc-header-toolbar .fc-toolbar-chunk:first-child {
    display: none;
}

.academic-card .calendar-container .fc-header-toolbar {
    justify-content: center;
}

/* xxl 구간 카드 폭 조정 (이 페이지 한정 Bootstrap row-cols override) */
.row-cols-xxl-3>* {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 auto;
    flex: 0 0 auto;
    width: 22.33%;
}

.row-cols-xxl-2>* {
    -webkit-box-flex: 0;
    -ms-flex: 0 0 auto;
    flex: 0 0 auto;
    width: 28%;
}

/* 메인/사이드 컬럼 위 여백 최소화 + 우측 캘린더 좌측 패딩 */
.dashboard-main-col {
    margin-top: 0;
    padding-top: 0.25rem;
}

.dashboard-side-col {
    margin-top: 0;
    padding-top: 0.25rem;
    padding-left: 1.5rem;
}

/* 캠퍼스 소식 제목 링크 스타일: 색상 상속 + hover 시 밑줄만 */
.campus-news-table .campus-title-cell a {
    color: inherit;
    text-decoration: none;
}

.campus-news-table .campus-title-cell a:hover {
    text-decoration: underline;
}
</style>

<script>
// ======================================================================
// [code-intent] 학생 대시보드 우측 학사 캘린더(FullCalendar) + 하단 리스트 동기화
// [data-flow] /api/schedule/events → FullCalendar events → 날짜 선택/뷰 변경 → 리스트 렌더
// [params] FullCalendar info(startStr/endStr), fetch 응답 일정 JSON, DOM 요소 참조
// [I/O] 입력: 기간, 일정 타입/메모 / 출력: 캘린더 셀, 선택일 이벤트 리스트, (툴팁 HTML)
// [error/role] fetch 실패 시 failureCallback + 콘솔 로그, UI는 최소한 "빈 상태 + 로딩 종료" 유지
// [security] credentials: 'include' 로 세션 쿠키 사용, 민감 데이터 필터링은 서버 단 책임 가정
// [maintenance] 일정 type 추가 시 buildTitle/mapTypeLabel/buildDetailHtml/buildTooltipHtml 함께 수정
// [rationale] selectedDateStr 로 캘린더/리스트를 하나의 "관점"으로 묶어 학생이 헤매지 않게 함
// ======================================================================
document.addEventListener("DOMContentLoaded", function () {
    var calendarEl = document.getElementById("calendar");
    var loadingEl = document.getElementById("calendar-loading");
    var tooltipEl = document.getElementById("event-tooltip");
    var eventListEl = document.getElementById("calendar-event-list");

    // [state] 기간별 이벤트 캐시, 타입별 표시 여부, 선택 날짜, dayCell 높이 동기화 플래그
    var eventCache = {};
    var typeVisibility = {};
    var sticky = false;
    var stickyEventId = null;
    var syncQueued = false;

    // 로딩 스피너 on/off (서버 round-trip 체감 줄이기용)
    function setLoading(visible) {
        if (!loadingEl) return;
        loadingEl.classList.toggle("visible", !!visible);
    }

    // 선택된 날짜 문자열(YYYY-MM-DD) 상태
    var selectedDateStr = null;

    function setSelectedDate(dateStr) {
        selectedDateStr = dateStr;
        highlightSelectedDate();
        renderEventList(dateStr);
    }

    var calendar = new FullCalendar.Calendar(calendarEl, {
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

        // 일정이 많을 때 "+more" 버튼으로 축약
        dayMaxEvents: true,
        dayMaxEventRows: true,

        eventTimeFormat: {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false
        },

        // 캘린더 셀 안에 표시되는 이벤트 HTML 커스터마이징
        // (필요한 정보만 압축해서 보여주는 작은 레이블 역할)
        eventContent: function (arg) {
            var e = arg.event;
            var html = "";

            if (!e.allDay && e.start) {
                html += "<span class='fc-time'>" +
                    formatAmPm24Time(e.start) + "</span> ";
            }
            html += "<span class='fc-title'>" +
                escapeHtml(e.title || "") + "</span>";

            return { html: html };
        },

        // 시간축 레이블(주/일 뷰에서 사용) - 24시간 + 오전/오후 텍스트
        slotLabelContent: function (arg) {
            return formatAmPm24Time(arg.date);
        },

        // FullCalendar 이벤트 소스 (뷰가 바뀔 때마다 호출)
        // - 기간 단위로 캐시해 서버 호출 최소화
        events: function (info, successCallback, failureCallback) {
            var startDate = info.startStr.substring(0, 10);
            var endDate = info.endStr.substring(0, 10);
            var cacheKey = startDate + "|" + endDate;

            if (eventCache[cacheKey]) {
                successCallback(eventCache[cacheKey].map(applyTypeToEventDisplay));
                queueSyncDayCellHeights();
                return;
            }

            var url = "/api/schedule/events"
                + "?start=" + encodeURIComponent(startDate)
                + "&end=" + encodeURIComponent(endDate);

            setLoading(true);

            fetch(url, { method: "GET", credentials: "include" })
                .then(function (response) {
                    if (!response.ok) {
                        // HTTP 레벨 에러 → FullCalendar failureCallback + 콘솔 로그
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

                    // 서버 이벤트 모델 → FullCalendar 이벤트로 매핑
                    var events = data.map(function (e) {
                        var type = e.type || "";
                        if (!(type in typeVisibility)) {
                            // 처음 보는 타입은 기본 ON
                            typeVisibility[type] = true;
                        }

                        var baseTitle = e.title || "";
                        var title = buildTitle(type, baseTitle);

                        var fcEvent = {
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

        // 뷰가 바뀔 때마다 dayCell 높이 재계산
        datesSet: function () { queueSyncDayCellHeights(); },
        eventDidMount: function () { queueSyncDayCellHeights(); },

        // 날짜 클릭 → 선택일 변경 + 리스트 리렌더링
        dateClick: function (info) {
            setSelectedDate(info.dateStr);
        },

        // 이벤트 세트가 바뀌었을 때: 최초 진입 시 오늘 날짜를 기본 선택
        eventsSet: function () {
            if (!selectedDateStr) {
                var today = calendar.getDate();
                selectedDateStr = today.toISOString().slice(0, 10);
            }
            highlightSelectedDate();
            renderEventList(selectedDateStr);
        },

        // 이벤트 클릭 시 해당 날짜 기준으로 리스트 하이라이트 (툴팁 대신 리스트 중심 UX)
        eventClick: function (info) {
            var dateStr = info.event.startStr.slice(0, 10);
            setSelectedDate(dateStr);
        }
    });

    calendar.render();

    window.addEventListener("resize", queueSyncDayCellHeights);

    // 캘린더 상단 범례 클릭 시 타입별 온/오프 토글
    document.querySelectorAll(".legend-item[data-type]").forEach(function (item) {
        var type = item.getAttribute("data-type");
        if (!(type in typeVisibility)) {
            typeVisibility[type] = true;
        }

        item.addEventListener("click", function () {
            var enabled = typeVisibility[type] !== false;
            var next = !enabled;
            typeVisibility[type] = next;
            item.classList.toggle("disabled", !next);
            applyTypeFilterToRenderedEvents();
            queueSyncDayCellHeights();
        });
    });

    // dayCell height 동기화 예약 (rAF 로 1프레임 뒤에 실행)
    function queueSyncDayCellHeights() {
        if (syncQueued) return;
        syncQueued = true;
        requestAnimationFrame(function () {
            syncQueued = false;
            syncDayCellHeights();
            killCalendarScroll();
        });
    }

    // FullCalendar 내부 스크롤 제거 (카드 높이 안에서만 레이아웃)
    function killCalendarScroll() {
        var scrollers = calendarEl.querySelectorAll(".fc-scroller");
        scrollers.forEach(function (el) {
            el.style.overflow = "visible";
        });
    }

    // dayGrid 셀 높이를 같은 행 기준으로 최대값에 맞춰 통일
    // (책장에 꽂힌 책 높이를 맞춰 한 줄로 정리하는 느낌)
    function syncDayCellHeights() {
        var view = calendar.view;
        if (!view || view.type.indexOf("dayGrid") !== 0) return;

        var frames = calendarEl.querySelectorAll(".fc-daygrid-day-frame");
        if (!frames.length) return;

        frames.forEach(function (f) { f.style.height = "auto"; });

        var max = 0;
        frames.forEach(function (f) {
            if (f.offsetHeight > max) max = f.offsetHeight;
        });
        if (!max) return;

        frames.forEach(function (f) { f.style.height = max + "px"; });
    }

    // 타입별 표시 여부를 반영해 display 설정
    function applyTypeToEventDisplay(evt) {
        var t = evt.extendedProps && evt.extendedProps.type;

        if (t === "LECTURE") {
            // 강의 시간표 이벤트는 미니 학사 캘린더에서는 숨김
            evt.display = "none";
        } else if (!t || typeVisibility[t] !== false) {
            evt.display = "auto";
        } else {
            evt.display = "none";
        }
        return evt;
    }

    // 현재 렌더된 이벤트에 타입 필터 재적용 (legend 토글 시 사용)
    function applyTypeFilterToRenderedEvents() {
        calendar.getEvents().forEach(function (e) {
            var t = e.extendedProps && e.extendedProps.type;

            if (t === "LECTURE") {
                e.setProp("display", "none");
            } else if (!t || typeVisibility[t] !== false) {
                e.setProp("display", "auto");
            } else {
                e.setProp("display", "none");
            }
        });
    }

    // 타입별 제목 prefix 부여 (예: [과제], [상담] 등)
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

    // 타입 → 한국어 라벨 매핑
    function mapTypeLabel(type) {
        switch (type) {
            case "LECTURE":      return "강의";
            case "TASK":         return "과제";
            case "PROJECT":      return "팀프로젝트";
            case "COUNSEL":      return "상담";
            case "COUNSEL_SLOT": return "상담가능";
            case "ENROLL_REQ":   return "수강신청";
            case "ADMIN_CERT":   return "행정(증명서)";
            case "ADMIN_STATUS": return "행정(학적)";
            case "ADMIN_GRAD":   return "행정(졸업)";
            case "ADMIN_REGIST": return "행정(등록)";
            case "SYSTEM":       return "학사공지";
            case "HOLIDAY":      return "공휴일";
            default:             return type || "-";
        }
    }

    // "키 : 값 | 키2 : 값2" 형식의 memo 문자열을 파싱해서 key-value 쌍 배열로 변경
    // (줄글로 적힌 성적표를 표 형태의 데이터로 옮겨 적는 느낌)
    function parseLabeledPairs(memo) {
        if (!memo || typeof memo !== "string") return [];
        return memo.split("|").map(function (part) {
            var s = part.trim();
            if (!s) return null;

            var key, value;
            var idx = s.indexOf(" : ");
            if (idx >= 0) {
                key = s.substring(0, idx).trim();
                value = s.substring(idx + 3).trim();
            } else {
                var idxEq = s.indexOf("=");
                if (idxEq === -1) return null;
                key = s.substring(0, idxEq).trim();
                value = s.substring(idxEq + 1).trim();
            }
            if (!key || !value) return null;
            return { key: key, value: value };
        }).filter(Boolean);
    }

    // [{key, value}] → {key: value} 맵 변환
    function pairsToMap(pairs) {
        var map = {};
        pairs.forEach(function (kv) { map[kv.key] = kv.value; });
        return map;
    }

    // 상세 정보 HTML 구성 (모달/툴팁용, 현재는 내부에서만 사용)
    function buildDetailHtml(e) {
        var p = e.extendedProps || {};
        var type = p.type || "";
        var memo = p.memo || "";
        var pairs = parseLabeledPairs(memo);
        var map = pairsToMap(pairs);
        var html = "";

        if (type === "COUNSEL_SLOT") {
            var title = p.displayTitle || p.rawTitle || e.title || "";
            html += "<h4>" + escapeHtml(title) + "</h4>";
            if (map["교수명"])      html += row("교수명", map["교수명"]);
            if (map["교수사무실"])  html += row("교수사무실", map["교수사무실"]);
            var phone = map["전화번호"] || map["연락처"];
            if (phone)              html += row("전화번호", phone);
            if (map["구분"])        html += row("구분", map["구분"]);
            html += row("기간", formatRange(e.start, e.end, e.allDay, type));
            return html;
        }

        if (type === "TASK") {
            var tTitle = map["제목"] || p.rawTitle || e.title || "";
            html += "<h4>" + escapeHtml(tTitle) + "</h4>";
            if (map["과목"]) html += row("과목", map["과목"]);
            if (map["구분"]) html += row("구분", map["구분"]);
            html += row("기간", formatRange(e.start, e.end, e.allDay, type));
            if (map["마감일"]) html += row("마감일", map["마감일"]);
            return html;
        }

        if (type === "COUNSEL") {
            var cTitle = p.displayTitle || p.rawTitle || e.title || "";
            html += "<h4>" + escapeHtml(cTitle) + "</h4>";

            if (map["성명"] || map["학번"]) {
                if (map["성명"])  html += row("학생", map["성명"]);
                if (map["학번"])  html += row("학번", map["학번"]);
                if (map["전공"])  html += row("전공", map["전공"]);
                var cTel = map["전화번호"] || map["연락처"];
                if (cTel)        html += row("전화번호", cTel);
                if (map["상태"]) html += row("상태", map["상태"]);
            } else if (map["교수명"] || map["교수번호"]) {
                if (map["교수명"])    html += row("교수명", map["교수명"]);
                if (map["교수번호"])  html += row("교수번호", map["교수번호"]);
                if (map["상태"])      html += row("상태", map["상태"]);
            } else if (memo) {
                html += row("메모", memo);
            }

            html += row("기간", formatRange(e.start, e.end, e.allDay, type));
            return html;
        }

        var gTitle = p.displayTitle || p.rawTitle || e.title || "";
        html += "<h4>" + escapeHtml(gTitle) + "</h4>";
        html += row("유형", mapTypeLabel(type));
        html += row("기간", formatRange(e.start, e.end, e.allDay, type));
        if (p.place) html += row("장소", p.place);

        if (pairs.length > 0) {
            pairs.forEach(function (kv) { html += row(kv.key, kv.value); });
        } else if (memo) {
            html += row("메모", memo);
        }

        return html;
    }

    // 툴팁용 HTML 구성 (현재는 표시용 로직만, 호출 지점은 추후 확장 가능)
    function buildTooltipHtml(event) {
        var p = event.extendedProps || {};
        var type = p.type || "";
        var memo = p.memo || "";
        var pairs = parseLabeledPairs(memo);
        var map = pairsToMap(pairs);
        var html = "";

        if (type === "COUNSEL_SLOT") {
            var title = p.displayTitle || p.rawTitle || event.title || "";
            html += "<div>" + escapeHtml(title) + "</div>";
            if (map["교수명"])      html += row("교수명", map["교수명"]);
            if (map["교수사무실"])  html += row("교수사무실", map["교수사무실"]);
            var phone = map["전화번호"] || map["연락처"];
            if (phone)              html += row("전화번호", phone);
            if (map["구분"])        html += row("구분", map["구분"]);
            html += row("기간", formatRange(event.start, event.end, event.allDay, type));
            return html;
        }

        if (type === "TASK") {
            var tTitle = map["제목"] || p.rawTitle || event.title || "";
            html += "<div>" + escapeHtml(tTitle) + "</div>";
            if (map["과목"]) html += row("과목", map["과목"]);
            if (map["구분"]) html += row("구분", map["구분"]);
            html += row("기간", formatRange(event.start, event.end, event.allDay, type));
            if (map["마감일"]) html += row("마감일", map["마감일"]);
            return html;
        }

        if (type === "COUNSEL") {
            var cTitle = p.displayTitle || p.rawTitle || event.title || "";
            html += "<div>" + escapeHtml(cTitle) + "</div>";
            if (map["성명"] || map["학번"]) {
                if (map["성명"])  html += row("학생", map["성명"]);
                if (map["학번"])  html += row("학번", map["학번"]);
                if (map["전공"])  html += row("전공", map["전공"]);
                var cTel = map["전화번호"] || map["연락처"];
                if (cTel)        html += row("전화번호", cTel);
                if (map["상태"]) html += row("상태", map["상태"]);
            } else if (map["교수명"] || map["교수번호"]) {
                if (map["교수명"])    html += row("교수명", map["교수명"]);
                if (map["교수번호"])  html += row("교수번호", map["교수번호"]);
                if (map["상태"])      html += row("상태", map["상태"]);
            } else if (memo) {
                html += row("메모", memo);
            }
            html += row("기간", formatRange(event.start, event.end, event.allDay, type));
            return html;
        }

        html += "<div class='label'>" +
            escapeHtml(mapTypeLabel(type)) + "</div>";
        html += "<div>" +
            escapeHtml(p.displayTitle || p.rawTitle || event.title || "") + "</div>";
        html += row("기간", formatRange(event.start, event.end, event.allDay, type));

        if (pairs.length > 0) {
            pairs.forEach(function (kv) { html += row(kv.key, kv.value); });
        } else if (memo) {
            html += row("메모", memo);
        }
        if (p.place) html += row("장소", p.place);

        return html;
    }

    // 툴팁 위치 업데이트 (sticky 모드 아닐 때만 마우스 위치 기준)
    function updateTooltipPosition(ev) {
        if (!ev || !tooltipEl || tooltipEl.style.display === "none") return;
        if (sticky) return;

        var offset = 14;
        var x = ev.clientX + offset;
        var y = ev.clientY + offset;

        var rect = tooltipEl.getBoundingClientRect();
        var vw = window.innerWidth;
        var vh = window.innerHeight;

        if (x + rect.width > vw - 10) {
            x = ev.clientX - rect.width - offset;
        }
        if (y + rect.height > vh - 10) {
            y = ev.clientY - rect.height - offset;
        }

        tooltipEl.style.left = x + "px";
        tooltipEl.style.top = y + "px";
    }

    // label/value 한 줄 HTML (툴팁/상세 공용)
    function row(label, value) {
        if (value === undefined || value === null || value === "") return "";
        return "<div><span class='label'>" +
            escapeHtml(label) + " : </span>" +
            escapeHtml(value) + "</div>";
    }

    // 기간 포맷터: allDay 여부에 따라 날짜/시간 조합
    function formatRange(start, end, allDay, type) {
        if (!start) return "-";
        var s = toDate(start);
        var e = end ? toDate(end) : null;

        if (allDay) {
            if (!e) return formatDate(s);
            var eAdj = new Date(e.getTime() - 24 * 60 * 60 * 1000);
            if (sameDate(s, eAdj)) return formatDate(s);
            return formatDate(s) + " ~ " + formatDate(eAdj);
        }

        var sLabel = formatAmPm24Time(s);
        if (!e) return sLabel;

        var eLabel = formatAmPm24Time(e);
        if (sameDate(s, e)) {
            return sLabel + " ~ " + eLabel;
        }

        return formatDate(s) + " " + sLabel + " ~ " +
            formatDate(e) + " " + eLabel;
    }

    // 선택 날짜 배경/라벨 하이라이트
    function highlightSelectedDate() {
        if (!selectedDateStr) return;

        var dayCells = calendarEl.querySelectorAll(".fc-daygrid-day");
        dayCells.forEach(function (cell) {
            var cellDate = cell.getAttribute("data-date");
            if (!cellDate) return;

            if (cellDate === selectedDateStr) {
                cell.classList.add("fc-day-selected");
            } else {
                cell.classList.remove("fc-day-selected");
            }
        });
    }

    function formatDate(d) {
        return d.getFullYear() + "-" +
            pad2(d.getMonth() + 1) + "-" +
            pad2(d.getDate());
    }

    // "오전/오후 HH:MM" 형식으로 24시간 시각 표현
    function formatAmPm24Time(v) {
        var d = toDate(v);
        var h = d.getHours();
        var m = d.getMinutes();
        var ampm = (h < 12) ? "오전" : "오후";
        return ampm + " " + pad2(h) + ":" + pad2(m);
    }

    function sameDate(a, b) {
        return a.getFullYear() === b.getFullYear() &&
            a.getMonth() === b.getMonth() &&
            a.getDate() === b.getDate();
    }

    function pad2(n) {
        return (n < 10 ? "0" : "") + n;
    }

    function toDate(v) {
        return (v instanceof Date) ? v : new Date(v);
    }

    // XSS 방지용 HTML escape (제목/메모/라벨 전부 공통 사용)
    function escapeHtml(str) {
        if (str === null || str === undefined) return "";
        return String(str)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    // 선택된 날짜 기준으로 하단 리스트 렌더링
    // (캘린더 셀은 개략, 리스트는 자세한 메모/타입 중심 정보패널)
    function renderEventList(dateStr) {
        if (!eventListEl) return;
        selectedDateStr = dateStr;

        var events = calendar.getEvents().filter(function (ev) {
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

        var rowsHtml = events.map(function (ev) {
            var allDay = ev.allDay;
            var start = ev.start;
            var timeLabel = "종일";

            if (!allDay && start instanceof Date) {
                var h = String(start.getHours()).padStart(2, "0");
                var m = String(start.getMinutes()).padStart(2, "0");
                timeLabel = h + ":" + m;
            }

            var title = escapeHtml(ev.title || "");
            var type = (ev.extendedProps && ev.extendedProps.type) ? ev.extendedProps.type : "";
            var memo = (ev.extendedProps && ev.extendedProps.memo) ? ev.extendedProps.memo : "";

            // memo 에서 "요청일" 항목만 필터링해서 리스트를 가볍게 유지
            var memoPairs = parseLabeledPairs(memo);
            if (memoPairs.length > 0) {
                memoPairs = memoPairs.filter(function (kv) {
                    return kv.key !== "요청일";
                });
                memo = memoPairs.map(function (kv) {
                    return kv.key + " : " + kv.value;
                }).join(" | ");
            }

            var typeClass = type ? (" type-" + type) : "";

            return (
                "<div class='calendar-event-list-item" + typeClass + "'>" +
                "<div class='type-strip'></div>" +
                "<div class='calendar-event-list-item-body'>" +
                "<div class='d-flex align-items-center'>" +
                "<span class='calendar-event-time'>" + timeLabel + "</span>" +
                "<span class='calendar-event-title'>" + title + "</span>" +
                "</div>" +
                (memo
                    ? "<div class='calendar-event-meta'>" +
                    escapeHtml(memo) +
                    "</div>"
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
});
</script>

<script>
// ======================================================================
// [code-intent] 좌측 "캠퍼스 소식" 탭 영역 (공지/뉴스/학사일정)
// [data-flow]
//   - 탭 버튼 클릭 → data-type 기반으로 endpoint + 탭 종류 선택
//   - fetch(endpoint) → JSON 목록 → renderItems(items, tabType) 테이블 렌더
// [정책]
//   - 공지사항 / 대덕 뉴스: 제목 클릭 시 /bbs/detail?bbscttNo=... 로 이동
//   - 학사일정: 상세 페이지 없음 → 제목은 텍스트, 조회수 컬럼/데이터 제거
// [I/O] 입력: REST 응답(게시글/일정 목록) / 출력: 제목/작성자/등록일/(조회수) 테이블
// [error/role] HTTP 에러 시 콘솔 로그 + 사용자에게 에러 메시지 텍스트 표시
// [security] read-only GET, HTML escape 로 XSS 예방
// [maintenance]
//   - API 필드명(bbscttSj, bbscttWritngDe, bbscttNo 등) 변경 시 renderItems 내 매핑만 수정
//   - 탭 종류 추가 시 data-type 값과 renderItems 의 분기 로직만 확장
// ======================================================================
document.addEventListener("DOMContentLoaded", function () {
    const ctx = "${pageContext.request.contextPath}";
    const tabButtons = document.querySelectorAll(".campus-news-tab");
    const listContainer = document.getElementById("campus-news-list");

    if (!tabButtons.length || !listContainer) return;

    // 탭 클릭 핸들러: active 클래스 토글 + endpoint/type 전달
    tabButtons.forEach(function (btn) {
        btn.addEventListener("click", function () {
            tabButtons.forEach(function (b) {
                b.classList.remove("active");
            });
            this.classList.add("active");

            const endpoint = this.dataset.endpoint;
            const tabType = this.dataset.type || "notice"; // notice | news | academic
            loadCampusList(endpoint, tabType);
        });
    });

    // 첫 번째 탭을 초기 로딩 대상으로 사용
    const firstEndpoint = tabButtons[0].dataset.endpoint;
    const firstType = tabButtons[0].dataset.type || "notice";
    if (firstEndpoint) {
        loadCampusList(firstEndpoint, firstType);
    }

    // 서버에서 캠퍼스 소식 목록 로딩
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

    // 게시글/일정 리스트 → 테이블 HTML 렌더링
    // - tabType 에 따라 컬럼 구조와 제목 링크 여부 제어
    //   * notice/news: 제목 → /bbs/detail?bbscttNo=... 링크, 조회수 컬럼 표시
    //   * academic: 제목 → 텍스트, 조회수 컬럼 제거
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

            // 학사일정이 아닌 경우에만 조회수 사용
            let hit = "";
            if (!isAcademic && typeof item.bbscttRdcnt === "number") {
                hit = String(item.bbscttRdcnt);
            }

            // 날짜 필드는 여러 포맷(String/Number/Date) 가능성을 허용
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
                    const y = d.getFullYear();
                    const m = String(d.getMonth() + 1).padStart(2, "0");
                    const dd = String(d.getDate()).padStart(2, "0");
                    dateStr = y + "-" + m + "-" + dd;
                }
            } else if (rawDate instanceof Date) {
                const d = rawDate;
                const y = d.getFullYear();
                const m = String(d.getMonth() + 1).padStart(2, "0");
                const dd = String(d.getDate()).padStart(2, "0");
                dateStr = y + "-" + m + "-" + dd;
            }

            const date = escapeHtml(dateStr);

            // 공지/뉴스: 제목에 상세 페이지 링크 부여
            // 학사일정: 링크 없음, 순수 텍스트 유지
            let titleCellHtml = titleText;
            if (!isAcademic) {
                // bbscttNo 기준으로 상세 페이지 이동
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

            // 학사일정은 조회수 컬럼 제거
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

            // 공지사항/뉴스: 조회수 포함
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

        // 테이블 헤더: 학사일정은 조회수 헤더 제거
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

    // 스코프 전용 escapeHtml (캘린더 쪽과 동일 목적, 별도 클로저)
    function escapeHtml(str) {
        return String(str || "")
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }
});
</script>