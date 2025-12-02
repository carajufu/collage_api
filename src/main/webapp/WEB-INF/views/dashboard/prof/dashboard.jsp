<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../../header.jsp"%>

<!-- 전역 스케줄러 CSS -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/schedule.css" />

<!-- FullCalendar 정적 리소스 -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/js/fullcalendar/main.min.css" />
<script src="/assets/libs/fullcalendar/index.global.min.js"></script>

<!-- ================================================================== -->
<!--  수강 강의 카드 영역, 작업하다 어느 순간ㅂ포스터 형태로 변형되서 주석 처리 -->
<!-- ================================================================== -->
<%-- <div class="row p-5">
    <div class="col-12">
        <div class="row row-cols-xxl-4 row-cols-lg-2 row-cols-1">
           <c:forEach items="${lectureList}" var="lecture">
                <div class="col">
                    <div class="card card-body rounded-3 shadow-sm"
                         data-lec-no="${lecture.estbllctreCode}">
                        <h4 class="card-title">${lecture.lctreNm}</h4>
                        <p class="card-subtitle">${lecture.lctrum}</p>
                        <p class="card-subtitle">${lecture.sklstfNm}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div> --%>

<!-- ================================================================== -->
<!--  학사 일정 요약 + 시간표 + 공휴일 카드  -->
<!-- ================================================================== -->
<div class="row px-5 pb-5">
	<!-- 좌측: 시간표 + 공휴일 -->
	<div class="col-xxl-7 col-lg-7">
	    <!-- 시간표 카드 -->
	    <div class="timetable-container" >
		    <div id="timetable"></div>
		</div>		    
	           <!-- 학사 일정 미니 캘린더 + 범례 -->
	           <div class="row">
	               <div class="col-12">
	                   <div class="calendar-container">
	                       <div class="legend">
	                           <div class="legend-item" data-type="TASK">
	                               <div class="legend-color type-TASK"></div><span>과제</span>
	                           </div>
	                           <div class="legend-item" data-type="PROJECT">
	                               <div class="legend-color type-PROJECT"></div><span>팀프로젝트</span>
	                           </div>
	                           <div class="legend-item" data-type="COUNSEL">
	                               <div class="legend-color type-COUNSEL"></div><span>상담</span>
	                           </div>
	                           <div class="legend-item" data-type="COUNSEL_SLOT">
	                               <div class="legend-color type-COUNSEL_SLOT"></div><span>상담가능</span>
	                           </div>
	                           <div class="legend-item" data-type="ENROLL_REQ">
	                               <div class="legend-color type-ENROLL_REQ"></div><span>수강신청</span>
	                           </div>
	                           <div class="legend-item" data-type="ADMIN_REGIST">
	                               <div class="legend-color type-ADMIN_REGIST"></div><span>등록/행정</span>
	                           </div>
	                           <div class="legend-item" data-type="HOLIDAY">
	                               <div class="legend-color type-HOLIDAY"></div><span>공휴일</span>
	                           </div>
	                       </div>
	
	                       <div id="calendar"></div>
	
	                       <div id="calendar-loading" class="calendar-loading">
	                           일정을 불러오는 중...
	                       </div>
	                   </div>
	
	                   <!-- 공용 툴팁 -->
	                   <div id="event-tooltip" class="event-tooltip"></div>
	               </div>
	           </div>
	
	           <!-- 필요 시, 아래에 순수 리스트 형태 공휴일 요약 추가 가능
	                   (현재는 미니 캘린더 중심이라 생략)
	           -->
	       </div>
    
	<!-- 우측: 공지/뉴스/학사일정 탭 -->
	<div class="col-xxl-5 col-lg-5 mb-3 mb-lg-0">
	    <div class="card campus-news-card">
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
				                data-endpoint="${pageContext.request.contextPath}/api/dashboard/notices">
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
				                data-endpoint="${pageContext.request.contextPath}/api/dashboard/news">
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
				                data-endpoint="${pageContext.request.contextPath}/api/dashboard/academic">
				            학사일정
				         </button>
				    </li>
								    
				    <!--교수용 교무/행정 탭 -->
				    <li class="nav-item" role="presentation">
				        <button class="nav-link campus-news-tab"
				                id="campus-news-prof-academic-tab"
				                data-bs-toggle="tab"
				                type="button"
				                role="tab"
				                aria-selected="false"
				                data-type="prof-academic"
				                data-endpoint="${pageContext.request.contextPath}/api/dashboard/prof-academic">
				            교무/행정
				        </button>
				    </li>
				</ul>
	            <!-- Ajax 결과 렌더링 영역 -->
	            <div id="campus-news-list" class="mt-3"></div>
	        </div>
	    </div>
	</div>

<%@ include file="../../footer.jsp"%>

<style>
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
	    height: 280px !important; /* 기본 높이, JS에서 필요 시 override */
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
	    font-weight: 600;
	}
	
	/* 요일 헤더 여백 최소화 */
	.timetable-container .fc-col-header-cell {
	    padding-top: 0;
	    padding-bottom: 0;
	}
	
	/* 시간 슬롯(row) 기본 압축 */
	#timetable .fc-timegrid-slot {
	    height: 1.4rem;              /* 기본 ~2.5rem 보다 압축 */
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
	    overflow-y: auto;
	}
	
	/* 상단/하단 카드 바디 공통: 고정 height 제거 */
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
	
	/* 대시보드 카드 내부 좌우 패딩 공통 (시간표 포함) */
	.timetable-container {
	    padding-left: 1.28rem;
	    padding-right: 1.28rem;
	}
	
	/* 카드 헤더 정렬: 시간표 / 우측 카드만 한정 */
	.timetable-container .card-header,
	.card-body_1 .card-header,
	.card-body_2 .card-header {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    gap: 0.75rem;
	}
	
	/* 대시보드 카드 제목만 센터 정렬 (헤더/푸터 카드 충돌 방지용 scope) */
	.timetable-container .card-title,
	.card-body_1 .card-title,
	.card-body_2 .card-title {
	    padding-top: 3px;
	    font-size: 1.3rem;
	    text-align: center;
	}
	
	/* 캠퍼스 소식 리스트 폰트 */
	.academic-card .card-body,
	.card-body_2 {
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
	    overflow-y: hidden !important;  /* 스크롤 동작/표시 둘 다 막기 */
	    scrollbar-width: none;          /* Firefox */
	}
	
	/* Chrome/Edge/WebKit */
	.calendar-container .fc-scroller::-webkit-scrollbar {
	    display: none;
	}
	
	/* 두 캘린더 공통 폰트 사이즈 약간 축소 */
	.timetable-container .fc,
	.calendar-container .fc {
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
	    font-weight: 650;
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
	    font-weight: 600;
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
	.fc .fc-toolbar > * > :first-child {
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
	.card-body_1 .card-title,
	.card-body_2 .card-title {
	    font-size: 15px;
	    margin: -7px 0 2px 0;
	}
</style>
<script>
// ======================================================================
//  학생 대시보드: 수강 강의 카드 클릭 이동 + 주간 강의 시간표 FullCalendar
// ======================================================================
document.addEventListener("DOMContentLoaded", function () {
    const ctx = "${pageContext.request.contextPath}";

    // --------------------------------------------------------------
    // 1. 수강 강의 카드 클릭 시 학습 대시보드로 이동
    // --------------------------------------------------------------
    const lectureCards = Array.from(
        document.querySelectorAll(".card[data-lec-no]")
    );

    const calendarEl = document.getElementById("timetable-calendar");
    lectureCards.forEach((card) => {
        card.addEventListener("click", (e) => {
            const lecNo = e.currentTarget.dataset.lecNo;
            if (!lecNo) return;

            location.href =
                ctx + "/learning/student?lecNo=" + encodeURIComponent(lecNo);
        });
    });

    // --------------------------------------------------------------
    // 2. FullCalendar 기반 강의 시간표 (헤더 ON, 툴팁 OFF)
    // --------------------------------------------------------------
    const el = document.getElementById("timetable");
    if (!el || !window.FullCalendar) return;

    // 과목별 색상 매핑: 같은 과목은 어디서나 같은 색
    const courseColorMap = {};
    const courseColors = [
        "#1976d2", "#388e3c", "#d32f2f", "#7b1fa2",
        "#f57c00", "#0097a7", "#5d4037", "#c2185b",
        "#512da8", "#00796b", "#303f9f", "#afb42b",
        "#8e24aa", "#ff7043", "#26a69a", "#ffa000"
    ];

    function getCourseColor(key) {
        if (!key) return "#1976d2";
        if (!courseColorMap[key]) {
            const idx = Object.keys(courseColorMap).length % courseColors.length;
            courseColorMap[key] = courseColors[idx];
        }
        return courseColorMap[key];
    }

    const dayNames = ["일", "월", "화", "수", "목", "금", "토"];

    // 주간 범위/스크롤 상태 캐시
    let lastScrollConfig = {
        needScroll: false,
        earliest: null,
        maxDailySpanHours: 0
    };

    const calendar = new FullCalendar.Calendar(el, {
        locale: "ko",
        initialView: "timeGridWeek",
        firstDay: 1,
        weekends: true,
        allDaySlot: false,
        slotMinTime: "08:00:00",
        slotMaxTime: "22:00:00",
        expandRows: true,
        height: "100%",
        handleWindowResize: true,

        headerToolbar: {
            left: "",
            center: "title",
            right: ""
        },

        dayHeaderContent: function (arg) {
            const d = arg.date.getDay();
            return { html: "<span>" + dayNames[d] + "</span>" };
        },

        slotEventOverlap: false,

        slotLabelContent: function (arg) {
            return { html: formatAmPm24(arg.date) };  // 기존 유틸 그대로 사용
        },

        eventTimeFormat: {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false
        },

        // datesSet: 타이틀 갱신만
        datesSet: function () {
            updateHeaderTitle();
        },

        // 이벤트 로딩
        events: function (info, successCallback, failureCallback) {
            const start = info.startStr.substring(0, 10);
            const endExclusive = new Date(info.endStr);
            endExclusive.setDate(endExclusive.getDate() - 1);
            const end = dateToYmd(endExclusive); // 기존 유틸 사용

            const url =
                ctx + "/api/schedule/timetable/lectures"
                + "?start=" + encodeURIComponent(start)
                + "&end=" + encodeURIComponent(end);

            fetch(url, { method: "GET", credentials: "include" })
                .then(function (res) {
                    if (!res.ok) {
                        console.error("[Timetable] load failed", res.status, res.statusText);
                        successCallback([]);
                        return [];
                    }
                    return res.json();
                })
                .then(function (data) {
                    if (!Array.isArray(data)) {
                        console.error("[Timetable] invalid response", data);
                        successCallback([]);
                        return;
                    }

                    const events = data.map(function (e) {
                        const type = e.type || "";
                        const lectureName = e.lectureName || e.title || "";
                        const room = e.room || "";
                        let title = e.title;

                        if (!title) {
                            if (type === "PROF") {
                                const cnt =
                                    (e.studentCount != null && e.maxStudent != null)
                                        ? " [" + e.studentCount + "/" + e.maxStudent + "]"
                                        : "";
                                const rm = room ? " (" + room + ")" : "";
                                title = lectureName + cnt + rm;
                            } else {
                                const prof = e.profName ? " / " + e.profName : "";
                                const rm2 = room ? " (" + room + ")" : "";
                                title = lectureName + prof + rm2;
                            }
                        }

                        const courseKey =
                            e.estblLctreCode ||
                            e.lectureCode ||
                            e.lectureName ||
                            e.id;

                        const color = getCourseColor(courseKey);

                        return {
                            id: e.id,
                            title: title,
                            start: e.startDateTime,
                            end: e.endDateTime,
                            allDay: false,
                            backgroundColor: color,
                            borderColor: color,
                            textColor: "#ffffff",
                            classNames: ["lecture-event"],
                            extendedProps: {
                                type: type,
                                estblLctreCode: e.estblLctreCode,
                                lectureCode: e.lectureCode,
                                lectureName: e.lectureName,
                                room: room,
                                year: e.year,
                                semstr: e.semstr,
                                profName: e.profName,
                                profDeptName: e.profDeptName,
                                studentCount: e.studentCount,
                                maxStudent: e.maxStudent
                            }
                        };
                    });

                    successCallback(events);
                    
                })
                .catch(function (err) {
                    console.error("[Timetable] load error", err);
                    failureCallback(err);
                });
        },

        // 이벤트 셀이 실제로 렌더된 뒤 호출됨
        eventsSet: function (events) {
            compressEmptyDays(this);           // 기존 공강 요일 폭 조절
            updateScrollAndHeight(this, events); // 새 로직
        },

        // 이벤트 셀 렌더링: "시간 범위 + 제목"
        eventContent: function (arg) {
            const e = arg.event;
            const timeText = formatTimeRangeWithAmPm24(e.start, e.end); // 기존 유틸
            const title = e.title || "";
            let html = "";

            if (timeText) {
                html += "<div class='fc-event-time'>" + escapeHtml(timeText) + "</div>";
            }
            html += "<div class='fc-event-title'>" + escapeHtml(title) + "</div>";

            return { html: html };
        }
    });

    calendar.render();

    // --------------------------------------------------------------
    //  타이틀: 학기 정보 우선, 없으면 "YYYY년 M월 N주차"
    // --------------------------------------------------------------
    function updateHeaderTitle() {
        const titleEl = el.querySelector(".fc-toolbar-title");
        if (!titleEl || !calendar) return;

        const events = calendar.getEvents();
        let year = null;
        let semstr = null;

        for (let i = 0; i < events.length; i++) {
            const p = events[i].extendedProps || {};
            if (p.year && p.semstr) {
                year = p.year;
                semstr = p.semstr;
                break;
            }
        }

        if (year && semstr) {
            titleEl.textContent = year + "년 " + semstr + " 강의 시간표";
            return;
        }

        const view = calendar.view;
        if (!view || !view.currentStart) return;

        const start = view.currentStart;
        const y = start.getFullYear();
        const m = start.getMonth() + 1;
        const w = Math.floor((start.getDate() - 1) / 7) + 1;

        titleEl.textContent = y + "년 " + m + "월 " + w + "주차, 강의 시간표";
    }

    // --------------------------------------------------------------
    //  주간 시간 범위 계산 + 스크롤/높이 제어
    // --------------------------------------------------------------
    function updateScrollAndHeight(fcInstance, events) {
        if (!Array.isArray(events) || events.length === 0) {
            lastScrollConfig = { needScroll: false, earliest: null, maxDailySpanHours: 0 };
            applyScrollAndHeight(false, null);
            return;
        }

        let earliestGlobal = null;
        const perDay = {}; // "YYYY-MM-DD" → { earliest, latest }

        events.forEach(function (ev) {
            if (ev.allDay || !ev.start) return;

            const s = ev.start;
            const e = ev.end || s;

            if (!earliestGlobal || s < earliestGlobal) earliestGlobal = s;

            const key = s.getFullYear() + "-"
                + pad2(s.getMonth() + 1) + "-"
                + pad2(s.getDate());

            if (!perDay[key]) perDay[key] = { earliest: null, latest: null };
            if (!perDay[key].earliest || s < perDay[key].earliest) {
                perDay[key].earliest = s;
            }
            if (!perDay[key].latest || e > perDay[key].latest) {
                perDay[key].latest = e;
            }
        });

        let maxSpanHours = 0;
        Object.keys(perDay).forEach(function (k) {
            const bucket = perDay[k];
            if (!bucket.earliest || !bucket.latest) return;
            const spanMs = bucket.latest.getTime() - bucket.earliest.getTime();
            const spanH = spanMs / (1000 * 60 * 60);
            if (spanH > maxSpanHours) maxSpanHours = spanH;
        });

        const needScroll = maxSpanHours >= 6; // 6시간 이상이면 스크롤 유지

        lastScrollConfig = {
            needScroll: needScroll,
            earliest: earliestGlobal,
            maxDailySpanHours: maxSpanHours
        };

        applyScrollAndHeight(needScroll, earliestGlobal);
    }

    function applyScrollAndHeight(needScroll, earliest) {
        // 내부 timeGrid용 스크롤러
        const scroller = el.querySelector(".fc-scroller.fc-scroller-liquid-absolute");
        const wrap = document.querySelector(".timetable-container");
        const academic = document.querySelector(".academic-card");

        // 스크롤 모드
        if (scroller) {
            scroller.style.overflowY = needScroll ? "auto" : "hidden";
        }

        // 가장 이른 시간으로 스크롤 맞추기 (예: 09:00)
        if (earliest instanceof Date) {
            const hh = pad2(earliest.getHours());
            const mm = pad2(earliest.getMinutes());
            const timeStr = hh + ":" + mm + ":00";
            calendar.scrollToTime(timeStr);
        }

        // 높이 조정
        if (!wrap) {
            calendar.updateSize();
            return;
        }

        if (needScroll) {
            // 주간 수업 길이가 긴 경우: 오른쪽 학사 카드 높이에 맞춤 (기존 동작)
            const h = academic ? academic.offsetHeight : 600;
            wrap.style.height = h + "px";
        } else {
            // 6시간 미만일 때: 컨텐츠 전체가 보이도록 카드 자체를 줄이고 스크롤 제거
            wrap.style.height = ""; // auto 로 리셋
            if (scroller) {
                // 전체 행 높이에 약간 여백
                const innerH = scroller.scrollHeight + 5;
                wrap.style.height = innerH + "px";
            }
        }

        calendar.updateSize();
    }

    // --------------------------------------------------------------
    // 유틸 함수
    // --------------------------------------------------------------
	function pad2(n) {
        n = Number(n) || 0;
        return (n < 10 ? "0" : "") + n;
    }
    
    function compressEmptyDays(calendar) {
	  const hasEvent = {};
	
	  calendar.getEvents().forEach(function (ev) {
	    if (!ev.startStr) return;
	    const dateKey = ev.startStr.slice(0, 10);
	    hasEvent[dateKey] = true;
	  });
	
	  const minWidth = 40;
	
	  const headerCells = calendar.el.querySelectorAll(
	    ".fc-col-header-cell[data-date]"
	  );
	
	  headerCells.forEach(function (headerCell) {
	    const dateStr = headerCell.getAttribute("data-date");
	    const dayHasEvent = !!hasEvent[dateStr];
	
	    const bodyCols = calendar.el.querySelectorAll(
	      '.fc-timegrid-col[data-date="' + dateStr + '"]'
	    );
	
	    if (dayHasEvent) {
	      headerCell.style.width = "";
	      bodyCols.forEach(function (col) {
	        col.style.width = "";
	      });
	    } else {
	      headerCell.style.width = minWidth + "px";
	      bodyCols.forEach(function (col) {
	        col.style.width = minWidth + "px";
	      });
	    }
	  });
	}

    function formatAmPm24(date) {
        const d = toDate(date);
        const h = d.getHours();
        const m = d.getMinutes();
        const ampm = h < 12 ? "오전" : "오후";
        return ampm + " " + pad2(h) + ":" + pad2(m);
    }

    function formatTimeRangeWithAmPm24(start, end) {
        if (!start) return "";
        const s = formatAmPm24(start);
        if (!end) return s;
        const e = formatAmPm24(end);
        return s + " ~ " + e;
    }

    function dateToYmd(d) {
        return (
            d.getFullYear()
            + "-" + pad2(d.getMonth() + 1)
            + "-" + pad2(d.getDate())
        );
    }

    function toDate(v) {
        return v instanceof Date ? v : new Date(v);
    }

    function pad2(n) {
        return (n < 10 ? "0" : "") + n;
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
	 // timeGridWeek / timeGridDay 뷰에서만 적용되는 스크롤 정책
	 // - 한 주(또는 하루) 내 가장 이른 start ~ 가장 늦은 end 차이가 6시간 이상이면 스크롤 유지
	 // - 6시간 미만이면 세로 스크롤 숨김
	 // - 스크롤 있을 때는 가장 이른 시간으로 자동 스크롤
	 function applyScrollPolicyForTimeGrid(events) {
	     // month 뷰(dayGridMonth)에서는 의미 없으니 timeGrid에서만 수행
	     var view = calendar.view;
	     if (!view) return;
	     if (view.type !== "timeGridWeek" && view.type !== "timeGridDay") {
	         return;
	     }
	
	     if (!events || !events.length) {
	         // 이벤트 없으면 그냥 스크롤 숨김
	         var emptyScroller = calendarEl.querySelector(".fc-scroller");
	         if (emptyScroller) {
	             emptyScroller.style.overflowY = "hidden";
	         }
	         return;
	     }
	
	     var earliest = null;
	     var latest   = null;
	
	     events.forEach(function (ev) {
	         if (ev.start) {
	             var s = new Date(ev.start);
	             if (!isNaN(s)) {
	                 if (earliest === null || s < earliest) earliest = s;
	                 if (latest === null) latest = s;
	             }
	         }
	         if (ev.end) {
	             var e = new Date(ev.end);
	             if (!isNaN(e)) {
	                 if (latest === null || e > latest) latest = e;
	             }
	         }
	     });
	
	     var needScroll = false;
	
	     if (earliest && latest) {
	         var diffHours = (latest.getTime() - earliest.getTime()) / (1000 * 60 * 60);
	         // 주(또는 하루) 전체 시간대 범위가 6시간 이상이면 스크롤 필요
	         needScroll = diffHours >= 6;
	     }
	
	     // FullCalendar 내부 스크롤 엘리먼트
	     var scrollerEl = calendarEl.querySelector(".fc-scroller");
	     if (scrollerEl) {
	         scrollerEl.style.overflowY = needScroll ? "auto" : "hidden";
	     }
	
	     // 스크롤이 있을 때만 가장 이른 시작 시간으로 자동 스크롤
	     if (needScroll && earliest && typeof calendar.scrollToTime === "function") {
	         var hh = String(earliest.getHours()).padStart(2, "0");
	         var mm = String(earliest.getMinutes()).padStart(2, "0");
	         var scrollTime = hh + ":" + mm + ":00";
	         calendar.scrollToTime(scrollTime);
	     }
	 }

});


</script>
<script>
document.addEventListener("DOMContentLoaded", function () {
    var calendarEl = document.getElementById("calendar");
    var loadingEl = document.getElementById("calendar-loading");
    var tooltipEl = document.getElementById("event-tooltip");

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

    /* =====================================================================
       FullCalendar 초기화
       - 이 화면: "학사 일정 종합" 용도
       - 월/주/일/리스트 전환 허용
       - LECTURE 타입은 별도 시간표 화면이 있으므로 여기서는 숨김
       - 시간 표기는 전역 정책:
           "오전/오후 + 24시간제"
           예) 오전 09:00, 오후 13:00, 오후 16:00
       ===================================================================== */
    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth",
        locale: "ko",

        headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "dayGridMonth,timeGridWeek,timeGridDay,listWeek"
        },

        // 셀 안에서 "+ more"로 접지 말고 그대로 늘어나게 하고 싶으면
        dayMaxEvents: true,
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
	// 번호+제목+날짜만 텍스트로 렌더
	function renderItems(items) {
	    if (!Array.isArray(items) || items.length === 0) {
	        return "<div class='text-muted small py-3'>게시글이 없습니다.</div>";
	    }
	    
		// 가장 최근 30건
	    return items.slice(0, 30).map(function (item, idx) {
	        const indexLabel = String(idx + 1).padStart(2, "0");
	
	        // 제목 후보: 공지/뉴스 → bbscttSj, 학사일정 → title
	        const title = escapeHtml(
	            item.bbscttSj ||
	            item.title ||          // ScheduleEventVO.title
	            item.bbscttCn ||
	            item.content ||        // ScheduleEventVO.content (fallback)
	            ""
	        );
	
	        // 날짜 후보: 공지/뉴스 → bbscttWritngDe, 학사일정 → startDt
	        let raw =
	            item.bbscttWritngDe || // Date/String
	            item.startDt ||        // ScheduleEventVO.startDt (camelCase)
	            item.START_DT ||       // 혹시 대문자로 올 경우 대비
	            item.startDate ||      // 다른 네이밍 대비
	            "";
	
	        let dateStr = "";
	
	        if (typeof raw === "string" && raw) {
	            // "YYYY-MM-DD" or "YYYY-MM-DDTHH:MM"
	            if (raw.indexOf("T") > 0) {
	                dateStr = raw.split("T")[0];
	            } else if (raw.indexOf(" ") > 0) {
	                dateStr = raw.split(" ")[0];
	            } else {
	                dateStr = raw;
	            }
	        } else if (typeof raw === "number") {
	            const d = new Date(raw);
	            if (!Number.isNaN(d.getTime())) {
	                const y  = d.getFullYear();
	                const m  = String(d.getMonth() + 1).padStart(2, "0");
	                const dd = String(d.getDate()).padStart(2, "0");
	                dateStr = y + "-" + m + "-" + dd;
	            }
	        } else if (raw instanceof Date) {
	            const d  = raw;
	            const y  = d.getFullYear();
	            const m  = String(d.getMonth() + 1).padStart(2, "0");
	            const dd = String(d.getDate()).padStart(2, "0");
	            dateStr = y + "-" + m + "-" + dd;
	        }
	
	        const date = escapeHtml(dateStr);
	
	        // 링크 없이 텍스트만
	        return (
	            "<div class='campus-item d-flex justify-content-between align-items-center py-1'>" +
	                "<div class='d-flex align-items-center flex-grow-1 text-truncate'>" +
	                    "<span class='campus-item-index'>" + indexLabel + "</span>" +
	                    "<span class='campus-item-title text-truncate'>" + title + "</span>" +
	                "</div>" +
	                "<span class='campus-item-date text-muted small ms-2'>" + date + "</span>" +
	            "</div>"
	        );
	    }).join("");
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

