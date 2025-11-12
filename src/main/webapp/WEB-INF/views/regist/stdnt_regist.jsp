<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

    <div id="main-container" class="container-fluid">
        <div class="flex-grow-1 p-1 overflow-auto">
            <!-- 메인 콘텐츠 -->
            <div class="content-area" id="mainContent">
                <h2 class="section-title">대시보드</h2>

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
                            <p id="dashPayStatus" class="text-success fw-semibold mb-0">등록금 납부 완료 ✅</p> <!-- ✅ CHANGED: id 추가 -->
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
                                <button class="nav-link active" id="bank-tab" data-bs-toggle="tab" data-bs-target="#bank" type="button"
                                        role="tab">계좌이체</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="card-tab" data-bs-toggle="tab" data-bs-target="#card" type="button"
                                        role="tab">카드결제</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="simple-tab" data-bs-toggle="tab" data-bs-target="#simple" type="button"
                                        role="tab">간편결제</button>
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

                            <div class="tab-pane fade" id="simple" role="tabpanel">
                                <p class="text-muted">지원 간편결제 서비스:</p>
                                <div class="d-flex gap-3">
                                    <button class="btn btn-outline-primary flex-fill"><i class="bi bi-tencent-qq"></i> 토스페이</button>
                                    <button class="btn btn-outline-warning flex-fill"><i class="bi bi-chat-dots-fill"></i> 카카오페이</button>
                                    <button class="btn btn-outline-success flex-fill"><i class="bi bi-n"></i> 네이버페이</button>
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
    </div>
</main>

<%@ include file="../footer.jsp" %>