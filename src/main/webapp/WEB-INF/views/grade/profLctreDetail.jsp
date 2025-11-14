<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <!-- 제목 -->
    <h2 class="border-bottom pb-3 mb-4">성적 조회</h2>

    <!-- 요약 카드 -->
    <div class="card shadow-sm mb-4">
      <div class="card-header bg-light p-3">
        <h4 class="card-title mb-0">
          <i class="bi bi-person-fill"></i> 학생 ID: <strong>${sessionScope.stdntId}</strong>
        </h4>
      </div>
      <div class="card-body">
        <div class="row text-center">
          <div class="col-md-4">
            <h6 class="text-muted mb-1">총 수강 과목 수</h6>
            <h4>${totalCourses}</h4>
          </div>
          <div class="col-md-4">
            <h6 class="text-muted mb-1">평균 평점</h6>
            <h4><fmt:formatNumber value="${avgGrade}" type="number" maxFractionDigits="2"/></h4>
          </div>
          <div class="col-md-4">
            <h6 class="text-muted mb-1">학기</h6>
            <h4>2025-1</h4>
          </div>
        </div>
      </div>
    </div>

    <!-- 성적 목록 -->
    <div class="card shadow-sm">
      <div class="card-header bg-light p-3">
        <h5 class="card-title mb-0">
          <i class="bi bi-list-ul"></i> 과목별 성적
        </h5>
      </div>

      <div class="card-body">
        <table class="table table-hover align-middle">
          <thead class="table-light">
            <tr>
              <th>개설강의ID</th>
              <th>강의명</th>
              <th>교수명</th>
              <th>등급</th>
              <th>환산점수</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty gradeList}">
                <c:forEach var="grade" items="${gradeList}">
                  <tr>
                    <td>${grade.estblCourseId}</td>
                    <td>${grade.lectureName}</td>
                    <td>${grade.profName}</td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty grade.grade}">
                          ${grade.grade}
                        </c:when>
                        <c:otherwise>
                          <span class="text-muted">미입력</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${grade.gradePoint ne null}">
                          <fmt:formatNumber value="${grade.gradePoint}" type="number" maxFractionDigits="2"/> / 4.5
                        </c:when>
                        <c:otherwise>
                          <span class="text-muted">-</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="5" class="text-center text-muted py-4">
                    조회된 성적이 없습니다.
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>

    <!-- 버튼 영역 -->
    <div class="mt-4 d-flex justify-content-between">
      <a href="/stdnt/home" class="btn btn-secondary">
        <i class="bi bi-arrow-left"></i> 메인으로
      </a>
      <a href="/stdnt/grade/evalList" class="btn btn-primary">
        <i class="bi bi-pencil-square"></i> 강의평가 하러가기
      </a>
    </div>

  </div>
</div>

<%@ include file="../footer.jsp" %>
