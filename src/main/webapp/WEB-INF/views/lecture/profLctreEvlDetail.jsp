<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="../header.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
window.onload = function() {
  
  const scoreData = [
    <c:choose>
      <%-- 데이터가 정상적으로 전달된 경우 --%>
      <c:when test="${not empty evalScoreCounts}">
        <c:forEach var="count" items="${evalScoreCounts}" varStatus="status">
          ${count}<c:if test="${not status.last}">,</c:if> <%-- JS 배열 요소로 삽입 (쉼표 포함) --%>
        </c:forEach>
      </c:when>
      <%-- 데이터가 없는 경우(null 등) 차트 오류 방지용 기본값 --%>
      <c:otherwise>
        0, 0, 0, 0, 0
      </c:otherwise>
    </c:choose>
  ];

  // --- [디버깅 코드 추가] ---
  // 1. F12 개발자 도구 콘솔에서 scoreData가 [1, 2, 3, 4, 5] 처럼 올바른 배열로 찍히는지 확인
  console.log("Chart Data (scoreData):", scoreData);
  // --- [디버깅 코드 끝] ---
  
  // [1] 차트 데이터 설정
  const data = {
    labels: ['1점', '2점', '3점', '4점', '5점'],
    datasets: [
      {
        label: '평가 점수 분포',
        data: scoreData, // 위에서 변환한 동적 데이터 사용
        backgroundColor: [
          '#FF6B6B', '#FFA94D', '#FFE066', '#8CE99A', '#4DABF7'
        ],
        borderWidth: 1
      }
    ]
  };

  // [2] 차트 옵션 설정
  const config = {
    type: 'doughnut', // 차트 종류
    data: data,
    options: {
      responsive: true,
      maintainAspectRatio:false,
      plugins: {
        legend: { position: 'top' },
        title: { display: true, text: '강의평가 점수 분포' }
      }
    }
  };

  // [3] 'myChart' ID를 가진 캔버스에 차트 렌더링
  const ctx = document.getElementById('myChart');
  if (ctx) {
    new Chart(ctx, config);
  }
}
</script>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <%-- [A] 강의평가 점수 분포 차트 --%>
    <div class="card shadow-sm mb-4">
      <div class="card-header bg-light p-3">
        <h5 class="card-title mb-0"><i class="bi bi-pie-chart"></i> 강의평가 점수 분포</h5>
      </div>
      <div class="card-body text-center" style="max-height: 400px; padding: 20px;">
        <%-- Chart.js가 이 캔버스에 차트를 그림 --%>
        <canvas id="myChart" style="margin: auto; max-width: 400px;"></canvas>
      </div>
    </div>

    <h2 class="border-bottom pb-3 mb-4">강의평가 상세 보기</h2>

    <%-- [B] 강의 기본정보 ('estblCourseInfo' 객체 사용) --%>
    <div class="card shadow-sm mb-4">
      <div class="card-header bg-light p-3">
        <h4 class="card-title mb-0">
          <i class="bi bi-journal-text"></i>
          강의(개설)코드: <strong>${lectureName}</strong>
        </h4>
      </div>
      <div class="card-body">
        <p><strong>강의코드:</strong> ${estblCourseInfo.lctreCode}</p>
        <p><strong>교수번호:</strong> ${estblCourseInfo.profsrNo}</p>
        <p><strong>취득학점:</strong> ${estblCourseInfo.acqsPnt}</p>
        <p><strong>수업 언어:</strong> ${estblCourseInfo.lctreUseLang}</p>
        <p><strong>운영년도/학기:</strong> ${estblCourseInfo.estblYear} / ${estblCourseInfo.estblSemstr}</p>
      </div>
    </div>

    <%-- [C] 강의평가 요약 ('evalList' 사용) --%>
    <div class="card shadow-sm mb-4">
      <div class="card-header bg-light p-3">
        <h5 class="card-title mb-0"><i class="bi bi-bar-chart-line"></i> 강의평가 요약</h5>
      </div>
      <div class="card-body">
        <%-- 'evalList'가 비어있을 경우 메시지 표시 --%>
        <c:if test="${empty evalList}">
          <div class="text-muted">등록된 평가 기본정보가 없습니다.</div>
        </c:if>
        
        <%-- 'evalList' 목록 반복 --%>
        <c:forEach var="eval" items="${evalList}">
          <div class="mb-3">
            <p class="mb-1"><strong>평가 점수:</strong>
              <%-- 'allEvlAvrg' 값이 null일 경우 '-' 표시 --%>
              <c:out value="${eval.evlScore}" default="-" /> / 5
            </p>
            <p class="mb-1"><strong>평가명:</strong> ${eval.evlCn}</p>
          </div>
        </c:forEach>
      </div>
    </div>

    <%-- [D] 강의 시간표 ('timetableList' 사용) --%>
    <div class="card shadow-sm mb-4">
      <div class="card-header bg-light p-3">
        <h5 class="card-title mb-0"><i class="bi bi-calendar-week"></i> 강의 시간표</h5>
      </div>
      <div class="card-body">
        <%-- 'timetableList'가 비어있을 경우 --%>
        <c:if test="${empty timetableList}">
          <div class="text-muted">등록된 시간표가 없습니다.</div>
        </c:if>
        
        <%-- 'timetableList'가 있을 경우 테이블로 표시 --%>
        <c:if test="${not empty timetableList}">
          <table class="table table-hover">
            <thead class="table-light">
              <tr>
                <th>요일</th>
                <th>시작 교시</th>
                <th>종료 교시</th>
              </tr>
            </thead>
            <tbody>
              <%-- 'timetableList' 목록 반복 --%>
              <c:forEach var="time" items="${timetableList}">
                <tr>
                  <td>${time.lctreDfk}</td>
                  <td>${time.beginTm}교시</td>
                  <td>${time.endTm}교시</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:if>
      </div>
    </div>

    <%-- 목록으로 돌아가기 버튼 --%>
    <div class="mt-4 d-flex justify-content-between">
      <a href="/prof/lecture/main/All" class="btn btn-secondary">
        <i class="bi bi-arrow-left"></i> 목록으로
      </a>
    </div>

  </div>
</div>

<%-- <%@ include file="../footer.jsp" %> --%>

