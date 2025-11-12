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
  if (count === 0) return; // 학생이 없으면 차트 그리지 않음

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
          data: avgData,
          backgroundColor: [
            'rgba(255, 99, 132, 0.5)',
            'rgba(54, 162, 235, 0.5)',
            'rgba(255, 206, 86, 0.5)',
            'rgba(75, 192, 192, 0.5)'
          ]
        }]
      },
      options: { 
        maintainAspectRatio: false, 
        scales: { y: { beginAtZero: true, max: 100 } },
        plugins: { legend: { display: false } }
      }
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
    // 기존 이벤트 리스너 제거 (중복 방지)
    const cloned = input.cloneNode(true);
    input.parentNode.replaceChild(cloned, input);
    
    // 점수 입력 시 총점/차트 즉시 재계산
    cloned.addEventListener("input", function() {
      // 0~100 사이 강제
      if (this.value > 100) this.value = 100;
      if (this.value < 0) this.value = 0;
      
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
  $("#saveBtn").on("click", function(e){
    e.preventDefault();
    
    $.ajax({
      url: "/prof/grade/main/save", 
      type: "POST",
      data: $("#gradeForm").serialize(), 
      success: function(response) {
        if(response === "success") {
            alert("저장되었습니다.");
            setEditMode(false);
            snapshotOriginalValues();
        } else {
            alert("저장에 실패했습니다. (서버 응답 오류)");
        }
      },
      error: function(xhr, status, error) {
        console.error("AJAX Error:", error);
        alert("저장 중 오류가 발생했습니다. (네트워크 또는 서버 오류)");
      }
    });
  });
}

/* =========================================================================
   초기화
   ========================================================================= */
window.addEventListener("DOMContentLoaded", function() {
  recalcAllTotals();          // 1. (로드 시) 총점/등급/평점 재계산
  bindScoreInputEvents();     // 2. 점수 입력칸 이벤트 바인딩
  updateAverageChart();       // 3. (로드 시) 차트 그리기
  setEditMode(false);         // 4. (로드 시) 읽기 전용 모드
  snapshotOriginalValues();   // 5. (로드 시) 원본 값 스냅샷
  
  // 버튼 이벤트 바인딩
  editBtn.addEventListener("click", () => { setEditMode(true); snapshotOriginalValues(); });
  cancelBtn.addEventListener("click", () => { restoreOriginalValues(); setEditMode(false); });
  
  // AJAX 저장 이벤트 바인딩
  wireAjaxSave();
});
</script>

<main class="d-flex flex-column flex-grow-1">
  <div id="main-container" class="container-fluid">
    <div class="flex-grow-1 p-3 overflow-auto">

      <h2 class="border-bottom pb-3 mb-4">과목별 성적 관리</h2>

      <div class="alert alert-info mb-4">
        <div class="row g-2">
          <div class="col-sm-6"><strong>강의명:</strong> ${selSbject.lctreNm}</div>
          <div class="col-sm-6"><strong>강의코드:</strong> ${selSbject.lctreCode}</div>
          <div class="col-sm-6"><strong>이수구분:</strong> ${selSbject.complSe}</div>
          <div class="col-sm-6"><strong>년도/학기:</strong> ${selSbject.estblYear}년 / ${selSbject.estblSemstr}</div>
        </div>
      </div>

      <div class="card card-primary mt-4">
        <div class="card-header">
          <h3 class="card-title">전체 학생 평균 점수 (100점 만점 기준)</h3>
        </div>
        <div class="card-body">
          <div class="chart">
            <canvas id="barChart" style="min-height: 250px; height: 250px; max-height: 250px; max-width: 100%;"></canvas>
          </div>
        </div>
      </div>

      <form id="gradeForm" method="post">
        <input type="hidden" name="estbllctreCode" value="${selSbject.estbllctreCode}">

        <c:if test="${empty sbjectScr}">
          <div class="alert alert-warning text-center mt-3">
            수강 중인 학생이 없습니다.
          </div>
        </c:if>

        <c:if test="${not empty sbjectScr}">
          <table class="table table-hover table-bordered align-middle mt-3">
            <thead class="table-light text-center">
              <tr>
                <th>학번</th>
                <th>학생명</th>
                <th>출석 (20%)</th>
                <th>과제 (20%)</th>
                <th>중간 (30%)</th>
                <th>기말 (30%)</th>
                <th>총점 (100)</th>
                <th>평점 (4.5)</th>
                <th>등급</th>
              </tr>
            </thead>
            <tbody class="text-center">
              <c:forEach var="stdnt" items="${sbjectScr}" varStatus="status">
                <tr>
                  <td>${stdnt.stdntNo}</td>
                  <td>${stdnt.stdntNm}</td>

                  <input type="hidden" name="grades[${status.index}].atnlcReqstNo" value="${stdnt.atnlcReqstNo}" />

                  <td><input type="number" min="0" max="100" name="grades[${status.index}].atendScore"  value="${stdnt.atendScore}"  class="form-control form-control-sm score-input" readonly></td>
                  <td><input type="number" min="0" max="100" name="grades[${status.index}].taskScore"   value="${stdnt.taskScore}"   class="form-control form-control-sm score-input" readonly></td>
                  <td><input type="number" min="0" max="100" name="grades[${status.index}].middleScore" value="${stdnt.middleScore}" class="form-control form-control-sm score-input" readonly></td>
                  <td><input type="number" min="0" max="100" name="grades[${status.index}].trmendScore" value="${stdnt.trmendScore}" class="form-control form-control-sm score-input" readonly></td>

                  <td><input type="number" name="grades[${status.index}].sbjectTotpoint" value="${stdnt.sbjectTotpoint}" class="form-control form-control-sm bg-light" readonly style="font-weight: bold;"></td>
                  <td><input type="number" name="grades[${status.index}].pntAvrg" value="${stdnt.pntAvrg}" class="form-control form-control-sm bg-light" readonly></td>
                  <td><input type="text"   name="grades[${status.index}].pntGrad" value="${stdnt.pntGrad}" class="form-control form-control-sm bg-light" readonly></td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:if>

        <div class="mt-4 d-flex justify-content-between">
          <a href="/prof/grade/main/All" class="btn btn-secondary">목록으로</a>
          
          <c:if test="${not empty sbjectScr}">
            <div>
              <button type="button" id="editBtn" class="btn btn-warning">수정하기</button>
              <button type="submit" id="saveBtn" name="action" value="save" class="btn btn-primary me-2" style="display:none;">저장</button>
              <button type="button" id="cancelBtn" class="btn btn-secondary" style="display:none;">취소</button>
            </div>
          </c:if>
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