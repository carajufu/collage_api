<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교수 강의관리</title>
<style>
	body { font-family: '맑은 고딕', sans-serif; margin: 40px; }
	h2 { text-align: center; margin-bottom: 20px; }
	table { width: 100%; border-collapse: collapse; margin-top: 10px; }
	th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
	th { background-color: #f8f8f8; }
	tr:hover { background-color: #f1f1f1; }
	.btn-area { margin-top: 20px; text-align: right; }
	button { padding: 8px 14px; margin-left: 5px; }
	a { text-decoration: none; color: black; }
</style>
</head>

<body>
	<!-- /// menu.jsp 시작 /// -->
	<%@ include file="../menu.jsp" %>
	<!-- /// menu.jsp 끝 /// -->

	<h2>교수 강의관리</h2>

	<!-- 강의 목록 테이블 -->
	<table>
		<thead>
			<tr>
				<th>강의코드</th>
				<th>강의명</th>
				<th>학기</th>
				<th>수강인원</th>
				<th>평균평가점수</th>
				<th>관리</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="lecture" items="${lectureList}">
				<tr>
					<td>${lecture.lctreCode}</td>
					<td>${lecture.lctreName}</td>
					<td>${lecture.term}</td>
					<td>${lecture.studentCnt}</td>
					<td>
						<c:choose>
							<c:when test="${lecture.avgEvalScore ne null}">
								<fmt:formatNumber value="${lecture.avgEvalScore}" pattern="0.0"/>
							</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose>
					</td>
					<td>
						<a href="lectureDetail.do?lctreCode=${lecture.lctreCode}">상세보기</a> |
						<a href="lectureEdit.do?lctreCode=${lecture.lctreCode}">수정</a> |
						<a href="lectureDelete.do?lctreCode=${lecture.lctreCode}" 
						   onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty lectureList}">
				<tr>
					<td colspan="6">등록된 강의가 없습니다.</td>
				</tr>
			</c:if>
		</tbody>
	</table>

	<div class="btn-area">
		<button type="button" onclick="location.href='lectureAddForm.do'">강의등록</button>
	</div>

	<!-- /// footer.jsp 시작 /// -->
	<%@ include file="../footer.jsp" %>
	<!-- /// footer.jsp 끝 /// -->
</body>
</html>
