<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>
body {
	background-color: #f8fafc;
	font-family: "Pretendard", "Noto Sans KR", sans-serif;
}

.sidebar {
	width: 250px;
	background-color: #1e3a8a;
	color: white;
	min-height: 100vh;
	padding: 20px;
}

.btn-toggle {
	color: white;
	text-align: left;
	font-weight: 500;
	width: 100%;
}

.card-custom {
	border-radius: 12px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
	background-color: #fff;
	transition: 0.2s;
}

.card-custom:hover {
	transform: translateY(-3px);
}
</style>

<div class="content-area flex-grow-1 p-4">
	<h2 class="section-title mb-4">등록 관리</h2>

	<div class="mb-4">
		<h5>등록 학기 정보</h5>
		<p class="text-muted">현재 학기: 2025년 2학기</p>
	</div>

	<!-- 조회 폼 -->
	<form action="${pageContext.request.contextPath}/regist/list"
		method="get" class="row g-3 mb-3">
		<div class="col-md-3">
			<select id="mk_sel" class="form-select" name="year">
				<option value="">-- 년도 선택 --</option>
				<option value="2025">2025</option>
				<option value="2024">2024</option>
				<option value="2023">2023</option>
			</select>
		</div>
		<script>
      document.querySelector("#mk_sel").value="${mk_ys.year}";
    </script>
		<div class="col-md-3">
			<select id="mk_sel2" class="form-select" name="semester">
				<option value="">-- 학기 선택 --</option>
				<option value="1학기">1학기</option>
				<option value="2학기">2학기</option>
			</select>
		</div>
		<script>
      document.querySelector("#mk_sel2").value="${mk_ys.semester}";
    </script>
		<div class="col-md-3">
			<button type="submit" class="btn btn-primary">조회</button>
		</div>
	</form>

	<!-- ✅ DB 데이터 출력 -->
	<div class="accordion" id="registerList">
		<c:choose>
			<c:when test="${empty registerList}">
				<p class="text-muted">등록 내역이 없습니다.</p>
			</c:when>
			<c:otherwise>
				<c:forEach var="item" items="${registerList}" varStatus="st">
					<div class="accordion-item">
						<h2 class="accordion-header">
							<button class="accordion-button collapsed" type="button"
								data-bs-toggle="collapse" data-bs-target="#reg${st.index}">
								${item.year}년 ${item.semester} 등록 내역</button>
						</h2>
						<div id="reg${st.index}" class="accordion-collapse collapse"
							data-bs-parent="#registerList">
							<div class="accordion-body">
								<ul>
									<li>등록일: ${item.regDate}</li>
									<li>납부 금액: <fmt:formatNumber value="${item.payAmount}"
											pattern="#,###" />원
									</li>
									<li>상태: <c:choose>
											<c:when test="${item.payStatus eq '완료'}">
												<span class="badge bg-success">완료</span>
											</c:when>
											<c:otherwise>
												<span class="badge bg-warning text-dark">미납</span>
											</c:otherwise>
										</c:choose>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
	<!-- 등록 규정 안내 -->
	<div class="info-box mt-5">
		<h6 class="fw-semibold mb-2">등록 규정 안내</h6>
		<p class="mb-0 text-muted">
			등록은 매 학기 시작 전 지정된 기간 내에만 가능합니다. 등록금 미납 시 수강신청이 제한됩니다.
		</p>
	</div>
</div>
</div>
<%@ include file="../footer.jsp"%>
