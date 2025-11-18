<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>대덕대학교-로그인</title>

    <!-- Pretendard + Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/pretendard/dist/web/static/pretendard.css" />
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
    <!-- 전역 스케줄러 css -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/schedule.css" />

    <!-- 메인 포털 전용 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/main-portal.css" />

    <!-- FullCalendar 정적 리소스 (전역 공용) -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/js/fullcalendar/main.min.css" />
    <script src="${pageContext.request.contextPath}/js/fullcalendar/index.global.min.js"></script>

</head>
<body>

<%@ include file="../index-header.jsp"%>
<style>
/* 고정 헤더 – 항상 불투명 탑바 */
header.main-header {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1050;

    background-color: #0f172a;      /* 완전히 불투명한 네이비 톤 */
    box-shadow: 0 2px 12px rgba(15, 23, 42, 0.45);

    /* 기존 padding, 기타 스타일 있으면 그대로 유지 */
}

/* 헤더 아래 메인 콘텐츠 상하 패딩 (스샷 기준 간격) */
.main-content-with-header-calendar {
    padding-top: 7rem;   /* 헤더와 콘텐츠 카드 사이 여유 크게 */
    padding-bottom: 2rem;  /* 하단도 넉넉하게 */
}

/* 메인 콘텐츠 전체 폰트 한 단계 축소 */
.main-content-with-header-calendar {
    font-size: 0.85rem;   /* 기본 1rem 기준 약 10% 감소 */
}

/* 제목들은 너무 작아지지 않게 약간만 보정 (선택) */
.main-content-with-header-calendar h1 {
    font-size: 1.4rem;
}
.main-content-with-header-calendar h2 {
    font-size: 1.2rem;
}
.main-content-with-header-calendar h3 {
    font-size: 1.0rem;
}

</style>
<title>대덕대학교-학사 일정</title>
</head>
<body>

<main class="main-content-with-header-calendar">
	<div class="calendar-container">
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
</main>

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
        height: "auto",
        headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "dayGridMonth,timeGridWeek,timeGridDay,listWeek"
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

<%@ include file="../index-footer.jsp"%>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>