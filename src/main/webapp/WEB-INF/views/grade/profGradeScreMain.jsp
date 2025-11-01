<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<body>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">과목별 성적 입력</h2>

    <!-- =========================================================
         검색 영역 (검색항목 = 목록항목과 일치)
         ========================================================= -->
    <form method="get" class="mb-3">
      <div class="row g-2">

        <div class="col-md-3">
          <label class="form-label">개설강의코드</label>
          <input type="text" name="estbllctreCode" class="form-control" value="${param.estbllctreCode}">
        </div>

        <div class="col-md-3">
          <label class="form-label">강의코드</label>
          <input type="text" name="lctreCode" class="form-control" value="${param.lctreCode}">
        </div>

        <div class="col-md-2">
          <label class="form-label">개설년도</label>
          <input type="number" name="estblYear" class="form-control" value="${param.estblYear}">
        </div>

        <div class="col-md-2">
          <label class="form-label">개설학기</label>
          <select name="estblSemstr" class="form-select">
            <option value="">전체</option>
            <option value="1" ${param.estblSemstr == '1' ? 'selected' : ''}>1학기</option>
            <option value="2" ${param.estblSemstr == '2' ? 'selected' : ''}>2학기</option>
          </select>
        </div>

        <div class="col-md-2 d-flex align-items-end">
          <button type="submit" class="btn btn-primary w-100">검색</button>
        </div>
      </div>
    </form>


    <!-- =========================================================
         빈 목록 안내
         ========================================================= -->
    <c:if test="${empty allSbject}">
      <div class="alert alert-warning" role="alert">
        등록된 강의가 없습니다.
        <div class="mt-2">
          <a href="/prof/grade/main/All" class="btn btn-secondary btn-sm">메인으로</a>
        </div>
      </div>
    </c:if>

    <!-- =========================================================
         목록 테이블 (table-responsive 적용)
         ========================================================= -->
    <c:if test="${not empty allSbject}">
      <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle">
          <thead class="table-light text-center">
            <tr>
              <th>개설강의코드</th>
              <th>강의코드</th>
              <th>개설년도</th>
              <th>개설학기</th>
              <th class="text-start">이수구분</th>
              <th class="text-start">강의실</th>
              <th>입력</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="course" items="${allSbject}">
              <tr>
                <td class="text-center">${course.estbllctreCode}</td>
                <td class="text-center">${course.lctreCode}</td>
                <td class="text-center">${course.estblYear}</td>
                <td class="text-center">${course.estblSemstr}</td>
                <td class="text-start">${course.complSe}</td>
                <td class="text-start">${course.lctrum}</td>

                <td class="text-center">
                  <c:url var="detailUrl" value="/prof/grade/main/detail/${course.estbllctreCode}" />
                  <a href="${detailUrl}" class="btn btn-primary btn-sm" role="button">
                    학생별 성적입력
                  </a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:if>

    <!-- =========================================================
         페이징 (예시 / 서버 페이징 연동 시 교체 가능)
         ========================================================= -->
    <c:if test="${not empty allSbject}">
      <nav aria-label="pagination" class="mt-3">
        <ul class="pagination justify-content-center">
          <li class="page-item"><a class="page-link" href="?page=1">1</a></li>
          <li class="page-item"><a class="page-link" href="?page=2">2</a></li>
          <li class="page-item"><a class="page-link" href="?page=3">3</a></li>
        </ul>
      </nav>
    </c:if>

  </div>
</div>

<%-- <%@ include file="../footer.jsp" %> --%>

</body>
</html>
