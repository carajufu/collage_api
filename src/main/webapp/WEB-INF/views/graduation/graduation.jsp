<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="../header.jsp" %>

<div id="main-container" class="container-fluid">
  <div class="flex-grow-1 p-3 overflow-auto">

    <!-- 제목 영역 -->
    <h2 class="border-bottom pb-3 mb-4">졸업 관리</h2>
    <p class="text-muted mb-4">
      졸업 요건을 충족한 학생 목록을 확인하고 졸업 승인 처리를 진행합니다.
    </p>

    <!-- 졸업대상자 목록 -->
    <c:if test="${empty gradList}">
      <div class="alert alert-info text-center">현재 졸업 대상 학생이 없습니다.</div>
    </c:if>

    <c:if test="${not empty gradList}">
      <div class="card shadow-sm">
        <div class="card-body p-0">
          <table class="table table-hover mb-0 align-middle text-center">
            <thead class="table-light">
              <tr>
                <th style="width: 60px;">No.</th>
                <th>학번</th>
                <th>이름</th>
                <th>전공</th>
                <th>취득학점</th>
                <th>졸업요건 충족 여부</th>
                <th style="width: 150px;">졸업 승인</th>
              </tr>
            </thead>

            <tbody>
              <c:forEach var="std" items="${gradList}" varStatus="status">
                <tr>
                  <td>${status.count}</td>
                  <td>${std.stdntNo}</td>
                  <td>${std.stdntNm}</td>
                  <td>${std.majorNm}</td>
                  <td>${std.totalCredit}</td>
                  <td>
                    <c:choose>
                      <c:when test="${std.isEligible eq 'Y'}">
                        <span class="text-success fw-bold">충족</span>
                      </c:when>
                      <c:otherwise>
                        <span class="text-danger fw-bold">미충족</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <button class="btn btn-primary btn-sm btn-graduate" data-std="${std.stdntNo}">
                      승인 처리
                    </button>
                  </td>
                </tr>
              </c:forEach>
            </tbody>

          </table>
        </div>
      </div>
    </c:if>

  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(function() {
  $(".btn-graduate").click(function() {
    const stdntNo = $(this).data("std");

    if(!confirm(stdntNo + " 학생의 졸업을 승인하시겠습니까?")) return;

    $.ajax({
      url: "/admin/graduation/approve",
      type: "POST",
      data: { stdntNo: stdntNo },
      success: function() {
        alert("졸업 승인이 완료되었습니다.");
        location.reload();
      },
      error: function() {
        alert("처리 중 오류가 발생했습니다.");
      }
    });
  });
});
</script>

<%@ include file="../footer.jsp" %>
