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
	<h2 class="section-title mb-4">납부 관리</h2>

	<div class="row g-4 mb-4">
		<div class="col-md-4">
			<div class="card card-custom p-3">
				<h5>학기</h5>
				<p class="text-muted mb-0">2025년 2학기</p>
			</div>
		</div>
		<div class="col-md-4">
			<div class="card card-custom p-3">
				<h5>납부 상태</h5>
				<p class="mb-0">
					<span class="badge bg-success">완료</span>
				</p>
			</div>
		</div>
		<div class="col-md-4">
			<div class="card card-custom p-3">
				<h5>납부 기한</h5>
				<p class="text-danger mb-0">2025-09-15까지</p>
			</div>
		</div>
	</div>

	<h5 class="mt-4">납부 항목</h5>
	<table class="table table-bordered table-hover bg-white align-middle">
		<thead class="table-light">
			<tr>
				<th>항목</th>
				<th>금액</th>
				<th>비고</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>등록금</td>
				<td>3,000,000원</td>
				<td>전공 학기별 고정 납부액</td>
			</tr>
			<tr>
				<td>학생회비</td>
				<td>200,000원</td>
				<td>자율 납부 가능</td>
			</tr>
			<tr>
				<td>도서관 이용료</td>
				<td>30,000원</td>
				<td>신입생 필수 납부</td>
			</tr>
		</tbody>
		<tfoot class="table-light">
			<tr>
				<th>총 납부 금액</th>
				<th class="text-primary fs-5">3,230,000원</th>
				<th></th>
			</tr>
		</tfoot>
	</table>

	<div class="text-center mt-4">
		<button class="btn btn-lg btn-success px-5" data-bs-toggle="modal"
			data-bs-target="#paymentModal">
			<i class="bi bi-credit-card me-2"></i>결제하기
		</button>
	</div>
</div>
</div>
<%@ include file="../footer.jsp"%>
