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

<%-- 
  교수 대시보드: 
  - 좌측: 주간 강의 시간표(timeGridWeek) + 학사 일정 미니 캘린더(dayGridMonth)
  - 우측: 캠퍼스 소식(공지사항 / 대덕 뉴스 / 학사일정 / 교무/행정)
--%>

<!-- ================================================================== -->
<!--  학사 일정 요약 + 시간표 + 공휴일 카드  -->
<!-- ================================================================== -->
<div class="row px-5 pb-5">
    <!-- 좌측: 시간표 + 학사 일정 미니 캘린더 -->
    <div class="col-xxl-7 col-lg-7">
        <!-- 시간표 카드 -->
        <div class="timetable-container">
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
    </div>

    <!-- 우측: 공지/뉴스/학사일정/교무행정 탭 -->
    <div class="col-xxl-5 col-lg-5 mb-3 mb-lg-0">
        <div class="card campus-news-card academic-card">
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

                    <!-- 교수용 교무/행정 탭 -->
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
</div>

<%@ include file="../../footer.jsp"%>

<style>
    /* =========================================================
       1. 메인 컨테이너: 헤더/푸터와 충돌 없게 뷰포트 기준 높이
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
        padding: 0.5rem 1.28rem 0.25rem;
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
        height: 1.4rem;
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

    /* 수강 강의 카드 영역: 높이 제한 + 스크롤 (향후 재사용 대비) */
    .lecture-cards-row {
        max-height: 260px;
        overflow-y: auto;
        padding-bottom: 0 !important;
    }

    /* =========================================================
       3. 우측: 캠퍼스 소식 / 교무행정 카드 래퍼
       ========================================================= */
    .academic-card {
        background-color: #fff;
        border-radius: .75rem;
        box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .09);
        margin-top: 0 !important;
        margin-bottom: 10px !important;
        padding: 2px 8px 4px;
        height: auto !important;
        max-height: calc(100vh - 120px);
        overflow-y: auto;
    }

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

    /* 대시보드 카드 제목만 센터 정렬 */
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
    .calendar-containers {
        position: relative;
        margin: -2px auto;
        padding: 2px 12px;
        background-color: #ffffff;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        max-height: 360px;
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
        overflow-y: hidden !important;
        scrollbar-width: none;
    }

    .calendar-container .fc-scroller::-webkit-scrollbar {
        display: none;
    }

    /* 두 캘린더 공통 폰트 사이즈 축소 */
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

    /* 오늘 날짜 하이라이트 */
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

    .fc-daygrid-day-top {
        overflow: visible;
        padding-top: 4px;
    }

    .fc .fc-toolbar.fc-header-toolbar {
        margin-bottom: 0.5em;
    }

    .fc .fc-toolbar > * > :first-child {
        margin-left: 3px;
    }

    .fc-button-group {
        margin-left: -3px;
    }

    /* =========================================================
       5. 기타 자잘한 조정
       ========================================================= */
    .card-body_1 .card-title,
    .card-body_2 .card-title {
        font-size: 15px;
        margin: -7px 0 2px 0;
    }

    /* =========================================================
       6. 캠퍼스 소식 테이블 (공지/뉴스/학사/교무행정)
       ========================================================= */
    .campus-news-table-wrapper {
        max-height: 360px;
        overflow-y: auto;
    }

    .campus-news-table .col-no {
        width: 40px;
    }
    .campus-news-table .col-writer {
        width: 80px;
    }
    .campus-news-table .col-date {
        width: 90px;
    }
    .campus-news-table .col-hit {
        width: 60px;
    }

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
// [code-intent]
//   대시보드(교수/학생 공통) 주간 강의 시간표(timeGridWeek) 렌더링
//   - FullCalendar timeGridWeek 기반
//   - 수업 시간대 밀도에 따라 카드 높이/스크롤 정책 제어
//
// [data-flow]
//   - DOMContentLoaded → #timetable 엘리먼트 찾기
//   - /api/schedule/timetable/lectures?start=YYYY-MM-DD&end=YYYY-MM-DD 호출
//   - 강의 이벤트를 FullCalendar 이벤트 객체로 매핑
//   - 과목별 색상 일관성 유지(courseKey 기반 컬러 맵)
//   - 렌더 후 compressEmptyDays / updateScrollAndHeight 적용
// ======================================================================
document.addEventListener("DOMContentLoaded", function () {
    const ctx = "${pageContext.request.contextPath}";

    // 수강 강의 카드 클릭 이동(학생 화면에서만 실질 사용, 교수 화면에서는 lectureCards = []라 영향 없음)
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

    const el = document.getElementById("timetable");
    if (!el || !window.FullCalendar) return;

    // 과목별 색상 매핑
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
            return { html: formatAmPm24(arg.date) };
        },

        eventTimeFormat: {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false
        },

        datesSet: function () {
            updateHeaderTitle();
        },

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

                        // 한 줄 주석: 교수용(timeGrid)에서는 인원/강의실 정보를 제목에 포함
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

        eventsSet: function (events) {
            compressEmptyDays(this);
            updateScrollAndHeight(this, events);
        },

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

    // ------------------------------------------------------------------
    // 타이틀: 학기 정보 우선, 없으면 "YYYY년 M월 N주차"
    // ------------------------------------------------------------------
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

    // ------------------------------------------------------------------
    // 주간 시간 범위 계산 + 스크롤/높이 제어
    // ------------------------------------------------------------------
    function updateScrollAndHeight(fcInstance, events) {
        if (!Array.isArray(events) || events.length === 0) {
            lastScrollConfig = { needScroll: false, earliest: null, maxDailySpanHours: 0 };
            applyScrollAndHeight(false, null);
            return;
        }

        let earliestGlobal = null;
        const perDay = {};

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

        const needScroll = maxSpanHours >= 6;

        lastScrollConfig = {
            needScroll: needScroll,
            earliest: earliestGlobal,
            maxDailySpanHours: maxSpanHours
        };

        applyScrollAndHeight(needScroll, earliestGlobal);
    }

    function applyScrollAndHeight(needScroll, earliest) {
        const scroller = el.querySelector(".fc-scroller.fc-scroller-liquid-absolute");
        const wrap = document.querySelector(".timetable-container");
        const academic = document.querySelector(".academic-card");

        if (scroller) {
            scroller.style.overflowY = needScroll ? "auto" : "hidden";
        }

        if (earliest instanceof Date) {
            const hh = pad2(earliest.getHours());
            const mm = pad2(earliest.getMinutes());
            const timeStr = hh + ":" + mm + ":00";
            calendar.scrollToTime(timeStr);
        }

        if (!wrap) {
            calendar.updateSize();
            return;
        }

        if (needScroll) {
            const h = academic ? academic.offsetHeight : 600;
            wrap.style.height = h + "px";
        } else {
            wrap.style.height = "";
            if (scroller) {
                const innerH = scroller.scrollHeight + 5;
                wrap.style.height = innerH + "px";
            }
        }

        calendar.updateSize();
    }

    // ------------------------------------------------------------------
    // 유틸 함수
    // ------------------------------------------------------------------
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
// =====================================================================
// [code-intent]
//   좌측 학사 일정 미니 캘린더(dayGridMonth + timeGridWeek/Day/list)
//   - 일정 타입별 색상/범례/툴팁/필터링
//   - 툴팁은 hover 전용 (고정/닫기 버튼 없음)
//
// [data-flow]
//   - DOMContentLoaded → #calendar, #calendar-loading, #event-tooltip 참조
//   - /api/schedule/events?start=YYYY-MM-DD&end=YYYY-MM-DD 호출
//   - type별 display, 타이틀 prefix, 상세/요약 툴팁 구성
// =====================================================================
document.addEventListener("DOMContentLoaded", function () {
    var ctx = "${pageContext.request.contextPath}";
    var calendarEl = document.getElementById("calendar");
    var loadingEl = document.getElementById("calendar-loading");
    var tooltipEl = document.getElementById("event-tooltip");

    var eventCache = {};
    var typeVisibility = {};
    var syncQueued = false;

    function setLoading(visible) {
        if (!loadingEl) return;
        loadingEl.classList.toggle("visible", !!visible);
    }

    if (!calendarEl || !window.FullCalendar) return;

    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth",
        locale: "ko",

        headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "dayGridMonth,timeGridWeek,timeGridDay,listWeek"
        },

        dayMaxEvents: true,
        dayMaxEventRows: true,

        eventTimeFormat: {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false
        },

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

        slotLabelContent: function (arg) {
            return formatAmPm24Time(arg.date);
        },

        events: function (info, successCallback, failureCallback) {
            var startDate = info.startStr.substring(0, 10);
            var endDate = info.endStr.substring(0, 10);
            var cacheKey = startDate + "|" + endDate;

            if (eventCache[cacheKey]) {
                successCallback(eventCache[cacheKey].map(applyTypeToEventDisplay));
                queueSyncDayCellHeights();
                return;
            }

            var url = ctx + "/api/schedule/events"
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

        datesSet: function () { queueSyncDayCellHeights(); },
        eventDidMount: function () { queueSyncDayCellHeights(); },

        // 클릭 고정 기능 제거, hover 전용
        eventMouseEnter: function (info) {
            if (!tooltipEl) return;
            tooltipEl.innerHTML = buildTooltipHtml(info.event);
            tooltipEl.style.display = "block";
            tooltipEl.classList.remove("sticky");
            updateTooltipPosition(info.jsEvent);
        },
        eventMouseMove: function (info) {
            updateTooltipPosition(info.jsEvent);
        },
        eventMouseLeave: function () {
            if (!tooltipEl) return;
            tooltipEl.style.display = "none";
            tooltipEl.classList.remove("sticky");
        }
    });

    calendar.render();

    window.addEventListener("resize", queueSyncDayCellHeights);

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

    function applyTypeToEventDisplay(evt) {
        var t = evt.extendedProps && evt.extendedProps.type;

        if (t === "LECTURE") {
            evt.display = "none";
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

    function updateTooltipPosition(ev) {
        if (!ev || !tooltipEl || tooltipEl.style.display === "none") return;

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

    function row(label, value) {
        if (value === undefined || value === null || value === "") return "";
        return "<div><span class='label'>" +
            escapeHtml(label) + " : </span>" +
            escapeHtml(value) + "</div>";
    }

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

    function formatDate(d) {
        return d.getFullYear() + "-" +
            pad2(d.getMonth() + 1) + "-" +
            pad2(d.getDate());
    }

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
// ======================================================================
// [code-intent]
//   교수 대시보드 우측 "캠퍼스 소식" 탭(공지사항 / 대덕 뉴스 / 학사일정 / 교무/행정)
//   - 공지/뉴스/교무행정: /bbs/detail?bbscttNo=... 로 이동
//   - 학사일정: 링크 없음, 조회수 컬럼 제거
//
// [data-flow]
//   - 탭 클릭 → data-type / data-endpoint 읽기
//   - loadCampusList(endpoint, tabType) → fetch JSON
//   - renderItems(items, tabType)에서 타입별 테이블 렌더링
// ======================================================================
document.addEventListener("DOMContentLoaded", function () {
    const ctx = "${pageContext.request.contextPath}";
    const tabButtons = document.querySelectorAll(".campus-news-tab");
    const listContainer = document.getElementById("campus-news-list");

    if (!tabButtons.length || !listContainer) return;

    tabButtons.forEach(function (btn) {
        btn.addEventListener("click", function () {
            tabButtons.forEach(function (b) {
                b.classList.remove("active");
            });
            this.classList.add("active");

            const endpoint = this.dataset.endpoint;
            const tabType = this.dataset.type || "notice";
            loadCampusList(endpoint, tabType);
        });
    });

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

    // 번호 + 제목 + 작성자 + 날짜 (+ 조회수) 테이블 렌더링
    function renderItems(items, tabType) {
        if (!Array.isArray(items) || items.length === 0) {
            return "<div class='text-muted small py-3'>게시글이 없습니다.</div>";
        }

        const isAcademic = (tabType === "academic");

        const rowsHtml = items.slice(0, 30).map(function (item, idx) {
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
            if (!isAcademic) {
                const rawHit =
                    item.bbscttRdcnt != null
                        ? item.bbscttRdcnt
                        : (item.readCount != null ? item.readCount : null);
                hit = (rawHit != null ? String(rawHit) : "");
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

            // 제목 셀: 게시판 계열만 링크
            let titleCellHtml = titleText;

            if (!isAcademic) {
                const bbscttNo =
                    item.bbscttNo != null
                        ? String(item.bbscttNo)
                        : (item.bbscttSn != null ? String(item.bbscttSn) : null);

                if (bbscttNo) {
                    const href =
                        ctx + "/bbs/detail?bbscttNo=" + encodeURIComponent(bbscttNo);
                    titleCellHtml =
                        "<a href='" + href +
                        "' class='campus-link text-decoration-none text-body'>" +
                        titleText +
                        "</a>";
                }
            }

            if (isAcademic) {
                // 학사일정: 조회수 컬럼 제거
                return (
                    "<tr>" +
                        "<td class='col-no text-center'>" + no + "</td>" +
                        "<td class='campus-title-cell text-truncate'>" + titleCellHtml + "</td>" +
                        "<td class='col-writer text-center'>" + writer + "</td>" +
                        "<td class='col-date text-center'>" + date + "</td>" +
                    "</tr>"
                );
            }

            // 공지/뉴스/교무행정: 조회수 포함
            return (
                "<tr>" +
                    "<td class='col-no text-center'>" + no + "</td>" +
                    "<td class='campus-title-cell text-truncate'>" + titleCellHtml + "</td>" +
                    "<td class='col-writer text-center'>" + writer + "</td>" +
                    "<td class='col-date text-center'>" + date + "</td>" +
                    "<td class='col-hit text-center'>" + escapeHtml(hit) + "</td>" +
                "</tr>"
            );
        }).join("");

        const theadHtml = isAcademic
            ? (
                "<thead>" +
                    "<tr>" +
                        "<th class='col-no text-center'>#</th>" +
                        "<th>제목</th>" +
                        "<th class='col-writer text-center'>작성자</th>" +
                        "<th class='col-date text-center'>등록일</th>" +
                    "</tr>" +
                "</thead>"
            )
            : (
                "<thead>" +
                    "<tr>" +
                        "<th class='col-no text-center'>#</th>" +
                        "<th>제목</th>" +
                        "<th class='col-writer text-center'>작성자</th>" +
                        "<th class='col-date text-center'>등록일</th>" +
                        "<th class='col-hit text-center'>조회수</th>" +
                    "</tr>" +
                "</thead>"
            );

        return (
            "<div class='campus-news-table-wrapper'>" +
                "<table class='table campus-news-table mb-0 align-middle'>" +
                    theadHtml +
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
