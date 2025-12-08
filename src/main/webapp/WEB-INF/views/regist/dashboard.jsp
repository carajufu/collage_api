<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="header.jsp"%>

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
<div id="main-container" class="container-fluid">
	<div class="flex-grow-1 p-1 overflow-auto">

		<div class="content-area flex-grow-1 p-4">
			<h2 class="section-title mb-4">대시보드</h2>
			<div class="row g-4">
				<div class="col-md-4">
					<div class="card card-custom p-3">
						<h5>현재 학기</h5>
						<p class="text-muted mb-0">2025년 2학기</p>
					</div>
				</div>
				<div class="col-md-4">
					<div class="card card-custom p-3">
						<h5>납부 상태</h5>
						<p class="text-success fw-semibold mb-0">등록금 납부 완료 ✅</p>
					</div>
				</div>
				<div class="col-md-4">
					<div class="card card-custom p-3">
						<h5>총 납부 금액</h5>
						<p class="fw-bold text-primary mb-0">3,200,000원</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>
<%@ include file="footer.jsp"%>

