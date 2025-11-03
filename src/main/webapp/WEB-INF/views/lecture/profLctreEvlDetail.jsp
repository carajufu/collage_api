<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- header.jsp가 필요합니다 --%>
<%@ include file="../header.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
window.onload = function() {
  // -----------------------------
  // [1] 강의평가 점수 분포 데이터
  // -----------------------------
  const scoreData = [
    <c:choose>
      <c:when test="${not empty evalScoreCounts}">
        <c:forEach var="count" items="${evalScoreCounts}" varStatus="st">
          ${count}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
      </c:when>
      <c:otherwise>0,0,0,0,0</c:otherwise>
    </c:choose>
  ];

  const chartConfig = {
    type: 'doughnut',
    data: {
      labels: ['1점', '2점', '3점', '4점', '5점'],
      datasets: [{
        label: '강의평가 점수 분포',
        data: scoreData,
        backgroundColor: ['#FF6B6B', '#FFA94D', '#FFE066', '#8CE99A', '#4DABF7']
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { position: 'top' },
        title: { display: true, text: '강의평가 점수 분포' }
      }
    }
  };

  const ctx = document.getElementById('myChart');
  if (ctx) new Chart(ctx, chartConfig);
};
</script>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <section class="card shadow-sm mb-4">
      <div class="card-header bg-light d-flex align-items-center justify-content-between">
        <h5 class="card-title mb-0"><i class="bi bi-pie-chart"></i> 강의평가 점수 분포</h5>
      </div>
      <div class="card-body text-center" style="height: 360px;">
        <canvas id="myChart" style="max-width: 420px; margin: auto;"></canvas>
      </div>
    </section>

    <section class="card shadow-sm mb-4">
      <div class="card-header bg-light">
        <h5 class="card-title mb-0"><i class="bi bi-journal-text"></i> 강의 기본 정보</h5>
      </div>
      <div class="card-body">
        <div class="row mb-2">
          <div class="col-md-6"><strong>강의명:</strong> ${estblCourseInfo.lctreNm}</div>
          <div class="col-md-6"><strong>교수명:</strong> ${estblCourseInfo.profsrNm}</div>
        </div>
        <div class="row mb-2">
          <div class="col-md-6"><strong>강의코드:</strong> ${estblCourseInfo.lctreCode}</div>
          <div class="col-md-6"><strong>개설코드:</strong> ${estblCourseInfo.estbllctreCode}</div>
        </div>
        <div class="row mb-2">
          <div class="col-md-6"><strong>취득학점:</strong> ${estblCourseInfo.acqsPnt}</div>
          <div class="col-md-6"><strong>수업언어:</strong> ${estblCourseInfo.lctreUseLang}</div>
        </div>
        <div class="row mb-2">
          <div class="col-md-6"><strong>운영년도:</strong> ${estblCourseInfo.estblYear}</div>
          <div class="col-md-6"><strong>학기:</strong> ${estblCourseInfo.estblSemstr}</div>
        </div>
      </div>
    </section>

    <section class="card shadow-sm mb-4">
      <div class="card-header bg-light">
        <h5 class="card-title mb-0"><i class="bi bi-bar-chart-line"></i> 강의평가 요약</h5>
      </div>
      <div class="card-body">
        <c:if test="${empty evalSummaryList}">
          <div class="text-muted text-center">등록된 평가 결과가 없습니다.</div>
        </c:if>

        <c:if test="${not empty evalSummaryList}">
          <table class="table table-bordered text-center align-middle">
            <thead class="table-light">
              <tr>
                <th style="width: 50%;">평가항목</th>
                <th>평균점수</th>
                <th>참여인원</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="item" items="${evalSummaryList}">
                <tr>
                  <td>${item.evlCn}</td>
                  <td>${item.avgScore}</td>
                  <td>${item.evlCnt}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:if>
      </div>
    </section>

 
    <div class="mt-4 d-flex justify-content-between">
      <a href="/prof/lecture/main/All" class="btn btn-secondary">
        <i class="bi bi-arrow-left"></i> 목록으로
      </a>
    </div>

  </div>
</div>