<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="page-content">
  <div class="container-fluid">

    <h4 class="fw-bold mb-4">개설 강의 목록</h4>

    <!-- 검색 폼 추가 -->
    <form method="get" action="/prof/course/list" class="row g-3 mb-4">
      <div class="col-md-3">
        <label class="form-label fw-semibold">개설년도</label>
        <select name="year" class="form-select">
          <option value="">전체</option>
          <option value="2025">2025</option>
          <option value="2024">2024</option>
          <option value="2023">2023</option>
        </select>
      </div>

      <div class="col-md-3">
        <label class="form-label fw-semibold">학기</label>
        <select name="semstr" class="form-select">
          <option value="">전체</option>
          <option value="1">1학기</option>
          <option value="2">2학기</option>
        </select>
      </div>

      <div class="col-md-3 align-self-end">
        <button type="submit" class="btn btn-primary">검색</button>
      </div>
    </form>

    <c:if test="${empty allCourseList}">
      <div class="alert alert-warning text-center" role="alert">
        등록된 강의가 없습니다.
      </div>
    </c:if>

    <c:if test="${not empty allCourseList}">
      <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle text-center">
          <thead class="table-light">
            <tr>
              <th>No.</th>
              <th class="text-start">강의명</th>
              <th>강의코드</th>
              <th>강의실</th>
              <th>이수구분</th>
              <th>개설년도</th>
              <th>개설학기</th>
              <th>성적입력</th>
              <th>평균그래프</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="course" items="${allCourseList}" varStatus="status">
              <tr>
                <td>${status.count}</td>
                <td class="text-start fw-semibold">${course.lctreNm}</td>
                <td>${course.lctreCode}</td>
                <td>${course.lctrum}</td>
                <td>${course.complSe}</td>
                <td>${course.estblYear}</td>
                <td>${course.estblSemstr}</td>
                <td>
                  <a href="/prof/grade/main/detail/${course.estbllctreCode}" class="btn btn-sm btn-primary">보기</a>
                </td>
                <td>
                  <button type="button"
                          class="btn btn-sm btn-outline-secondary btn-chart"
                          data-bs-toggle="modal"
                          data-bs-target="#chartModal"
                          data-code="${course.estbllctreCode}">
                    보기
                  </button>
                </td>
              </tr>
            </c:forEach>
          </tbody>

        </table>
      </div>
    </c:if>

  </div>
</div>

<!-- 성적 평균 그래프 모달 -->
<div class="modal fade" id="chartModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">성적 평균 그래프</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <canvas id="avgChart" height="120"></canvas>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
let chartInstance;

document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".btn-chart").forEach(btn => {
    btn.addEventListener("click", function () {

      const code = this.dataset.code;

      // AJAX 요청하여 평균 데이터 가져오는 형식
      fetch("/prof/grade/chart/" + code)
        .then(res => res.json())
        .then(data => {

          const ctx = document.getElementById("avgChart").getContext("2d");

          if (chartInstance) {
            chartInstance.destroy();
          }

          chartInstance = new Chart(ctx, {
            type: 'bar',
            data: {
              labels: ['출석', '과제', '중간', '기말'],
              datasets: [{
                label: '평균점수',
                data: [data.atendAvg, data.taskAvg, data.middleAvg, data.trmendAvg]
              }]
            },
            options: {
              responsive: true,
              scales: { y: { beginAtZero: true } }
            }
          });
        });
    });
  });
});
</script>

<%@ include file="/WEB-INF/views/footer.jsp" %>
