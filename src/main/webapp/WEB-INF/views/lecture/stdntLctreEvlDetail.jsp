<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="../header.jsp" %>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(function() {
  $("#btnSubmit").click(function() {
    const estbllctreCode = $("input[name='estbllctreCode']").val();
    const stdntNo = $("input[name='stdntNo']").val();

    const evlScore = [];
    const evlCn = [];

    $(".evl-item").each(function(index) {
      const score = $(`input[name='evlScore_${index}']:checked`).val();
      evlScore.push(score ? parseInt(score) : 0);
      evlCn.push($(this).find(".evlCn").val() || "");
    });

    const payload = { estbllctreCode, stdntNo, evlScore, evlCn };
    console.log("전송 데이터:", payload);

    $.ajax({
      url: "/stdnt/lecture/main/detail/post/submit",
      type: "POST",
      data: JSON.stringify(payload),
      contentType: "application/json; charset=UTF-8",
      success: function(res) {
        alert("강의평가가 제출되었습니다.");
        window.location.href = "/stdnt/lecture/main/All";
      },
      error: function(err) {
        console.error("Ajax 오류:", err);
        alert("서버 통신 중 오류가 발생했습니다.");
      }
    });
  });
});
</script>

<div class="container-fluid p-4">
  <h2 class="border-bottom pb-3 mb-4">강의평가 작성</h2>

  <!-- 세션 미완으로 임시용 -->
  <input type="hidden" name="estbllctreCode" value="E250001">
  <input type="hidden" name="stdntNo" value="230101001">

  <!-- 단일 평가폼 -->
  <form id="evalForm">
    <div class="evl-item mb-4 p-3 border rounded">
      <label class="form-label mb-1"><strong>강의 전반에 대한 만족도</strong></label>
      <div class="mb-2">
        <c:forEach begin="1" end="5" var="i">
          <label class="form-check form-check-inline">
            <input type="radio" class="form-check-input" name="evlScore_0" value="${i}">${i}점
          </label>
        </c:forEach>
      </div>
      <textarea class="form-control evlCn" rows="3" placeholder="의견 입력 (선택사항)"></textarea>
    </div>

    <div class="text-center">
      <button type="button" id="btnSubmit" class="btn btn-primary">
        제출하기
      </button>
      <a href="/stdnt/lecture/main/All" class="btn btn-secondary">목록으로</a>
    </div>
  </form>
</div>

<%@ include file="../footer.jsp" %>
