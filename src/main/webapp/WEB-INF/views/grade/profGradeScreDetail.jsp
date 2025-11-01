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
   - 차트 인스턴스 보관
   - 편집 모드에서 취소 시 원복할 값 보관
   ========================================================================= */
let myBarChart = null;
let originalValues = [];    // 취소 시 복구용
let isEditMode = false;     // 현재 편집 모드 여부

/* =========================================================================
   공통 유틸: 현재 테이블의 모든 점수 입력칸(NodeList)을 반환
   ========================================================================= */
function getAllScoreInputs() {
	  return document.querySelectorAll(".score-input");
	}

/* =========================================================================
   기능 1) 총점 재계산: 특정 행 1개 기준
   - 출석 20%, 과제 20%, 중간 30%, 기말 30% 가중치 적용
   - 각 행의 sbjectTotpoint 입력칸을 갱신
   ========================================================================= */
function recalcRowTotal(row) {
	  const chul = parseFloat(row.querySelector("input[name*='.atendScore']").value) || 0;
	  const guwa = parseFloat(row.querySelector("input[name*='.taskScore']").value) || 0;
	  const mid  = parseFloat(row.querySelector("input[name*='.middleScore']").value) || 0;
	  const fin  = parseFloat(row.querySelector("input[name*='.trmendScore']").value) || 0;
	  const total = (chul * 0.2) + (guwa * 0.2) + (mid * 0.3) + (fin * 0.3);
	  
	  // ✅ 수정: '.total-score' 클래스 대신 name 속성으로 총점 필드를 정확히 타겟팅합니다.
	  row.querySelector("input[name*='.sbjectTotpoint']").value = total.toFixed(1);
	  
	  // ✅ 수정: 총점 계산 후, 이 값을 기준으로 즉시 평점/등급을 적용합니다.
	  applyGrade(row, total);
	}

/* =========================================================================
   기능 2) 성적 평균 밑 등급 부여
   ========================================================================= */
// ✅ 수정: 'total' 값을 파라미터로 직접 받도록 변경 (DOM을 다시 읽을 필요 없음)
function applyGrade(row, total) { 
	  // const total = parseFloat(row.querySelector(".total-score").value) || 0; // ✅ 제거
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

	  // ✅ 수정: 이 값들이 AJAX 전송 시 포함됩니다.
	  row.querySelector("input[name*='.pntGrad']").value = grade;
	  row.querySelector("input[name*='.pntAvrg']").value = score.toFixed(1);
	}

/* =========================================================================
   기능 2) 전체 총점 일괄 재계산
   ========================================================================= */
function recalcAllTotals() {
  // (recalcRowTotal이 applyGrade를 호출하므로, 모든 값이 갱신됩니다)
  document.querySelectorAll("table tbody tr").forEach(recalcRowTotal);
}

/* =========================================================================
   기능 3) 평균 차트 생성/업데이트
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

  const avgAtend  = count ? (sumAtend  / count) : 0;
  const avgTask   = count ? (sumTask   / count) : 0;
  const avgMiddle = count ? (sumMiddle / count) : 0;
  const avgTrmend = count ? (sumTrmend / count) : 0;

  const chartData = [
    (avgAtend).toFixed(1),
    (avgTask).toFixed(1),
    (avgMiddle).toFixed(1),
    (avgTrmend).toFixed(1)
  ];

  const ctx = document.getElementById('barChart').getContext('2d');
  if (!myBarChart) {
    myBarChart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: ['출석(20)', '과제(20)', '중간(30)', '기말(30)'],
        datasets: [{
          label: '평균 점수',
          data: chartData,
          backgroundColor: [
            'rgba(60,141,188,0.9)',
            'rgba(40,167,69,0.9)',
            'rgba(255,193,7,0.9)',
            'rgba(220,53,69,0.9)'
          ],
          borderColor: 'rgba(0,0,0,0.4)',
          borderWidth: 1
        }]
      },
      options: { maintainAspectRatio: false, scales: { y: { beginAtZero: true }} }
    });
  } else {
    myBarChart.data.datasets[0].data = chartData;
    myBarChart.update();
  }
}

/* =========================================================================
   기능 4) 점수 입력칸 이벤트 바인딩
   ========================================================================= */
function bindScoreInputEvents(scope = document) {
  scope.querySelectorAll(".score-input").forEach(input => {
	  
    const cloned = input.cloneNode(true);
    
    input.parentNode.replaceChild(cloned, input);
    
    cloned.addEventListener("input", function() {
    	
      const row = this.closest("tr");
      
      // ✅ 수정: recalcRowTotal이 applyGrade를 포함하여 호출합니다.
      recalcRowTotal(row);
      // applyGrade(row) // ✅ 제거: 중복 호출 방지
      
      updateAverageChart();
    });
  });
}

/* =========================================================================
   기능 5) 편집 모드 토글
   ========================================================================= */
function setEditMode(enable) {
  isEditMode = !!enable;
  // (총점, 평점, 등급은 항상 readonly여야 하므로 .score-input만 제어하는 것이 맞습니다)
  getAllScoreInputs().forEach(input => input.readOnly = !isEditMode);
  document.getElementById("editBtn").style.display   = isEditMode ? "none" : "inline-block";
  document.getElementById("saveBtn").style.display   = isEditMode ? "inline-block" : "none";
  document.getElementById("cancelBtn").style.display = isEditMode ? "inline-block" : "none";
}

/* =========================================================================
   기능 6) 원본 값 저장/복원
   ========================================================================= */
function snapshotOriginalValues() {
  originalValues = [];
  getAllScoreInputs().forEach(input => originalValues.push(input.value));
}
function restoreOriginalValues() {
  getAllScoreInputs().forEach((input, i) => input.value = originalValues[i]);
  // ✅ 수정: 값 복원 후에도 전체 계산을 다시 실행하여 총점/등급을 원복합니다.
  recalcAllTotals();
  updateAverageChart();
}

/* =========================================================================
   기능 9) AJAX 저장
   ========================================================================= */
function wireAjaxSave() {
  $(document).on("click","button[name='action'][value='update']",function(e){
    e.preventDefault();
    $.ajax({
      url: "/prof/grade/main/update",
      type: "POST",
      data: $("#gradeForm").serialize(), // (폼 전체 직렬화: 수정된 총점/평점/등급 자동 포함)
      success: function() {
        alert("저장되었습니다.");
        setEditMode(false);
        snapshotOriginalValues(); // (저장된 값을 새 원본으로 스냅샷)
      },
      error: function() { // (에러 핸들링 추가 권장)
    	  alert("저장에 실패했습니다.");
      }
    });
  });
}

/* =========================================================================
   초기화
   ========================================================================= */
window.addEventListener("DOMContentLoaded", function() {
  // ✅ 수정: 페이지 로드 시 DB 값 기준으로 총점/등급/평점을 *먼저* 계산합니다.
  recalcAllTotals();
  
  bindScoreInputEvents(document);
  updateAverageChart();
  setEditMode(false);
  
  // ✅ 수정: 계산이 완료된 후의 값을 원본으로 저장합니다.
  snapshotOriginalValues(); 
  
  document.getElementById("editBtn").addEventListener("click", function() {
    setEditMode(true);
    snapshotOriginalValues(); // (수정 시작 시점의 값을 스냅샷)
  });
  
  document.getElementById("cancelBtn").addEventListener("click", function() {
    restoreOriginalValues();
    setEditMode(false);
  });
  
  wireAjaxSave();
});
</script>

<main class="d-flex flex-column flex-grow-1">
  <div id="main-container" class="container-fluid ">
    <div class="flex-grow-1 p-3 overflow-auto">

      <h2 class="border-bottom pb-3 mb-4">과목별 성적 관리</h2>

      <div class="alert alert-info mb-4">
        <form>
          <strong>강의코드:</strong> ${selSbjectList[0].lctreCode} |
          <strong>강의명:</strong> ${selSbjectList[0].lctrum}
        </form>
      </div>

      <div class="card card-success mt-4">
        <div class="card-header">
          <h3 class="card-title">전체 학생 평균 점수</h3>
          <div class="card-tools">
            <button type="button" class="btn btn-tool" data-card-widget="collapse">
              <i class="fas fa-minus"></i>
            </button>
            <button type="button" class="btn btn-tool" data-card-widget="remove">
              <i class="fas fa-times"></i>
            </button>
          </div>
        </div>
        <div class="card-body">
          <div class="chart">
            <canvas id="barChart" style="min-height: 250px; height: 250px;"></canvas>
          </div>
        </div>
      </div>

      <form id="gradeForm" method="post">
        <input type="hidden" name="estbllctreCode" value="${selSbjectList[0].estbllctreCode}"> <table class="table table-hover align-middle">
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

                <td><input type="text" name="grades[${status.index}].pntGrad" value="${stdnt.pntGrad}" class="form-control form-control-sm" readonly></td>

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
      <div class="modal-content">


      </div>
    </div>
  </div>

  <%-- footer.jsp가 별도로 필요한 경우 포함하세요 --%>
  <%-- <%@ include file="../footer.jsp"%> --%>
</main>