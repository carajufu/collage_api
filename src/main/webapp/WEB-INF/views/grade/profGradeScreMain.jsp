<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

    <h2 class="border-bottom pb-2 mb-2">개설 강의 목록</h2>

    <div class="d-flex justify-content-end mb-3 mt-0">
      <input type="text" id="lectureSearch" class="form-control w-25" placeholder="강의명 / 코드 / 연도 / 학기 검색">
      <button type="submit" class="btn btn-primary ms-2">검색</button>
    </div>
	
    <c:if test="${empty allCourseList}">
      <div class="alert alert-warning text-center">등록된 강의가 없습니다.</div>
    </c:if>

    <c:if test="${not empty allCourseList}">
      <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle text-center">
          <thead class="table-light">
            <tr>
              <th>No.</th>
              <th class="text-start">강의명</th>
              <th>강의코드</th>
              <th>강의실</th>
              <th>이수구분</th>
              <th>개설년도</th>
              <th>개설학기</th>
              <th>성적입력</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="course" items="${allCourseList}" varStatus="status">
              <tr>
                <td>${status.count}</td>
                <td class="text-start fw-semibold">${course.lctreNm}</td>
                <td>${course.lctreCode}</td>
                <td>${course.lctrum}</td>
                <td>${course.complSe}</td>
                <td>${course.estblYear}</td>
                <td>${course.estblSemstr}</td>
                <td>
                  <a href="/prof/grade/main/detail/${course.estbllctreCode}" class="btn btn-sm btn-primary">보기</a>
                </td>
              </tr>
            </c:forEach>
          </tbody>

        </table>
      </div>
    </c:if>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {

  const searchInput = document.getElementById("lectureSearch");
  const table = document.querySelector("table");
  const rows = table.getElementsByTagName("tr");

  const searchBtn = document.querySelector(".btn.btn-primary");
  searchBtn.addEventListener("click", function(e) {
    e.preventDefault();
    searchInput.dispatchEvent(new Event("keyup"));
  });

  searchInput.addEventListener("keyup", () => {
    const keyword = searchInput.value.toLowerCase();

    for (let i = 1; i < rows.length; i++) {
      const rowText = rows[i].innerText.toLowerCase();

      if (rowText.includes(keyword)) {
        rows[i].style.display = "";
      } else {
        rows[i].style.display = "none";
      }
    }
  });

});
</script>

<%@ include file="../footer.jsp" %>
