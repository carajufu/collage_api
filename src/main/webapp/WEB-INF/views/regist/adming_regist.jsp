<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="../header.jsp" %>

<style>
body {
  background-color: #f8fafc;
  font-family: "Pretendard", "Noto Sans KR", sans-serif;
}
.container {
  max-width: 900px;
}
.card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  padding: 30px;
}
h3 {
  color: #1e3a8a;
  font-weight: 700;
}
label {
  font-weight: 500;
}
.btn-primary {
  background-color: #1e3a8a;
  border: none;
}
.btn-primary:hover {
  background-color: #153e90;
}
</style>

<div class="container py-5">
  <h3 class="mb-4">등록금 등록</h3>

  <form action="${pageContext.request.contextPath}/regist/insertRegistCt" method="post" class="card">
    <div class="row g-3">
      <div class="col-md-6">
        <label class="form-label">학생번호</label>
        <input type="text" name="stdntNo" class="form-control" required>
      </div>
      <div class="col-md-6">
        <label class="form-label">학기</label>
        <input type="text" name="semester" class="form-control" placeholder="예: 2025-1학기" required>
      </div>
      <div class="col-md-6">
        <label class="form-label">등록금 금액</label>
        <input type="number" name="rqestGld" class="form-control" placeholder="3500000" required>
      </div>
      <div class="col-md-6">
        <label class="form-label">장학금 금액</label>
        <input type="number" name="schlship" class="form-control" value="0">
      </div>
    </div>
    <div class="text-end mt-4">
      <button type="submit" class="btn btn-primary px-4">등록</button>
    </div>
  </form>
</div>

<%@ include file="../footer.jsp" %>
