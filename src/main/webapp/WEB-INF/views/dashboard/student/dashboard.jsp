<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../../header.jsp"%>

<!-- 전역 스케줄러 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/schedule.css" />

<!-- FullCalendar 정적 리소스 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/js/fullcalendar/main.min.css" />
<script
	src="/assets/libs/fullcalendar/index.global.min.js"></script>
<!-- 수강중인 리스트 -->
<div class="row pt-3 px-5">
	<div class="col-xxl-12 col-12">
		<div class="row row-cols-xxl-4 row-cols-lg-2 row-cols-1">
			<c:forEach items="${lectureList}" var="lecture">
				<div class="col">
					<div id="lecCard" class="card card-body rounded-3 shadow-sm"
						data-lec-no="${lecture.estbllctreCode}">
						<h4 class="card-title" data-key="${lecture.lctreNm}">${lecture.lctreNm}</h4>
						<p class="card-subtitle" data-key="${lecture.lctrum}">${lecture.lctrum}</p>
						<p class="card-subtitle" data-key="${lecture.sklstfNm}">${lecture.sklstfNm}</p>
					</div>
				</div>
			</c:forEach>

		</div>
	</div>
</div>
<!-- ================================================================== -->
<!--  학사 일정 요약 + 시간표 + 공휴일 카드  -->
<!-- ================================================================== -->
<div class="row px-5 pb-5 g-3">
	<!-- ============================= -->
	<!-- 좌측: 학적 이행 시각화 + 캠퍼스 소식   -->
	<!-- ============================= -->
	<div class="col-xxl-6 col-lg-6 dashboard-main-col">
		<table class="table table-bordered align-middle text-center mb-3">
			<thead class="table-light">
				<tr>
					<th>항목</th>
					<th>진행률</th>
					<th>상태</th>
				</tr>
			</thead>
			<tbody>
				<!-- 현시점 하드코딩-251128, 쿼리 찾아서 주입예정 -->
				<!-- 총 이수학점 -->
				<tr>
					<td>총 이수학점</td>
					<td>
						<div class="progress progress-compact" aria-label="총 이수학점 진행률">
							<div class="progress-bar bg-danger" role="progressbar"
								style="width:${empty totalCreditRate ? 0 : totalCreditRate}%;"
								aria-valuenow="${empty totalCreditRate ? 0 : totalCreditRate}"
								aria-valuemin="0" aria-valuemax="100">
								${totalCompletedCredits}/${totalRequiredCredits} 학점</div>
						</div>
					</td>
					<td><span class="text-danger fw-semibold">미충족</span></td>
				</tr>

				<!-- 전공필수 -->
				<tr>
					<td>전공필수 이수학점</td>
					<td>
						<div class="progress progress-compact" aria-label="전공필수 이수학점 진행률">
							<div class="progress-bar bg-primary" role="progressbar"
								style="width:${empty majorRequiredRate ? 0 : majorRequiredRate}%;"
								aria-valuenow="${empty majorRequiredRate ? 0 : majorRequiredRate}"
								aria-valuemin="0" aria-valuemax="100">
								${majorCompletedCredits}/${majorRequiredCredits} 학점</div>
						</div>
					</td>
					<td><span class="text-primary fw-semibold">충족</span></td>
				</tr>

				<!-- 교양필수 -->
				<tr>
					<td>교양필수 이수학점</td>
					<td>
						<div class="progress progress-compact" aria-label="교양필수 이수학점 진행률">
							<div class="progress-bar bg-primary" role="progressbar"
								style="width:${empty liberalRequiredRate ? 0 : liberalRequiredRate}%;"
								aria-valuenow="${empty liberalRequiredRate ? 0 : liberalRequiredRate}"
								aria-valuemin="0" aria-valuemax="100">
								${liberalCompletedCredits}/${liberalRequiredCredits} 학점</div>
						</div>
					</td>
					<td><span class="text-primary fw-semibold">충족</span></td>
				</tr>

				<!-- 외국어 -->
				<tr>
					<td>외국어 이수</td>
					<td>
						<div class="progress progress-compact" aria-label="외국어 이수 진행률">
							<div class="progress-bar bg-danger" role="progressbar"
								style="width:${empty foreignRate ? 0 : foreignRate}%;"
								aria-valuenow="${empty foreignRate ? 0 : foreignRate}"
								aria-valuemin="0" aria-valuemax="100">
								${foreignCompletedSubjects}/${foreignRequiredSubjects} 과목</div>
						</div>
					</td>
					<td><span class="text-danger fw-semibold">미충족</span></td>
				</tr>
			</tbody>
		</table>



		<!-- 캠퍼스 소식 카드 (좌측 하단으로 이동) -->
		<div class="card campus-news-card mt-3">
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

	<!-- ============================= -->
	<!-- 우측: 학사 캘린더 카드       -->
	<!-- ============================= -->
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
/* 스타일 통합 필요 및 처리 예정-251128 */

/* 내부 중첩 카드/컨테이너는 전부 평면화 */
.academic-card .card,
.academic-card .calendar-container,
.academic-card .fc-theme-standard .fc-scrollgrid {
    background: transparent !important;
    box-shadow: none !important;
    border-radius: 0 !important;
    border: 0 !important;
}


/* =========================================================
	   1. 메인 컨테이너: 헤더/푸터와 충돌 없게 뷰포트 기준 높이
	   - header/footer 높이 합계 120px 가정
	   ========================================================= */
#main-container.container-fluid {
	height: auto;
	min-height: calc(100vh - 120px);
	padding-top: 12px;
	padding-bottom: 12px;
}

/* =========================================================
	   2. 좌측 시간표 카드 (학생/교수 공통)
	   ========================================================= */
.timetable-container {
	background-color: #fff;
	border-radius: .75rem;
	box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .09);
	margin-top: 0 !important;
	margin-bottom: 10px !important;
	padding: 0.5rem 1.28rem 0.25rem; /* 좌우는 카드와 정렬 맞춤 */
	overflow: hidden;
	height: 380px !important; /* 기본 높이, JS에서 필요 시 override */
}

/* 시간표 FullCalendar 루트는 컨테이너 높이를 그대로 채움 */
.timetable-container #timetable {
	height: 100%;
}

/* 시간표 타이틀 바 */
.timetable-container .fc-header-toolbar {
	margin: 0 0 2px 0;
	padding: 0;
	border-radius: .75rem;
	min-height: 32px;
	display: flex;
	align-items: center;
	justify-content: center;
}

/* 시간표 타이틀 폰트 */
.timetable-container .fc-toolbar-title {
	font-size: 1rem;
	font-weight: 500;
}

/* 요일 헤더 여백 최소화 */
.timetable-container .fc-col-header-cell {
	padding-top: 0;
	padding-bottom: 0;
}

/* 시간 슬롯(row) 기본 압축 */
#timetable .fc-timegrid-slot {
	height: 1.4rem; /* 기본 ~2.5rem 보다 압축 */
	min-height: 1.4rem;
	line-height: 1.4rem;
}

/* 시간표 좌측 시간축 라벨 */
#timetable .fc-timegrid-slot-label-cushion {
	padding: 0 4px;
	font-size: 0.8rem;
}

/* 시간표 이벤트(강의) 텍스트 */
#timetable .fc-timegrid-event {
	font-size: 0.8rem;
	line-height: 1.2;
}

/* 이벤트 박스 공통 스타일 */
.fc-event {
	position: relative;
	display: block;
	font-size: 10.2px;
	line-height: 1.0;
	border-radius: 3px;
	border: 0.8px solid #3a87ad;
}

/* 수강 강의 카드 영역: 높이 제한 + 스크롤 (사용 시) */
.lecture-cards-row {
	max-height: 260px;
	overflow-y: auto;
	padding-bottom: 0 !important;
}

.card-header
	.fc-toolbar-chunk {
	font-size: 10.2px;
}
/* =========================================================
	   3. 우측: 캠퍼스 소식 / 교무행정 카드 래퍼
	   ========================================================= */

/* 우측 전체 컬럼에 쓸 경우 */
.academic-card {
	background-color: #fff;
	border-radius: .75rem;
	box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .09);
	margin-top: 0 !important;
	margin-bottom: 10px !important;
	padding: 2px 8px 4px;
	height: auto !important;
	max-height: calc(100vh - 120px); /* 좌측 시간표 컬럼과 높이 맞춤 */
	overflow-y: visible !important;
}

/* 상단/하단 카드 바디 공통: 고정 height 제거 */
.card-body_1, .card-body_2 {
	background-color: #fff;
	border-radius: .75rem;
	box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .09);
	margin-top: 0 !important;
	margin-bottom: 4px !important;
	height: auto !important;
	padding-left: 1.28rem;
	padding-right: 1.28rem;
}

/* 대시보드 카드 내부 좌우 패딩 공통 (시간표 포함) */
.timetable-container {
	padding-left: 1.28rem;
	padding-right: 1.28rem;
}

/* 카드 헤더 정렬: 시간표 / 우측 카드만 한정 */
.timetable-container .card-header, .card-body_1 .card-header,
	.card-body_2 .card-header {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 0.75rem;
}

/* 대시보드 카드 제목만 센터 정렬 (헤더/푸터 카드 충돌 방지용 scope) */
.timetable-container .card-title, .card-body_1 .card-title, .card-body_2 .card-title
	{
	padding-top: 3px;
	font-size: 1.3rem;
	text-align: center;
}

/* 캠퍼스 소식 리스트 폰트 */
.academic-card .card-body, .card-body_2 {
	font-size: 0.86rem;
}

/* 우측 리스트 넘버링(01, 02, ...) */
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

/* =========================================================
	   4. 캘린더 공통 (좌측 학사 캘린더)
	   ========================================================= */

/* 캘린더/시간표 공통 카드 래퍼 */
.calendar-containers {
	position: relative;
	margin: -2px auto;
	padding: 2px 12px;
	background-color: #ffffff;
	border-radius: 12px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
	max-height: 360px; /* 한 화면에 들어오도록 제한 */
}

.calendar-container {
	margin: 0;
	padding: 1px;
	background-color: #ffffff;
}

/* 캘린더 범례 여백 */
.calendar-container .legend {
	margin-top: 4px;
}

/* 학사 캘린더 우측 스크롤바 제거 */
.calendar-container .fc-scroller {
	overflow-y: hidden !important; /* 스크롤 동작/표시 둘 다 막기 */
	scrollbar-width: none; /* Firefox */
}

/* Chrome/Edge/WebKit */
.calendar-container .fc-scroller::-webkit-scrollbar {
	display: none;
}

/* 두 캘린더 공통 폰트 사이즈 약간 축소 */
.timetable-container .fc, .calendar-container .fc {
	font-size: 0.78rem;
}

/* FullCalendar 일자 숫자 공통 스타일 */
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

/* 오늘 날짜 하이라이트 재정의 */
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

/* day number 위가 잘려 보이는 현상 방지 */
.fc-daygrid-day-top {
	overflow: visible;
	padding-top: 4px;
}

/* FullCalendar 툴바 여백 최소화 */
.fc .fc-toolbar.fc-header-toolbar {
	margin-bottom: 0.5em;
}

/* 툴바 첫 요소 좌측 여백 미세 조정 */
.fc .fc-toolbar>*>:first-child {
	margin-left: 3px;
}

.fc-button-group {
	margin-left: -3px;
}

/* =========================================================
	   5. 기타 자잘한 조정
	   ========================================================= */

/* (필요 시) 이 페이지 카드 제목만 소형화
	   - header/footer 에 쓰는 다른 .card-title 과 충돌 방지 위해 scope 한정 */
.card-body_1 .card-title, .card-body_2 .card-title {
	font-size: 13px;
	margin: -6px 0 2px 0;
}
/* ================================
   학사일정 캘린더 툴바 정리
   - Month/Week/Day/List 버튼 그룹 숨김
   - Prev/Next/Today 도 숨기고 타이틀만 중앙 배치
   ================================ */

/* 1) Month/Week/Day/List 묶음(fc-button-group) 숨김 */
.academic-card .calendar-container .fc-button-group {
	display: none;
}

/* 2) prev / next / today 들어있는 왼쪽 chunk 숨김 */
.academic-card .calendar-container .fc-header-toolbar .fc-toolbar-chunk:first-child
	{
	display: none;
}

/* 3) 타이틀 chunk만 남았으니 가운데 정렬 */
.academic-card .calendar-container .fc-header-toolbar {
	justify-content: center;
}
/* ============================
	 `  캠퍼스 소식 카드 전용 스타일
	   ============================ */
.campus-news-card {
	background-color: #ffffff;
	border-radius: .9rem;
	box-shadow: 0 .125rem .45rem rgba(15, 23, 42, .12);
	border: 0;
}

/* 이 카드 안에서는 card-body_2의 이중 그림자 제거 */
.campus-news-card .card-body_2 {
	box-shadow: none;
	border-radius: 0 0 .9rem .9rem;
	padding-top: 0;
	padding-bottom: 0.75rem;
}

/* 상단 탭 바를 카드 상단 전체 폭으로 */
.campus-news-card .campus-news-tabs {
	margin: 0;
	border-radius: .9rem .9rem 0 0;
	overflow: hidden;
	background-color: #eef2ff;
	border-bottom: 1px solid #e5e7eb;
}

/* 탭 버튼 – 양쪽 꽉 차게, 이미지 스타일 */
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

/* 표 래퍼 */
.campus-news-table-wrapper {
	padding: 0.75rem 1.25rem 0.75rem;
}

/* 표 스타일 – 이미지처럼 심플한 그리드 */
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
	background-color: #ffffff;
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

/* 제목은 한 줄 말줄임 */
.campus-news-table .campus-title-cell {
	max-width: 0;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

/* 번호/작성자/날짜/조회수 정렬 */
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

.card-title {
	font-size: 14px;
	margin: -8px 0px 2px -8px;
}

.calendar-event-list {
	border-top: 1px solid #e5e7eb;
	padding-top: .5rem;
	font-size: 0.8125rem;
	max-height: 220px;
	overflow-y: auto;
}

.calendar-event-list-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: .25rem;
}

.calendar-event-list-item {
	padding: .1rem 0;
	border-bottom: 1px dashed #e5e7eb;
}

.calendar-event-list-item:last-child {
	border-bottom: none;
}

.calendar-event-time {
	min-width: 40px;
	font-weight: 600;
	margin-right: .5rem;
}

.calendar-event-title {
	font-weight: 500;
}

.calendar-event-meta {
	color: #6b7280;
	font-size: 0.70rem;
	margin-top: 1px;
}

.calendar-container {
	padding: 0.75rem 1.25rem 1rem 1.25rem;
}
/* 리스트 전체 컨테이너 */
.calendar-event-list {
	border-top: 1px solid #e5e7eb;
	margin-top: .5rem;
	padding-top: .25rem;
	font-size: 0.8125rem;
	max-height: 260px;
	overflow-y: auto;
}

/* 한 줄 아이템 */
.calendar-event-list-item {
	display: flex;
	align-items: flex-start;
	padding: .35rem .6rem;
	margin-bottom: .25rem;
	border-radius: .45rem;
	border: 1px solid #e5e7eb;
	background-color: #ffffff;
}

/* 왼쪽 컬러 띠 */
.calendar-event-list-item .type-strip {
	width: 4px;
	border-radius: 999px;
	margin-right: .6rem;
	flex-shrink: 0;
}

/* 내용 영역 */
.calendar-event-list-item-body {
	flex: 1;
}

.calendar-event-time {
	min-width: 42px;
	font-weight: 600;
	margin-right: .4rem;
}

.calendar-event-title {
	font-weight: 500;
}

.calendar-event-meta {
	color: #6b7280;
	font-size: 0.75rem;
	margin-top: 2px;
}

/* 카테고리별 색상 매핑 (legend 색과 맞춰서 조정하면 됨) */
.calendar-event-list-item.type-TASK .type-strip {
	background-color: #22c55e; /* 과제 */
}

.calendar-event-list-item.type-PROJECT .type-strip {
	background-color: #f97316; /* 팀프로젝트 */
}

.calendar-event-list-item.type-COUNSEL .type-strip {
	background-color: #0ea5e9; /* 상담 */
}

.calendar-event-list-item.type-COUNSEL_SLOT .type-strip {
	background-color: #38bdf8; /* 상담가능 */
}

.calendar-event-list-item.type-ENROLL_REQ .type-strip {
	background-color: #6366f1; /* 수강신청 */
}

.calendar-event-list-item.type-ADMIN_REGIST .type-strip {
	background-color: #a855f7; /* 등록/행정 */
}

.calendar-event-list-item.type-HOLIDAY .type-strip {
	background-color: #ef4444; /* 공휴일 */
}
/* 메인/사이드 비율 : 데스크탑 기준 7:3 */
@media ( min-width : 1400px) {
	.dashboard-main-col {
		flex: 0 0 70%;
		max-width: 70%;
	}
	.dashboard-side-col {
		flex: 0 0 30%;
		max-width: 30%;
	}
}
/* 학사 캘린더 카드 내부 비율 고정 */
.academic-card {
	display: flex;
	flex-direction: column;
}

/* 달력 높이: 월 뷰가 납작해지지 않게 고정 */
.academic-card #calendar {
	height: 350px; /* 필요하면 320~360 사이에서 조절 */
}

/* 하단 일정 리스트는 남은 공간만큼 + 스크롤 */
.calendar-event-list {
	border-top: 1px solid #e5e7eb;
	margin-top: .5rem;
	padding-top: .25rem;
	font-size: 0.8125rem;
	max-height: 300px; /* 달력 340 + 리스트 220 ≒ 이미지 비율 */
	overflow-y: auto;
}
/* 헤더 라인 강조 + 배경 */
.campus-news-table thead th {
	padding: 0.6rem 0.4rem;
	font-size: 0.8rem;
	font-weight: 600;
	color: #94a3b8;
	border-bottom: 1px solid #e5e7eb;
	border-top: 1px solid #e5e7eb;
	background-color: #f9fafb;
}

/* 행 hover 효과 */
.campus-news-table tbody tr:hover td {
	background-color: #f3f4ff;
}

/* 테이블 전체 모서리 둥글게 맞추기 */
.campus-news-table-wrapper {
	padding: 0.75rem 1.25rem 0.75rem;
	border-radius: 0 0 .9rem .9rem;
}

.campus-news-table {
	border-radius: .6rem;
	overflow: hidden;
}
/* ===== 학사 캘린더 하단 일정 리스트 폰트/간격 튜닝 ===== */

/* 리스트 컨테이너 전체 폰트 살짝 축소 */
.calendar-event-list {
	font-size: 0.75rem; /* 기존 0.8125rem → 조금 줄임 */
	line-height: 1.35;
}

/* 한 줄 아이템 패딩/간격 압축 */
.calendar-event-list-item {
	padding: .22rem .5rem;
	margin-bottom: .18rem;
}

/* 왼쪽 시간 / 제목 / 메타 각각 폰트 조정 */
.calendar-event-time {
	font-size: 0.75rem;
	min-width: 38px;
	margin-right: .35rem;
}

.calendar-event-title {
	font-size: 0.78rem;
	font-weight: 500;
}

.calendar-event-meta {
	font-size: 0.70rem;
	margin-top: 1px;
}

/* 헤더 뱃지도 살짝 줄이기 */
.calendar-event-list-header .badge {
	font-size: 0.70rem;
	padding: .25rem .55rem;
}

.fc-daygrid-event-harness {
	display: none !important;
}
/* +more 제거 */
.fc .fc-daygrid-day-bottom {
	display: none !important;
}
/* 패딩 조정 */
.px-5 {
	padding-right: 1rem !important;
	padding-left: 1rem !important;
}
/* 카드 바디 자체는 스크롤 제거 */
.academic-card {
	height: auto !important;
	max-height: none !important;
	overflow: visible !important;
}
/* 학적 진행률 바 공통 스타일 */
.progress-compact {
	height: 22px;
}

.progress-compact .progress-bar {
	min-width: 24%;
	font-size: 0.78rem;
}
/* 선택한 날짜 하이라이트 */
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

.calendar-event-list-item.type-TASK, .calendar-event-list-item.type-PROJECT,
	.calendar-event-list-item.type-COUNSEL, .calendar-event-list-item.type-COUNSEL_SLOT,
	.calendar-event-list-item.type-ENROLL_REQ, .calendar-event-list-item.type-ADMIN_REGIST,
	.calendar-event-list-item.type-HOLIDAY {
	border: none !important; /* 기존 카드 테두리 제거 */
	box-shadow: none !important; /* 그림자 제거 (있다면) */
	border-radius: 0; /* 둥근 모서리 제거 */
	padding: 6px 10px; /* 여백은 필요에 따라 조정 */
	border-top: 2px solid #e5e7eb; /* 상단 구분선 */
	padding-bottom: 0.1rem;
}
/* 최상위 카드만 "진짜 카드"로 사용 */
.academic-card {
    background: #fff;
    border-radius: 1rem;
    box-shadow: 0 .5rem 1.5rem rgba(15, 23, 42, .08);
    position: relative;
    overflow: hidden; /* 내부 모서리/레이어 잘라버리기 */
}

</style>

<script>
document.addEventListener("DOMContentLoaded", function () {
    var calendarEl = document.getElementById("calendar");
    var loadingEl = document.getElementById("calendar-loading");
    var tooltipEl = document.getElementById("event-tooltip");
    var eventListEl = document.getElementById("calendar-event-list");


    // [상태] 캐시/필터/툴팁
    var eventCache = {};           // 기간별 응답 캐시
    var typeVisibility = {};       // 타입별 ON/OFF
    var sticky = false;            // 툴팁 고정 여부
    var stickyEventId = null;      // 고정된 이벤트 ID
    var syncQueued = false;        // dayGrid 셀 높이 rAF 중복 방지

    /* 로딩 오버레이 */
    function setLoading(visible) {
        if (!loadingEl) return;
        loadingEl.classList.toggle("visible", !!visible);
    }

    const cards = Array.from(document.querySelectorAll("#lecCard"));
    console.log("chkng cards > ", cards);

    cards.forEach(e => {
        e.addEventListener("click", e => {
            const lecNo = e.currentTarget.dataset.lecNo;
            console.log("chkng lecNo ", lecNo);

            location.href = "/learning/student?lecNo=" + lecNo;
        });
    })

    /* =====================================================================
       FullCalendar 초기화
       - 이 화면: "학사 일정 종합" 용도
       - 월/주/일/리스트 전환 허용
       - LECTURE 타입은 별도 시간표 화면이 있으므로 여기서는 숨김
       - 시간 표기는 전역 정책:
           "오전/오후 + 24시간제"
           예) 오전 09:00, 오후 13:00, 오후 16:00
       ===================================================================== */

       var selectedDateStr = null;   // 현재 리스트가 가리키는 날짜

       function setSelectedDate(dateStr) {
           selectedDateStr = dateStr;
           highlightSelectedDate();
           renderEventList(dateStr);
       }
       var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth",
        locale: "ko",

        // 전체 캘린더 세로 크기 고정
        height: 400,          // 카드 안에서 보이는 총 높이
        contentHeight: 360,   // 그리드(날짜 영역) 높이
        expandRows: true,     // 세로 공간 꽉 채우도록
        
        headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "dayGridMonth,timeGridWeek,timeGridDay,listWeek"
        },

        // 셀 안에서 "+ more"로 접지 말고 그대로 늘어나게 하고 싶으면
        dayMaxEvents: false,
        dayMaxEventRows: true,
        
        // 내부 timeText 포맷: 24시간제
        eventTimeFormat: {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false
        },

        // [이벤트 셀 표시 형식 통일]
        //  - allDay: 제목만
        //  - timed: "오전/오후 HH:MM 제목"
        eventContent: function(arg) {
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

        // [timeGrid 주/일 뷰 좌측 라벨 포맷]
        slotLabelContent: function(arg) {
            return formatAmPm24Time(arg.date);
        },

        /* =================================================================
           이벤트 로딩
           - FullCalendar: [start, end) 전달
           - 백엔드 API: start~end 포함 조회 설계
           - 그대로 전달해도 되도록 서버 단에서 end-1일 처리 또는 BETWEEN < end 구현
           ================================================================= */
        events: function (info, successCallback, failureCallback) {
            var startDate = info.startStr.substring(0, 10);
            var endDate = info.endStr.substring(0, 10);
            var cacheKey = startDate + "|" + endDate;

            // 캐시 히트 시 서버 콜 회피
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
                          typeVisibility[type] = true;
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

        // 뷰 변경 / 이벤트 마운트 시 dayGrid 높이 동기화 예약
        datesSet: function () { queueSyncDayCellHeights(); },
        eventDidMount: function () { queueSyncDayCellHeights(); },

        /* =================================================================
           클릭: 상세 툴팁 고정 모드
           - hover 정보 + 닫기 버튼
           ================================================================= */
        eventClick: function (info) {
            var e = info.event;
            var html = buildDetailHtml(e);
            html = "<div class='event-tooltip-close' id='event-tooltip-close'>✕</div>" + html;

            tooltipEl.innerHTML = html;
            tooltipEl.style.display = "block";
            tooltipEl.classList.add("sticky");

            var rect = info.el.getBoundingClientRect();
            var scrollX = window.scrollX || document.documentElement.scrollLeft;
            var scrollY = window.scrollY || document.documentElement.scrollTop;

            var left = rect.right + 8 + scrollX;
            var top = rect.top + scrollY;
            var tooltipRect = tooltipEl.getBoundingClientRect();

            // 화면 밖으로 밀리지 않도록 보정
            if (left + tooltipRect.width > scrollX + window.innerWidth - 10) {
                left = rect.left + scrollX - tooltipRect.width - 8;
            }
            if (top + tooltipRect.height > scrollY + window.innerHeight - 10) {
                top = scrollY + window.innerHeight - tooltipRect.height - 10;
            }

            tooltipEl.style.left = left + "px";
            tooltipEl.style.top = top + "px";

            sticky = true;
            stickyEventId = e.id;

            var closeBtn = document.getElementById("event-tooltip-close");
            if (closeBtn) {
                closeBtn.onclick = function () {
                    tooltipEl.style.display = "none";
                    tooltipEl.classList.remove("sticky");
                    sticky = false;
                    stickyEventId = null;
                };
            }
        },

        /* =================================================================
           hover: 요약 툴팁
           - sticky 모드일 때는 무시 (사용자 명시 선택 우선)
           ================================================================= */
        eventMouseEnter: function (info) {
            if (sticky) return;
            tooltipEl.innerHTML = buildTooltipHtml(info.event);
            tooltipEl.style.display = "block";
            tooltipEl.classList.remove("sticky");
            updateTooltipPosition(info.jsEvent);
        },
        eventMouseMove: function (info) {
            if (sticky) return;
            updateTooltipPosition(info.jsEvent);
        },
        eventMouseLeave: function () {
            if (sticky) return;
            tooltipEl.style.display = "none";
        },
        
        dateClick: function (info) {
        	 // 날짜 클릭 시 해당 날짜 일정 리스트 + 일자 하이라이트
            setSelectedDate(info.dateStr);
        },

        eventsSet: function () {
            // 이벤트가 처음 로딩된 순간, 기본은 "오늘" 기준으로 리스트 한 번 그림
            if (!selectedDateStr) {
                var today = calendar.getDate();
                selectedDateStr = today.toISOString().slice(0, 10); // yyyy-MM-dd
            }
            highlightSelectedDate();
            renderEventList(selectedDateStr);
        },

        eventClick: function (info) {
            // 이벤트 클릭 시, 그 날 기준으로 리스트 다시 갱신해도 됨(선택)
            var dateStr = info.event.startStr.slice(0, 10);
            setSelectedDate(dateStr);
        }
    });

    calendar.render();

    // 리사이즈 시 dayGrid 높이 재동기화
    window.addEventListener("resize", queueSyncDayCellHeights);

    /* =====================================================================
       범례 클릭: 타입별 토글
       - typeVisibility 갱신 + 렌더된 이벤트 display 반영
       ===================================================================== */
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

    /* =====================================================================
       dayGrid 셀 높이 동기화
       - 한 주 안에서 셀 높이가 달라져 배치 틀어지는 문제 방지
       ===================================================================== */
    function queueSyncDayCellHeights() {
        if (syncQueued) return;
        syncQueued = true;
        requestAnimationFrame(function () {
            syncQueued = false;
            syncDayCellHeights();
            killCalendarScroll(); 
        });
    }
    // FullCalendar 내부 스크롤러(.fc-scroller) 스크롤 제거
    function killCalendarScroll() {
        var scrollers = calendarEl.querySelectorAll(".fc-scroller");
        scrollers.forEach(function (el) {
            el.style.overflow = "visible";   // 기본 hidden scroll 덮어쓰기
        });
    }
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

    /* =====================================================================
       타입 필터링: LECTURE 제외 / legend 기반 on/off
       ===================================================================== */
    function applyTypeToEventDisplay(evt) {
        var t = evt.extendedProps && evt.extendedProps.type;

        if (t === "LECTURE") {
            evt.display = "none";           // 강의는 전용 시간표 화면에서 처리
        } else if (!t || typeVisibility[t] !== false) {
            evt.display = "auto";
        } else {
            evt.display = "none";
        }
        return evt;
    }

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

    /* =====================================================================
       타이틀 prefix: 타입별 시각적 분류
       ===================================================================== */
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

    /* =====================================================================
       메모 파싱 유틸: "키 : 값 | 키=값" 패턴을 구조화
       - 서버 포맷이 제멋대로여도 최소한 읽히게 정규화
       ===================================================================== */
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

    function pairsToMap(pairs) {
        var map = {};
        pairs.forEach(function (kv) { map[kv.key] = kv.value; });
        return map;
    }

    /* =====================================================================
       상세 툴팁 (click)
       - 타입별로 핵심 정보만 재구성
       - 정책: 의미 없는 null/빈값은 렌더하지 않음
       ===================================================================== */
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

        // 기타 타입: 공통 템플릿
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

    /* =====================================================================
       hover 툴팁 (요약)
       - 구조는 click 상세와 동일하되, 정보량을 줄여도 됨
       - 여기서는 동일 row() 사용해서 중복 줄임
       ===================================================================== */
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

    /* =====================================================================
       툴팁 위치 제어
       - hover 모드에서만 마우스 기준 위치 보정
       ===================================================================== */
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

    /* =====================================================================
       공통 출력 유틸
       ===================================================================== */

    // label/value 한 줄. value 없으면 렌더 스킵.
    function row(label, value) {
        if (value === undefined || value === null || value === "") return "";
        return "<div><span class='label'>" +
            escapeHtml(label) + " : </span>" +
            escapeHtml(value) + "</div>";
    }

    // allDay/시간 혼합에 대한 기간 문자열
    function formatRange(start, end, allDay, type) {
        if (!start) return "-";
        var s = toDate(start);
        var e = end ? toDate(end) : null;

        // 종일 일정: FullCalendar end는 다음날 00시 기준, -1일 보정
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

    // YYYY-MM-DD
    function formatDate(d) {
        return d.getFullYear() + "-" +
            pad2(d.getMonth() + 1) + "-" +
            pad2(d.getDate());
    }

    // "오전/오후 HH:MM" (HH는 24시간제)
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

    function escapeHtml(str) {
        if (str === null || str === undefined) return "";
        return String(str)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }
    // YYYY-MM-DD 기준으로 해당 날짜 일정 리스트 렌더
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
        var start  = ev.start;
        var timeLabel = "종일";

        if (!allDay && start instanceof Date) {
            var h = String(start.getHours()).padStart(2, "0");
            var m = String(start.getMinutes()).padStart(2, "0");
            timeLabel = h + ":" + m;
        }

        var title = escapeHtml(ev.title || "");
        var type  = (ev.extendedProps && ev.extendedProps.type) ? ev.extendedProps.type : "";
        var memo  = (ev.extendedProps && ev.extendedProps.memo) ? ev.extendedProps.memo : "";

        // "요청일" 제거
        var memoPairs = parseLabeledPairs(memo);   // 이미 위에 정의된 함수 사용
        if (memoPairs.length > 0) {
            memoPairs = memoPairs.filter(function (kv) {
                return kv.key !== "요청일";        // 요청일 키는 버림
            });
            memo = memoPairs.map(function (kv) {
                return kv.key + " : " + kv.value; // "구분 : ~ | 과목 : ~ | 상태 : ~" 형태로 재조합
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
                    // memo 있을 때만 meta 렌더
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
document.addEventListener("DOMContentLoaded", function () {
    const ctx = "${pageContext.request.contextPath}";
    const tabButtons = document.querySelectorAll(".campus-news-tab");
    const listContainer = document.getElementById("campus-news-list");

    if (!tabButtons.length || !listContainer) return;

    // 탭 클릭 시 공통 처리
    tabButtons.forEach(function (btn) {
        btn.addEventListener("click", function () {
            // active 토글
            tabButtons.forEach(function (b) {
                b.classList.remove("active");
            });
            this.classList.add("active");

            const endpoint = this.dataset.endpoint;
            loadCampusList(endpoint);
        });
    });

    // 최초 진입: 첫 번째 탭 자동 로딩
    const firstEndpoint = tabButtons[0].dataset.endpoint;
    if (firstEndpoint) {
        loadCampusList(firstEndpoint);
    }

    // 실제 비동기 로딩 함수
    function loadCampusList(endpoint) {
        if (!endpoint) return;

        listContainer.innerHTML =
            "<div class='text-muted small py-3'>로딩 중...</div>";

        fetch(endpoint, { method: "GET", credentials: "include" })
            .then(function (res) {
                if (!res.ok) throw new Error("HTTP " + res.status);
                return res.json();
            })
            .then(function (items) {
                listContainer.innerHTML = renderItems(items);
            })
            .catch(function (err) {
                console.error("[CampusNews] load error", err);
                listContainer.innerHTML =
                    "<div class='text-danger small py-3'>데이터를 불러오지 못했습니다.</div>";
            });
    }

    // 리스트 렌더링 (공지/뉴스/학사일정 공통 포맷)
    // IndexBbsVO 구조 + 공통 넘버링 적용
    // 번호+제목+작성자+날짜 텍스트 렌더
    // IndexBbsVO / ScheduleEventVO → 표 형태 (#, 제목, 작성자, 등록일, 조회수)
    function renderItems(items) {
        if (!Array.isArray(items) || items.length === 0) {
            return "<div class='text-muted small py-3'>게시글이 없습니다.</div>";
        }

        const rowsHtml = items.slice(0, 5).map(function (item, idx) {
            const no = idx + 1;

            const title = escapeHtml(
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

            // 조회수: kr.ac.collage_api.index.vo.IndexBbsVO.bbscttRdcnt(Integer)
            let hit = "";
            if (typeof item.bbscttRdcnt === "number") {
                // Integer → 그대로 출력 (0 도 표시)
                hit = String(item.bbscttRdcnt);
            }

            // 날짜
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
                    const y  = d.getFullYear();
                    const m  = String(d.getMonth() + 1).padStart(2, "0");
                    const dd = String(d.getDate()).padStart(2, "0");
                    dateStr = y + "-" + m + "-" + dd;
                }
            } else if (rawDate instanceof Date) {
                const d  = rawDate;
                const y  = d.getFullYear();
                const m  = String(d.getMonth() + 1).padStart(2, "0");
                const dd = String(d.getDate()).padStart(2, "0");
                dateStr = y + "-" + m + "-" + dd;
            }

            const date = escapeHtml(dateStr);

            return (
                "<tr>" +
                    "<td class='col-no'>" + no + "</td>" +
                    "<td class='campus-title-cell'>" + title + "</td>" +
                    "<td class='col-writer'>" + writer + "</td>" +
                    "<td class='col-date'>" + date + "</td>" +
                    "<td class='col-hit'>" + hit + "</td>" +
                "</tr>"
            );
        }).join("");

        return (
            "<div class='campus-news-table-wrapper'>" +
                "<table class='table campus-news-table mb-0'>" +
                    "<thead>" +
                        "<tr>" +
                            "<th class='col-no'>#</th>" +
                            "<th>제목</th>" +
                            "<th class='col-writer'>작성자</th>" +
                            "<th class='col-date'>등록일</th>" +
                            "<th class='col-hit'>조회수</th>" +
                        "</tr>" +
                    "</thead>" +
                    "<tbody>" + rowsHtml + "</tbody>" +
                "</table>" +
            "</div>"
        );
    }
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
