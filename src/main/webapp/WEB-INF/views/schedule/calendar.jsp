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
   (Velzon 전체 primary=주황 이더라도 여기만 파랑 강제)
   ========================================= */
.academic-calendar-page {
    --calendar-primary: #2563eb;             /* 포인트 블루 */
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
    background-color: #ffffff !important;                          /* 흰색 바탕 */
    border-color: rgba(37, 99, 235, 0.7) !important;              /* 파랑 테두리 */
    color: #1d4ed8 !important;                                    /* 파랑 텍스트 */
    box-shadow: 0 0 0 1px rgba(37, 99, 235, 0.10) !important;     /* 옅은 블루 링 */
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
   학사일정 전용 레이아웃/시인성 튜닝 (정리·중복 제거 버전)
   ========================================================= */
/* 페이지 기본 폰트 스케일 */
.academic-calendar-page.main-content-with-header-calendar {
    font-size: 0.85rem;
}

/* 상단 타이틀 */
.academic-calendar-page .page-title h2 {
    font-size: 1.5rem;
}

/* ================= 캘린더 카드 래퍼 ================= */
.academic-calendar-page .calendar-container {
    position: relative;                 /* 로딩/툴팁 기준 */
    max-width: 1120px;
    margin: -5px 137px 40px;
    padding: 20px;
    background-color: #ffffff;
    border-radius: 0.75rem;
    box-shadow: 0 .125rem .25rem rgba(15, 23, 42, .08);
    display: flex;
    flex-direction: column;

    /* 내부 스크롤 금지, 페이지 전체 스크롤 사용 */
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

/* 오늘 날짜 하이라이트: 셀 배경 + 숫자 뱃지 강조 */
.academic-calendar-page .fc-day-today {
    background-color: rgba(255, 152, 120, 0.18);
}

.academic-calendar-page .fc-day-today .fc-daygrid-day-number {
    background-color: #ff7b66;
    color: #ffffff;
    font-weight: 700;
    box-shadow: 0 0 0 2px #ffffff;
}

/* ================= 이벤트 박스 / day 셀 ================= */

/* day 셀 높이 고정 (이벤트 개수와 무관) */
.academic-calendar-page .fc-daygrid-day-frame {
    height: 100px;                      /* 필요시 90~130px 사이 조정 */
}

/* 셀 내부 이벤트 영역 높이 제한 */
.academic-calendar-page .fc-daygrid-day-events {
    max-height: 80px;
    overflow: hidden;
}

/* 월 뷰 이벤트 박스: 세로 폭 축소 */
.academic-calendar-page .fc-daygrid-event {
    margin: 0;
    padding: 0 2px;
    border-radius: 3px;
    border: none;
    font-size: 0.80rem;
    line-height: 1.2;
}

/* 이벤트 텍스트: 한 줄 + 말줄임 → 옆 칸으로 안 밀리게 */
.academic-calendar-page .fc-daygrid-event .fc-event-main {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* "+ n개" 링크(압축 표시) */
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
    z-index: 9999;
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
                <!-- [범례] 타입별 필터링 트리거 -->
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

    // [상태] 캐시/필터/툴팁
    var eventCache = {};           // 기간별 응답 캐시
    var typeVisibility = {};       // 타입별 ON/OFF
    var sticky = false;            // 툴팁 고정 여부
    var stickyEventId = null;      // 고정된 이벤트 ID
    var syncQueued = false;        // dayGrid 셀 높이 rAF 중복 방지

    // 캘린더 카드 컨테이너 경계(페이지 좌표 기준) 계산
    var calendarContainer = calendarEl.closest(".calendar-container");

    function getContainerBounds() {
        if (!calendarContainer) return null;
        var r = calendarContainer.getBoundingClientRect();
        var scrollX = window.scrollX || document.documentElement.scrollLeft;
        var scrollY = window.scrollY || document.documentElement.scrollTop;
        return {
            left:   r.left + scrollX + 8,   // 안쪽 여백 8px
            top:    r.top + scrollY + 8,
            right:  r.right + scrollX - 8,
            bottom: r.bottom + scrollY - 8
        };
    }
    /* 로딩 오버레이 */
    function setLoading(visible) {
        if (!loadingEl) return;
        loadingEl.classList.toggle("visible", !!visible);
    }

    /* =====================================================================
       FullCalendar 초기화
       - 이 화면: "학사 일정 종합" 용도
       - 월/주/일/리스트 전환 허용
       - PC 기준 한 화면 안에 들어오도록:
         * calendar-container에 max-height 설정
         * 캘린더는 height: '100%'로 flex 영역 채움
       - LECTURE 타입은 별도 시간표 화면이 있으므로 여기서는 숨김
       - 시간 표기는 전역 정책:
           "오전/오후 + 24시간제"
           예) 오전 09:00, 오후 13:00, 오후 16:00
       - 월 뷰 이벤트 과다 시 "+ n개 더보기" 형태로 압축(dayMaxEvents)
       ===================================================================== */
    var calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: "dayGridMonth",
        locale: "ko",

        // flex 컨테이너 안에서 100% 높이로만 운용 → 페이지 한 화면에 수렴

	   height: "auto",
	   contentHeight: "auto",
        headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "dayGridMonth,timeGridWeek,timeGridDay,listWeek"
        },

        // 월 뷰에서 하루에 표시할 최대 이벤트 수 제한 → 나머지는 "+ n개" 링크로 압축
        dayMaxEvents: 3,          // 필요시 2~4 사이에서 숫자만 조정
        // dayMaxEventRows: true, // (구버전 호환용, 있으면 무시됨)

        // "+ n개" 텍스트 한글화
        moreLinkContent: function (args) {
            return "+" + args.num + "more";
        },

        // 내부 timeText 포맷: 24시간제
        eventTimeFormat: {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false
        },

        // [이벤트 셀 표시 형식 통일]
        //  - allDay: 제목만
        //  - timed: "오전/오후 HH:MM 제목"
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

        // [timeGrid 주/일 뷰 좌측 라벨 포맷]
        slotLabelContent: function (arg) {
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
                        console.error("[Calendar] invalid response", data);
                        eventCache[cacheKey] = [];
                        successCallback([]);
                        return;
                    }

                    var events = data.map(function (e) {
                        var type = e.type || "";
                        if (!(type in typeVisibility)) {
                            // 첫 등장 타입은 기본 ON
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

            var rect           = info.el.getBoundingClientRect();
            var containerRect  = calendarContainer.getBoundingClientRect();
            var tooltipRect    = tooltipEl.getBoundingClientRect();
            var gap = 90; // 이벤트 박스와의 간격 최소

            // 카드 내부 좌표계로 변환
            var left = (rect.right - containerRect.left) + gap;
            var top  = (rect.top  - containerRect.top)
                     + (rect.height - tooltipRect.height) / 2;

            // 카드 안에서만 보이도록 clamp
            var minLeft = 0;
            var maxLeft = containerRect.width  - tooltipRect.width;
            var minTop  = 0;
            var maxTop  = containerRect.height - tooltipRect.height;

            if (left > maxLeft) {
                // 오른쪽이 넘치면 왼쪽으로 붙임
                left = (rect.left - containerRect.left) - tooltipRect.width - gap;
            }

            if (left < minLeft) left = minLeft;
            if (left > maxLeft) left = maxLeft;
            if (top  < minTop)  top  = minTop;
            if (top  > maxTop)  top  = maxTop;

            tooltipEl.style.left = left + "px";
            tooltipEl.style.top  = top  + "px";

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

    function queueSyncDayCellHeights() {}
    /* =====================================================================
       타입 필터링: LECTURE 제외 / legend 기반 on/off
       ===================================================================== */
    function applyTypeToEventDisplay(evt) {
        // 방어적으로 extendedProps 보장
        evt.extendedProps = evt.extendedProps || {};
        var t = evt.extendedProps.type;

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
       툴팁 위치 제어 (hover 모드)
       ===================================================================== */
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

<%@ include file="../footer.jsp"%>
