<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<!-- 결제 모달 -->
<div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="paymentModalLabel">💳 결제하기</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
			</div>
			<div class="modal-body">
				<!-- 결제 방식 탭 -->
				<ul class="nav nav-tabs mb-3" id="paymentTabs" role="tablist">
					<li class="nav-item" role="presentation">
						<button class="nav-link active" id="bank-tab" data-bs-toggle="tab"
							data-bs-target="#bank" type="button" role="tab">무통장입금/계좌이체<br />(ATM기 현금송금불가)</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link" id="card-tab" data-bs-toggle="tab"
							data-bs-target="#card" type="button" role="tab">카드결제<br />(카카오페이/네이버페이)</button>
					</li>
				</ul>

				<!-- 탭 내용 -->
				<div class="tab-content" id="paymentTabsContent">
					<div class="tab-pane fade show active" id="bank" role="tabpanel">
						<div class="mb-3">
							<label class="form-label">입금 은행 선택</label>
							<select class="form-select">
								<option>국민은행</option>
								<option>우리은행</option>
								<option>하나은행</option>
							</select>
						</div>
						<div class="mb-3">
							<label class="form-label">입금자명</label>
							<input type="text" class="form-control" placeholder="예: 홍길동">
						</div>
					</div>

					<div class="tab-pane fade" id="card" role="tabpanel">
						<div class="mb-3">
							<label class="form-label">카드번호</label>
							<input type="text" class="form-control" placeholder="0000-0000-0000-0000">
						</div>
						<div class="row">
							<div class="col-md-6 mb-3">
								<label class="form-label">유효기간</label>
								<input type="text" class="form-control" placeholder="MM/YY">
							</div>
							<div class="col-md-6 mb-3">
								<label class="form-label">CVC</label>
								<input type="text" class="form-control" placeholder="123">
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="modal-footer">
				<button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				<button class="btn btn-success" id="confirmPayment">결제 확인</button>
			</div>
		</div>
	</div>
</div>
</div>
<!-- 결제 모달 끝 -->

<%@ include file="../footer.jsp"%>

<!--Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('click', (e) => {
	if (e.target && e.target.id === 'confirmPayment') {
		e.preventDefault();
		const btn = e.target;
		const original = btn.innerHTML;
		btn.disabled = true;
		btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>처리 중...';

		setTimeout(() => {
			btn.disabled = false;
			btn.innerHTML = original;
			const modal = bootstrap.Modal.getInstance(document.getElementById('paymentModal'));
			modal && modal.hide();
			alert('✅ 결제가 완료되었습니다. 감사합니다!');
		}, 1200);
	}
});
</script>
