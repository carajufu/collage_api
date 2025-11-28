<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../../header.jsp"%>

<!-- 전역 스케줄러 CSS -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/schedule.css" />

<!-- FullCalendar 정적 리소스 -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/js/fullcalendar/main.min.css" />
<script src="${pageContext.request.contextPath}/js/fullcalendar/index.global.min.js"></script>

<style>
    /* 좌측 학사 일정 카드 + 우측 시간표 카드 공통 스타일(그림자/배경 동일) */

    /* 시간표 카드 안을 꽉 채우도록 높이 확보 */
    .timetable-container {
        height: 200px;
        padding-top: 0;
    }
    .card-body,
    .academic-card,
    .timetable-container {
        background-color: #fff;
        border-radius: .75rem;
        box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .09); /* 카드 그림자 공통 */
        margin-top: 0 !important;
        margin-bottom: 1px !important;
    }

	#timetable { height: 100%; }
    /* 시간표 전체 래퍼: 카드처럼 보이게 + 내부 전용 설정 */
    .timetable-container  {
        padding: .5rem 1.25rem 1rem;
        overflow: hidden;
        height: auto;          /* JS에서 실제 height 지정 */
    }

    /* 캘린더는 컨테이너 높이를 그대로 채움 */
    .timetable-container #timetable {
        height: 100%;
    }

    /* 풀캘린더 타이틀 바: 카드 안에서 중간 높이 느낌 */
    .timetable-container .fc-header-toolbar {
        margin: 0 0 2px 0;
        padding: 0;
        min-height: 32px;
        display: flex;
        align-items: center;     /* 세로 가운데 */
        justify-content: center; /* 가로 가운데 (center only) */
    }

    .timetable-container .fc-toolbar-title {
        font-size: 1rem;
        font-weight: 600;
    }

    /* 요일 헤더 여백 최소화 */
    .timetable-container .fc-col-header-cell {
        padding-top: 0;
        padding-bottom: 0;
    }

    /* 시간 슬롯(row) 높이 축소 → 세로 길이 줄이기 */
    .timetable-container .fc-timegrid-slot {
        height: 15px !important;
        min-height: 15px !important;
        line-height: 15px !important;
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

    const calendar = new FullCalendar.Calendar(el, {
        locale: "ko",
        initialView: "timeGridWeek",
        firstDay: 1,          // 월요일 시작
        weekends: true,
        allDaySlot: false,
        slotMinTime: "08:00:00",
        slotMaxTime: "22:00:00",
        expandRows: true,

        height: "100%",
        handleWindowResize: true,

        // 풀캘린더 헤더(타이틀 줄) 복원
        headerToolbar: {
            left: "",
            center: "title",
            right: ""
        },

        // 날짜 대신 "월 화 수 목 금 토 일"만 출력
        dayHeaderContent: function(arg) {
            const d = arg.date.getDay();
            return { html: "<span>" + dayNames[d] + "</span>" };
        },

        // 같은 시간대 이벤트 겹치지 않게
        slotEventOverlap: false,

        // 좌측 시간축 라벨: "오전 09:00" / "오후 13:00"
        slotLabelContent: function (arg) {
            return { html: formatAmPm24(arg.date) };
        },

        eventTimeFormat: {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false
        },

        // 헤더 타이틀 커스터마이징
        datesSet: function () {
            updateHeaderTitle();
        },

        // 이벤트 로딩
        events: function (info, successCallback, failureCallback) {
            const start = info.startStr.substring(0, 10);
            const endExclusive = new Date(info.endStr);
            endExclusive.setDate(endExclusive.getDate() - 1);
            const end = dateToYmd(endExclusive);

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

                        // title 기본 규칙
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

        // 이벤트 셀 렌더링: "시간 범위 + 제목"
        eventContent: function (arg) {
            const e = arg.event;
            const timeText = formatTimeRangeWithAmPm24(e.start, e.end);
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
    // academic-card 높이에 맞춰 timetable-container 동기화 + 캘린더 리사이즈
    function resizeTimetable() {
        const academic = document.querySelector(".academic-card");
        the timetableWrap = document.querySelector(".timetable-container");
        if (!academic || !timetableWrap) return;

        const h = academic.offsetHeight;
        timetableWrap.style.height = h + "px";

        // 컨테이너 높이 바뀐 뒤 캘린더 레이아웃 재계산
        calendar.updateSize();
    }

    // 초기 한 번, 레이아웃 안정된 뒤 한 번 더
    resizeTimetable();
    setTimeout(resizeTimetable, 0);

    // 창 크기 변화 시에도 동기화
    window.addEventListener("resize", resizeTimetable);
    // --------------------------------------------------------------
    // 헤더 타이틀: 학기 정보 우선, 없으면 "YYYY년 M월 N주차"
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
    // 유틸 함수
    // --------------------------------------------------------------
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
});
</script>

<!-- ================================================================== -->
<!--  수강 강의 카드 영역  -->
<!-- ================================================================== -->
<div class="row p-5">
    <div class="col-12">
        <div class="row row-cols-xxl-4 row-cols-lg-2 row-cols-1">
            <c:forEach items="${lectureList}" var="lecture">
			  <div class="col">
			    <div class="card card-body rounded-3 shadow-sm" data-lec-no="${lecture.estbllctreCode}">
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
<div class="row px-5 pb-5">
    <!-- 좌측: 학사 일정 요약 -->
	<div class="col-xxl-8 col-lg-8 mb-3 mb-lg-0">
	    <div class="card h-100 academic-card">
            <div class="card-header d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-2">
                    <h5 class="card-title mb-0" data-key="t-academic-schedule-summary">학사 일정 요약</h5>
                    <span class="badge bg-light text-muted">
                        <c:out value="${currentYear}" />년
                        <c:out value="${currentMonth}" />월
                    </span>
                </div>
                <div class="btn-group btn-group-sm" role="group">
                    <a class="btn btn-soft-secondary"
                       href="/dashboard/student?year=${prevYear}&month=${prevMonth}">
                        <i class="ri-arrow-left-s-line align-middle"></i>
                    </a>
                    <a class="btn btn-soft-secondary"
                       href="/dashboard/student?year=${nextYear}&month=${nextMonth}">
                        <i class="ri-arrow-right-s-line align-middle"></i>
                    </a>
                </div>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty academicSchedules}">
                        <ul class="list-group list-group-flush">
                            <c:forEach items="${academicSchedules}" var="ev">
                                <li class="list-group-item d-flex align-items-center">
                                    <span class="text-muted small" style="min-width: 70px;">
                                        <c:out value="${ev.startDate}" />
                                    </span>
                                    <span class="mx-2 text-muted">|</span>
                                    <span class="flex-grow-1 text-truncate" data-key="${ev.title}">
                                        <c:out value="${ev.title}" />
                                    </span>
                                    <c:if test="${not empty ev.type}">
                                        <span class="badge bg-soft-primary text-primary ms-2" data-key="${ev.type}">
                                            <c:out value="${ev.type}" />
                                        </span>
                                    </c:if>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small mb-0" data-key="t-no-academic-schedule">
                            이번 달 등록된 학사 일정이 없습니다.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-footer text-end">
                <a href="/schedule/calendar" class="btn btn-sm btn-soft-primary" data-key="t-academic-schedule-view-all">
                    학사일정 전체 보기
                </a>
            </div>
        </div>
    </div>


	<!-- 우측: 시간표 + 공휴일 -->
	<div class="col-xxl-4 col-lg-4">
	    <!-- 시간표 카드 -->
	    <div class="timetable-container">
		    <div id="timetable"></div>
		</div>
		    
        <!-- 공휴일 카드 -->
        <div class="card h-50">
            <div class="card-header d-flex align-items-center justify-content-between">
                <h5 class="card-title mb-0" data-key="t-holiday-anniversary">공휴일 · 기념일</h5>
                <span class="text-muted small">
                    <c:out value="${currentYear}" />년
                    <c:out value="${currentMonth}" />월
                </span>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty holidays}">
                        <ul class="list-group list-group-flush">
                            <c:forEach items="${holidays}" var="holiday">
                                <li class="list-group-item d-flex align-items-center">
                                    <span class="text-muted small" style="min-width: 70px;">
                                        <c:out value="${holiday.startLabel}" />
                                        <c:if test="${empty holiday.startLabel}">
                                            <c:out value="${holiday.startDate}" />
                                        </c:if>
                                    </span>
                                    <span class="mx-2 text-muted">|</span>
                                    <span class="flex-grow-1 text-truncate" data-key="${holiday.title}">
                                        <c:out value="${holiday.title}" />
                                    </span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small mb-0" data-key="t-no-holiday-info">
                            이번 달 등록된 공휴일 정보가 없습니다.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%@ include file="../../footer.jsp"%>
