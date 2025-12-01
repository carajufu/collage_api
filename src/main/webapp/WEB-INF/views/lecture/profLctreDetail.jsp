<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">강의평가 상세 보기</h2>

    <!-- [1] 강의 기본정보 -->
    <div class="card shadow-sm mb-4">
      <div class="card-header bg-light p-3">
        <h4 class="card-title mb-0">
          <i class="bi bi-journal-text"></i>
          강의(개설)코드: <strong>${lectureName}</strong>
        </h4>
      </div>
      <div class="card-body">
        <p><strong>강의코드:</strong> ${estblCourseInfo.lctreCode}</p>
        <p><strong>교수번호:</strong> ${estblCourseInfo.profsrNo}</p>
        <p><strong>취득학점:</strong> ${estblCourseInfo.acqsPnt}</p>
        <p><strong>수업 언어:</strong> ${estblCourseInfo.lctreUseLang}</p>
        <p><strong>운영년도/학기:</strong> ${estblCourseInfo.estblYear} / ${estblCourseInfo.estblSemstr}</p>
      </div>
    </div>

    <!-- [2] 강의평가 요약 (LCTRE_EVL) -->
    <div class="card shadow-sm mb-4">
      <div class="card-header bg-light p-3">
        <h5 class="card-title mb-0"><i class="bi bi-bar-chart-line"></i> 강의평가 요약</h5>
      </div>
      <div class="card-body">
        <c:if test="${empty evalList}">
          <div class="text-muted">등록된 평가 기본정보가 없습니다.</div>
        </c:if>
        <c:forEach var="eval" items="${evalList}">
          <div class="mb-3">
            <p class="mb-1"><strong>평가번호:</strong> ${eval.evlNo}</p>
            <p class="mb-1"><strong>전체 평균점수:</strong>
              <c:out value="${eval.allEvlAvrg}" default="-" /> / 5
            <p class="mb-1"><strong>평가명:</strong> ${eval.evlCn}</p>
            </p>
            <!-- evalCn 제거 (테이블에 없음) -->
          </div>
        </c:forEach>
      </div>
    </div>

    <!-- [3] 강의 시간표 (LCTRE_TIMETABLE) -->
    <div class="card shadow-sm mb-4">
      <div class="card-header bg-light p-3">
        <h5 class="card-title mb-0"><i class="bi bi-calendar-week"></i> 강의 시간표</h5>
      </div>
      <div class="card-body">
        <c:if test="${empty timetableList}">
          <div class="text-muted">등록된 시간표가 없습니다.</div>
        </c:if>
        <c:if test="${not empty timetableList}">
          <table class="table table-hover">
            <thead class="table-light">
              <tr>
                <th>요일</th>
                <th>시작 교시</th>
                <th>종료 교시</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="time" items="${timetableList}">
                <tr>
                  <td>${time.lctreDfk}</td>
                  <td>${time.beginTm}교시</td>
                  <td>${time.endTm}교시</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:if>
      </div>
    </div>

    <div class="mt-4 d-flex justify-content-between">
      <a href="/prof/lecture/main/All" class="btn btn-secondary">
        <i class="bi bi-arrow-left"></i> 목록으로
      </a>
    </div>

  </div>
</div>

<%@ include file="../footer.jsp" %>
