<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<body>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">과목별 성적 상세 조회</h2>

    <c:if test="${empty detailScore}">
      <div class="alert alert-warning">조회된 성적이 없습니다.</div>
    </c:if>

    <c:if test="${not empty detailScore}">
      <div class="card p-4 shadow-sm mb-3">

        <h4 class="mb-3"><strong>${detailScore.lctreNm}</strong></h4>

        <table class="table table-bordered text-center align-middle">
          <thead class="table-light">
            <tr>
              <th>항목</th>
              <th>점수</th>
            </tr>
          </thead>
          <tbody>
            <tr><td>출석</td><td>${detailScore.atendScore}</td></tr>
            <tr><td>과제</td><td>${detailScore.taskScore}</td></tr>
            <tr><td>중간시험</td><td>${detailScore.middleScore}</td></tr>
            <tr><td>기말시험</td><td>${detailScore.trmendScore}</td></tr>
            <tr class="table-secondary"><td><strong>총점</strong></td><td><strong>${detailScore.sbjectTotpoint}</strong></td></tr>
            <tr class="table-success"><td><strong>학점</strong></td><td><strong>${detailScore.pntGrad}</strong></td></tr>
          </tbody>
        </table>

        <a href="/stdnt/grade/main/All" class="btn btn-outline-secondary mt-3">← 목록으로</a>
      </div>
    </c:if>

  </div>
</div>

<!--<%@ include file="../footer.jsp" %>-->

</body>
</html>
