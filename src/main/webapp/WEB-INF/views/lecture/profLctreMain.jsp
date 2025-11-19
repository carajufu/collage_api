<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-1 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">강의 목록</h2>

    <c:forEach var="lecture" items="${allCourseList}">
      <div class="card shadow-sm mb-4">
        <div class="card-header bg-light p-3">
          <h4 class="card-title mb-0">
            개설강의명: <strong>${lecture.lctreNm}</strong>
          </h4>
        </div>

        <div class="card-body pb-2">
          <div class="d-flex flex-wrap gap-3 align-items-center">
            <span class="text-muted">
              <i class="bi bi-hash"></i> 강의코드: ${lecture.lctreCode}
            </span>
            <span class="text-muted">
              <i class="bi bi-people"></i> 수강 정원: ${lecture.atnlcNmpr}
            </span>
            <span class="text-muted">
              <i class="bi bi-calendar"></i> 개설년도: ${lecture.estblYear}
            </span>
            <span class="text-muted">
              <i class="bi bi-book"></i> 개설학기: ${lecture.estblSemstr}
            </span>
          </div>
        </div>

        <hr class="my-0">

        <div class="card-body border-top">
          <h6>기타 정보</h6>
          <ul class="mb-0">
            <li>이수 구분: ${lecture.complSe}</li>
            <li>수업 언어: ${lecture.lctreUseLang}</li>
            <li>취득 학점: ${lecture.acqsPnt}</li>
          </ul>
        </div>

        <div class="card-footer d-flex justify-content-between">
          <!-- lctreEvlInnb는 목록 데이터에 없음 → 제거 -->
          <a href="/prof/lecture/main/detail/${lecture.estbllctreCode}" class="btn btn-success">
            <i class="bi bi-search"></i> 상세 보기
          </a>
        </div>
      </div>
    </c:forEach>

    <c:if test="${empty allCourseList}">
      <div class="alert alert-info text-center">표시할 강의가 없습니다.</div>
    </c:if>

  </div>
</div>

<%@ include file="../footer.jsp" %>
