<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>
    <title>강의 시간표</title>
	<%-- <%@ include file="../header.jsp" %> --%>
    <!-- 전역 스케줄러 css -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/schedule.css" />

    <!-- FullCalendar 정적 리소스 -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/js/fullcalendar/main.min.css" />
    <script src="${pageContext.request.contextPath}/js/fullcalendar/index.global.min.js"></script>
 	
</head>
<body>

<div class="timetable-container">
    <!-- FullCalendar 마운트 타겟 -->
    <div id="timetable"></div>
</div>

<!-- 공용 툴팁: 인스턴스 1개 재사용 -->
<div id="event-tooltip" class="event-tooltip"></div>


<%-- <%@ include file="../footer.jsp" %> --%>
<script>
document.addEventListener("DOMContentLoaded", function () {
    var el = document.getElementById("timetable");
    var tooltipEl = document.getElementById("event-tooltip");
    var ctx = "${pageContext.request.contextPath}";

    /* =====================================================================
       [과목별 색상 매핑 규칙]
       - 목표: 같은 과목은 어디서 봐도 같은 색 (시각 패턴 유지)
       - key 우선순위: estblLctreCode > lectureCode > lectureName > id
       - 팔레트는 적당히 대비 나게 순환 사용
       ===================================================================== */
    var courseColorMap = {};      // key -> color
    var courseColors = [
        "#1976d2", "#388e3c", "#d32f2f", "#7b1fa2",
        "#f57c00", "#0097a7", "#5d4037", "#c2185b",
        "#512da8", "#00796b", "#303f9f", "#afb42b",
        "#8e24aa", "#ff7043", "#26a69a", "#ffa000"
    ];

    function getCourseColor(key) {
        if (!key) return "#1976d2";
        if (!courseColorMap[key]) {
            var idx = Object.keys(courseColorMap).length % courseColors.length;
            courseColorMap[key] = courseColors[idx];
        }
        return courseColorMap[key];
    }

    /* =====================================================================
       [툴팁 상태]
       - sticky: 클릭 후 고정 모드
       - hover 시 sticky=true면 무시 (의도치 않은 깜빡임 방지)
       ===================================================================== */
    var sticky = false;
    var stickyEventId = null;

    /* =====================================================================
       [FullCalendar 초기화]
       - timeGridWeek 고정: "강의 시간표" 목적이므로 월/리스트 뷰 불필요
       - slotMin/Max: 운용 정책에 맞게 08~22시
       ===================================================================== */
    var calendar = new FullCalendar.Calendar(el, {
        locale: "ko",
        initialView: "timeGridWeek",
        firstDay: 1,
        weekends: true,
        allDaySlot: false,
        slotMinTime: "08:00:00",
        slotMaxTime: "22:00:00",
        expandRows: true,
        height: "auto",
        nowIndicator: true,

        headerToolbar: {
            left: "",
            center: "title",
            right: ""
        },

        // [좌측 시간축 라벨]
        //  예: "오전 09:00", "오후 13:00"
        slotLabelContent: function(arg) {
            return { html: formatAmPm24(arg.date) };
        },

        // FullCalendar가 내부적으로 사용하는 timeText 포맷(24시간제)
        // 실제 표시는 eventContent에서 통제
        eventTimeFormat: {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false
        },

        // 뷰 변경 시 상단 타이틀 동기화
        datesSet: function () {
            updateHeaderTitle();
        },

        /* =================================================================
           [이벤트 로딩]
           - FullCalendar: [start, end) (end는 미포함)
           - API: start~end "포함" 쿼리
           - 따라서 endExclusive - 1일 해서 호출
           ================================================================= */
        events: function(info, successCallback, failureCallback) {
            var start = info.startStr.substring(0, 10);

            var endExclusive = new Date(info.endStr);
            endExclusive.setDate(endExclusive.getDate() - 1);
            var end = dateToYmd(endExclusive);

            var url = ctx + "/api/schedule/timetable/lectures"
                + "?start=" + encodeURIComponent(start)
                + "&end=" + encodeURIComponent(end);

            fetch(url, { method: "GET", credentials: "include" })
                .then(function(res) {
                    if (!res.ok) {
                        console.error("[Timetable] load failed", res.status, res.statusText);
                        successCallback([]);
                        return [];
                    }
                    return res.json();
                })
                .then(function(data) {
                    if (!Array.isArray(data)) {
                        console.error("[Timetable] invalid response", data);
                        successCallback([]);
                        return;
                    }

                    var events = data.map(function(e) {
                        var type = e.type || "";
                        var lectureName = e.lectureName || e.title || "";
                        var room = e.room || "";
                        var title = e.title;

                        // [title 보정 규칙]
                        //  - PROF: "강의명 [수강/정원] (강의실)"
                        //  - STUDENT: "강의명 / 교수명 (강의실)"
                        if (!title) {
                            if (type === "PROF") {
                                var cnt = (e.studentCount != null && e.maxStudent != null)
                                    ? " [" + e.studentCount + "/" + e.maxStudent + "]"
                                    : "";
                                var rm = room ? " (" + room + ")" : "";
                                title = lectureName + cnt + rm;
                            } else {
                                var prof = e.profName ? " / " + e.profName : "";
                                var rm2 = room ? " (" + room + ")" : "";
                                title = lectureName + prof + rm2;
                            }
                        }

                        // 색상 키 선택 (동일 과목 동일 색)
                        var courseKey =
                            e.estblLctreCode ||
                            e.lectureCode ||
                            e.lectureName ||
                            e.id;
                        var color = getCourseColor(courseKey);

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
                })
                .finally(function () {
                    // 데이터 들어온 후 학기 기반 타이틀 재계산
                    setTimeout(updateHeaderTitle, 0);
                });
        },

        /* =================================================================
           [이벤트 셀 렌더링]
           - 기본 timeText 버리고 직접 구성
           - "오전/오후 24시간제" 범위 + title
           ================================================================= */
        eventContent: function(arg) {
            var e = arg.event;
            var timeText = formatTimeRangeWithAmPm24(e.start, e.end);
            var title = e.title || "";
            var html = "";

            if (timeText) {
                html += "<div class='fc-event-time'>" + escapeHtml(timeText) + "</div>";
            }
            html += "<div class='fc-event-title'>" + escapeHtml(title) + "</div>";

            return { html: html };
        },

        /* =================================================================
           [이벤트 클릭: 툴팁 고정 모드]
           - 교수/학생 모두 동일 로직
           - 내용 구성은 buildDetailHtml에서 역할에 따라 분기
           ================================================================= */
        eventClick: function(info) {
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

            var tRect = tooltipEl.getBoundingClientRect();
            if (left + tRect.width > scrollX + window.innerWidth - 10) {
                left = rect.left + scrollX - tRect.width - 8;
            }
            if (top + tRect.height > scrollY + window.innerHeight - 10) {
                top = scrollY + window.innerHeight - tRect.height - 10;
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
           [이벤트 호버: 요약 툴팁]
           - sticky 상태일 때는 무시 (사용자 의도 우선)
           - 내용은 동일 buildDetailHtml 사용 (중복 제거)
           ================================================================= */
        eventMouseEnter: function(info) {
            if (sticky) return;
            tooltipEl.innerHTML = buildDetailHtml(info.event);
            tooltipEl.style.display = "block";
            tooltipEl.classList.remove("sticky");
            updateTooltipPosition(info.jsEvent);
        },
        eventMouseMove: function(info) {
            if (sticky) return;
            updateTooltipPosition(info.jsEvent);
        },
        eventMouseLeave: function() {
            if (sticky) return;
            tooltipEl.style.display = "none";
        }
    });

    calendar.render();

    /* =====================================================================
       [헤더 타이틀 규칙]
       1순위: 이벤트에 year+semstr 존재 → "YYYY년 N학기 강의 시간표"
       2순위: 뷰 시작일 기준 월 N주차 → "YYYY년 M월 N주차, 강의 시간표"
       - 학기 정보를 서버에서 신뢰할 수 있을 때는 그걸 우선 사용
       ===================================================================== */
    function updateHeaderTitle() {
        var titleEl = el.querySelector(".fc-toolbar-title");
        if (!titleEl || !calendar) return;

        var events = calendar.getEvents();
        var year = null;
        var semstr = null;

        for (var i = 0; i < events.length; i++) {
            var p = events[i].extendedProps || {};
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

        var view = calendar.view;
        if (!view || !view.currentStart) return;

        var start = view.currentStart;
        var y = start.getFullYear();
        var m = start.getMonth() + 1;
        var w = Math.floor((start.getDate() - 1) / 7) + 1;

        titleEl.textContent = y + "년 " + m + "월 " + w + "주차, 강의 시간표";
    }

    /* =====================================================================
       [툴팁 내용 생성]
       - 요구사항:
         * 교수(또는 관리 뷰): 출력 가능한 정보 최대한 노출 (운영/진단용)
         * 학생: 최소 정보 (강의명, 강의실, 시간, 담당교수)만 노출
       - type 필드로 분기
       ===================================================================== */
    function buildDetailHtml(event) {
        var p = event.extendedProps || {};
        var type = p.type || "";
        var html = "";

        if (type === "STUDENT") {
            // 학생 뷰: 일정 안내 목적. 과도한 메타 정보 숨김.
            html += line("강의명", p.lectureName || event.title);
            html += line("강의실", p.room);
            html += line("시간", formatTimeRangeWithAmPm24(event.start, event.end));
            html += line("담당교수", p.profName);
            return html;
        }

        // 교수 및 기타 권한: 모니터링/운영용 정보 풀 노출.
        var typeLabel = "";
        if (type === "PROF") typeLabel = "교수 시간표";
        else if (type === "STUDENT") typeLabel = "학생 시간표";
        else if (type) typeLabel = type;

        html += line("강의명", p.lectureName || event.title);
        html += line("교과코드", p.lectureCode);
        html += line("개설강의코드", p.estblLctreCode);
        html += line("강의실", p.room);

        if (p.year && p.semstr) {
            html += line("개설년도/학기", p.year + "년 " + p.semstr);
        }

        html += line("시간", formatTimeRangeWithAmPm24(event.start, event.end));
        html += line("담당교수", p.profName);
        html += line("교수소속", p.profDeptName);

        if (p.studentCount != null && p.maxStudent != null) {
            html += line("수강인원", p.studentCount + " / " + p.maxStudent);
        }

        html += line("구분", typeLabel);

        return html;
    }

    /* =====================================================================
       [툴팁 위치 제어]
       - hover: 마우스 기준, 뷰포트 밖으로 나가지 않도록 보정
       - sticky: 여기서는 건드리지 않음 (eventClick에서 좌표 설정)
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
       [시간/포맷 유틸]
       - 전역 정책: "오전/오후 + 24시간제"
       - 예: 오전 09:00, 오후 13:00, 오후 16:00
       ===================================================================== */

    // 단일 시각 포맷
    function formatAmPm24(date) {
        var d = toDate(date);
        var h = d.getHours();
        var m = d.getMinutes();
        var ampm = (h < 12) ? "오전" : "오후";
        return ampm + " " + pad2(h) + ":" + pad2(m);
    }

    // 범위 포맷: "오전/오후 HH:MM ~ 오전/오후 HH:MM"
    function formatTimeRangeWithAmPm24(start, end) {
        if (!start) return "";
        var s = formatAmPm24(start);
        if (!end) return s;
        var e = formatAmPm24(end);
        return s + " ~ " + e;
    }

    // label/value 한 줄 생성. value 없으면 스킵.
    function line(label, value) {
        if (value === undefined || value === null || value === "") return "";
        return "<div><span class='label'>" + escapeHtml(label)
            + " : </span>" + escapeHtml(value) + "</div>";
    }

    // Date -> YYYY-MM-DD
    function dateToYmd(d) {
        return d.getFullYear() + "-" + pad2(d.getMonth() + 1) + "-" + pad2(d.getDate());
    }

    function toDate(v) {
        return (v instanceof Date) ? v : new Date(v);
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
<%@ include file="../footer.jsp" %>
