<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="../header.jsp" %>


<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-1 overflow-auto">


    <h2 class="border-bottom pb-3 mb-4">강의 목록</h2>

    <c:if test="${empty allCourseList}">
      <div class="alert alert-info text-center">표시할 강의가 없습니다.</div>
    </c:if>

    <%-- 
      [분기 처리 2: 목록이 존재하는 경우]
      - 'allCourseList'가 비어있지 않을 때 (not empty) 테이블을 화면에 그립니다.
    --%>
    <c:if test="${not empty allCourseList}">
      
      <%-- 
        .table-responsive
        - 테이블의 너비가 화면보다 클 경우 (예: 모바일) 
        - 테이블 자체에 가로 스크롤바를 생성하여 화면 레이아웃이 깨지는 것을 방지합니다.
      --%>
      <div class="table-responsive">
        
        <%-- 
          Bootstrap 테이블 스타일
          - .table: 기본적인 테이블 스타일을 적용합니다.
          - .table-hover: 테이블의 각 행(row)에 마우스를 올렸을 때 하이라이트 효과를 줍니다.
          - .align-middle: 셀 안의 내용을 세로 기준으로 중앙 정렬합니다.
        --%>
        <table class="table table-hover align-middle">
          
          <%-- 
            테이블 헤더(<thead>)
            - .table-light: 헤더 행에 밝은 회색 배경색을 적용합니다.
            - .text-center: 헤더의 텍스트를 수평 기준으로 중앙 정렬합니다.
          --%>
          <thead class="table-light text-center">
            <tr>
              <th>No.</th>
              <th style="width: 25%;">개설강의명</th>
              <th>강의코드</th>
              <th>개설년도</th>
              <th>개설학기</th>
              <th>이수구분</th>
              <th>취득학점</th>
              <th>수강정원</th>
              <th>수업언어</th>
              <th>상세보기</th>
            </tr>
          </thead>
          
          <%-- 테이블 본문(<tbody>) --%>
          <tbody>
            <%--
              <c:forEach>: JSTL 반복문
              - 'allCourseList' (List 또는 Array)의 각 요소를 순회합니다.
              - var="lecture": 각 요소를 'lecture'라는 변수명으로 참조합니다.
              - varStatus="status": 루프의 현재 상태(순번, 인덱스 등)를 'status' 변수로 참조합니다.
                                  'status.count'는 1부터 시작하는 순번입니다.
            --%>
            <c:forEach var="lecture" items="${allCourseList}" varStatus="status">
              <tr>
                <%-- No. (순번) --%>
                <td class="text-center">${status.count}</td>
                
                <%-- 개설강의명: 굵은 글씨로 표시 --%>
                <td>
                  <strong>${lecture.lctreNm}</strong>
                </td>
                
                <%-- 강의코드 --%>
                <td class="text-center">${lecture.lctreCode}</td>
                
                <%-- 개설년도 --%>
                <td class="text-center">${lecture.estblYear}</td>
                
                <%-- 개설학기 --%>
                <td class="text-center">${lecture.estblSemstr}</td>
                
                <%-- 이수구분 --%>
                <td class="text-center">${lecture.complSe}</td>
                
                <%-- 취득학점 --%>
                <td class="text-center">${lecture.acqsPnt}</td>
                
                <%-- 수강정원 --%>
                <td class="text-center">${lecture.atnlcNmpr}</td>
                
                <%-- 수업언어 --%>
                <td class="text-center">${lecture.lctreUseLang}</td>

                <%-- 상세보기 버튼 --%>
                <td class="text-center">
                  <%-- 
                    <a> 태그로 상세 페이지 링크를 생성합니다.
                    - href 속성값에 EL을 사용하여 동적인 URL을 만듭니다.
                    - 예: /prof/lecture/main/detail/L001
                    - ${lecture.estbllctreCode}는 각 강의의 고유한 식별자(PK 등)여야 합니다.
                    - 이 링크는 Spring Controller의 @GetMapping("/prof/lecture/main/detail/{code}") 와 같은
                      메서드와 매핑됩니다.
                  --%>
                  <a href="/prof/lecture/main/detail/${lecture.estbllctreCode}" class="btn btn-success btn-sm">
                    <i class="bi bi-search"></i> 상세
                  </a>
                </td>
              </tr>
            </c:forEach> <%-- c:forEach 반복문 종료 --%>
          </tbody>
        </table>
      </div> <%-- .table-responsive div 종료 --%>
    </c:if> <%-- c:if (not empty allCourseList) 조건문 종료 --%>

  </div>
</div>

<%-- 
  공통 푸터 파일 삽입
  - </body>, </html> 태그 및 공통 JavaScript 파일 등을 포함하는 'footer.jsp' 파일을 삽입합니다.
  - (요청하신 코드에서 주석 처리 되어 있어 동일하게 주석 처리합니다.)
--%>
<%-- <%@ include file="../footer.jsp" %> --%>
