<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../header.jsp" %>

<!-- Chart.js 로드 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function() {

  // JSP에서 넘어온 evalScoreCounts(List<Integer>)를 JS 배열로 변환
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

  console.log("evalScoreCounts from server:", scoreData);

  let evalChartInstance = null;

  const modalEl = document.getElementById('evalChartModal');
  if (!modalEl) {
    console.warn("evalChartModal 요소를 찾을 수 없습니다.");
    return;
  }

  // 모달이 실제로 화면에 보여질 때 차트 생성
  modalEl.addEventListener('shown.bs.modal', function () {
    const ctxEl = document.getElementById('evalChart');
    if (!ctxEl) {
      console.warn("evalChart 캔버스를 찾을 수 없습니다.");
      return;
    }

    const hasData = scoreData.some(v => v > 0);
    if (!hasData) {
      console.warn("차트 데이터가 모두 0입니다.");
    }

    const ctx = ctxEl.getContext('2d');

    if (evalChartInstance) {
      evalChartInstance.destroy();
    }

    evalChartInstance = new Chart(ctx, {
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
    });
  });
});
</script>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="/dashboard/prof"><i class="las la-home"></i></a>
            </li>
            <li class="breadcrumb-item"><a href="#">학사 정보</a></li>
            <li class="breadcrumb-item">
                <a href="/prof/lecture/main/All">강의 평가</a>
            </li>
            <li class="breadcrumb-item active" aria-current="page">
                ${estblCourseInfo.lctreNm}
            </li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">${estblCourseInfo.lctreNm}</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">

        <div class="text-end mb-3">
            <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#evalChartModal">
                <i class="bi bi-pie-chart"></i> 점수 분포 보기
            </button>
        </div>

        <!-- 강의 기본 정보 -->
        <section class="card shadow-sm mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="bi bi-journal-text"></i> 강의 기본 정보
                </h5>
            </div>
            <div class="card-body">
                <div class="row mb-2">
                    <div class="col-md-6">
                        <strong>강의명:</strong> ${estblCourseInfo.lctreNm}
                    </div>
                    <div class="col-md-6">
                        <strong>교수명:</strong> ${estblCourseInfo.profsrNm}
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="col-md-6">
                        <strong>강의코드:</strong> ${estblCourseInfo.lctreCode}
                    </div>
                    <div class="col-md-6">
                        <strong>개설코드:</strong> ${estblCourseInfo.estbllctreCode}
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="col-md-6">
                        <strong>취득학점:</strong> ${estblCourseInfo.acqsPnt}
                    </div>
                    <div class="col-md-6">
                        <strong>수업언어:</strong> ${estblCourseInfo.lctreUseLang}
                    </div>
                </div>
                <div class="row mb-2">
                    <div class="col-md-6">
                        <strong>운영년도:</strong> ${estblCourseInfo.estblYear}
                    </div>
                    <div class="col-md-6">
                        <strong>학기:</strong> ${estblCourseInfo.estblSemstr}
                    </div>
                </div>
            </div>
        </section>

        <!-- 강의평가 요약 -->
        <section class="card shadow-sm mb-4">
            <div class="card-header bg-light">
                <h5 class="card-title mb-0">
                    <i class="bi bi-bar-chart-line"></i> 강의평가 요약
                </h5>
            </div>
            <div class="card-body">
                <c:if test="${empty evalSummaryList}">
                    <div class="text-muted text-center">
                        등록된 평가 결과가 없습니다.
                    </div>
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

        <div class="mt-4 d-flex justify-content-end">
            <a href="/prof/lecture/main/All" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> 목록으로
            </a>
        </div>

        <!-- 점수 분포 모달 (여기에만 Chart.js 사용) -->
        <div class="modal fade" id="evalChartModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-lg">

                <div class="modal-content">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title">
                            <i class="bi bi-pie-chart"></i> 강의평가 점수 분포
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body text-center" style="height: 380px;">
                        <canvas id="evalChart" style="max-width: 420px; margin: auto;"></canvas>
                    </div>

                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    </div>

                </div>
            </div>
        </div>

    </div>
</div>

<%@ include file="../footer.jsp" %>
