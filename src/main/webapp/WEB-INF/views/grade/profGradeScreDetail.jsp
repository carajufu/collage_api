<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<%@ include file="../header.jsp"%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script type="text/javascript">
/* =========================================================================
   전역 상태
   ========================================================================= */
let myBarChart = null;
let originalValues = [];
let isEditMode = false;

/* =========================================================================
   공통 유틸
   ========================================================================= */
function getAllScoreInputs() {
  return document.querySelectorAll(".score-input");
}

/* =========================================================================
   기능 1) 총점 재계산 + 등급 적용
   ========================================================================= */
function recalcRowTotal(row) {
  const chul = parseFloat(row.querySelector("input[name*='.atendScore']").value) || 0;
  const guwa = parseFloat(row.querySelector("input[name*='.taskScore']").value) || 0;
  const mid  = parseFloat(row.querySelector("input[name*='.middleScore']").value) || 0;
  const fin  = parseFloat(row.querySelector("input[name*='.trmendScore']").value) || 0;

  const total = (chul * 0.2) + (guwa * 0.2) + (mid * 0.3) + (fin * 0.3);
  row.querySelector("input[name*='.sbjectTotpoint']").value = total.toFixed(1);

  applyGrade(row, total);
}

/* =========================================================================
   기능 2) 등급 계산
   ========================================================================= */
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

/* =========================================================================
   기능 3) 전체 총점 재계산
   ========================================================================= */
function recalcAllTotals() {
  document.querySelectorAll("table tbody tr").forEach(recalcRowTotal);
}

/* =========================================================================
   기능 4) 평균 차트 업데이트
   ========================================================================= */
function updateAverageChart() {
  const rows = document.querySelectorAll("table tbody tr");
  const count = rows.length;

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

  const ctx = document.getElementById('barChart').getContext('2d');
  if (!myBarChart) {
    myBarChart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: ['출석(20)', '과제(20)', '중간(30)', '기말(30)'],
        datasets: [{
          label: '평균 점수',
          data: avgData
        }]
      },
      options: { maintainAspectRatio: false, scales: { y: { beginAtZero: true }} }
    });
  } else {
    myBarChart.data.datasets[0].data = avgData;
    myBarChart.update();
  }
}

/* =========================================================================
   기능 5) 입력 이벤트 바인딩
   ========================================================================= */
function bindScoreInputEvents(scope = document) {
  scope.querySelectorAll(".score-input").forEach(input => {
    const cloned = input.cloneNode(true);
    input.parentNode.replaceChild(cloned, input);
    cloned.addEventListener("input", function() {
      const row = this.closest("tr");
      recalcRowTotal(row);
      updateAverageChart();
    });
  });
}

/* =========================================================================
   기능 6) 편집모드 토글
   ========================================================================= */
function setEditMode(enable) {
  isEditMode = !!enable;
  getAllScoreInputs().forEach(input => input.readOnly = !isEditMode);
  editBtn.style.display   = isEditMode ? "none" : "inline-block";
  saveBtn.style.display   = isEditMode ? "inline-block" : "none";
  cancelBtn.style.display = isEditMode ? "inline-block" : "none";
}

/* =========================================================================
   기능 7) 값 복원
   ========================================================================= */
function snapshotOriginalValues() {
  originalValues = [];
  getAllScoreInputs().forEach(input => originalValues.push(input.value));
}
function restoreOriginalValues() {
  getAllScoreInputs().forEach((input, i) => input.value = originalValues[i]);
  recalcAllTotals();
  updateAverageChart();
}

/* =========================================================================
   기능 8) AJAX 저장
   ========================================================================= */
function wireAjaxSave() {
  $(document).on("click","button[name='action'][value='update']",function(e){
    e.preventDefault();
    $.ajax({
      url: "/prof/grade/main/update",
      type: "POST",
      data: $("#gradeForm").serialize(),
      success: function() {
        alert("저장되었습니다.");
        setEditMode(false);
        snapshotOriginalValues();
      },
      error: function() {
        alert("저장에 실패했습니다.");
      }
    });
  });
}

/* =========================================================================
   초기화
   ========================================================================= */
window.addEventListener("DOMContentLoaded", function() {
  recalcAllTotals();
  bindScoreInputEvents(document);
  updateAverageChart();
  setEditMode(false);
  snapshotOriginalValues();
  editBtn.addEventListener("click", () => { setEditMode(true); snapshotOriginalValues(); });
  cancelBtn.addEventListener("click", () => { restoreOriginalValues(); setEditMode(false); });
  wireAjaxSave();
});
</script>

<main class="d-flex flex-column flex-grow-1">
  <div id="main-container" class="container-fluid">
    <div class="flex-grow-1 p-3 overflow-auto">

      <h2 class="border-bottom pb-3 mb-4">과목별 성적 관리</h2>

      <!-- ✅ 화면설계원칙에 따른 강의 정보 2열배치 -->
      <div class="alert alert-info mb-4">
        <div class="row g-2">
          <div class="col-sm-6"><strong>강의명:</strong> ${selSbjectList[0].lctrum}</div>
          <div class="col-sm-6"><strong>강의코드:</strong> ${selSbjectList[0].lctreCode}</div>
        </div>
      </div>

      <!-- 평균 차트 -->
      <div class="card card-success mt-4">
        <div class="card-header">
          <h3 class="card-title">전체 학생 평균 점수</h3>
        </div>
        <div class="card-body">
          <div class="chart">
            <canvas id="barChart" style="min-height: 250px; height: 250px;"></canvas>
          </div>
        </div>
      </div>

      <form id="gradeForm" method="post">
        <input type="hidden" name="estbllctreCode" value="${selSbjectList[0].estbllctreCode}">

        <table class="table table-hover align-middle mt-3">
          <thead class="table-light">
            <tr>
              <th>학생 ID</th>
              <th>학생명</th>
              <th>출석</th>
              <th>과제</th>
              <th>중간</th>
              <th>기말</th>
              <th>총점</th>
              <th>평점</th>
              <th>등급</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="stdnt" items="${sbjectScr}" varStatus="status">
              <tr>
                <td>${stdnt.stdntNo}</td>
                <td>${stdnt.stdntNm}</td>

                <input type="hidden" name="grades[${status.index}].atnlcReqstNo" value="${stdnt.atnlcReqstNo}" />

                <td><input type="number" name="grades[${status.index}].atendScore"  value="${stdnt.atendScore}"  class="form-control form-control-sm score-input" readonly></td>
                <td><input type="number" name="grades[${status.index}].taskScore"   value="${stdnt.taskScore}"   class="form-control form-control-sm score-input" readonly></td>
                <td><input type="number" name="grades[${status.index}].middleScore" value="${stdnt.middleScore}" class="form-control form-control-sm score-input" readonly></td>
                <td><input type="number" name="grades[${status.index}].trmendScore" value="${stdnt.trmendScore}" class="form-control form-control-sm score-input" readonly></td>

                <td><input type="number" name="grades[${status.index}].sbjectTotpoint" value="${stdnt.sbjectTotpoint}" class="form-control form-control-sm" readonly></td>
                <td><input type="number" name="grades[${status.index}].pntAvrg" value="${stdnt.pntAvrg}" class="form-control form-control-sm" readonly></td>
                <td><input type="text"   name="grades[${status.index}].pntGrad" value="${stdnt.pntGrad}" class="form-control form-control-sm" readonly></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>

        <div class="mt-4 d-flex justify-content-between">
          <a href="/prof/grade/main/All" class="btn btn-secondary">메인으로</a>
          <div>
            <button type="button" id="editBtn" class="btn btn-warning">수정하기</button>
            <button type="submit" id="saveBtn" name="action" value="update" class="btn btn-primary me-2" style="display:none;">저장</button>
            <button type="button" id="cancelBtn" class="btn btn-secondary" style="display:none;">취소</button>
          </div>
        </div>
      </form>
    </div>
  </div>

  <div class="modal fade" id="selectStudentModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content"></div>
    </div>
  </div>

</main>
