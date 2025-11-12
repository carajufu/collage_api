<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%--
[student/dashboard.jsp — 학생 대시보드]

1) 코드 의도
   - 로그인한 학생에게:
     - 본인 수강 강의 카드 목록
     - 공통 학사일정 캘린더(fullcalendar.jsp) 제공.

2) 데이터 흐름
   - 서버에서 lectureList 모델 주입.
   - 카드 클릭 시 /learning/student?lecNo=... 로 이동.
   - 학사일정은 fullcalendar.jsp 모듈이 /api/schedule 호출해 별도 처리.

3) 계약
   - lectureList: estbllctreCode, lctreNm, lctrum, sklstfNm 필드를 가진 리스트.
   - 학사일정 계약은 fullcalendar.jsp 주석 참고.

4) 유지보수자 가이드
   - 대시보드 레이아웃 수정 시 fullcalendar.jsp 내용 직접 수정 금지.
   - 일정 UI 변경은 fullcalendar.jsp에서만 수행.
--%>

<%@ include file="../../header.jsp" %>

<script type="text/javascript">
  document.addEventListener("DOMContentLoaded", function () {
    var cards = Array.prototype.slice.call(document.querySelectorAll(".card"));
    console.log("[student/dashboard] cards:", cards);

    cards.forEach(function (card) {
      card.addEventListener("click", function (e) {
        var lecNo = e.currentTarget.dataset.lecNo;
        if (!lecNo) {
          console.warn("[student/dashboard] lecNo 누락 카드 클릭");
          return;
        }
        location.href = "/learning/student?lecNo=" + encodeURIComponent(lecNo);
      });
    });
  });
</script>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 overflow-hidden mx-5">
    <h1>로그인 성공</h1>

    <%-- 공통 학사일정 캘린더 모듈 포함 (조회 전용) --%>
    <%@ include file="../../fullcalendar.jsp" %>

    <div class="row row-cols-4 px-3 gap-2 mt-4">
      <c:forEach items="${lectureList}" var="lecture">
        <div class="col card rounded-3 shadow-sm" data-lec-no="${lecture.estbllctreCode}">
          <div class="card-body">
            <h4 class="card-title">${lecture.lctreNm}</h4>
            <p class="card-subtitle">${lecture.lctrum}</p>
            <p class="card-subtitle">${lecture.sklstfNm}</p>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>
</div>

<%@ include file="../../footer.jsp" %>
