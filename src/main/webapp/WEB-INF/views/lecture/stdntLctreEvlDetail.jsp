<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- header.jsp가 필요합니다 --%>
<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">강의평가</h2>

    <section class="card shadow-sm mb-4">
      <div class="card-header bg-light">
        <h5 class="card-title mb-0"><i class="bi bi-journal-text"></i> 강의 정보</h5>
      </div>
      <div class="card-body p-4">
        <div class="row mb-2">
          <div class="col-md-6"><strong>강의명:</strong> ${lectureInfo.lctreNm}</div>
          <div class="col-md-6"><strong>교수명:</strong> ${lectureInfo.profsrNm}</div>
        </div>
        <div class="row mb-2">
          <div class="col-md-6"><strong>운영년도:</strong> ${lectureInfo.estblYear}</div>
          <div class="col-md-6"><strong>학기:</strong> ${lectureInfo.estblSemstr}</div>
        </div>
        <div class="row mb-2">
          <div class="col-md-6"><strong>취득학점:</strong> ${lectureInfo.acqsPnt}</div>
          <div class="col-md-6"><strong>이수구분:</strong> ${lectureInfo.complSe}</div>
        </div>
      </div>
    </section>

    <section class="card shadow-sm mb-4">
      <div class="card-header bg-light">
        <h5 class="card-title mb-0"><i class="bi bi-check2-square"></i> 평가 항목</h5>
      </div>
      <div class="card-body p-4">
        
        <input type="hidden" id="estbllctreCode" value="${estbllctreCode}" />

        <c:if test="${empty evalItemList}">
          <div class="alert alert-warning">
            등록된 평가 항목이 없습니다. 관리자에게 문의하세요.
          </div>
        </c:if>

        <c:if test="${not empty evalItemList}">
          <form id="evalForm">
            <c:forEach var="item" items="${evalItemList}" varStatus="status">
              <div class="mb-4 p-3 border rounded">
                <h6 class="mb-3">
                  ${status.count}. ${item.evlCn}
                </h6>
                
                <div class="mb-3 d-flex justify-content-center eval-score-group">
                  <input type="radio" class="btn-check" name="evlScore_${status.count}" id="score_${status.count}_1" value="1" required>
                  <label class="btn btn-outline-secondary me-2" for="score_${status.count}_1">1점 (매우 불만족)</label>

                  <input type="radio" class="btn-check" name="evlScore_${status.count}" id="score_${status.count}_2" value="2" required>
                  <label class="btn btn-outline-secondary me-2" for="score_${status.count}_2">2점 (불만족)</label>

                  <input type="radio" class="btn-check" name="evlScore_${status.count}" id="score_${status.count}_3" value="3" required>
                  <label class="btn btn-outline-primary me-2" for="score_${status.count}_3">3점 (보통)</label>

                  <input type="radio" class="btn-check" name="evlScore_${status.count}" id="score_${status.count}_4" value="4" required>
                  <label class="btn btn-outline-primary me-2" for="score_${status.count}_4">4점 (만족)</label>

                  <input type="radio" class="btn-check" name="evlScore_${status.count}" id="score_${status.count}_5" value="5" required>
                  <label class="btn btn-outline-primary" for="score_${status.count}_5">5점 (매우 만족)</label>
                </div>
                
                <div class="mb-2">
                  <textarea class="form-control eval-cn" rows="2" placeholder="주관식 의견을 남겨주세요 (선택)"></textarea>
                </div>
              </div>
            </c:forEach>
            
            <div class="mt-4 d-flex justify-content-between">
              <a href="/stdnt/lecture/main/All" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> 목록으로
              </a>
              <button type="button" id="submitBtn" class="btn btn-primary">
                <i class="bi bi-send"></i> 평가 제출하기
              </button>
            </div>
          </form>
        </c:if>
      </div>
    </section>

<!--	<%@ include file="../footer.jsp" %>-->
	
  </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const submitBtn = document.getElementById("submitBtn");
    
    if (submitBtn) {
        submitBtn.addEventListener("click", function() {
            
            const form = document.getElementById("evalForm");
            
            // 1. 유효성 검사 (모든 라디오 그룹이 선택되었는지)
            const radioGroups = document.querySelectorAll(".eval-score-group");
            let allAnswered = true;
            radioGroups.forEach((group, index) => {
                // 'name' 속성을 기반으로 선택된 라디오를 찾음
                if (!form.querySelector(`input[name="evlScore_${index + 1}"]:checked`)) {
                    allAnswered = false;
                }
            });

            if (!allAnswered) {
                alert("모든 평가 항목(1~5점)에 응답해야 합니다.");
                return;
            }

            // 2. 데이터 수집
            const evlScore = [];
            radioGroups.forEach((group, index) => {
                const score = form.querySelector(`input[name="evlScore_${index + 1}"]:checked`).value;
                evlScore.push(parseInt(score)); // 숫자로 변환
            });

            const evlCn = [];
            document.querySelectorAll(".eval-cn").forEach(textarea => {
                evlCn.push(textarea.value);
            });
            
            const estbllctreCode = document.getElementById("estbllctreCode").value;
            
            // 3. 컨트롤러에서 정의한 JSON 형식으로 데이터 객체 생성
            const data = {
                estbllctreCode: estbllctreCode,
                evlScore: evlScore,
                evlCn: evlCn
                // ★ stdntNo는 컨트롤러(서버)에서 세션을 통해 가져오므로 전송하지 않습니다.
            };

            // 4. AJAX (fetch) POST 전송
            if (!confirm("강의평가를 제출하시겠습니까? 제출 후 수정할 수 없습니다.")) {
                return;
            }
            
            fetch("/stdnt/lecture/main/detail/post/submit", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                    // (필요시) CSRF 토큰 헤더 추가
                },
                body: JSON.stringify(data)
            })
            .then(response => response.text())
            .then(result => {
                if (result === "success") {
                    alert("강의평가가 성공적으로 제출되었습니다.");
                    // 목록 페이지로 이동
                    location.href = "/stdnt/lecture/main/All";
                } else if (result === "fail_auth") {
                    alert("인증 정보가 올바르지 않습니다. 다시 로그인해주세요.");
                } else {
                    alert("서버 오류로 제출에 실패했습니다. 관리자에게 문의하세요.");
                }
            })
            .catch(error => {
                console.error("Submit Error:", error);
                alert("전송 중 오류가 발생했습니다.");
            });
        });
    }
});
</script>


