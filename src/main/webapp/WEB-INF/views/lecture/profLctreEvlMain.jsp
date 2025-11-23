<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>

<%@ include file="../header.jsp" %>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/prof"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">학사 정보</a></li>
            <li class="breadcrumb-item active" aria-current="page">강의 평가</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">강의 평가</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>
<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">

  <!-- 검색창 추가               -->
  <div class="d-flex justify-content-end mb-1">
    <input type="text" id="lectureSearch" class="form-control w-25" placeholder="강의명 / 코드 / 연도 / 학기 검색">
  </div>

  <c:if test="${empty allCourseList}">
    <div class="alert alert-info text-center">표시할 강의가 없습니다.</div>
  </c:if>

  <c:if test="${not empty allCourseList}">
    <div class="table-responsive">
      <table class="table table-hover align-middle" id="lectureTable">
        <thead class="table-light text-center">
          <tr>
            <th>No.</th>
            <th style="width: 25%;">개설강의명</th>
            <th>강의코드</th>
            <th>개설년도</th>
            <th>개설학기</th>
            <th>이수구분</th>
            <th>취득학점</th>
            <th>수강정원</th>
            <th>수업언어</th>
            <th>상세보기</th>
          </tr>
        </thead>

        <tbody>
          <c:forEach var="lecture" items="${allCourseList}" varStatus="status">
            <tr>
              <td class="text-center">${status.count}</td>
              <td><strong>${lecture.lctreNm}</strong></td>
              <td class="text-center">${lecture.lctreCode}</td>
              <td class="text-center">${lecture.estblYear}</td>
              <td class="text-center">${lecture.estblSemstr}</td>
              <td class="text-center">${lecture.complSe}</td>
              <td class="text-center">${lecture.acqsPnt}</td>
              <td class="text-center">${lecture.atnlcNmpr}</td>
              <td class="text-center">${lecture.lctreUseLang}</td>

              <td class="text-center">
                <a href="/prof/lecture/main/detail/${lecture.estbllctreCode}" class="btn btn-success btn-sm">
                  상세
                </a>
              </td>
            </tr>
          </c:forEach>
        </tbody>

      </table>
    </div>
  </c:if>
    </div>
</div>

<script>

document.addEventListener("DOMContentLoaded", () => {
  const searchInput = document.getElementById("lectureSearch");
  const table = document.getElementById("lectureTable");
  const rows = table.getElementsByTagName("tr");

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
