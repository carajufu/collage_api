<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">과목별 성적 상세</h2>

    <c:if test="${empty subjectList}">
      <div class="alert alert-warning">과목 성적 정보가 없습니다.</div>
    </c:if>

    <c:if test="${not empty subjectList}">
      <table class="table table-bordered table-hover align-middle text-center">
        <thead class="table-light">
          <tr>
            <th class="text-start">과목명</th>
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
          <c:forEach var="grade" items="${subjectList}">
            <tr>
              <td class="text-start">${grade.lctreNm}</td>
              <td>${grade.atendScore}</td>
              <td>${grade.taskScore}</td>
              <td>${grade.middleScore}</td>
              <td>${grade.trmendScore}</td>
              <td>${grade.sbjectTotpoint}</td>
              <td>${grade.pntAvrg}</td> 
              <td>${grade.pntGrad}</td>
            </tr>
          </c:forEach>
        </tbody>

      </table>
    </c:if>

    <div class="mt-3">
      <a href="/stdnt/grade/main/All" class="btn btn-secondary btn-sm">뒤로가기</a>
    </div>

  </div>
</div>