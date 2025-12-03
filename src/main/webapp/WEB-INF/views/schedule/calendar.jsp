<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ include file="../header.jsp"%>

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
/* =========================================
   FullCalendar 전용 버튼 컬러 오버라이드 – 학사일정 전용
   - 기본: 연회색
   - 활성: 흰색 + 파랑 라인
   ========================================= */
.academic-calendar-page {
    --calendar-primary: #2563eb;             /* 기본 포인트 블루 */
    --calendar-primary-soft: #eef2ff;        /* 아주 연한 블루 */
    --calendar-neutral-bg: #f5f5f7;          /* 비활성 기본 배경 */
    --calendar-neutral-border: #e5e7eb;      /* 비활성 테두리 */
}

/* 공통 버튼 기본 (Month / Week / Day / List / prev / next / Today) */
.academic-calendar-page .fc .fc-button,
.academic-calendar-page .fc-theme-standard .fc-button {
    border-radius: 999px;
    background-color: var(--calendar-neutral-bg) !important;
    border: 1.8px solid var(--calendar-neutral-border) !important;
    color: #4b5563 !important;
    box-shadow: none !important;
    padding: 0.25rem 0.8rem;
    font-size: 0.80rem;
    font-weight: 750;
}

/* Prev / Next 아이콘 버튼은 조금 더 컴팩트 */
.academic-calendar-page .fc .fc-prev-button,
.academic-calendar-page .fc .fc-next-button {
    width: 35px;
    padding: 0;
}

/* 비활성(선택 안 된) 버튼 hover: 연회색 → 거의 흰색 */
.academic-calendar-page .fc .fc-button:not(.fc-button-active):hover,
.academic-calendar-page .fc-theme-standard .fc-button:not(.fc-button-active):hover {
    background-color: #ffffff !important;
    border-color: #d1d5db !important;
    color: #111827 !important;
}

/* 활성 뷰(Month/Week/Day/List) + Today 버튼 */
.academic-calendar-page
.fc .fc-button-primary.fc-button-active,
.academic-calendar-page
.fc-theme-standard .fc-button-primary.fc-button-active,
.academic-calendar-page
.fc .fc-today-button:not(.fc-button-disabled) {
    background-color: #ffffff !important;
    border-color: rgba(37, 99, 235, 0.7) !important;
    color: #1d4ed8 !important;
    box-shadow: 0 0 0 1px rgba(37, 99, 235, 0.10) !important;
}

/* 활성 hover: 아주 연한 블루 */
.academic-calendar-page
.fc .fc-button-primary.fc-button-active:hover,
.academic-calendar-page
.fc .fc-today-button:not(.fc-button-disabled):hover {
    background-color: var(--calendar-primary-soft) !important;
    border-color: rgba(37, 99, 235, 0.9) !important;
}

/* Today 비활성(이동 불가 상태) */
.academic-calendar-page
.fc .fc-today-button.fc-button-disabled {
    background-color: #f3f4f6 !important;
    border-color: #e5e7eb !important;
    color: #9ca3af !important;
    box-shadow: none !important;
}

/* =========================================================
   학사일정 전용 레이아웃/시인성 튜닝
   ========================================================= */
.academic-calendar-page.main-content-with-header-calendar {
    font-size: 0.85rem;
}

/* 상단 타이틀 */
.academic-calendar-page .page-title h2 {
    font-size: 1.5rem;
}

/* ================= 캘린더 카드 래퍼 ================= */
.academic-calendar-page .calendar-container {
    position: relative;
    max-width: 1120px;
    margin: -5px 137px 40px;
    padding: 20px;
    background-color: #ffffff;
    border-radius: 0.75rem;
    box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .08);
    display: flex;
    flex-direction: column;
    max-height: none;
    height: auto;
    overflow: visible;
}

/* FullCalendar 루트 */
.academic-calendar-page #calendar {
    flex: 1 1 auto;
    min-height: 580px;
}

/* ================= 범례 ================= */
.academic-calendar-page .legend {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
    margin-bottom: 0.70rem;
    font-size: 0.9rem;
}

.academic-calendar-page .legend-item {
    display: inline-flex;
    align-items: center;
    cursor: pointer;
    opacity: 0.9;
}

.academic-calendar-page .legend-item.disabled {
    opacity: 0.35;
}

.academic-calendar-page .legend-color {
    width: 9px;
    height: 9px;
    border-radius: 999px;
    margin-right: 6px;
}

/* ================= FullCalendar 공통 ================= */
.academic-calendar-page .fc {
    font-size: 0.8rem;
}

/* 헤더 툴바 여백 축소 + 타이틀 폰트 */
.academic-calendar-page .fc-toolbar.fc-header-toolbar {
    margin-bottom: 0.5rem;
}

.fc .fc-toolbar h2 {
    font-size: 20px;
    line-height: 30px;
    text-transform: uppercase;
}

/* 요일 헤더 텍스트 */
.academic-calendar-page .fc-col-header-cell-cushion {
    padding: 4px 0;
    font-size: 0.75rem;
    font-weight: 600;
}

/* 일반 날짜 숫자 스타일 (동그란 뱃지) */
.academic-calendar-page .fc .fc-daygrid-day-number {
    width: 29px;
    height: 28px;
    border-radius: 75%;
    margin: 3px;
    padding: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
    white-space: nowrap;
    word-break: keep-all;
    font-size: 0.85rem;
    font-weight: 500;
    color: var(--vz-body-color);
}

/* 오늘 날짜 하이라이트 (배경) */
.academic-calendar-page .fc-day-today {
    background-color: rgba(37, 99, 235, 0.03) !important;
}

/* 오늘 날짜 하이라이트 (숫자 뱃지) */
.academic-calendar-page .fc-day-today .fc-daygrid-day-number {
    background-color: #2563eb;
    color: white;
    border-radius: 50%;
    width: 24px;
    height: 24px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    margin: 4px;
}

/* ================= 이벤트 박스 / day 셀 ================= */

/* day 셀 높이 고정 */
.academic-calendar-page .fc-daygrid-day-frame {
    height: 150px;
}

/* 셀 내부 이벤트 영역 높이 제한 */
.academic-calendar-page .fc-daygrid-day-events {
    max-height: 150px;
}

/* 월 뷰 이벤트 박스 */
.academic-calendar-page .fc-daygrid-event {
    margin-top: 1px !important;
    margin-bottom: 2px !important;
    padding: 0 2px;
    border-radius: 4px;
    border: none !important;
    font-size: 0.80rem;
    line-height: 1.2;
    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    opacity: 0.95;
}

/* 이벤트 텍스트: 한 줄 + 말줄임 */
.academic-calendar-page .fc-daygrid-event .fc-event-main {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* "+ n개" 링크(압축 표시) 기본 */
.academic-calendar-page .fc-daygrid-more-link {
    margin-top: 1px;
    font-size: 0.7rem;
    font-weight: 600;
    color: #ff7b66;
}

/* 주/일 뷰 시간 라벨 */
.academic-calendar-page .fc-timegrid-slot-label-cushion {
    font-size: 0.7rem;
}

/* ================= 로딩 오버레이 ================= */
.academic-calendar-page #calendar-loading {
    position: absolute;
    inset: 0;
    background: rgba(255, 255, 255, 0.75);
    display: none;
    align-items: center;
    justify-content: center;
    font-size: 0.9rem;
    z-index: 10;
}

.academic-calendar-page #calendar-loading.visible {
    display: flex;
}

/* ================= 툴팁 ================= */
.academic-calendar-page .event-tooltip {
    position: absolute;
    z-index: 99999;
    background: #ffffff;
    border-radius: 0.5rem;
    box-shadow: 0 .35rem .9rem rgba(15, 23, 42, .18);
    padding: 0.8rem 1rem;
    font-size: 0.80rem;
    max-width: 280px;
    display: none;
}

.academic-calendar-page .event-tooltip .label {
    font-weight: 600;
    color: #64748b;
    margin-right: 4px;
}

.academic-calendar-page .event-tooltip-close {
    text-align: right;
    font-size: 0.7rem;
    cursor: pointer;
    color: #64748b;
}

.academic-calendar-page .event-tooltip.sticky {
    border: 1px solid rgba(148, 163, 184, 0.45);
}

/* =========================================================
   FullCalendar 가독성 및 멀티데이 렌더링 최적화
   ========================================================= */

/* 1. 날짜 셀 내부 오버플로우 허용 */
.academic-calendar-page .fc-daygrid-day-frame,
.academic-calendar-page .fc-daygrid-day-events,
.academic-calendar-page .fc-daygrid-event-harness {
    overflow: visible !important;
}

/* 2. 이벤트 공통 베이스 */
.academic-calendar-page .fc-event {
    background-color: var(--calendar-primary, #2563eb);
    border-color: var(--calendar-primary, #2563eb);
    color: #ffffff;
}

/* 3. 이벤트 내부 텍스트 */
.academic-calendar-page .fc-event-main {
    padding: 3px 6px;
    font-size: 0.78rem;
    font-weight: 500;
    line-height: 1.3;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    text-align: left;
}

/* 4. "+ n개" 더보기 링크 재정의 */
.academic-calendar-page .fc-daygrid-more-link {
    display: block;
    text-align: right;
    font-size: 0.75rem;
    font-weight: 600;
    color: #6b7280 !important;
    text-decoration: none;
    margin-top: 2px;
    padding-right: 4px;
}
.academic-calendar-page .fc-daygrid-more-link:hover {
    color: #111827 !important;
    background-color: transparent;
    text-decoration: underline;
}

/* 5. 이벤트 타입별 컬러 정의
   요구사항:
   - 과제 · 시험 · 평가         | 주황색
   - 학사공지                  | 보라색
   - 상담(예약건)              | 연녹색
   - 상담가능(교수시간)        | 청녹색
   - 수강신청 · 정정/철회      | 하늘색
   - 등록 · 휴학 · 복학 · 계절학기 | 분홍색
   - 공휴일 · 임시공휴일       | 빨간색
*/

/* 과제 · 시험 · 평가(+팀프로젝트) = 주황색 */
.academic-calendar-page .fc-event.type-TASK,
.academic-calendar-page .fc-event.type-PROJECT {
    background-color: #f97316;   /* orange-500 */
    border-color: #f97316;
}
.academic-calendar-page .legend-color.type-TASK,
.academic-calendar-page .legend-color.type-PROJECT {
    background-color: #f97316;
}

/* 학사공지 = 보라색 (SYSTEM) */
.academic-calendar-page .fc-event.type-SYSTEM {
    background-color: #8b5cf6;   /* violet-500 */
    border-color: #8b5cf6;
}
.academic-calendar-page .legend-color.type-SYSTEM {
    background-color: #8b5cf6;
}

/* 상담(예약건) = 연녹색 */
.academic-calendar-page .fc-event.type-COUNSEL {
    background-color: #4ade80;   /* emerald-400 */
    border-color: #4ade80;
}
.academic-calendar-page .legend-color.type-COUNSEL {
    background-color: #4ade80;
}

/* 상담가능(교수시간) = 청녹색(티얼) */
.academic-calendar-page .fc-event.type-COUNSEL_SLOT {
    background-color: #14b8a6;   /* teal-500 */
    border-color: #14b8a6;
}
.academic-calendar-page .legend-color.type-COUNSEL_SLOT {
    background-color: #14b8a6;
}

/* 수강신청 · 정정/철회 = 하늘색 */
.academic-calendar-page .fc-event.type-ENROLL_REQ {
    background-color: #38bdf8;   /* sky-400 */
    border-color: #38bdf8;
}
.academic-calendar-page .legend-color.type-ENROLL_REQ {
    background-color: #38bdf8;
}

/* 등록 · 휴학 · 복학 · 계절학기 = 분홍색 */
.academic-calendar-page .fc-event.type-ADMIN_REGIST {
    background-color: #f472b6;   /* pink-400 */
    border-color: #f472b6;
}
.academic-calendar-page .legend-color.type-ADMIN_REGIST {
    background-color: #f472b6;
}

/* 공휴일 · 임시공휴일 = 빨간색 톤 */
.academic-calendar-page .fc-event.type-HOLIDAY {
    background-color: #fecaca;   /* red-200 */
    border-color: #fca5a5;       /* red-300 */
}
.academic-calendar-page .fc-event.type-HOLIDAY .fc-event-title,
.academic-calendar-page .fc-event.type-HOLIDAY .fc-event-main,
.academic-calendar-page .fc-event.type-HOLIDAY .fc-time {
    color: #b91c1c !important;   /* red-700 */
}
.academic-calendar-page .legend-color.type-HOLIDAY {
    background-color: #dc2626;   /* red-600 */
}

/* 시간 뱃지 */
.academic-calendar-page .fc-time {
    display: inline-block;
    padding: 2px 5px;
    margin-right: 4px;
    border-radius: 4px;
    font-weight: 600;
    font-size: 0.75rem;
    line-height: 1;
    background-color: rgba(255, 255, 255, 0.2);
    color: inherit;
}
.academic-calendar-page .fc-event.type-HOLIDAY .fc-time {
    background-color: rgba(0, 0, 0, 0.1);
    color: #b91c1c !important;
}

/* 하루짜리 점 이벤트: 텍스트 박스 정리 */
.academic-calendar-page .fc-daygrid-dot-event.fc-event {
    width: 100%;
    box-sizing: border-box;
}
.academic-calendar-page .fc-daygrid-dot-event .fc-event-main {
    display: flex;
    align-items: center;
    width: 100%;
    overflow: hidden;
}
.academic-calendar-page .fc-daygrid-dot-event .fc-time {
    flex: 0 0 auto;
    margin-right: 4px;
    white-space: nowrap;
}
.academic-calendar-page .fc-daygrid-dot-event .fc-title,
.academic-calendar-page .fc-daygrid-dot-event .fc-event-title {
    flex: 1 1 auto;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
</style>

<div class="academic-calendar-page main-content-with-header-calendar">
    <div class="row pt-3 px-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="/dashboard/student"><i class="las la-home"></i></a>
                </li>
                <li class="breadcrumb-item"><a href="#">학교 소개</a></li>
                <li class="breadcrumb-item active" aria-current="page">학사일정</li>
            </ol>
        </nav>
        <div class="col-12 page-title mt-2">
            <h2 class="fw-semibold">학사일정</h2>
            <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
        </div>
    </div>

    <div class="row">
        <div class="col-12 col-xxl-12">
            <div class="calendar-container position-relative">
                <!-- 범례 -->
                <div class="legend">
                    <!-- 과제 · 시험 · 평가 (주황색) -->
                    <div class="legend-item" data-type="TASK">
                        <div class="legend-color type-TASK"></div>
                        <span>과제·시험·평가</span>
                    </div><!-- 
                    팀프로젝트 (과제 그룹과 동일색)
                    <div class="legend-item" data-type="PROJECT">
                        <div class="legend-color type-PROJECT"></div>
                        <span>팀프로젝트</span>
                    </div> -->

                    <!-- 상담(예약건) = 연녹색 -->
                    <div class="legend-item" data-type="COUNSEL">
                        <div class="legend-color type-COUNSEL"></div>
                        <span>상담(예약건)</span>
                    </div>

                    <!-- 상담가능(교수시간) = 청녹색 -->
                    <div class="legend-item" data-type="COUNSEL_SLOT">
                        <div class="legend-color type-COUNSEL_SLOT"></div>
                        <span>상담가능(교수시간)</span>
                    </div>

                    <!-- 수강신청 · 정정/철회 = 하늘색 -->
                    <div class="legend-item" data-type="ENROLL_REQ">
                        <div class="legend-color type-ENROLL_REQ"></div>
                        <span>수강신청·정정/철회</span>
                    </div>

                    <!-- 등록 · 휴학 · 복학 · 계절학기 = 분홍색 -->
                    <div class="legend-item" data-type="ADMIN_REGIST">
                        <div class="legend-color type-ADMIN_REGIST"></div>
                        <span>등록·휴학·복학·계절학기</span>
                    </div>

                    <!-- 학사공지 = 보라색 -->
                    <div class="legend-item" data-type="SYSTEM">
                        <div class="legend-color type-SYSTEM"></div>
                        <span>학사공지·학사일정</span>
                    </div>

                    <!-- 공휴일 · 임시공휴일 = 빨간색 -->
                    <div class="legend-item" data-type="HOLIDAY">
                        <div class="legend-color type-HOLIDAY"></div>
                        <span>공휴일 · 임시공휴일</span>
                    </div>
                </div>

                <!-- FullCalendar 렌더링 영역 -->
                <div id="calendar"></div>

                <!-- 비동기 로딩 표시 -->
                <div id="calendar-loading" class="calendar-loading">
                    일정을 불러오는 중...
                </div>
            </div>

            <!-- 공용 툴팁 인스턴스 -->
            <div id="event-tooltip" class="event-tooltip"></div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    var calendarEl = document.getElementById("calendar");
    var loadingEl = document.getElementById("calendar-loading");
    var tooltipEl = document.getElementById("event-tooltip");

    // 상태
    var eventCache = {};
    var typeVisibility = {};
    var sticky = false;
    var stickyEventId = null;

    var calendarContainer = calendarEl.closest(".calendar-container");

    function setLoading(visible) {
        if (!loadingEl) return;
        loadingEl.classList.toggle("visible", !!visible);
    }

    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth",
        locale: "ko",
        height: "auto",
        contentHeight: "auto",
        headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "dayGridMonth,timeGridWeek,timeGridDay,listWeek"
        },
        dayMaxEvents: 4,
        moreLinkContent: function (args) {
            return "+" + args.num + "more";
        },
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

        // 이벤트 로딩
        events: function (info, successCallback, failureCallback) {
            var startDate = info.startStr.substring(0, 10);
            var endDate = info.endStr.substring(0, 10);
            var cacheKey = startDate + "|" + endDate;

            if (eventCache[cacheKey]) {
                successCallback(eventCache[cacheKey].map(applyTypeToEventDisplay));
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
                        console.error("[Calendar] invalid response", data);
                        eventCache[cacheKey] = [];
                        successCallback([]);
                        return;
                    }

                    var events = data.map(function (e) {
                        var type = inferTypeFromContent(e.type, e.title, e.memo);

                        if (!(type in typeVisibility)) {
                            typeVisibility[type] = true;
                        }

                        var baseTitle = e.title || "";
                        var title = buildTitle(type, baseTitle);

                        var correctedEndDate = e.endDate;
                        if (!!e.allDay && e.endDate && e.endDate.length === 10) {
                            var d = new Date(e.endDate + "T00:00:00");
                            d.setDate(d.getDate() + 1);
                            correctedEndDate =
                                d.getFullYear() + "-" + pad2(d.getMonth() + 1) + "-" + pad2(d.getDate());
                        }

                        var fcEvent = {
                            id: e.id,
                            title: title,
                            start: e.startDate,
                            end: correctedEndDate,
                            allDay: !!e.allDay,
                            extendedProps: {
                                rawType: e.type || "",
                                rawTitle: baseTitle,
                                displayTitle: title,
                                type: type,
                                place: e.place,
                                target: e.target,
                                memo: e.memo || "",
                                originalEndDate: e.endDate
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
                });
        },

        eventClick: function (info) {
            var e = info.event;
            var html = buildDetailHtml(e);
            html = "<div class='event-tooltip-close' id='event-tooltip-close'>✕</div>" + html;

            tooltipEl.innerHTML = html;
            tooltipEl.style.display = "block";
            tooltipEl.classList.add("sticky");

            var rect = info.el.getBoundingClientRect();
            var containerRect = calendarContainer.getBoundingClientRect();
            var tooltipRect = tooltipEl.getBoundingClientRect();
            var gap = 90;

            var left = (rect.right - containerRect.left) + gap;
            var top = (rect.top - containerRect.top)
                + (rect.height - tooltipRect.height) / 2;

            var minLeft = 0;
            var maxLeft = containerRect.width - tooltipRect.width;
            var minTop = 0;
            var maxTop = containerRect.height - tooltipRect.height;

            if (left > maxLeft) {
                left = (rect.left - containerRect.left) - tooltipRect.width - gap;
            }

            if (left < minLeft) left = minLeft;
            if (left > maxLeft) left = maxLeft;
            if (top < minTop) top = minTop;
            if (top > maxTop) top = maxTop;

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

    // 범례 토글
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
        });
    });

    function applyTypeToEventDisplay(evt) {
        evt.extendedProps = evt.extendedProps || {};
        var t = evt.extendedProps.type;

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

    // ====== 헬퍼 ======

    // 시연용 학사일정: 제목/메모 키워드로 타입 재분류
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

        // 수업평가/시험 관련은 과제 느낌으로 묶기
        if (text.indexOf("수업평가") >= 0 
        		|| text.indexOf("시험") >= 0
        		|| text.indexOf("팀프로젝트") >= 0
        		|| text.indexOf("프로젝트") >= 0
        		|| text.indexOf("팀") >= 0) {
            
        	return "TASK";
        }

        // 기타 시연용 학사일정(SCHAFS)은 기본값을 학사공지로
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
        if (sticky) return;

        var offset = -230;
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

<%@ include file="../footer.jsp"%>
