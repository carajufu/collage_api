<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="../header.jsp" %>

  <div class="flex-grow-1 p-1 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">강의 목록</h2>

    <c:if test="${empty allCourseList}">
      <div class="alert alert-info text-center">표시할 강의가 없습니다.</div>
    </c:if>

    <c:if test="${not empty allCourseList}">
      <div class="table-responsive">
        <table class="table table-hover align-middle">
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
                <!-- 순번 -->
                <td class="text-center">${status.count}</td>

                <!-- 개설강의명 -->
                <td><strong>${lecture.lctreNm}</strong></td>

                <!-- 강의코드 -->
                <td class="text-center">${lecture.lctreCode}</td>

                <!-- 개설년도 -->
                <td class="text-center">${lecture.estblYear}</td>

                <!-- 개설학기 -->
                <td class="text-center">${lecture.estblSemstr}</td>

                <!-- 이수구분 -->
                <td class="text-center">${lecture.complSe}</td>

                <!-- 취득학점 -->
                <td class="text-center">${lecture.acqsPnt}</td>

                <!-- 수강정원 -->
                <td class="text-center">${lecture.atnlcNmpr}</td>

                <!-- 수업언어 -->
                <td class="text-center">${lecture.lctreUseLang}</td>

                <!-- 상세보기 -->
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

<%@ include file="../footer.jsp" %>
