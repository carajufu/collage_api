<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-1 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">강의평가 목록</h2>
    <p class="text-muted mb-4">해당 학기 수강 강의 중 아직 평가하지 않은 강의를 확인하세요.</p>

    <c:forEach var="lecture" items="${atnlcList}">
      <div class="card shadow-sm mb-4">
        <div class="card-header bg-light p-3 d-flex justify-content-between align-items-center">
          <h4 class="card-title mb-0">
            개설강의코드: <strong>${lecture.estbllctreCode}</strong>
          </h4>
          <small class="text-muted">${lecture.estblYear}년도 ${lecture.estblSemstr}학기</small>
        </div>

        <div class="card-body pb-2">
          <div class="d-flex flex-wrap gap-3 align-items-center">
            <span class="text-muted">
              <i class="bi bi-person-video3"></i> 교수번호: ${lecture.profsrNo}
            </span>
            <span class="text-muted">
              <i class="bi bi-alarm"></i> 취득 학점: ${lecture.acqsPnt}학점
            </span>
            <span class="text-muted">
              <i class="bi bi-people"></i> 수강 정원: ${lecture.atnlcNmpr}
            </span>
          </div>
        </div>

        <hr class="my-0">

        <div class="card-body border-top">
          <ul class="mb-0">
            <li>강의 코드: ${lecture.lctreCode}</li>
            <li>이수 구분: ${lecture.complSe}</li>
            <li>수업 언어: ${lecture.lctreUseLang}</li>
          </ul>
        </div>

        <div class="card-footer d-flex justify-content-end">
          <a href="/stdnt/lecture/main/${lecture.estbllctreCode}" class="btn btn-primary">
            <i class="bi bi-pencil-square"></i> 강의평가
          </a>
        </div>
      </div>
    </c:forEach>

    <c:if test="${empty atnlcList}">
      <div class="alert alert-info text-center">평가할 강의가 없습니다.</div>
    </c:if>

  </div>
</div>

<%@ include file="../footer.jsp" %>
