<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">강의평가 목록</h2>
    <p class="text-muted mb-4">수강한 강의 중 아직 평가하지 않은 강의를 확인하고 제출합니다.</p>

    <c:if test="${empty atnlcList}">
      <div class="alert alert-info text-center">
        현재 평가 가능한 강의가 없습니다.
      </div>
    </c:if>

    <c:if test="${not empty atnlcList}">
      <div class="table-responsive">
        <table class="table table-hover align-middle text-center">
          <thead class="table-light">
            <tr>
              <th style="width: 6%;">No.</th>
              <th style="width: 25%;">개설강의명</th>
              <th>강의코드</th>
              <th>개설년도</th>
              <th>학기</th>
              <th>이수구분</th>
              <th>학점</th>
              <th>수강정원</th>
              <th>수업언어</th>
              <th style="width: 12%;">평가하기</th>
            </tr>
          </thead>

          <tbody>
            <c:forEach var="lecture" items="${atnlcList}" varStatus="status">
              <tr>
                <td>${status.count}</td>
                
                <td class="text-start"><strong>${lecture.lctreNm}</strong></td>
                <td>${lecture.lctreCode}</td>
                <td>${lecture.estblYear}</td>
                <td>${lecture.estblSemstr}</td>
                <td>${lecture.complSe}</td>
                <td>${lecture.acqsPnt}</td>
                <td>${lecture.atnlcNmpr}</td>
                <td>${lecture.lctreUseLang}</td>
                <td>
                  <a href="/stdnt/lecture/main/${lecture.estbllctreCode}" class="btn btn-primary btn-sm">
                    평가하기
                  </a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:if>
	
<!--<%@ include file="../footer.jsp" %>-->

  </div>
</div>
