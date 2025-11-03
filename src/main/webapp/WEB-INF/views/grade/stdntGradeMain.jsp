<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">학기별 성적 조회</h2>

    <c:if test="${empty getAllSemstr}">
      <div class="alert alert-warning">조회 가능한 학기 성적이 없습니다.</div>
    </c:if>

    <c:if test="${not empty getAllSemstr}">
      <table class="table table-bordered table-hover align-middle text-center">
        <thead class="table-light">
          <tr>
            <th>년도</th>
            <th>학기</th>
            <th>총점</th>
            <th>평균</th>
            <th>등급</th>
            <th>취득학점</th>
            <th>상세조회</th>
          </tr>
        </thead>

        <tbody>
          <c:forEach var="sem" items="${getAllSemstr}">
            <tr>
              <td>${sem.year}</td>
              <td>${sem.semstr}</td>
              <td>${sem.semstrTotpoint}</td>
              <td>${sem.pntAvrg}</td>
              <td>${sem.pntGrad}</td>
              <td>${sem.totAcqsPnt}</td>

              <td>
                <a href="/stdnt/grade/main/detail/${sem.semstrScreInnb}" 
                   class="btn btn-outline-primary btn-sm">상세보기</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>

      </table>
    </c:if>

  </div>
</div>