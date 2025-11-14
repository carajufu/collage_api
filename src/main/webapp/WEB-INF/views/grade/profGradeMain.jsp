<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<body>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">개설 강의 목록</h2>

    <c:if test="${empty allCourseList}">
      <div class="alert alert-warning">등록된 강의가 없습니다.</div>
    </c:if>

    <c:if test="${not empty allCourseList}">
      <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle">

          <thead class="table-light">
            <tr class="text-center">
              <th>No.</th>
              <th class="text-start" style="width:25%;">강의명</th>
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
                <td class="text-center">${status.count}</td>
                <td class="text-start fw-semibold">${course.lctreNm}</td>
                <td class="text-center">${course.lctreCode}</td>
                <td class="text-center">${course.lctrum}</td>
                <td class="text-center">${course.complSe}</td>
                <td class="text-center">${course.estblYear}</td>
                <td class="text-center">${course.estblSemstr}</td>

                <td class="text-center">
                  <a href="/prof/grade/main/detail/${course.estbllctreCode}" class="btn btn-primary btn-sm px-3">입력</a>
                </td>

              </tr>
            </c:forEach>
          </tbody>

        </table>
      </div>
    </c:if>

  </div>
</div>

<%@ include file="../footer.jsp" %>

</body>
</html>
