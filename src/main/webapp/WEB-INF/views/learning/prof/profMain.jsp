<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../../header.jsp" %>

<!-- girdJs -->
<link href="/assets/libs/gridjs/theme/mermaid.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/assets/libs/gridjs/gridjs.umd.js"></script>

<!-- ckEditor -->
<script src="/assets/libs/@ckeditor/ckeditor5-build-classic/build/ckeditor.js"></script>

<!-- sweetalert2 -->
<link href="/assets/libs/sweetalert2/sweetalert2.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/assets/libs/sweetalert2/sweetalert2.min.js"></script>

<link href="/assets/css/custom.css" rel="stylesheet" type="text/css" />

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/profas"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">강의</a></li>
            <li class="breadcrumb-item"><a href="/prof/lecture/list">내 강의</a></li>
            <li class="breadcrumb-item active" aria-current="page">${body.lctreNm}</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">${body.lctreNm}</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
    <div class="col-xxl-12 col-12">
        <ul class="nav nav-tabs" role="tablist" id="profTabs">
            <li class="nav-item waves-effect waves-light" role="presentation">
                <a href="#tasks" class="nav-link active" role="tab" data-bs-toggle="tab" aria-selected="true"><h6>과제</h6></a>
            </li>
            <li class="nav-item waves-effect waves-light" role="presentation">
                <a href="#quiz" class="nav-link" role="tab" data-bs-toggle="tab" aria-selected="false"><h6>퀴즈</h6></a>
            </li>
            <li class="nav-item waves-effect waves-light" role="presentation">
                <a href="#attend" class="nav-link" role="tab" data-bs-toggle="tab" aria-selected="false"><h6>출결</h6></a>
            </li>
            <li class="nav-item waves-effect waves-light" role="presentation">
                <a href="#board" class="nav-link" role="tab" data-bs-toggle="tab" aria-selected="false"><h6>게시판</h6></a>
            </li>
        </ul>
        <div class="tab-content">
            <div class="tab-pane active show" id="tasks" role="tabpanel">
                <div class="card h-100">
                    <div data-simplebar style="max-height: 550px;">
                        <div class="card-body">
                            <div id="taskSection">
                                <div id="taskGrid"></div>
                                <div class="d-flex justify-content-end gap-2 mt-3">
                                    <button type="button" class="btn btn-primary">등록</button>
                                </div>
                            </div>
                            <div id="subTaskGrid" class="d-none">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6 class="mb-0"></h6>
                                </div>
                                <div id="submissionGrid"></div>
                            </div>
                            <div class="d-flex justify-content-end mt-3 d-none" id="submissionBackRow">
                                <button type="button" class="btn btn-outline-primary" id="submission-back-btn">목록</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tab-pane" id="quiz" role="tabpanel">
                <div class="card h-100">
                    <div data-simplebar style="max-height: 550px;">
                        <div class="card-body">
                            <div id="quizTable" class="text-muted">퀴즈 데이터를 불러오는 중...</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tab-pane" id="attend" role="tabpanel">
                <div class="card h-100">
                    <div data-simplebar style="max-height: 550px;">
                        <div class="card-body">
                            <div id="attendance-date-nav" class="col-xxl-12 col-12 d-flex justify-content-center align-items-center gap-3 mb-3">
                                <button type="button" class="btn btn-outline-primary btn-sm" id="attendance-prev">&lt;</button>
                                <div class="d-flex align-items-center gap-2">
                                    <div id="attendance-date" class="fw-semibold lh-lg"></div>
                                    <input type="date" id="attendance-date-picker" class="visually-hidden" />
                                    <button id="attendance-calendar-btn" class="btn btn-ghost-primary btn-icon" type="button">
                                        <i class="las la-calendar-alt"></i>
                                    </button>
                                </div>
                                <button type="button" class="btn btn-outline-primary btn-sm" id="attendance-next">&gt;</button>
                            </div>
                            <div class="text-muted">출결 데이터를 불러오는 중...</div>
                            <div id="attendGrid"></div>
                            <div id="attendance-empty" class="alert alert-warning d-none">출결 데이터가 없습니다.</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="tab-pane" id="board" role="tabpanel">
                <div class="card h-100">
                    <div data-simplebar style="max-height: 550px;">
                        <div class="card-body">
                            <div id="boardTable" class="text-muted">게시판 데이터를 불러오는 중...</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 과제 수정 모달 -->
<div class="modal fade" id="editTaskModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="editTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editTaskModalLabel">과제 수정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editTaskForm">
                    <input type="hidden" id="edit-task-no" name="taskNo" />
                    <div class="row">
                        <div class="col-12 mb-3">
                            <label for="edit-task-title" class="form-label">과제 제목</label>
                            <input type="text" class="form-control" id="edit-task-title" name="taskSj" placeholder="과제 제목을 입력하세요" />
                        </div>
                        <div class="col-12 mb-3">
                            <label for="edit-task-content" class="form-label">과제 내용</label>
                            <textarea class="form-control" id="edit-task-content" name="taskCn" rows="4" placeholder="과제 내용을 입력하세요"></textarea>
                            <div class ="ckeditor-classic"></div>
                        </div>
                        <div class="col-6 mb-3">
                            <label for="edit-task-start" class="form-label">시작일자</label>
                            <input type="date" class="form-control" id="edit-task-start" name="taskBeginDe" />
                        </div>
                        <div class="col-6 mb-3">
                            <label for="edit-task-due" class="form-label">마감일자</label>
                            <input type="date" class="form-control" id="edit-task-due" name="taskClosDe" />
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" form="editTaskForm" onclick="updateTask">저장</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    window.__INIT_TASKS = [
        <c:forEach var="t" items="${body.tasks}" varStatus="st">
        {
            taskNo: '${t.taskNo}',
            taskSj: '${t.taskSj}',
            weekAcctoLrnNo: '${t.weekAcctoLrnNo}',
            taskBeginDe: '${t.taskBeginDe}',
            taskClosDe: '${t.taskClosDe}',
            week: '${t.week}'
        }${st.last ? '' : ','}
        </c:forEach>
    ];
    window.__INIT_TASK_PRESENTN = [
        <c:forEach var="p" items="${body.taskPresentn}" varStatus="sp">
        {
            taskNo: '${p.taskNo}',
            presentnAt: '${p.presentnAt}'
        }${sp.last ? '' : ','}
        </c:forEach>
    ];
    window.__ESTBLLCTRE_CODE = '${estbllctreCode}';
</script>
<script type="text/javascript" src="/js/wtGrid.js"></script>
<script type="text/javascript" src="/js/prof-main.js"></script>

<style rel="stylesheet">
    .gridjs-table td,
    .gridjs-table th {
        padding: 10px 20px;
        line-height: 1.2;   /* 텍스트 줄높이 축소 */
    }

    #attendance-date-nav .btn-nav,
    #attendance-date-nav .btn-icon-square {
        width: 32px;
        height: 32px;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }

    #attendance-date-nav .btn-icon-square {
        border-radius: 0.25rem;
    }

    #attendance-date {
        min-width: 120px;
        text-align: center;
    }
</style>

<%@ include file="../../footer.jsp" %>
