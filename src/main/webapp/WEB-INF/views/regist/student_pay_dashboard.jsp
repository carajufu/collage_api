<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../header.jsp"%>

<style>
.payment-modal {
	border-radius: 14px;
	background: #fff;
	border: 1px solid #dcdcdc;
	overflow: hidden;
	font-family: "Pretendard", "Noto Sans KR", sans-serif;
	box-shadow: 0 10px 28px rgba(0, 0, 0, .20)
}

.payment-header {
	background: #f7f9fb;
	padding: 18px 22px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1px solid #e5e8eb
}

.payment-header .brand {
	font-size: 15px;
	color: #6b7280;
	font-weight: 500
}

.payment-header .amount {
	font-size: 19px;
	font-weight: 700;
	color: #2563eb
}

.payment-body {
	padding: 22px 26px 16px 26px
}

.payment-tabs {
	display: flex;
	gap: 8px;
	margin-bottom: 18px;
	padding-left: 0
}

.payment-tabs li {
	list-style: none;
	padding: 9px 16px;
	border-radius: 10px;
	background: #f1f5f9;
	color: #64748b;
	font-size: 14px;
	cursor: pointer;
	transition: .2s
}

.payment-tabs li.active {
	background: #2563eb;
	color: #fff;
	font-weight: 600
}

.pay-box {
	animation: fadeIn .25s ease-in-out
}

@keyframes fadeIn {
	from { opacity: .3 }
    to { opacity: 1 }
}

.guide-text {
	color: #6b7280;
	font-size: 13px;
	margin-top: 10px;
	text-align: center
}

.payment-footer {
	border-top: 1px solid #e5e8eb;
	padding: 18px 26px 22px 26px
}

.btn-pay {
	width: 100%;
	background: #2563eb;
	border: none;
	padding: 14px 0;
	border-radius: 12px;
	color: #fff;
	font-weight: 600;
	font-size: 15px;
	transition: .2s
}

.btn-pay:hover {
	background: #1d4ed8
}

#accountBox {
	border-radius: 10px;
	font-size: 14px;
	line-height: 1.5
}

.modal.fade .modal-dialog {
	transition: transform .25s ease-out, opacity .25s ease-out;
	transform: translateY(-8px);
	opacity: 0
}

.modal.show .modal-dialog {
	transform: translateY(0);
	opacity: 1
}
</style>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
                <li class="breadcrumb-item active"><a href="#">학사 정보</a></li>
                <li class="breadcrumb-item active"><a href="#">등록</a></li>
                <li class="breadcrumb-item active" aria-current="page">납부</li>
            </ol>
        </nav>
    </div>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">납부</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
    <div class="col-xxl-4 col-4">
        <div class="card card-custom p-3">
            <h5>현재 학기</h5>
            <p class="text-muted mb-0">${year}년${semstr}</p>
        </div>
    </div>
    <div class="col-xxl-4 col-4">
        <div class="card card-custom p-3">
            <h5>납부 상태</h5>
            <p
                class="${p.paySttus eq '완납' ? 'text-success' : 'text-warning'} fw-semibold mb-0">
                ${p.paySttus eq '완납' ? '등록금 납부 완료 ✅' : '등록금 미납 ⚠️'}</p>
        </div>
    </div>
    <div class="col-xxl-4 col-4">
        <div class="card card-custom p-3">
            <h5>총 납부 금액</h5>
            <p class="fw-bold text-primary mb-0">
                <fmt:formatNumber value="${p.payGld}" pattern="#,###" />
                원
            </p>
        </div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">
		<h4 class="fw-bold mt-5 mb-3 text-primary">
			<i class="bi bi-list-check me-2"></i>납부 상세
		</h4>
    </div>
    <div class="col-xxl-12 col-12">
		<table class="table table-bordered table-hover align-middle bg-white">
			<thead>
				<tr>
					<th>학기</th>
					<th>청구일자</th>
					<th>납부금액</th>
					<th>납부방식</th>
					<th>납부상태</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="pay" items="${payList}">
					<tr>
						<td>${pay.rqestYear}년${pay.rqestSemstr}</td>
						<td><c:choose>
								<c:when test="${not empty pay.rqestDe}">${fn:replace(pay.rqestDe, '/', '-')}</c:when>
								<c:otherwise>--</c:otherwise>
							</c:choose></td>
						<td><fmt:formatNumber value="${pay.payGld}" pattern="#,###" />원</td>
						<td><c:choose>
								<c:when test="${pay.payMthd eq 'CARD'}">💳 카드결제</c:when>
								<c:when test="${pay.payMthd eq 'TRANSFER'}">🏦 계좌이체</c:when>
								<c:when test="${pay.payMthd eq 'VA'}">📄 가상계좌</c:when>
								<c:when test="${pay.payMthd eq 'EASY'}">⚡ 간편결제</c:when>
								<c:otherwise>-</c:otherwise>
							</c:choose></td>
						<td><c:choose>
								<c:when test="${pay.paySttus eq '완납'}">
									<span class="badge bg-success">완료</span>
								</c:when>
								<c:otherwise>
									<span class="badge bg-warning text-dark">미납</span>
								</c:otherwise>
							</c:choose></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
    </div>
    <div class="col-xxl-12 col-12">
		<!-- 결제 버튼 -->
		<div class="text-center mt-5">
			<c:set var="isPaid" value="${p.paySttus eq '완납'}" />
            <c:if test="${!isPaid}">
                <button id="openPayModalBtn"
                        class="btn btn-lg btn-primary px-5 payBtn"
                        data-registctno="${p.registCtNo}"
                        data-stdntno="${p.stdntNo}"
                        data-paygld="${p.payGld}"
                        data-bs-toggle="modal"
                        data-bs-target="#paymentModal">
                    <i class="bi bi-credit-card me-2"></i>
                    등록금 납부하기
                </button>
            </c:if>
		</div>

		<!-- 영수증 버튼(완납시에만) -->
        <c:if test="${p.paySttus eq '완납'}">
		<div class="text-center mt-3">
				<form
					action="${pageContext.request.contextPath}/payinfo/receipt/${p.stdntNo}"
					method="get">
					<button type="submit" class="btn btn-outline-secondary">
						<i class="bi bi-file-earmark-pdf"></i> 영수증 다운로드
					</button>
				</form>
		</div>
        </c:if>
    </div>
</div>

<!-- 결제 모달 -->
<div class="modal fade" id="paymentModal" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content payment-modal">
			<input type="hidden" id="registCtNo"><input type="hidden"
				id="stdntNo">

			<div class="payment-header">
				<span class="brand">등록금 결제</span> <span class="amount"
					id="modalPayAmount">₩0</span>
			</div>

			<div class="payment-body">
				<ul class="payment-tabs" id="payTabs">
					<li class="active" data-type="CARD">💳 카드결제</li>
					<li data-type="VA">📄 무통장 / 가상계좌</li>
				</ul>

				<!-- 카드 결제 -->
				<div class="pay-box" id="payCard">
					<label class="form-label mt-2">카드사 선택</label> <select
						class="form-select" id="cardCorp">
						<option>KB국민카드</option>
						<option>신한카드</option>
						<option>우리카드</option>
						<option>NH농협카드</option>
					</select> <label class="form-label mt-3">카드번호</label>
					<div class="d-flex gap-2">
						<input type="text" maxlength="4" class="form-control card-num"
							id="card1"> <input type="text" maxlength="4"
							class="form-control card-num" id="card2"> <input
							type="text" maxlength="4" class="form-control card-num"
							id="card3"> <input type="password" maxlength="4"
							class="form-control card-num" id="card4">
					</div>

					<div class="row mt-3">
						<div class="col">
							<label class="form-label">유효기간</label> <input type="text"
								class="form-control" id="cardExpire" placeholder="MM/YY"
								maxlength="5" style="ime-mode: disabled;" />
						</div>

						<script>
						document.getElementById("cardExpire").addEventListener("input", function(e) {
						  let v = e.target.value.replace(/[^0-9]/g, ""); // 숫자만
						  if (v.length >= 3) {
						    e.target.value = v.slice(0,2) + "/" + v.slice(2,4);
						  } else {
						    e.target.value = v;
						  }
						});
						</script>

						<div class="col">
							<label class="form-label">비밀번호 앞 2자리</label> <input
								type="password" maxlength="2" class="form-control" id="cardPw"
								placeholder="**">
						</div>
						<div class="col">
							<label class="form-label">CVC</label> <input type="password"
								maxlength="3" class="form-control" id="cardCvc"
								placeholder="***">
						</div>
					</div>

					<div class="guide-text">카드 결제 승인 후 영수증 출력이 가능합니다.</div>
				</div>

				<!-- 가상계좌 -->
				<div class="pay-box d-none" id="payVA">
					<label class="form-label mt-3">입금 은행</label> <select
						class="form-select" id="bankSel">
						<option value="001">농협</option>
						<option value="004">국민은행</option>
						<option value="088">신한은행</option>
					</select> <label class="form-label mt-3">입금자명</label> <input type="text"
						class="form-control" id="dpstrNm" value="${p.stdntNm}" readonly />

					<!-- 가상계좌 발급 버튼 -->
					<div class="d-grid mt-3">
						<button class="btn btn-warning" id="issueVA">가상계좌 발급</button>
					</div>

					<!-- 계좌 표시 영역 -->
					<div id="accountBox" class="alert alert-warning mt-3 d-none"></div>

				</div>

			</div>

			<div class="payment-footer">
				<button id="mockPayBtn" class="btn-pay">
					<i class="bi bi-lock-fill me-2"></i> 결제 진행하기
				</button>
			</div>
			<div class="guide-text">이체/카드 승인 완료 후 영수증 출력이 가능합니다.</div>
			<br>
		</div>
	</div>
</div>

<!-- 모달 및 결제 스크립트 -->
<script>
document.addEventListener("DOMContentLoaded", () => {

  let registCtNo = null;
  let stdntNo = null;
  let amount = null;
  let payMthd = "CARD"; // 기본 카드

  document.getElementById("paymentModal").addEventListener("show.bs.modal", (e) => {
    const btn = e.relatedTarget;
    registCtNo = btn.dataset.registctno;
    stdntNo = btn.dataset.stdntno;
    amount = btn.dataset.paygld;
    document.getElementById("modalPayAmount").textContent = Number(amount).toLocaleString() + "원";
  });

  document.querySelectorAll("#payTabs li").forEach(tab => {
    tab.addEventListener("click", () => {
      document.querySelectorAll("#payTabs li").forEach(t => t.classList.remove("active"));
      tab.classList.add("active");

      if (tab.dataset.type === "CARD") {
        payMthd = "CARD";
        document.getElementById("payCard").classList.remove("d-none");
        document.getElementById("payVA").classList.add("d-none");
      } else {
        payMthd = "VA";
        document.getElementById("payCard").classList.add("d-none");
        document.getElementById("payVA").classList.remove("d-none");
      }
    });
  });

  // 가상계좌 발급
  document.getElementById("issueVA").addEventListener("click", () => {
    fetch("/payment/mock/account", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        registCtNo,
        stdntNo,
        bank: document.getElementById("bankSel").value
      })
    })
    .then(r => r.json())
    .then(d => {
      console.log("✅ 서버에서 받은 데이터:", d);
      const box = document.getElementById("accountBox");
      box.classList.remove("d-none");
      box.innerHTML = `
    	<b>입금 계좌번호 :</b> ${'${'}d.accountNo}<br/>
        <b>입금 금액 :</b> \${Number(d.amount).toLocaleString()}원
      `;
    });
  });

// 결제 진행하기 버튼 → 카드 / 무통장 모두 처리
  document.getElementById("mockPayBtn").addEventListener("click", () => {
    if (payMthd === "CARD") {
      fetch("/payment/mock/card", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          registCtNo: registCtNo,
          stdntNo: stdntNo,
          payMthd: "CARD"
        })
      }).then(() => {
        alert("✅ 카드 결제가 완료되었습니다.");
        location.reload();
      });
    } else {
      fetch("/payment/mock/confirm", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          registCtNo: registCtNo,
          stdntNo: stdntNo,
          payMthd: "VA"
        })
      }).then(() => {
        alert("✅ 계좌이체 결제가 완료되었습니다.");
        location.reload();
      });
    }
  });
});
</script>

<%@ include file="../footer.jsp"%>
