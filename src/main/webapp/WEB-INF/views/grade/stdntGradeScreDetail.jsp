<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<body>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">수강 과목별 성적 조회</h2>

    <c:if test="${empty getAllScore}">
      <div class="alert alert-warning" role="alert">
        수강한 과목이 없습니다.
      </div>
    </c:if>

    <c:if test="${not empty getAllScore}">
      <table class="table table-bordered table-hover align-middle text-center">
        <thead class="table-light">
          <tr>
            <th>과목명</th>
            <th>출석</th>
            <th>과제</th>
            <th>중간</th>
            <th>기말</th>
            <th>총점</th>
            <th>평균</th>
            <th>등급</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="grade" items="${getAllScore}">
            <tr>
              <td>${grade.lctreNm}</td>
              <td>${grade.atendScore}</td>
              <td>${grade.taskScore}</td>
              <td>${grade.middleScore}</td>
              <td>${grade.trmendScore}</td>
              <td>${grade.sbjectTotpoint}</td>
              <td>${grade.avrgScore}</td>
              <td>${grade.pntGrad}</td>
              <td>
              </td>
            </tr>
          </c:forEach>
        </tbody>
        
      </table>
    </c:if>
        <a href="/stdnt/grade/main/All" class="btn btn-outline-primary btn-sm">메인으로</a>

  </div>
</div>

 
</body>
</html>
