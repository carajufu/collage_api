<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

<div class="flex-grow-1 p-3 overflow-auto">

  <h2 class="border-bottom pb-3 mb-4 fw-semibold">강의평가</h2>

  <!-- 강의 정보 -->
  <div class="card mb-4 shadow-sm">
    <div class="card-header bg-light fw-semibold">강의 정보</div>
    <div class="card-body p-4">
      <table class="table table-bordered align-middle mb-0">
        <tbody>
          <tr><th class="table-light" style="width:20%;">강의명</th><td>${lectureInfo.lctreNm}</td></tr>
          <tr><th class="table-light">교수명</th><td>${lectureInfo.profsrNm}</td></tr>
          <tr><th class="table-light">운영년도</th><td>${lectureInfo.estblYear}</td></tr>
          <tr><th class="table-light">학기</th><td>${lectureInfo.estblSemstr}</td></tr>
          <tr><th class="table-light">취득학점</th><td>${lectureInfo.acqsPnt}</td></tr>
          <tr><th class="table-light">이수구분</th><td>${lectureInfo.complSe}</td></tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- 학생 평가 입력 -->
  <div class="card shadow-sm">
    <div class="card-header bg-light fw-semibold">평가 항목</div>
    <div class="card-body p-4">

      <input type="hidden" id="estbllctreCode" value="${estbllctreCode}" />

      <form id="evalForm">

        <!-- 문항 단위 컨테이너: .eval-item -->
        <c:forEach var="item" items="${evalItemList}" varStatus="status">
          <div class="eval-item mb-4 pb-3 border-bottom">

            <p class="fw-semibold mb-3">${status.count}. ${item.evlCn}</p>

            <div class="d-flex gap-2 justify-content-center">

              <input type="radio" class="btn-check"
                     name="evlScore_${status.index}" id="score_${status.index}_1" value="1">
              <label class="btn btn-outline-warning w-100" for="score_${status.index}_1">1점</label>

              <input type="radio" class="btn-check"
                     name="evlScore_${status.index}" id="score_${status.index}_2" value="2">
              <label class="btn btn-outline-warning w-100" for="score_${status.index}_2">2점</label>

              <input type="radio" class="btn-check"
                     name="evlScore_${status.index}" id="score_${status.index}_3" value="3">
              <label class="btn btn-outline-primary w-100" for="score_${status.index}_3">3점</label>

              <input type="radio" class="btn-check"
                     name="evlScore_${status.index}" id="score_${status.index}_4" value="4">
              <label class="btn btn-outline-success w-100" for="score_${status.index}_4">4점</label>

              <input type="radio" class="btn-check"
                     name="evlScore_${status.index}" id="score_${status.index}_5" value="5">
              <label class="btn btn-outline-success w-100" for="score_${status.index}_5">5점</label>

            </div>

            <textarea class="form-control eval-cn mt-3" rows="2"
                      placeholder="주관식 의견을 입력하실 수 있습니다."></textarea>

          </div>
        </c:forEach>

        <div class="d-flex justify-content-between mt-4">
          <a href="/stdnt/lecture/main/All" class="btn btn-secondary">목록으로</a>
          <button type="button" id="submitBtn" class="btn btn-primary">평가 제출하기</button>
        </div>

      </form>

    </div>
  </div>

</div>

<script>
document.addEventListener("DOMContentLoaded", () => {

  document.getElementById("submitBtn").addEventListener("click", () => {

    const estbllctreCode = document.getElementById("estbllctreCode").value;

    const payloadScore = [];
    const payloadCn = [];

    // 문항 블록 기준으로만 탐색
    const items = document.querySelectorAll(".eval-item");
    const textareas = document.querySelectorAll(".eval-cn");

    for (let i = 0; i < items.length; i++) {
      const item = items[i];

      // 이 문항 안에서만 체크된 라디오 찾기
      const checked = item.querySelector("input[type='radio']:checked");
      if (!checked) {
        alert((i + 1) + "번 항목 점수를 선택해 주세요.");
        return;
      }

      payloadScore.push(Number(checked.value));
      payloadCn.push(textareas[i].value.trim());
    }

    fetch("/stdnt/lecture/save", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        estbllctreCode: estbllctreCode,
        evlScore: payloadScore,
        evlCn: payloadCn
      })
    })
    .then(r => r.text())
    .then(result => {
      if (result === "success") {
        alert("강의평가가 정상적으로 제출되었습니다.");
        location.href = "/stdnt/lecture/main/All";
      } else {
        alert("오류가 발생했습니다.");
      }
    })
    .catch(err => {
      alert("서버 통신 오류가 발생했습니다.");
    });

  });

});
</script>

<%@ include file="../footer.jsp" %>
