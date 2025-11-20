<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ include file="../header.jsp" %>


    <h4 class="fw-bold mb-4">강의평가</h4>

    <!-- 요약 박스 -->
    <div class="border rounded p-3 mb-4 bg-light">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <span class="fw-semibold">미평가 강의 수:</span>
          <span class="text-primary fw-bold">${fn:length(atnlcList)}</span> 개
        </div>
        <div class="text-muted small">
          평가 완료 후 수정은 불가하니 신중히 제출해주세요.
        </div>
      </div>
    </div>

    <p class="text-muted mb-3">
      평가가 가능한 강의 목록입니다. 각 강의의 평가 버튼을 눌러 강의평가를 진행하세요.
    </p>

    <c:if test="${empty atnlcList}">
      <div class="alert alert-secondary text-center py-4">
        현재 평가할 강의가 없습니다.
      </div>
    </c:if>

    <c:if test="${not empty atnlcList}">
      <div class="table-responsive">
        <table class="table table-bordered align-middle">
          <thead class="table-light text-center">
        <table class="table table-hover align-middle text-center">
          <thead class="table-light">
            <tr>
              <th style="width: 6%;">No.</th>
              <th style="width: 25%;">개설 강의명</th>
              <th>강의코드</th>
              <th>년도</th>
              <th>학기</th>
              <th>이수구분</th>
              <th>학점</th>
              <th>정원</th>
              <th>수업언어</th>
              <th style="width: 12%;">평가하기</th>
            </tr>
          </thead>

          <tbody class="text-center">
            <c:forEach var="lecture" items="${atnlcList}" varStatus="status">
              <tr>
                <td>${status.count}</td>
                <td class="text-start fw-semibold">${lecture.lctreNm}</td>
                <td>${lecture.lctreCode}</td>
                <td>${lecture.estblYear}</td>
                <td>${lecture.estblSemstr}</td>
                <td>${lecture.complSe}</td>
                <td>${lecture.acqsPnt}</td>
                <td>${lecture.atnlcNmpr}</td>
                <td>${lecture.lctreUseLang}</td>
                <td class="text-center">
                  <a href="/stdnt/lecture/main/${lecture.estbllctreCode}" 
                     class="btn btn-primary btn-sm px-3">
                    평가하기
                  </a>
                </td>
              </tr>
            </c:forEach>
          </tbody>

        </table>
      </div>
    </c:if>

<%@ include file="../footer.jsp" %>
