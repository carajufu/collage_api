<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>

<html>
<body>

<%@ include file="../header.jsp" %>



<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">과목별 성적 입력</h2>
    <c:if test="${empty allSbject}">
      <div class="alert alert-warning" role="alert">
        등록된 강의가 없습니다.
      </div>
    </c:if>

    <c:if test="${not empty allSbject}">
      <table class="table table-bordered table-hover align-middle text-center">
        <thead class="table-light">
          <tr>
            <th>개설강의코드</th>
            <th>강의코드</th>
            <th>강의실</th>
            <th>이수구분</th>
            <th>개설년도</th>
            <th>개설학기</th>
            <th>입력</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="course" items="${allSbject}">
            <tr>
              <td>${course.estbllctreCode}</td>
              <td>${course.lctreCode}</td>
              <td>${course.lctrum}</td>
              <td>${course.complSe}</td>
              <td>${course.estblYear}</td>
              <td>${course.estblSemstr}</td>
              <td>
               <c:url var="detailUrl" value="/prof/grade/main/detail/${course.estbllctreCode}" />
				<a href="${detailUrl}" class="btn btn-primary btn-sm" role="button">
				  학생별 성적입력
				</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>

  </div>
</div>

<%-- <%@ include file="../footer.jsp" %> --%>

</body>
</html>