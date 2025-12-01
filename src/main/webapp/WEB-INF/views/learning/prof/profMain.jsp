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
                                    <button type="button" class="btn btn-primary" id="task-create-btn"
                                            data-bs-toggle="modal" data-bs-target="#createTaskModal">등록</button>
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
                            <div id="quizSection">
                                <div id="quizGrid"></div>
                                <div class="d-flex justify-content-end gap-2 mt-3">
                                    <button type="button" class="btn btn-primary" id="quiz-create-btn"
                                            data-bs-toggle="modal" data-bs-target="#createQuizModal">등록</button>
                                </div>
                            </div>
                            <div id="quizSubGrid" class="d-none">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6 class="mb-0" id="quiz-submission-title"></h6>
                                </div>
                                <div id="quizSubmissionGrid"></div>
                            </div>
                            <div class="d-flex justify-content-end mt-3 d-none" id="quizSubmissionBackRow">
                                <button type="button" class="btn btn-outline-primary" id="quiz-submission-back-btn">목록</button>
                            </div>
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

<div class="modal fade" id="createTaskModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="createTaskModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createTaskModalLabel">과제 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="createTaskForm">
                    <div class="row">
                        <div class="col-8 mb-3">
                            <label for="create-task-title" class="form-label">과제 제목</label>
                            <input type="text" class="form-control" id="create-task-title"
                                   name="taskSj" placeholder="과제 제목을 입력하세요" required />
                        </div>
                        <div class="col-4 mb-3">
                            <label for="create-task-week" class="form-label">주차</label>
                            <select class="form-select" id="create-task-week" name="week" required>
                                <option value="" disabled selected>주차 선택</option>
                                <%-- 1~15 고정 옵션 --%>
                                <option value="1">1주차</option>
                                <option value="2">2주차</option>
                                <option value="3">3주차</option>
                                <option value="4">4주차</option>
                                <option value="5">5주차</option>
                                <option value="6">6주차</option>
                                <option value="7">7주차</option>
                                <option value="8">8주차</option>
                                <option value="9">9주차</option>
                                <option value="10">10주차</option>
                                <option value="11">11주차</option>
                                <option value="12">12주차</option>
                                <option value="13">13주차</option>
                                <option value="14">14주차</option>
                                <option value="15">15주차</option>
                            </select>
                        </div>
                        <div class="col-12 mb-3">
                            <label for="create-task-content" class="form-label">과제 내용</label>
                            <textarea class="form-control" id="create-task-content" name="taskCn"
                                      rows="4" placeholder="과제 내용을 입력하세요"></textarea>
                            <div class="ckeditor-classic"></div>
                        </div>
                        <div class="col-6 mb-3">
                            <label for="create-task-start" class="form-label">시작일자</label>
                            <input type="date" class="form-control" id="create-task-start" name="taskBeginDe" required />
                        </div>
                        <div class="col-6 mb-3">
                            <label for="create-task-due" class="form-label">마감일자</label>
                            <input type="date" class="form-control" id="create-task-due" name="taskClosDe" required />
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" id="create-task-submit-btn">등록</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="createQuizModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="createQuizModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createQuizModalLabel">퀴즈 등록</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="createQuizForm">
                    <div class="mb-3">
                        <label for="create-quiz-question" class="form-label">문항</label>
                        <textarea class="form-control" id="create-quiz-question" name="quesCn" rows="4" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-4 mb-3">
                            <label for="create-quiz-week" class="form-label">주차</label>
                            <select class="form-select" id="create-quiz-week" name="week" required>
                                <option value="" disabled selected>주차 선택</option>
                                <option value="1">1주차</option>
                                <option value="2">2주차</option>
                                <option value="3">3주차</option>
                                <option value="4">4주차</option>
                                <option value="5">5주차</option>
                                <option value="6">6주차</option>
                                <option value="7">7주차</option>
                                <option value="8">8주차</option>
                                <option value="9">9주차</option>
                                <option value="10">10주차</option>
                                <option value="11">11주차</option>
                                <option value="12">12주차</option>
                                <option value="13">13주차</option>
                                <option value="14">14주차</option>
                                <option value="15">15주차</option>
                            </select>
                        </div>
                        <div class="col-4 mb-3">
                            <label for="create-quiz-begin" class="form-label">시작일</label>
                            <input type="date" class="form-control" id="create-quiz-begin" name="quizBeginDe" required />
                        </div>
                        <div class="col-4 mb-3">
                            <label for="create-quiz-close" class="form-label">마감일</label>
                            <input type="date" class="form-control" id="create-quiz-close" name="quizClosDe" required />
                        </div>
                        <div class="mb-2 d-flex justify-content-between align-items-center">
                            <label class="form-label mb-0">보기</label>
                            <div class="btn-group btn-group-sm">
                                <button type="button" class="btn btn-outline-primary" id="quiz-ex-add">+</button>
                                <button type="button" class="btn btn-outline-secondary" id="quiz-ex-del">-</button>
                            </div>
                        </div>
                        <div id="quiz-ex-list" class="d-flex flex-column gap-2"></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="create-quiz-submit-btn">등록</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editQuizModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header"><h5 class="modal-title">퀴즈 수정</h5></div>
            <div class="modal-body">
                <form id="editQuizForm">
                    <input type="hidden" id="edit-quiz-code" name="quizCode" />
                    <div class="mb-3">
                        <label for="edit-quiz-question" class="form-label">문항</label>
                        <textarea class="form-control" id="edit-quiz-question" name="quesCn" rows="4" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-4 mb-3">
                            <label for="edit-quiz-week" class="form-label">주차</label>
                            <select class="form-select" id="edit-quiz-week" name="week" required>
                                <option value="" disabled selected>주차 선택</option>
                                <option value="1">1주차</option>
                                <option value="2">2주차</option>
                                <option value="3">3주차</option>
                                <option value="4">4주차</option>
                                <option value="5">5주차</option>
                                <option value="6">6주차</option>
                                <option value="7">7주차</option>
                                <option value="8">8주차</option>
                                <option value="9">9주차</option>
                                <option value="10">10주차</option>
                                <option value="11">11주차</option>
                                <option value="12">12주차</option>
                                <option value="13">13주차</option>
                                <option value="14">14주차</option>
                                <option value="15">15주차</option>
                            </select>
                        </div>
                        <div class="col-4 mb-3">
                            <label for="edit-quiz-begin" class="form-label">시작일</label>
                            <input type="date" class="form-control" id="edit-quiz-begin" name="quizBeginDe" required />
                        </div>
                        <div class="col-4 mb-3">
                            <label for="edit-quiz-close" class="form-label">마감일</label>
                            <input type="date" class="form-control" id="edit-quiz-close" name="quizClosDe" required />
                        </div>
                        <div class="mb-2 d-flex justify-content-between align-items-center">
                            <label class="form-label mb-0">보기</label>
                            <div class="btn-group btn-group-sm">
                                <button type="button" class="btn btn-outline-primary" id="edit-quiz-ex-add">+</button>
                                <button type="button" class="btn btn-outline-secondary" id="edit-quiz-ex-del">-</button>
                            </div>
                        </div>
                        <div id="edit-quiz-ex-list" class="d-flex flex-column gap-2"></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-primary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="edit-quiz-submit-btn">저장</button>
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
            taskCn: '${fn:escapeXml(t.taskCn)}',
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

    window.__INIT_QUIZZES = [
        <c:forEach var="q" items="${body.quizzes}" varStatus="sq">
        {
            quizCode: '${q.quizCode}',
            quesCn: '${fn:escapeXml(q.quesCn)}',
            weekAcctoLrnNo: '${q.weekAcctoLrnNo}',
            quizBeginDe: '${q.quizBeginDe}',
            quizClosDe: '${q.quizClosDe}',
            week: '${q.week}'
        }${sq.last ? '' : ','}
        </c:forEach>
    ];
    window.__INIT_QUIZ_PRESENTN = [
        <c:forEach var="qp" items="${body.quizPresentn}" varStatus="sp">
        {
            quizPresentnNo: '${qp.quizPresentnNo}',
            stdntNo: '${qp.stdntNo}',
            stdntNm: '${fn:escapeXml(qp.stdntNm)}',
            quizCode: '${qp.quizCode}',
            quizExCode: '${qp.quizExCode}',
            quizPresentnDe: '${qp.quizPresentnDe}',
            presentnAt: '${qp.presentnAt}',
            week: '${qp.week}'
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
