<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">학생 마이페이지</h2>

    <!-- 학생 기본/계정 정보 -->
    <div class="row g-3 mb-4">
      <div class="col-md-6">
        <div class="card">
          <div class="card-header">학생 정보</div>
          <div class="card-body">
            <p class="mb-1"><strong>학번</strong> : ${stdntInfo.stdntNo}</p>
            <p class="mb-1"><strong>이름</strong> : ${stdntInfo.stdntNm}</p>
            <p class="mb-1"><strong>학적상태</strong> : ${stdntInfo.sknrgsSttus}</p>
          </div>
        </div>
      </div>

      <!-- 계정 정보 + 프로필 업로드/미리보기 -->
      <div class="col-md-6">
        <div class="card">
          <div class="card-header d-flex justify-content-between align-items-center">
            <span>계정 정보</span>
          </div>
          <div class="card-body">
            <div class="d-flex align-items-start gap-3">
              <!-- 프로필 미리보기 -->
              <div class="text-center">
                <img
                  src="<c:out value='${empty profileImagePath ? "/img/default-profile.png" : profileImagePath}'/>"
                  alt="프로필 이미지"
                  style="width:120px;height:120px;object-fit:cover;border-radius:50%;border:1px solid #ddd;" />
                <div class="small text-muted mt-2">
                  <c:choose>
                    <c:when test="${not empty profileImagePath}">업로드된 이미지</c:when>
                    <c:otherwise>기본 이미지</c:otherwise>
                  </c:choose>
                </div>
              </div>

              <!-- 계정 정보 -->
              <div class="flex-grow-1">
                <p class="mb-1"><strong>계정ID</strong> : ${acntInfo.acntId}</p>
                <p class="mb-1"><strong>파일그룹번호</strong> : ${acntInfo.fileGroupNo}</p>

                <!-- 프로필 업로드 UI -->
                <form action="/stdnt/main/uploadProfile" method="post" enctype="multipart/form-data" class="mt-2">
                  <div class="input-group">
                    <input type="file" name="uploadFile" class="form-control" required>
                    <button type="submit" class="btn btn-secondary">프로필 업로드</button>
                  </div>
                </form>
              </div>
            </div>

          </div>
        </div>
      </div>
    </div>

    <!-- 학기 선택 -->
    <form method="get" action="/stdnt/main/status" class="row mb-4">
      <div class="col-md-3">
        <select name="semstr" class="form-select">
          <c:forEach var="s" items="${semstrList}">
            <option value="${s.semstrScreInnb}"
              <c:if test="${selectedSemstr == s.semstrScreInnb}">selected</c:if>>
              ${s.year}년 ${s.semstr}
            </option>
          </c:forEach>
        </select>
      </div>
      <div class="col-md-2">
        <button class="btn btn-primary w-100">조회</button>
      </div>
    </form>

    <div class="row mb-5">
      <!-- 수강 목록 -->
      <div class="col-lg-8">
        <h5 class="fw-bold mb-3">수강 중 강의 목록</h5>
        <div class="table-responsive mb-3">
          <table class="table table-bordered table-hover align-middle text-center">
            <thead class="table-light">
              <tr>
                <th>강의코드</th>
                <th class="text-start">강의명</th>
                <th>학점</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="lec" items="${historyList}">
                <tr>
                  <td>${lec.lctreCode}</td>
                  <td class="text-start">
                    <a href="/stdnt/lecture/detail?estbllctreCode=${lec.estbllctreCode}"
                       class="fw-bold text-decoration-none">${lec.lctreNm}</a>
                  </td>
                  <td>${lec.acqsPnt}</td>
                </tr>
              </c:forEach>
              <c:if test="${empty historyList}">
                <tr>
                  <td colspan="3" class="text-center text-muted p-5">수강 중인 강의가 없습니다.</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </div>

      <!-- 요약 패널 -->
      <div class="col-lg-4">
        <div class="card mb-3">
          <div class="card-header">학점 요약</div>
          <div class="card-body">
            <p class="mb-1"><strong>총 이수학점</strong> : ${summary}</p>
            <p class="mb-1"><strong>전공 학점</strong> : ${majorPnt}</p>
            <p class="mb-0"><strong>교양 학점</strong> : ${culturePnt}</p>
          </div>
        </div>

        <div class="card">
          <div class="card-header">출결 요약</div>
          <div class="card-body">
            <p class="mb-1"><strong>출석</strong> : ${attendance.attendCnt}</p>
            <p class="mb-1"><strong>지각</strong> : ${attendance.lateCnt}</p>
            <p class="mb-0"><strong>결석</strong> : ${attendance.absentCnt}</p>
          </div>
        </div>
      </div>
    </div>

  </div>
</div>
