<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../../header.jsp" %>

<link href="/assets/libs/gridjs/theme/mermaid.min.css" rel="stylesheet" type="text/css" />
<script src="/assets/libs/gridjs/gridjs.umd.js"></script>
<script src="/js/wtGrid.js"></script>
<script src="/js/profMain.js" defer></script>

<div id="prof-main" class="row pt-3 px-3 px-lg-5" data-lec-no="${lecNo}">
    <div class="col-12 page-title mb-3">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
            <div>
                <p class="text-muted mb-1">교수 강의실</p>
                <div class="display-6 fw-semibold mb-0">학습 관리</div>
            </div>
            <c:if test="${empty lecNo}">
                <span class="badge bg-warning text-dark">lecNo 파라미터가 없어 데이터 요청이 제한됩니다.</span>
            </c:if>
        </div>
        <div class="my-4 p-0 bg-primary" style="width: 120px; height:5px;"></div>
    </div>

    <div class="col-12">
        <ul class="nav nav-tabs" id="learningTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" data-tab-target="task" type="button" role="tab">과제</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" data-tab-target="quiz" type="button" role="tab">퀴즈</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" data-tab-target="attendance" type="button" role="tab">출결</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" data-tab-target="board" type="button" role="tab">게시판</button>
            </li>
        </ul>

        <div class="card mt-3">
            <div class="card-body">
                <div class="tab-content">
                    <div class="tab-pane fade show active learning-tab-pane" data-tab="task" role="tabpanel">
                        <div class="alert alert-info mb-0">과제 탭은 데이터 비동기 로딩과 함께 곧 연결됩니다.</div>
                    </div>
                    <div class="tab-pane fade learning-tab-pane" data-tab="quiz" role="tabpanel">
                        <div class="alert alert-info mb-0">퀴즈 탭은 비동기 요청으로 채워질 예정입니다.</div>
                    </div>
                    <div class="tab-pane fade learning-tab-pane" data-tab="attendance" role="tabpanel">
                        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge bg-light text-dark border">출결 현황</span>
                                <small class="text-muted">탭 전환 시 비동기로 데이터를 가져옵니다.</small>
                            </div>
                            <div id="attendance-status" class="text-muted small"></div>
                        </div>
                        <div id="attendance-loader" class="text-center py-5 d-none">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                        <div  id="attendance-date-nav" class="col-xxl-12 col-12 d-flex justify-content-center align-items-center gap-3 mb-3">
                            <button type="button" class="btn btn-outline-primary btn-sm" id="attendance-prev">
                                &laquo;
                            </button>
                            <div id="attendance-date" class="fw-semibold lh-lg"></div>
                            <input type="date" id="attendance-date-picker" class="visually-hidden" />
                            <button id="attendance-calendar-btn" class="btn btn-ghost-primary btn-icon" type="button">
                                <i class="las la-calendar-alt"></i>
                            </button>
                            <button type="button" class="btn btn-outline-primary btn-sm" id="attendance-next">
                                &raquo;
                            </button>
                        </div>
                        <div id="attendance-grid" class="table-responsive"></div>
                        <div id="attendance-empty" class="alert alert-warning d-none">출결 데이터가 없습니다.</div>
                    </div>
                    <div class="tab-pane fade learning-tab-pane" data-tab="board" role="tabpanel">
                        <div class="alert alert-info mb-0">게시판 탭은 비동기 데이터 연동 후 노출됩니다.</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../../footer.jsp" %>
