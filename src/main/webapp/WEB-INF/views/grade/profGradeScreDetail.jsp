<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>


<%@ include file="../header.jsp"%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function () {

  let myBarChart = null;
  let originalValues = [];
  let isEditMode = false;

  function getAllScoreInputs() {
    return document.querySelectorAll(".score-input");
  }

  //총점 재계산
  function recalcRowTotal(row) {
    const chul = parseFloat(row.querySelector("input[name*='.atendScore']").value) || 0;
    const guwa = parseFloat(row.querySelector("input[name*='.taskScore']").value) || 0;
    const mid  = parseFloat(row.querySelector("input[name*='.middleScore']").value) || 0;
    const fin  = parseFloat(row.querySelector("input[name*='.trmendScore']").value) || 0;

    const total = (chul * 0.2) + (guwa * 0.2) + (mid * 0.3) + (fin * 0.3);
    row.querySelector("input[name*='.sbjectTotpoint']").value = total.toFixed(1);

    applyGrade(row, total);
  }

  //등급 계산
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

  // 전체 재계산
  function recalcAllTotals() {
    document.querySelectorAll("table tbody tr").forEach(recalcRowTotal);
  }

  // 차트 업데이트
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
          scales: { y: { beginAtZero: true, max: 100 }},
          plugins: { legend: { display: false } }
        }
      });
    } else {
      myBarChart.data.datasets[0].data = avgData;
      myBarChart.update();
    }
  }

  // 입력 이벤트
  function bindScoreInputEvents(scope = document) {
    scope.querySelectorAll(".score-input").forEach(input => {
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

  // 편집모드
  function setEditMode(enable) {
    isEditMode = !!enable;
    getAllScoreInputs().forEach(input => input.readOnly = !isEditMode);

    editBtn.style.display = enable ? "none" : "inline-block";
    saveBtn.style.display = enable ? "inline-block" : "none";
    cancelBtn.style.display = enable ? "inline-block" : "none";
  }

  // 값 저장/복구
  function snapshotOriginalValues() {
    originalValues = [];
    getAllScoreInputs().forEach(input => originalValues.push(input.value));
  }

  function restoreOriginalValues() {
    getAllScoreInputs().forEach((input, i) => input.value = originalValues[i]);
    recalcAllTotals();
    updateAverageChart();
  }

  // AJAX 저장
  function wireAjaxSave() {
    $("#saveBtn").on("click", function (e) {
      e.preventDefault();

      $.ajax({
        url: "/prof/grade/main/save",
        type: "POST",
        data: $("#gradeForm").serialize(),
        success: function (response) {
          if (response === "success") {
            alert("저장되었습니다.");
            setEditMode(false);
            snapshotOriginalValues();
          } else {
            alert("저장에 실패했습니다.(서버 응답 오류)");
          }
        },
        error: function () {
          alert("저장 중 오류가 발생했습니다.");
        }
      });
    });
  }

  // ⭐ DOM 요소 선언 (중요)
  const editBtn   = document.getElementById("editBtn");
  const saveBtn   = document.getElementById("saveBtn");
  const cancelBtn = document.getElementById("cancelBtn");

  // ⭐ 초기화 (이제 정상 작동)
  recalcAllTotals();
  bindScoreInputEvents();
  updateAverageChart();
  setEditMode(false);
  snapshotOriginalValues();

  // ⭐ 버튼 이벤트 바인딩
  if (editBtn) {
    editBtn.addEventListener("click", () => {
      setEditMode(true);
      snapshotOriginalValues();
    });
  }

  if (cancelBtn) {
    cancelBtn.addEventListener("click", () => {
      restoreOriginalValues();
      setEditMode(false);
    });
  }

  wireAjaxSave();
});
</script>


    <h4 class="fw-bold mb-4">과목별 성적 관리</h4>

    <div class="alert alert-info mb-4">
      <div class="row g-2">
        <div class="col-sm-6"><strong>강의명:</strong> ${selSbject.lctreNm}</div>
        <div class="col-sm-6"><strong>강의코드:</strong> ${selSbject.lctreCode}</div>
        <div class="col-sm-6"><strong>이수구분:</strong> ${selSbject.complSe}</div>
        <div class="col-sm-6"><strong>년도/학기:</strong> ${selSbject.estblYear}년 / ${selSbject.estblSemstr}</div>
      </div>
    </div>

    <div class="border rounded p-3 mb-4">
      <h6 class="fw-semibold mb-3">전체 학생 평균 점수 (100점 기준)</h6>
      <div style="height:200px;">
        <canvas id="barChart"></canvas>
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
        <table class="table table-bordered table-hover align-middle text-center mt-3">
          <thead class="table-light">
            <tr>
              <th>학번</th>
              <th>학생명</th>
              <th>출석 (20)</th>
              <th>과제 (20)</th>
              <th>중간 (30)</th>
              <th>기말 (30)</th>
              <th>총점 (100)</th>
              <th>평점 (4.5)</th>
              <th>등급</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="stdnt" items="${sbjectScr}" varStatus="status">
              <tr>
                <td>${stdnt.stdntNo}</td>
                <td>${stdnt.stdntNm}</td>

                <input type="hidden" name="grades[${status.index}].atnlcReqstNo" value="${stdnt.atnlcReqstNo}" />

                <td><input type="number" min="0" max="100" name="grades[${status.index}].atendScore"  value="${stdnt.atendScore}"  class="form-control form-control-sm score-input" readonly></td>
                <td><input type="number" min="0" max="100" name="grades[${status.index}].taskScore"   value="${stdnt.taskScore}"   class="form-control form-control-sm score-input" readonly></td>
                <td><input type="number" min="0" max="100" name="grades[${status.index}].middleScore" class="form-control form-control-sm score-input" value="${stdnt.middleScore}" readonly></td>
                <td><input type="number" min="0" max="100" name="grades[${status.index}].trmendScore" class="form-control form-control-sm score-input" value="${stdnt.trmendScore}" readonly></td>

                <td><input type="number" name="grades[${status.index}].sbjectTotpoint" value="${stdnt.sbjectTotpoint}" class="form-control form-control-sm bg-light text-center fw-semibold" readonly></td>
                <td><input type="number" name="grades[${status.index}].pntAvrg" value="${stdnt.pntAvrg}" class="form-control form-control-sm bg-light text-center" readonly></td>
                <td><input type="text"   name="grades[${status.index}].pntGrad" value="${stdnt.pntGrad}" class="form-control form-control-sm bg-light text-center" readonly></td>
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
            <button type="submit" id="saveBtn" class="btn btn-primary me-2" style="display:none;">저장</button>
            <button type="button" id="cancelBtn" class="btn btn-secondary" style="display:none;">취소</button>
          </div>
        </c:if>
      </div>
    </form>

<%@ include file="../footer.jsp" %>
