<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<body>

<%-- 공통 헤더 파일을 포함합니다. --%>
<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <h2 class="border-bottom pb-3 mb-4">수강 과목별 성적 조회</h2>

    <%-- 
      컨트롤러에서 전달받은 모델('getAllScore')이 비어있는지 확인합니다.
      비어있다면, 수강 과목이 없다는 메시지를 표시합니다.
    --%>
    <c:if test="${empty getAllScore}">
      <div class="alert alert-warning" role="alert">
        수강한 과목이 없습니다.
      </div>
    </c:if>

    <%-- 
      'getAllScore' 모델이 비어있지 않은 경우에만 테이블을 렌더링합니다.
    --%>
    <c:if test="${not empty getAllScore}">
      <table class="table table-bordered table-hover align-middle text-center">
        
        <%-- 테이블 헤더: 표시할 컬럼의 제목을 정의합니다. --%>
        <thead class="table-light">
          <tr>
            <%-- 
              'getAllSemstr' 쿼리에서 새로 가져온 'ESTBL_YEAR', 'ESTBL_SEMSTR'를 표시합니다. 
            --%>
            <th>년도</th>
            <th>학기</th>
            <th>총점</th>
            <th>평균</th>
            <th>등급</th>
            <%-- 'getAllSemstr' 쿼리에서 새로 가져온 'ACQS_PNT'를 표시합니다. --%>
            <th>취득학점</th>
            <th>상세조회</th>
          </tr>
        </thead>
        
        <%-- 
          테이블 본문: 
          컨트롤러에서 전달받은 'getAllScore' 리스트를 c:forEach 태그로 반복 순회합니다.
          각 항목은 'grade'라는 변수명으로 접근할 수 있습니다.
        --%>
        <tbody>
          <c:forEach var="grade" items="${getAllScore}">
            <tr>
              <%-- 'getAllSemstr' 쿼리의 ESTBL_YEAR 컬럼 값 --%>
              <td>${grade.year}</td>
              <%-- 'getAllSemstr' 쿼리의 ESTBL_SEMSTR 컬럼 값 --%>
              <td>${grade.semstr}</td>
              <td>${grade.sbjectTotpoint}</td>
              <%-- 'getAllSemstr' 쿼리의 AVRG_SCORE 컬럼 값 --%>
              <td>${grade.avrgScore}</td>
              <%-- 'getAllSemstr' 쿼리의 PNT_GRAD 컬럼 값 --%>
              <td>${grade.pntGrad}</td>
              <%-- 'getAllSemstr' 쿼리의 ACQS_PNT 컬럼 값 --%>
              <td>${grade.acqsPnt}</td>
              
              <%-- 
                상세보기 버튼:
                'getAllSemstr' 쿼리에 포함된 'SEMSTR_SCRE_INNB' (학기성적고유번호)를
                URL 파라미터로 사용하여 상세 페이지로 이동합니다.
              --%>
              <td>
                <a href="/stdnt/grade/main/detail/${grade.semstrScreInnb}" class="btn btn-outline-primary btn-sm">
                  상세보기
                </a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>

  </div>
</div>

</body>
</html>