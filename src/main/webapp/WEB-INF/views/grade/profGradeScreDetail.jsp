<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function () {

	document.getElementById("fillRandomScores").addEventListener("click", function () {

		  const rows = document.querySelectorAll("table tbody tr");

		  rows.forEach((row, idx) => {

		    const r = () => Math.floor(75 + Math.random() * 25);

		    row.querySelector("input[name*='.atendScore']").value  = r();
		    row.querySelector("input[name*='.taskScore']").value   = r();
		    row.querySelector("input[name*='.middleScore']").value = r();
		    row.querySelector("input[name*='.trmendScore']").value = r();

		    recalcRowTotal(row);
		  });

		  updateAverageChart();
		});
	
  if (new URL(location.href).searchParams.get("saved") === "Y") {
    Swal.fire({
      icon: 'success',
      title: '저장되었습니다',
      text: '입력하신 내용이 성공적으로 저장되었습니다.',
      confirmButtonColor: '#556ee6',
      confirmButtonText: '확인'
    });
  }

  let myBarChart = null;

  function recalcRowTotal(row) {
    const chul = parseFloat(row.querySelector("input[name*='.atendScore']").value) || 0;
    const guwa = parseFloat(row.querySelector("input[name*='.taskScore']").value) || 0;
    const mid  = parseFloat(row.querySelector("input[name*='.middleScore']").value) || 0;
    const fin  = parseFloat(row.querySelector("input[name*='.trmendScore']").value) || 0;

    const total = (chul * 0.2) + (guwa * 0.2) + (mid * 0.3) + (fin * 0.3);
    row.querySelector("input[name*='.sbjectTotpoint']").value = total.toFixed(1);

    applyGrade(row, total);
  }

  function applyGrade(row, total) {
    let grade = "";
    let score = 0;

    if (total >= 95) { grade = "A+"; score = 4.5; }
    else if (total >= 90) { grade = "A0"; score = 4.0; }
    else if (total >= 85) { grade = "B+"; score = 3.5; }
    else if (total >= 80) { grade = "B0"; score = 3.0; }
    else if (total >= 75) { grade = "C+"; score = 2.5; }
    else if (total >= 70) { grade = "C0"; score = 2.0; }
    else if (total >= 60) { grade = "D0"; score = 1.0; }
    else { grade = "F"; score = 0.0; }

    row.querySelector("input[name*='.pntGrad']").value = grade;
    row.querySelector("input[name*='.pntAvrg']").value = score.toFixed(1);
  }

  function recalcAllTotals() {
    document.querySelectorAll("table tbody tr").forEach(recalcRowTotal);
  }

  function updateAverageChart() {
    const rows = document.querySelectorAll("table tbody tr");
    const count = rows.length;
    if (count === 0) return;

    let sumAtend = 0, sumTask = 0, sumMiddle = 0, sumTrmend = 0;

    rows.forEach(row => {
      sumAtend  += parseFloat(row.querySelector("input[name*='.atendScore']").value)  || 0;
      sumTask   += parseFloat(row.querySelector("input[name*='.taskScore']").value)   || 0;
      sumMiddle += parseFloat(row.querySelector("input[name*='.middleScore']").value) || 0;
      sumTrmend += parseFloat(row.querySelector("input[name*='.trmendScore']").value) || 0;
    });

    const avgData = [
      (sumAtend / count).toFixed(1),
      (sumTask / count).toFixed(1),
      (sumMiddle / count).toFixed(1),
      (sumTrmend / count).toFixed(1)
    ];

    const ctx = document.getElementById('barChartModalCanvas').getContext('2d');

    if (!myBarChart) {
      myBarChart = new Chart(ctx, {
        type: 'bar',
        data: {
          labels: ['출석(20)', '과제(20)', '중간(30)', '기말(30)'],
          datasets: [{
            label: '평균 점수',
            data: avgData,
            backgroundColor: [
              'rgba(255, 99, 132, 0.5)',
              'rgba(54, 162, 235, 0.5)',
              'rgba(255, 206, 86, 0.5)',
              'rgba(75, 192, 192, 0.5)'
            ]
          }]
        },
        options: { maintainAspectRatio:false, scales:{ y:{beginAtZero:true, max:100}}, plugins:{legend:{display:false}}}
      });
    } else {
      myBarChart.data.datasets[0].data = avgData;
      myBarChart.update();
    }
  }

  function bindScoreInputEvents() {
    document.querySelectorAll(".score-input").forEach(input => {
      const cloned = input.cloneNode(true);
      input.parentNode.replaceChild(cloned, input);
      cloned.addEventListener("input", function () {
        if (this.value > 100) this.value = 100;
        if (this.value < 0) this.value = 0;

        const row = this.closest("tr");
        recalcRowTotal(row);
        updateAverageChart();
      });
    });
  }

  recalcAllTotals();
  bindScoreInputEvents();

  const chartModal = document.getElementById('averageChartModal');
  chartModal.addEventListener('shown.bs.modal', () => updateAverageChart());
});
</script>


<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/prof"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">학사 정보</a></li>
            <li class="breadcrumb-item"><a href="/prof/grade/main/All">성적 관리</a></li>
            <li class="breadcrumb-item active" aria-current="page">${selSbject.lctreNm}</li>
        </ol>
    </nav>
    <div class="container-fluid d-flex flex-column align-items-end">
    <button type="button" id="fillRandomScores" class="btn btn-secondary-sm">샘플 점수 자동 입력</button>
    </div>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">${selSbject.lctreNm}</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">

    <div class="alert alert-info mb-4">
      <div class="row g-2">
        <div class="col-sm-6"><strong>강의명:</strong> ${selSbject.lctreNm}</div>
        <div class="col-sm-6"><strong>강의코드:</strong> ${selSbject.lctreCode}</div>
        <div class="col-sm-6"><strong>이수구분:</strong> ${selSbject.complSe}</div>
        <div class="col-sm-6"><strong>년도/학기:</strong> ${selSbject.estblYear}년 / ${selSbject.estblSemstr}</div>
      </div>
    </div>

    <div class="d-flex justify-content-end mb-3">
      <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#averageChartModal">전체 평균 그래프</button>
    </div>

    <form id="gradeForm" method="post" action="/prof/grade/main/save">
      <input type="hidden" name="estbllctreCode" value="${selSbject.estbllctreCode}">

      <c:if test="${empty sbjectScr}">
        <div class="alert alert-warning text-center mt-3">수강 학생 없음</div>
      </c:if>

      <c:if test="${not empty sbjectScr}">
        <table class="table table-bordered table-hover align-middle text-center mt-3">
          <thead class="table-light">
            <tr><th>학번</th><th>학생명</th><th>출석</th><th>과제</th><th>중간</th><th>기말</th><th>총점</th><th>평점</th><th>등급</th></tr>
          </thead>
          <tbody>
            <c:forEach var="stdnt" items="${sbjectScr}" varStatus="st">
              <tr>
                <td>${stdnt.stdntNo}</td><td>${stdnt.stdntNm}</td>
                <input type="hidden" name="grades[${st.index}].atnlcReqstNo" value="${stdnt.atnlcReqstNo}">
                <td><input type="number" name="grades[${st.index}].atendScore" value="${stdnt.atendScore}" class="form-control form-control-sm score-input"></td>
                <td><input type="number" name="grades[${st.index}].taskScore" value="${stdnt.taskScore}" class="form-control form-control-sm score-input"></td>
                <td><input type="number" name="grades[${st.index}].middleScore" value="${stdnt.middleScore}" class="form-control form-control-sm score-input"></td>
                <td><input type="number" name="grades[${st.index}].trmendScore" value="${stdnt.trmendScore}" class="form-control form-control-sm score-input"></td>
                <td><input type="number" name="grades[${st.index}].sbjectTotpoint" value="${stdnt.sbjectTotpoint}" class="form-control form-control-sm bg-light" readonly></td>
                <td><input type="number" name="grades[${st.index}].pntAvrg" value="${stdnt.pntAvrg}" class="form-control form-control-sm bg-light" readonly></td>
                <td><input type="text" name="grades[${st.index}].pntGrad" value="${stdnt.pntGrad}" class="form-control form-control-sm bg-light" readonly></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:if>

      <div class="mt-4 text-end">
        <a href="/prof/grade/main/All" class="btn btn-outline-primary">목록</a>
        <c:if test="${not empty sbjectScr}">
          <button type="submit" class="btn btn-primary">저장</button>
        </c:if>
      </div>
    </form>

    </div>
</div>

<div class="modal fade" id="averageChartModal">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header"><h5>평균 그래프</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
      <div class="modal-body" style="height:350px;"><canvas id="barChartModalCanvas"></canvas></div>
    </div>
  </div>
</div>

<%@ include file="../footer.jsp" %>