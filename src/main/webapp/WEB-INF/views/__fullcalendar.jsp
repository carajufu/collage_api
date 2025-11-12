<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%--
[fullcalendar.jsp — 학사일정 공통 모듈]

1) 코드 의도
   - JSP 화면 어디서든 동일한 FullCalendar 기반 학사일정 조회 UI를 재사용하기 위한 공통 모듈.
   - 학생 대시보드, 교수·관리자용 JSP 등에서 인클루드하여 일정 조회 기능 일관 유지.

2) 데이터 흐름
   - 입력:
     - FullCalendar가 자동 제공하는 기간(start, end) 정보.
   - 가공:
     - /api/schedule?start=..&end=.. REST API로 해당 기간 학사일정 목록 조회.
   - 출력:
     - 월/주/일/리스트 뷰에 일정 표시.
     - 이벤트 클릭 시 상세 정보(제목, 기간, 장소, 대상, 비고)를 팝업으로 노출(조회 전용).

3) 계약 (REST API 스펙)
   - URL: GET {contextPath}/api/schedule?start=YYYY-MM-DD&end=YYYY-MM-DD
   - 응답(JSON Array) 필드:
     - id: 일정 식별자 (number/string)
     - title: 일정 제목 (string)
     - start: 시작일시 (ISO8601)
     - end: 종료일시 (ISO8601, 옵션)
     - allDay: 종일 여부 (boolean)
     - place: 장소 (string, 옵션)
     - target: 대상 (string, 옵션, 예: 전체학생/1학년/교직원)
     - memo: 비고/설명 (string, 옵션)
     - type: 일정 유형 코드 (string, 옵션)
   - 이 스펙은 React 관리자 캘린더와 동일하게 사용해야 함.

4) 보안·안전 전제
   - 이 모듈은 조회 전용.
   - 등록/수정/삭제 권한 검사는 /api/schedule 서버단에서 ROLE 기반으로 처리.
   - CORS/인증이 필요한 경우에도 JSP는 fetch만 수행하며 인증 토큰 등은 서버 정책에 따름.

5) 유지보수자 가이드
   - FullCalendar 버전 변경 시 script src 경로만 이 파일에서 수정.
   - /api/schedule 응답 스펙 변경 시, React·JSP 모두 이 계약을 기준으로 동기화.
   - 다른 JSP에 FullCalendar를 새로 구현하지 말 것. 이 파일을 include해서만 사용.
--%>

<div id="calendar" style="max-width: 1000px; margin: 20px auto;"></div>

<%-- 로컬에 배치한 FullCalendar 번들 (예: /resources/js/fullcalendar/index.global.min.js) --%>
<script src="${pageContext.request.contextPath}/resources/js/fullcalendar/index.global.min.js"></script>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    var el = document.getElementById('calendar');

    // 방어: element 또는 라이브러리 누락 시 조용히 실패 로그만 남김
    if (!el || !window.FullCalendar || !FullCalendar.Calendar) {
      console.error('[fullcalendar.jsp] 초기화 실패: DOM 또는 FullCalendar 로드 오류');
      return;
    }

    var calendar = new FullCalendar.Calendar(el, {
      initialView: 'dayGridMonth',
      locale: 'ko',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
      },
      // 학사일정 조회: 기간 기반 REST API 연동
      events: function(info, success, failure) {
        var params = new URLSearchParams({
          start: info.startStr,
          end: info.endStr
        });

        fetch('${pageContext.request.contextPath}/api/schedule?' + params.toString(), {
          method: 'GET',
          credentials: 'include' // 세션 기반 보호 리소스인 경우 대비. 필요 없으면 제거 가능.
        })
          .then(function(res) {
            if (!res.ok) {
              throw new Error('[' + res.status + '] 일정 조회 실패');
            }
            return res.json();
          })
          .then(function(data) {
            // data는 계약된 필드를 가진 이벤트 배열이어야 한다.
            success(data);
          })
          .catch(function(err) {
            console.error('[fullcalendar.jsp] events load error', err);
            failure(err);
          });
      },
      // 일정 클릭 시 간단 상세 정보 팝업 (조회 전용)
      eventClick: function(info) {
        var e = info.event;
        var props = e.extendedProps || {};

        alert(
          '제목: ' + (e.title || '') + '\n'
          + '기간: ' + (e.startStr || '') + (e.endStr ? ' ~ ' + e.endStr : '') + '\n'
          + '장소: ' + (props.place || '') + '\n'
          + '대상: ' + (props.target || '') + '\n'
          + '비고: ' + (props.memo || '')
        );
      }
    });

    calendar.render();
  });
</script>
