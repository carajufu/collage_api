(() => {
    const params = new URLSearchParams(location.search);
    const estbllctreCode = window.__ESTBLLCTRE_CODE || params.get('estbllctreCode');
    const initialTab = params.get('tab') || 'tasks';
    const targetGrid = document.querySelector("#taskGrid");
    const subTaskGrid = document.querySelector("#subTaskGrid");
    const submissionBackBtn = document.getElementById('submission-back-btn');
    const submissionBackRow = document.getElementById('submissionBackRow');
    const taskActionsRow = targetGrid?.nextElementSibling?.classList.contains('d-flex') ? targetGrid.nextElementSibling : null;
    let submissionGrid = document.querySelector("#submissionGrid");
    let submissionTitleEl = null;
    let taskSection = document.getElementById('taskSection');
    const editModalEl = document.getElementById('editTaskModal');
    const editTaskForm = document.getElementById('editTaskForm');
    const editTaskTitleInput = document.getElementById('edit-task-title');
    const editTaskContentInput = document.getElementById('edit-task-content');
    const editTaskStartInput = document.getElementById('edit-task-start');
    const editTaskDueInput = document.getElementById('edit-task-due');
    const editTaskNoInput = document.getElementById('edit-task-no');
    const quizGrid = document.getElementById('quizGrid');
    const quizSection = document.getElementById('quizSection');
    const quizSubGrid = document.getElementById('quizSubGrid');
    const quizSubmissionGrid = document.getElementById('quizSubmissionGrid');
    const quizSubmissionTitleEl = document.getElementById('quiz-submission-title');
    const quizSubmissionBackRow = document.getElementById('quizSubmissionBackRow');
    const quizSubmissionBackBtn = document.getElementById('quiz-submission-back-btn');
    const quizCreateBtn = document.getElementById('quiz-create-btn');
    const createQuizModal = document.getElementById('createQuizModal');
    const createQuizForm = document.getElementById('createQuizForm');
    const createQuizQuestion = document.getElementById('create-quiz-question');
    const createQuizWeek = document.getElementById('create-quiz-week');
    const createQuizBegin = document.getElementById('create-quiz-begin');
    const createQuizClose = document.getElementById('create-quiz-close');
    const quizExList = document.getElementById('quiz-ex-list');
    const quizExAddBtn = document.getElementById('quiz-ex-add');
    const quizExDelBtn = document.getElementById('quiz-ex-del');
    const editQuizModal = document.getElementById('editQuizModal');
    const editQuizForm = document.getElementById('editQuizForm');
    const editQuizCode = document.getElementById('edit-quiz-code');
    const editQuizQuestion = document.getElementById('edit-quiz-question');
    const editQuizWeek = document.getElementById('edit-quiz-week');
    const editQuizBegin = document.getElementById('edit-quiz-begin');
    const editQuizClose = document.getElementById('edit-quiz-close');
    const editQuizExList = document.getElementById('edit-quiz-ex-list');
    const editQuizExAddBtn = document.getElementById('edit-quiz-ex-add');
    const editQuizExDelBtn = document.getElementById('edit-quiz-ex-del');
    const quizCodeHidden = document.getElementById('edit-quiz-code');
    let editTaskEditor = null;
    const createModalEl = document.getElementById('createTaskModal');
    const createTaskForm = document.getElementById('createTaskForm');
    const createTaskTitle = document.getElementById('create-task-title');
    const createTaskContent = document.getElementById('create-task-content');
    const createTaskStart = document.getElementById('create-task-start');
    const createTaskDue = document.getElementById('create-task-due');
    let createTaskEditor = null;
    const boardGrid = document.getElementById('boardGrid');
    const boardDetail = document.getElementById('boardDetail');
    const boardDetailTitle = document.getElementById('board-detail-title');
    const boardDetailType = document.getElementById('board-detail-type');
    const boardDetailMeta = document.getElementById('board-detail-meta');
    const boardDetailBody = document.getElementById('board-detail-body');
    const boardBackBtn = document.getElementById('board-back-btn');
    const boardDeleteBtn = document.getElementById('board-delete-btn');
    const boardEditBtn = document.getElementById('board-edit-btn');
    const boardFilter = document.getElementById('board-type-filter');
    const boardCreateBtn = document.getElementById('board-create-btn');
    const boardModalEl = document.getElementById('boardModal');
    const boardTitleInput = document.getElementById('board-title');
    const boardContentInput = document.getElementById('board-content');
    const boardBbsCodeSelect = document.getElementById('board-bbs-code');
    const boardCttNoInput = document.getElementById('board-ctt-no');
    const boardSaveBtn = document.getElementById('board-save-btn');
    const boardModalInstance = boardModalEl ? new bootstrap.Modal(boardModalEl) : null;
    const boardState = { list: [], meta: [], loaded: false };
    let currentBoard = null;
    const toArray = val => Array.isArray(val) ? val : (Array.isArray(val?.data) ? val.data : []);
    const decodeBase64Utf8 = (val) => {
        if (!val) return "";
        try {
            return decodeURIComponent(escape(window.atob(val)));
        } catch (e) {
            return val;
        }
    };

    const tabEl = document.querySelector(`#profTabs a[href="#${initialTab}"]`);
    if (tabEl) new bootstrap.Tab(tabEl).show();

    const injectTotal = (container, count) => {
        const head = container?.querySelector('.gridjs-head');
        if (!head || head.querySelector('.gridjs-total')) return;
        const totalEl = document.createElement('div');
        totalEl.className = 'gridjs-total';
        totalEl.textContent = `총 ${count}건`;
        head.insertBefore(totalEl, head.firstChild);
    };

    const ensureTaskSection = () => {
        if (taskSection) return taskSection;
        if (!targetGrid) return null;
        const parent = targetGrid.parentElement;
        if (!parent) return null;

        taskSection = document.createElement('div');
        taskSection.id = 'taskSection';
        parent.insertBefore(taskSection, targetGrid);
        taskSection.appendChild(targetGrid);
        if (taskActionsRow) taskSection.appendChild(taskActionsRow);
        return taskSection;
    };

    const ensureSubmissionLayout = () => {
        if (!subTaskGrid) return null;
        if (submissionGrid && submissionTitleEl) return submissionGrid;

        subTaskGrid.innerHTML = '';
        const header = document.createElement('div');
        header.className = 'd-flex justify-content-between align-items-center mb-3';

        submissionTitleEl = document.createElement('h6');
        submissionTitleEl.className = 'mb-0';
        submissionTitleEl.textContent = '목록';

        header.append(submissionTitleEl);

        submissionGrid = document.createElement('div');
        submissionGrid.id = 'submissionGrid';

        subTaskGrid.append(header, submissionGrid);
        return submissionGrid;
    };

    const showTasks = () => {
        ensureTaskSection();
        if (taskSection) taskSection.classList.remove('d-none');
        if (subTaskGrid) subTaskGrid.classList.add('d-none');
        if (submissionBackRow) submissionBackRow.classList.add('d-none');
    };

    const showSubmissions = () => {
        ensureTaskSection();
        ensureSubmissionLayout();
        if (taskSection) taskSection.classList.add('d-none');
        if (subTaskGrid) subTaskGrid.classList.remove('d-none');
        if (submissionBackRow) submissionBackRow.classList.remove('d-none');
    };

    showTasks();

    const renderSubmissionsGrid = (list, title) => {
        const gridTarget = ensureSubmissionLayout();
        if (!gridTarget) return;

        if (submissionTitleEl) {
            submissionTitleEl.textContent = title ? `${title}` : '제출 목록';
        }

        const rows = toArray(list).map(item => {
            const files = toArray(item.fileDetailVOList);
            const fileCell = !files.length
                ? '-'
                : gridjs.html(`
                      <div class="dropend">
                        <button class="btn btn-ghost-primary btn-sm dropdown-toggle" type="button"
                                data-bs-toggle="dropdown" aria-expanded="false">
                          제출파일 (${files.length})
                        </button>
                        <ul class="dropdown-menu">
                          ${files.map(fd => `
                            <li>
                              <a class="dropdown-item d-flex align-items-center gap-2"
                                 href="/learning/prof/downloadFile?fileGroupNo=${encodeURIComponent(item.fileGroupNo)}${fd.fileNo ? `&fileNo=${encodeURIComponent(fd.fileNo)}` : ''}">
                                <i class="las la-paperclip text-muted"></i>
                                <span>${escapeAttr(fd.fileNm || '(무제)')}</span>
                              </a>
                            </li>
                          `).join('')}
                        </ul>
                      </div>
                     `);

            return [
                item.stdntNo,
                item.stdntNm,
                item.presentnAt === '1' ? '제출' : '미제출',
                item.taskPresentnDe || '-',
                fileCell || '-'
            ];
        });

        gridTarget.innerHTML = '';

        const options = {
            columns: [
                {
                    id: "stdntNo",
                    name: "학번",
                    search: true,
                    sort: true
                },
                {
                    id: "stdntNm",
                    name: "이름",
                    search: true,
                    sort: true
                },
                {
                    id: "submitAt",
                    name: "제출상태",
                    search: false,
                    sort: true
                },
                {
                    id: "submitDe",
                    name: "제출일",
                    search: false,
                    sort: true
                },
                {
                    id: "fileGroup",
                    name: "제출과제",
                    search: false,
                    sort: false
                }
            ],
            data: rows,
            pagination: {
                ...DEFAULT_GRID_OPTIONS.pagination,
                limit: 20
            },
            language: {
                noRecordsFound: '제출 데이터가 없습니다.',
                search: '학번및 이름으로 검색 '
            }
        }
        gridInit(options, gridTarget)
        requestAnimationFrame(() => injectTotal(gridTarget, rows.length));
        showSubmissions();
    };

    const loadSubmissions = (taskNo, taskTitle) => {
        const gridTarget = ensureSubmissionLayout();
        if (!gridTarget) return;
        gridTarget.innerHTML = '<div class="text-muted">제출 목록을 불러오는 중...</div>';
        showSubmissions();

        fetch(`/learning/prof/task-presentn?estbllctreCode=${encodeURIComponent(estbllctreCode)}&taskNo=${encodeURIComponent(taskNo)}`)
            .then(res => res.ok ? res.json() : Promise.reject(new Error('제출 목록 불러오기 실패')))
            .then(data => renderSubmissionsGrid(toArray(data), taskTitle))
            .catch(err => gridTarget.innerHTML = `<div class="text-danger">${err.message}</div>`);
    };

    targetGrid && targetGrid.addEventListener('click', (e) => {
        const editLink = e.target.closest('[data-action="edit-task"]');
        if (editLink) {
            e.preventDefault();
            const task = {
                taskNo: editLink.getAttribute('data-task-no'),
                title: editLink.getAttribute('data-task-title') || editLink.closest('tr')?.querySelector('td:nth-child(2)')?.textContent?.trim() || '',
                content: editLink.getAttribute('data-task-cn') || '',
                startDate: editLink.getAttribute('data-task-start') || editLink.closest('tr')?.querySelector('td:nth-child(3)')?.textContent?.trim() || '',
                dueDate: editLink.getAttribute('data-task-due') || editLink.closest('tr')?.querySelector('td:nth-child(4)')?.textContent?.trim() || ''
            };
            openEditModal(task);
            return;
        }

        const deleteLink = e.target.closest('[data-action="delete-task"]');
        if (deleteLink) {
            e.preventDefault();
            const taskNo = deleteLink.getAttribute('data-task-no');
            if (taskNo) handleDeleteTask(taskNo);
            return;
        }

        const link = e.target.closest('[data-action="view-submissions"]');
        if (!link) return;
        e.preventDefault();
        const taskNo = link.getAttribute('data-task-no');
        const taskTitle = link.closest('tr')?.querySelector('td:nth-child(2)')?.textContent?.trim();
        if (taskNo) loadSubmissions(taskNo, taskTitle);
    });

    const handleDeleteTask = async (taskNo) => {
        const confirm = await Swal.fire({
            icon: 'warning',
            title: '과제를 삭제하시겠습니까?',
            text: '제출 데이터가 함께 삭제될 수 있습니다.',
            showCancelButton: true,
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        });
        if (!confirm.isConfirmed) return;

        try {
            const res = await fetch(`/learning/prof/task?estbllctreCode=${encodeURIComponent(estbllctreCode)}&taskNo=${encodeURIComponent(taskNo)}`, {
                method: 'DELETE'
            });
            if (!res.ok) throw new Error(`삭제 실패 (${res.status})`);

            window.__INIT_TASKS = toArray(window.__INIT_TASKS).filter(t => String(t.taskNo) !== String(taskNo));
            renderTasksWithGrid(window.__INIT_TASKS, window.__INIT_TASK_PRESENTN);
            Swal.fire({ icon: 'success', title: '삭제되었습니다.', timer: 1200, showConfirmButton: false });
        } catch (err) {
            console.error(err);
            Swal.fire({ icon: 'error', title: '삭제 실패', text: err.message || '잠시 후 다시 시도하세요.' });
        }
    };

    submissionBackBtn && submissionBackBtn.addEventListener('click', showTasks);

    const renderTasksWithGrid = (tasks, submissions) => {
        // 기본값: 초기 주입 데이터 사용, 배열 안전 변환
        const taskList = toArray(tasks ?? window.__INIT_TASKS ?? []);
        const submissionList = toArray(submissions ?? window.__INIT_TASK_PRESENTN ?? []);

        const byTask = submissionList.reduce((acc, s) => {
            acc[s.taskNo] = acc[s.taskNo] || { total: 0, submitted: 0 };
            acc[s.taskNo].total += 1;
            if (s.presentnAt === '1') acc[s.taskNo].submitted += 1;
            return acc;
        }, {});

        const rows = taskList.map((t, idx) => {
            const stat = byTask[t.taskNo] || { total: 0, submitted: 0 };
            const taskTitle = t.taskSj || '';
            const taskDue = t.taskClosDe || '';
            const taskContent = decodeBase64Utf8(t.taskCn) || '';
            return [
                idx + 1,
                t.taskSj,
                t.week,
                `${t.taskBeginDe}`,
                `${t.taskClosDe}`,
                `${stat.submitted}/${stat.total}`,
                gridjs.html(`
                    <div class="dropend">
                        <button class="btn btn-ghost-primary btn-icon btn-sm" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                          <svg xmlns="http://www.w3.org/2000/svg" 
                          width="24" height="24" viewBox="0 0 24 24" 
                          fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" 
                          stroke-linejoin="round" class="feather feather-more-vertical icon-sm">
                            <circle cx="12" cy="12" r="1"></circle>
                            <circle cx="12" cy="5" r="1"></circle>
                            <circle cx="12" cy="19" r="1"></circle>
                          </svg>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#" data-action="edit-task" data-task-no="${t.taskNo}" data-task-title="${escapeAttr(taskTitle)}" data-task-start="${escapeAttr(t.taskBeginDe || '')}" data-task-due="${escapeAttr(taskDue)}" data-task-cn="${escapeAttr(taskContent)}">과제 수정</a></li>
                            <li><a class="dropdown-item" href="#" data-action="view-submissions" data-task-no="${t.taskNo}">제출 확인</a></li>
                            <li><div class="dropdown-divider"></div></li>
                            <li><a class="dropdown-item text-danger" href="#" data-action="delete-task" data-task-no="${t.taskNo}">삭제</a></li>
                        </ul>
                      </div>
        `)
            ];
        });

        const target = document.getElementById('taskGrid');
        target.innerHTML = '';

        const options = {
            columns: [
                {
                    id: 'no',
                    name: '번호',
                    search: false
                },
                {
                    id: 'title',
                    name: '제목',
                    search: true
                },
                {
                    id: 'week',
                    name: '주차',
                    search: false
                },
                {
                    id: 'opnDe',
                    name: '시작일자',
                    search: false
                },
                {
                    id: 'closDe',
                    name: '마감일자',
                    search: false
                },
                {
                    id: 'submit',
                    name: '제출',
                    search: false
                },
                {
                    id: 'actions',
                    name: '',
                    search: false
                },
            ],
            data: rows,
            pagination: {
                ...DEFAULT_GRID_OPTIONS.pagination,
                limit: 20
            },
            language: {
                noRecordsFound: '과제가 없습니다.',
                search: '과제 제목으로 검색'
            }
        };

        gridInit(options, target);
        requestAnimationFrame(() => injectTotal(target, rows.length));
    };

    // 날짜 관련 유틸
    const todayStr = () => new Date().toISOString().slice(0, 10);

    const normalizeDate = raw => {
        if (!raw) return "";
        const cleaned = String(raw).replace(/[.\s]/g, "-");
        if (cleaned.includes("-")) return cleaned.slice(0, 10);
        if (cleaned.length === 8) {
            // 20251128 -> 2025-11-28
            return `${cleaned.slice(0, 4)}-${cleaned.slice(4, 6)}-${cleaned.slice(6, 8)}`;
        }
        if (cleaned.length === 6) return `20${cleaned.slice(0,2)}-${cleaned.slice(2,4)}-${cleaned.slice(4,6)}`
        return cleaned;
    };

    const toISODate = val => {
        const norm = normalizeDate(val);
        const d = new Date(norm);
        return isNaN(d) ? todayStr() : d.toISOString().slice(0, 10);
    };

    const shiftDate = (iso, delta) => {
        const d = new Date(iso);
        d.setDate(d.getDate() + delta);
        return d.toISOString().slice(0, 10);
    };

    const formatLabel = iso => {
        const norm = normalizeDate(iso);
        if (!norm) return "";
        const [y, m, d] = norm.split("-");
        return `${y}. ${m}. ${d}`;
    };

    const escapeAttr = v => String(v ?? '').replace(/"/g, '&quot;');

    const ensureEditEditor = () => {
        if (editTaskEditor) return Promise.resolve(editTaskEditor);
        if (!window.ClassicEditor || !editTaskContentInput) return Promise.reject(new Error('CKEditor 로더를 찾을 수 없습니다.'));
        return ClassicEditor
            .create(editTaskContentInput)
            .then(editor => {
                editTaskEditor = editor;
                return editor;
            });
    };

    const addExRow = (listEl, data = {}) => {
        const idx = listEl.children.length + 1;
        const row = document.createElement('div');
        row.className = 'd-flex align-items-center gap-2 quiz-ex-row';
        row.innerHTML = `
          <div class="d-flex align-items-center gap-2 mb-2">
             <input type="text" class="form-control form-control-sm" style="width:30px" value="${idx}" data-field="exNo" readonly>
            <input type="text" class="form-control form-control-sm" style="width:350px" placeholder="보기 내용" value="${data.exCn || ''}" data-field="exCn" required>
             <div class="form-check d-flex align-items-center ms-1" style="white-space: nowrap;">
                <input class="form-check-input"
                       type="checkbox"
                       ${data.cnslAt === '1' ? 'checked' : ''}
                       data-field="cnslAt">
                <label class="form-check-label small ms-1">정답</label>
              </div>
          </div>
    `;
        listEl.appendChild(row);
    };
    const renumberEx = (listEl) => [...listEl.querySelectorAll('[data-field="exNo"]')].forEach((el, i) => el.value = i + 1);
    const fillExList = (listEl, arr = []) => { listEl.innerHTML = ''; (arr.length ? arr : [{}]).forEach(d => addExRow(listEl, d)); renumberEx(listEl); };
    const collectExList = (listEl) => [...listEl.querySelectorAll('.quiz-ex-row')].map((row, i) => ({
        exNo: i + 1,
        exCn: row.querySelector('[data-field="exCn"]').value.trim(),
        cnslAt: row.querySelector('[data-field="cnslAt"]').checked ? '1' : '0'
    })).filter(ex => ex.exCn);

    quizExAddBtn?.addEventListener('click', () => { addExRow(quizExList); renumberEx(quizExList); });
    quizExDelBtn?.addEventListener('click', () => { if (quizExList.lastElementChild) quizExList.removeChild(quizExList.lastElementChild); renumberEx(quizExList); });

    const openCreateQuizModal = () => {
        if (!createQuizForm) return;
        createQuizForm.reset();
        createQuizBegin.value = todayStr();
        createQuizClose.value = todayStr();
        fillExList(quizExList, [{},{},{},{}]); // 기본 4지선다
        bootstrap.Modal.getOrCreateInstance(createQuizModal).show();
    };

    quizCreateBtn?.addEventListener('click', openCreateQuizModal);

    document.getElementById('create-quiz-submit-btn')?.addEventListener('click', async () => {
        if (!createQuizForm?.checkValidity()) { createQuizForm.reportValidity(); return; }
        const payload = {
            estbllctreCode,
            quesCn: createQuizQuestion.value.trim(),
            week: createQuizWeek?.value,
            quizBeginDe: createQuizBegin.value.replace(/-/g, ''),
            quizClosDe: createQuizClose.value.replace(/-/g, ''),
            quizExVOList: collectExList(quizExList)
        };

        try {
            const res = await fetch('/learning/prof/quiz', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json;charset=utf-8' },
                body: JSON.stringify(payload)
            });

            if (!res.ok) throw new Error(`등록 실패 (${res.status})`);
            const saved = (await res.json().catch(() => ({})))?.data || payload;
            window.__INIT_QUIZZES = toArray(window.__INIT_QUIZZES).concat(saved);
            renderQuizGrid(window.__INIT_QUIZZES, window.__INIT_QUIZ_PRESENTN);
            Swal.fire({ icon: 'success', title: '등록되었습니다.', timer: 1200, showConfirmButton: false });
            bootstrap.Modal.getOrCreateInstance(createQuizModal).hide();
        } catch (err) {
            Swal.fire({ icon: 'error', title: '등록 실패', text: err.message || '잠시 후 다시 시도하세요.' });
        }
    });

    const openEditModal = (task) => {
        if (!editModalEl || !editTaskForm) return;
        const modal = bootstrap.Modal.getOrCreateInstance(editModalEl);
        editTaskForm.reset();
        if (editTaskNoInput) editTaskNoInput.value = task.taskNo || '';
        if (editTaskTitleInput) editTaskTitleInput.value = task.title || '';
        if (editTaskContentInput) editTaskContentInput.value = task.content || '';
        if (editTaskStartInput) editTaskStartInput.value = toISODate(task.startDate || todayStr());
        if (editTaskDueInput) editTaskDueInput.value = toISODate(task.dueDate || todayStr());

        ensureEditEditor()
            .then(editor => editor.setData(task.content || ''))
            .catch(err => console.warn('CKEditor 초기화 실패:', err));

        modal.show();
    };

    const handleDeleteQuiz = async (quizCode) => {
        const confirm = await Swal.fire({
            icon: 'warning',
            title: '퀴즈를 삭제하시겠습니까?',
            text: '제출 데이터가 함께 삭제될 수 있습니다.',
            showCancelButton: true,
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        });
        if (!confirm.isConfirmed) return;

        try {
            const res = await fetch(`/learning/prof/quiz?estbllctreCode=${encodeURIComponent(estbllctreCode)}&quizCode=${encodeURIComponent(quizCode)}`, {
                method: 'DELETE'
            });
            if (!res.ok) throw new Error(`삭제 실패 (${res.status})`);

            window.__INIT_QUIZZES = toArray(window.__INIT_QUIZZES).filter(q => String(q.quizCode) !== String(quizCode));
            renderQuizGrid(window.__INIT_QUIZZES, window.__INIT_QUIZ_PRESENTN);
            Swal.fire({ icon: 'success', title: '삭제되었습니다.', timer: 1200, showConfirmButton: false });
        } catch (err) {
            console.error(err);
            Swal.fire({ icon: 'error', title: '삭제 실패', text: err.message || '잠시 후 다시 시도하세요.' });
        }
    };

    const openEditQuizModal = (quiz) => {
        if (!editQuizForm) return;
        editQuizForm.reset();
        editQuizCode.value = quiz.quizCode || '';
        editQuizQuestion.value = quiz.quesCn || '';
        if (editQuizWeek) editQuizWeek.value = quiz.week || '';
        if (editQuizBegin) editQuizBegin.value = normalizeDate(quiz.quizBeginDe);
        if (editQuizClose) editQuizClose.value = normalizeDate(quiz.quizClosDe);
        fillExList(editQuizExList, quiz.quizeExVOList || quiz.quizExVOList || []);
        bootstrap.Modal.getOrCreateInstance(editQuizModal).show();
    };

    editQuizExAddBtn?.addEventListener('click', () => { addExRow(editQuizExList); renumberEx(editQuizExList); });
    editQuizExDelBtn?.addEventListener('click', () => { if (editQuizExList.lastElementChild) editQuizExList.removeChild(editQuizExList.lastElementChild); renumberEx(editQuizExList); });

    document.getElementById('edit-quiz-submit-btn')?.addEventListener('click', async () => {
        if (!editQuizForm?.checkValidity()) { editQuizForm.reportValidity(); return; }
        const payload = {
            quizCode: editQuizCode.value,
            estbllctreCode,
            quesCn: editQuizQuestion.value.trim(),
            week: editQuizWeek?.value,
            quizBeginDe: editQuizBegin.value.replace(/-/g, ''),
            quizClosDe: editQuizClose.value.replace(/-/g, ''),
            quizExVOList: collectExList(editQuizExList)
        };
        try {
            const res = await fetch('/learning/prof/quiz', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json;charset=utf-8' },
                body: JSON.stringify(payload)
            });
            if (!res.ok) throw new Error(`수정 실패 (${res.status})`);
            const saved = (await res.json().catch(() => ({})))?.data || payload;
            window.__INIT_QUIZZES = toArray(window.__INIT_QUIZZES).map(q =>
                String(q.quizCode) === String(saved.quizCode) ? { ...q, ...saved } : q
            );
            renderQuizGrid(window.__INIT_QUIZZES, window.__INIT_QUIZ_PRESENTN);
            Swal.fire({ icon: 'success', title: '수정되었습니다.', timer: 1200, showConfirmButton: false });
            bootstrap.Modal.getOrCreateInstance(editQuizModal).hide();
        } catch (err) {
            Swal.fire({ icon: 'error', title: '수정 실패', text: err.message || '잠시 후 다시 시도하세요.' });
        }
    });

    const ensureCreateEditor = () => {
        if (createTaskEditor) return Promise.resolve(createTaskEditor);
        if (!window.ClassicEditor || !createTaskContent) return Promise.reject(new Error('CKEditor 로더가 없습니다.'));
        return ClassicEditor.create(createTaskContent).then(editor => {
            createTaskEditor = editor;
            return editor;
        });
    };

    const openCreateModal = () => {
        if (!createModalEl || !createTaskForm) return;
        createTaskForm.reset();
        ensureCreateEditor().then(ed => ed.setData('')).catch(console.warn);
        if (createTaskStart) createTaskStart.value = todayStr();
        if (createTaskDue) createTaskDue.value = todayStr();
        bootstrap.Modal.getOrCreateInstance(createModalEl).show();
    };

    document.getElementById('task-create-btn')?.addEventListener('click', openCreateModal);

    const weekSelect = document.getElementById('create-task-week');
    const toDbDate = v => (v || "").replace(/[-.\s]/g, "").slice(0, 8);
    document.getElementById('create-task-submit-btn')?.addEventListener('click', async () => {
        if (!createTaskForm.checkValidity()) {
            createTaskForm.reportValidity();
            return;
        }
        const payload = {
            taskSj: createTaskTitle.value.trim(),
            taskCn: createTaskEditor ? createTaskEditor.getData() : (createTaskContent.value || ''),
            taskBeginDe: toDbDate(createTaskStart.value),
            taskClosDe: toDbDate(createTaskDue.value),
            estbllctreCode: estbllctreCode,
            week: weekSelect?.value,
        };

        try {
            const res = await fetch('/learning/prof/task', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json;charset=utf-8' },
                body: JSON.stringify(payload)
            });
            if (!res.ok) throw new Error(`등록 실패 (${res.status})`);
            const json = await res.json().catch(() => ({}));
            const created = json?.data || {};

            const nextTasks = toArray(window.__INIT_TASKS).concat(created);
            window.__INIT_TASKS = nextTasks;
            renderTasksWithGrid(nextTasks, window.__INIT_TASK_PRESENTN);
            Swal.fire({ icon: 'success', title: '과제가 등록되었습니다.', timer: 1200, showConfirmButton: false });
            bootstrap.Modal.getOrCreateInstance(createModalEl).hide();
        } catch (err) {
            console.error(err);
            Swal.fire({ icon: 'error', title: '과제 등록 실패', text: err.message || '잠시 후 다시 시도하세요.' });
        }
    });

    const statusLabel = { "1": "출석", "2": "지각", "3": "조퇴" };
    const mapStatus = code => statusLabel[code] || "결석";

    const attendanceModule = (() => {
        const attendGrid = document.querySelector("#attendGrid");
        const emptyBox = document.querySelector("#attendance-empty");
        const dateLabel = document.querySelector("#attendance-date");
        const datePicker = document.querySelector("#attendance-date-picker");
        const prevBtn = document.querySelector("#attendance-prev");
        const nextBtn = document.querySelector("#attendance-next");
        const calendarBtn = document.querySelector("#attendance-calendar-btn");
        const loadingText = document.querySelector("#attend .card-body .text-muted");

        const statusFilterEl = document.createElement('select');
        statusFilterEl.id = 'attendance-status-filter';
        statusFilterEl.className = 'form-select form-select-sm';
        statusFilterEl.style.width = '120px';
        statusFilterEl.innerHTML = `
            <option value="ALL">전체</option>
            <option value="1">출석</option>
            <option value="2">지각</option>
            <option value="0">결석</option>
          `;
        statusFilterEl.addEventListener('change', e => {
            console.log(e.target.value);
            state.statusFilter = e.target.value || 'ALL';
            renderFiltered();
        });

        // 출결 DOM이 아예 없으면 noop
        if (!attendGrid || !dateLabel || !datePicker) {
            return { load: () => {} };
        }

        const toggle = (el, show) => el && el.classList.toggle("d-none", !show);

        const state = {
            loaded: false,
            allRows: [],
            attendDate: todayStr(),
            statusFilter: 'ALL'
        };

        const hideLoading = () => {
            if (loadingText) loadingText.remove();
        };

        const formatStatusBadge = code => {
            const txt = mapStatus(code);
            const cls = code === "1" ? "success" : code === "2" ? "warning" : "danger";
            return `<span class="badge bg-${cls}">${txt}</span>`;
        };

        const updateDateLabel = () => {
            state.attendDate = toISODate(state.attendDate);
            dateLabel.textContent = formatLabel(state.attendDate);
            datePicker.value = state.attendDate;
        };

        const renderGrid = rows => {
            if (!rows.length) {
                attendGrid.innerHTML = "";
                toggle(emptyBox, true);
                return;
            }

            toggle(emptyBox, false);
            attendGrid.innerHTML = "";

            const data = rows.map(item => {
                const s = item.stdntVO || {};
                const subj = s.subjctVO || item.subjctVO || {};
                const stdntNo = s.stdntNo || item.stdntNo || "";
                const stdntNm = s.stdntNm || "";
                const deptNm = subj.subjctNm || "";
                const lctreDe = normalizeDate(item.lctreDe);
                const statusCell = gridjs.html(formatStatusBadge(item.atendSttusCode));
                return [
                    stdntNo,
                    stdntNm,
                    deptNm,
                    statusCell,
                    gridjs.html(`
                    <div class="dropend">
                        <button class="btn btn-ghost-primary btn-icon btn-sm" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                          <svg xmlns="http://www.w3.org/2000/svg" 
                          width="24" height="24" viewBox="0 0 24 24" 
                          fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" 
                          stroke-linejoin="round" class="feather feather-more-vertical icon-sm">
                            <circle cx="12" cy="12" r="1"></circle>
                            <circle cx="12" cy="5" r="1"></circle>
                            <circle cx="12" cy="19" r="1"></circle>
                          </svg>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#" data-action="attend-stats" data-stdnt-no="${stdntNo}" data-stdnt-nm="${stdntNm}">출석률 보기</a></li>
                        </ul>
                      </div>
                    `)
                ];
            });

            const options = {
                columns: [
                    { id: "stdntNo", name: "학번", sort: true, search: true },
                    { id: "stdntNm", name: "이름", sort: true, search: true },
                    { id: "sbjctNm", name: "학과", sort: false, search: false },
                    { id: "atendSttusCode", name: "상태", sort: false, search: false },
                    { id: "actions", name: "", sort: false, search: false }
                ],
                data,
                language: {
                    noRecordsFound: '출결 데이터가 없습니다.',
                    search: '학번 및 이름으로 검색'
                }
            }

            gridInit(options, attendGrid);
            requestAnimationFrame(() => {
                const head = attendGrid.querySelector('.gridjs-head');
                const search = head?.querySelector('.gridjs-search');
                const searchInput = search?.querySelector('input');
                if (head && searchInput && !head.querySelector('#attendance-status-filter')) {
                    head.prepend(statusFilterEl)
                }

                injectTotal(attendGrid, rows.length)
            });
        };

        const renderFiltered = () => {
            const base = normalizeDate(state.attendDate);
            const byDate = state.allRows.filter(r => normalizeDate(r.lctreDe) === base);
            const filtered = state.statusFilter === 'ALL'
                ? byDate
                : byDate.filter(r => String(r.atendSttusCode || '') === state.statusFilter );
            renderGrid(filtered);
        };

        const load = async () => {
            if (!estbllctreCode) {
                toggle(emptyBox, true);
                if (emptyBox) emptyBox.textContent = "개설강의 코드가 없어 출결을 불러올 수 없습니다.";
                hideLoading();
                return;
            }

            // 이미 한 번 로딩했다면 서버 재호출 없이 필터만
            if (state.loaded) {
                hideLoading();
                updateDateLabel();
                renderFiltered();
                return;
            }

            try {
                toggle(emptyBox, false);
                if (loadingText) loadingText.textContent = "출결 데이터를 불러오는 중...";

                const res = await fetch(
                    `/learning/prof/attend?estbllctreCode=${encodeURIComponent(estbllctreCode)}`
                );

                if (!res.ok) throw new Error(`요청 실패 (${res.status})`);

                const json = await res.json();
                // 응답이 배열이거나 { data: [...] } 모두 대응
                state.allRows = toArray(json);
                state.loaded = true;

                // 기본 날짜는 항상 오늘로 설정
                state.attendDate = todayStr();

                updateDateLabel();
                renderFiltered();
            } catch (err) {
                console.error(err);
                attendGrid.innerHTML = "";
                toggle(emptyBox, true);
                if (emptyBox) emptyBox.textContent = "출결 데이터를 불러오지 못했습니다.";
            } finally {
                hideLoading();
            }
        };

        // 날짜 네비게이션 이벤트
        prevBtn && prevBtn.addEventListener("click", () => {
            state.attendDate = shiftDate(toISODate(state.attendDate), -1);
            updateDateLabel();
            renderFiltered();
        });

        nextBtn && nextBtn.addEventListener("click", () => {
            state.attendDate = shiftDate(toISODate(state.attendDate), 1);
            updateDateLabel();
            renderFiltered();
        });

        calendarBtn && calendarBtn.addEventListener("click", () => {
            if (datePicker.showPicker) datePicker.showPicker();
            else datePicker.click();
        });

        datePicker && datePicker.addEventListener("change", e => {
            if (!e.target.value) return;
            state.attendDate = e.target.value;
            updateDateLabel();
            renderFiltered();
        });

        // 초기 라벨만 세팅 (실제 데이터 로드는 탭 전환 시)
        updateDateLabel();

        return { load, getState: () => state };
    })();

    // 출석률 모달/차트
    const statsModalEl = document.getElementById('attendanceStatsModal');
    const statsModal = statsModalEl ? new bootstrap.Modal(statsModalEl) : null;
    const statsCanvas = document.getElementById('attendanceStatsChart');
    const statsMeta = document.getElementById('attendanceStatsMeta');
    let statsChart = null;

    const renderAttendanceChart = (stdntNo, stdntNm) => {
        if (!statsCanvas) return;
        const state = attendanceModule?.getState ? attendanceModule.getState() : null;
        const rows = state?.allRows || [];
        const filtered = rows.filter(r => {
            const no = r.stdntVO?.stdntNo || r.stdntNo;
            return String(no) === String(stdntNo);
        });

        const counts = { att: 0, late: 0, early: 0, abs: 0 };
        filtered.forEach(r => {
            switch (String(r.atendSttusCode)) {
                case "1": counts.att += 1; break; // 출석
                case "2": counts.late += 1; break; // 지각
                case "3": counts.early += 1; break; // 조퇴
                default: counts.abs += 1; // 결석
            }
        });

        const labels = ["출석", "지각", "조퇴", "결석"];
        const data = [counts.att, counts.late, counts.early, counts.abs];
        const colors = ["#0d6efd", "#ffc107", "#dc3545", "#dc3545"];

        if (statsChart) {
            statsChart.destroy();
            statsChart = null;
        }

        statsChart = new Chart(statsCanvas, {
            type: "doughnut",
            data: {
                labels,
                datasets: [{
                    data,
                    backgroundColor: colors,
                    borderWidth: 1
                }]
            },
            options: {
                plugins: {
                    legend: { position: "bottom" }
                }
            }
        });

        if (statsMeta) {
            const total = data.reduce((a, b) => a + b, 0);
            statsMeta.textContent = `${stdntNm || stdntNo || ""} · 총 ${total}회`;
        }

        statsModal?.show();
    };


    const boardNameByCode = (code) => {
        const found = boardState.meta.find(b => String(b.bbsCode) === String(code));
        return found?.bbsNm || '';
    };

    const renderBoardFilter = () => {
        if (!boardFilter) return;
        const selected = boardFilter.value;
        boardFilter.innerHTML = '<option value=\"\">전체</option>';
        boardState.meta.forEach(b => {
            const opt = document.createElement('option');
            opt.value = b.bbsCode;
            opt.textContent = b.bbsNm || `분류 ${b.bbsCode}`;
            if (selected && String(selected) === String(b.bbsCode)) opt.selected = true;
            boardFilter.appendChild(opt);
        });
    };

    const renderBoardList = () => {
        if (!boardGrid) return;
        const filtered = boardFilter?.value
            ? boardState.list.filter(item => String(item.bbsCode) === String(boardFilter.value))
            : boardState.list;

        const rows = filtered.map((item, idx) => {
            const typeName = boardNameByCode(item.bbsCode);
            const writer = item.sklstfNm || item.stdntNm || item.stdntNo || item.acntId || '-';
            const date = normalizeDate(item.bbscttWritngDe);
            const title = escapeAttr(item.bbscttSj || '(제목 없음)');
            const viewUrl = `/learning/prof/board?code=${encodeURIComponent(item.bbsCode || '')}&no=${encodeURIComponent(item.bbscttNo || '')}`;
            return [
                idx + 1,
                typeName || '-',
                gridjs.html(`<a href="${viewUrl}" class="text-decoration-none">${title}</a>`),
                writer,
                date,
                item.bbscttRdcnt ?? 0
            ];
        });

        boardGrid.innerHTML = '';
        const options = {
            columns: [
                { id: 'no', name: '번호', sort: true, search: false },
                { id: 'type', name: '분류', sort: false, search: true },
                { id: 'title', name: '제목', sort: false, search: true },
                { id: 'writer', name: '작성자', sort: false, search: true },
                { id: 'date', name: '작성일', sort: true, search: false },
                { id: 'view', name: '조회수', sort: true, search: false }
            ],
            data: rows,
            pagination: { ...DEFAULT_GRID_OPTIONS.pagination, limit: 15 },
            language: { noRecordsFound: '게시글이 없습니다.', search: '제목, 작성자로 검색' }
        };
        gridInit(options, boardGrid);
        requestAnimationFrame(() => injectTotal(boardGrid, rows.length));
    };

    const renderBoardDetail = (board) => {
        if (!boardDetail) return;
        currentBoard = board;
        boardDetail.classList.remove('d-none');
        if (boardDetailTitle) boardDetailTitle.textContent = board?.bbscttSj || '(제목 없음)';
        if (boardDetailType) boardDetailType.textContent = boardNameByCode(board?.bbsCode) || '분류 없음';
        const writer = board?.sklstfNm || board?.stdntNm || board?.stdntNo || board?.acntId || '-';
        const date = normalizeDate(board?.bbscttWritngDe);
        if (boardDetailMeta) boardDetailMeta.textContent = `${writer}${date ? ` · ${date}` : ''}`;
        if (boardDetailBody) {
            const body = board?.bbscttCn || '';
            boardDetailBody.innerHTML = body.replace(/\n/g, '<br/>');
        }
    };

    const openBoardDetail = (bbscttNo) => {
        if (!bbscttNo) return;
        if (boardDetailBody) boardDetailBody.innerHTML = '<div class=\"text-muted\">게시글을 불러오는 중...</div>';
        if (boardDetail) boardDetail.classList.remove('d-none');
        fetch(`/learning/prof/board/detail?estbllctreCode=${encodeURIComponent(estbllctreCode)}&bbscttNo=${encodeURIComponent(bbscttNo)}`)
            .then(res => res.ok ? res.json() : Promise.reject(new Error('게시글을 불러오지 못했습니다.')))
            .then(data => renderBoardDetail(data?.data || data))
            .catch(err => boardDetailBody && (boardDetailBody.innerHTML = `<div class=\"text-danger\">${err.message}</div>`));
    };

    const resetBoardForm = (board = null) => {
        if (!boardModalEl) return;
        boardModalEl.querySelector('#boardForm')?.reset();
        if (boardCttNoInput) boardCttNoInput.value = board?.bbscttNo || '';
        if (boardTitleInput) boardTitleInput.value = board?.bbscttSj || '';
        if (boardContentInput) boardContentInput.value = board?.bbscttCn || '';

        if (boardBbsCodeSelect) {
            boardBbsCodeSelect.innerHTML = '';
            const targetCode = board?.bbsCode ? String(board.bbsCode) : (boardFilter?.value || '');
            boardState.meta.forEach(b => {
                const opt = document.createElement('option');
                opt.value = b.bbsCode;
                opt.textContent = b.bbsNm || `분류 ${b.bbsCode}`;
                if (String(targetCode) === String(b.bbsCode)) opt.selected = true;
                boardBbsCodeSelect.appendChild(opt);
            });
        }

        const modalTitle = boardModalEl.querySelector('#boardModalLabel');
        if (modalTitle) modalTitle.textContent = board ? '게시글 수정' : '게시글 작성';
        if (boardModalInstance) boardModalInstance.show();
    };

    const loadBoard = async (force = false) => {
        if (!boardGrid) return;
        if (boardState.loaded && !force) {
            renderBoardFilter();
            renderBoardList();
            return;
        }
        boardGrid.innerHTML = '<div class=\"text-muted\">게시판을 불러오는 중...</div>';
        try {
            const res = await fetch(`/learning/prof/board?estbllctreCode=${encodeURIComponent(estbllctreCode)}`);
            if (!res.ok) throw new Error('게시판 로드 실패');
            const data = await res.json();
            boardState.meta = toArray(data?.bbsList);
            boardState.list = toArray(data?.data);
            boardState.loaded = true;
            renderBoardFilter();
            renderBoardList();
        } catch (err) {
            console.error(err);
            boardGrid.innerHTML = `<div class=\"text-danger\">${err.message}</div>`;
        }
    };

    const saveBoard = () => {
        if (!boardTitleInput || !boardBbsCodeSelect) return;
        const payload = {
            estbllctreCode,
            bbscttSj: boardTitleInput.value.trim(),
            bbscttCn: boardContentInput?.value?.trim() || '',
            bbsCode: boardBbsCodeSelect.value
        };
        const isEdit = !!(boardCttNoInput?.value);
        if (isEdit) payload.bbscttNo = boardCttNoInput.value;

        const method = isEdit ? 'PUT' : 'POST';
        fetch('/learning/prof/board', {
            method,
            headers: { 'Content-Type': 'application/json; charset=utf-8' },
            body: JSON.stringify(payload)
        })
            .then(res => res.ok ? res.json() : res.json().catch(() => ({})).then(body => Promise.reject(new Error(body.message || '저장 실패'))))
            .then(data => {
                boardState.loaded = false;
                boardModalInstance?.hide();
                return loadBoard(true).then(() => {
                    const createdNo = data?.data?.bbscttNo;
                    if (createdNo) openBoardDetail(createdNo);
                });
            })
            .catch(err => Swal.fire({ icon: 'error', title: '저장 실패', text: err.message || '잠시 후 다시 시도하세요.' }));
    };

    const deleteBoard = () => {
        if (!currentBoard?.bbscttNo) return;
        Swal.fire({
            icon: 'warning',
            title: '게시글을 삭제할까요?',
            text: '삭제 후 되돌릴 수 없습니다.',
            showCancelButton: true,
            confirmButtonText: '삭제',
            cancelButtonText: '취소'
        }).then(res => {
            if (!res.isConfirmed) return;
            fetch(`/learning/prof/board?estbllctreCode=${encodeURIComponent(estbllctreCode)}&bbscttNo=${encodeURIComponent(currentBoard.bbscttNo)}`, {
                method: 'DELETE'
            })
                .then(resp => resp.ok ? resp.json() : Promise.reject(new Error('삭제에 실패했습니다.')))
                .then(() => {
                    Swal.fire({ icon: 'success', title: '삭제되었습니다.', timer: 1200, showConfirmButton: false });
                    currentBoard = null;
                    boardDetail?.classList.add('d-none');
                    boardState.loaded = false;
                    return loadBoard(true);
                })
                .catch(err => Swal.fire({ icon: 'error', title: '삭제 실패', text: err.message || '잠시 후 다시 시도하세요.' }));
        });
    };

    // 게시글 제목은 직접 링크로 이동하므로 별도 클릭 핸들러 없음
    boardFilter?.addEventListener('change', () => {
        renderBoardList();
        boardDetail?.classList.add('d-none');
    });
    boardBackBtn?.addEventListener('click', () => {
        boardDetail?.classList.add('d-none');
    });
    boardCreateBtn?.addEventListener('click', () => resetBoardForm(null));
    boardEditBtn?.addEventListener('click', () => {
        if (currentBoard) resetBoardForm(currentBoard);
    });
    boardDeleteBtn?.addEventListener('click', deleteBoard);
    boardSaveBtn?.addEventListener('click', saveBoard);

    const showQuizList = () => {
        quizSection?.classList.remove('d-none');
        quizSubGrid?.classList.add('d-none');
        quizSubmissionBackRow?.classList.add('d-none');
    };
    const showQuizSubmissions = () => {
        quizSection?.classList.add('d-none');
        quizSubGrid?.classList.remove('d-none');
        quizSubmissionBackRow?.classList.remove('d-none');
    };
    quizSubmissionBackBtn?.addEventListener('click', showQuizList);

    const renderQuizSubmissions = (list, title) => {
        if (!quizSubmissionGrid) return;
        quizSubmissionGrid.innerHTML = '';

        if (quizSubmissionTitleEl) {
            quizSubmissionTitleEl.textContent = title ? `${title}` : '제출 목록';
        }

        const rows = toArray(list).map(item => [
            item.stdntNo,
            item.stdntNm || '',
            item.presentnAt === '1' ? '제출' : '미제출',
            item.quizPresentnDe || '-',
            item.quizExCode || '-'
        ]);

        const options = {
            columns: [
                { id: 'stdntNo', name: '학번', search: true, sort: true },
                { id: 'stdntNm', name: '이름', search: true, sort: true },
                { id: 'status', name: '제출상태', search: false, sort: true },
                { id: 'submitDe', name: '제출일', search: false, sort: true },
                { id: 'answer', name: '선택한 보기', search: false, sort: false }
            ],
            data: rows,
            pagination: { ...DEFAULT_GRID_OPTIONS.pagination, limit: 20 },
            language: { noRecordsFound: '제출 데이터가 없습니다.', search: '학번 및 이름으로 검색' }
        };
        gridInit(options, quizSubmissionGrid);
        requestAnimationFrame(() => injectTotal(quizSubmissionGrid, rows.length));
        showQuizSubmissions();
    };

    const loadQuizSubmissions = (quizCode, quizTitle) => {
        if (!quizSubmissionGrid) return;
        quizSubmissionGrid.innerHTML = '<div class="text-muted">제출 목록을 불러오는 중...</div>';
        showQuizSubmissions();

        fetch(`/learning/prof/quiz-presentn?estbllctreCode=${encodeURIComponent(estbllctreCode)}&quizCode=${encodeURIComponent(quizCode)}`)
            .then(res => res.ok ? res.json() : Promise.reject(new Error('제출 목록 불러오기 실패')))
            .then(data => renderQuizSubmissions(toArray(data), quizTitle))
            .catch(err => quizSubmissionGrid.innerHTML = `<div class="text-danger">${err.message}</div>`);
    };

    const renderQuizGrid = (quizList, submissions) => {
        if (!quizGrid) return;

        const byQuiz = toArray(submissions).reduce((acc, s) => {
            const key = s.quizCode;
            acc[key] = acc[key] || { total: 0, submitted: 0 };
            acc[key].total += 1;
            if (s.presentnAt === '1') acc[key].submitted += 1;
            return acc;
        }, {});

        const rows = toArray(quizList).map((q, idx) => {
            const stat = byQuiz[q.quizCode] || { total: 0, submitted: 0 };
            const fullTitle = q.quesCn || '';
            const shortTitle = fullTitle.length > 50 ? `${fullTitle.slice(0, 30)}...` : fullTitle;
            return [
                idx + 1,
                gridjs.html(`<span data-full-title="${escapeAttr(fullTitle)}">${escapeAttr(shortTitle)}</span>`),
                q.week || '',
                q.quizBeginDe || '',
                q.quizClosDe || '',
                `${stat.submitted}/${stat.total}`,
                gridjs.html(`
                      <div class="dropend">
                          <button class="btn btn-ghost-primary btn-icon btn-sm" type="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                 stroke-linejoin="round" class="feather feather-more-vertical icon-sm">
                              <circle cx="12" cy="12" r="1"></circle>
                              <circle cx="12" cy="5" r="1"></circle>
                              <circle cx="12" cy="19" r="1"></circle>
                            </svg>
                          </button>
                          <ul class="dropdown-menu">
                              <li>
                                <a class="dropdown-item" href="#" data-action="edit-quiz"
                                   data-quiz-code="${q.quizCode}"
                                   data-quiz-week="${escapeAttr(q.week || '')}"
                                   data-quiz-begin="${escapeAttr(q.quizBeginDe || '')}"
                                   data-quiz-close="${escapeAttr(q.quizClosDe || '')}"
                                   data-quiz-question="${escapeAttr(q.quesCn || '')}">퀴즈 수정
                                </a>
                              </li>
                              <li><a class="dropdown-item" href="#" data-action="view-quiz-submissions" data-quiz-code="${q.quizCode}">제출 확인</a></li>
                              <li><div class="dropdown-divider"></div></li>
                              <li><a class="dropdown-item text-danger" href="#" data-action="delete-quiz" data-quiz-code="${q.quizCode}">삭제</a></li>
                          </ul>
                      </div>
                  `)
            ];
        });

        quizGrid.innerHTML = '';
        const options = {
            columns: [
                { id: 'code', name: '퀴즈코드', search: true, sort: true },
                { id: 'title', name: '문항', search: true, sort: false },
                { id: 'week', name: '주차', search: false, sort: true },
                { id: 'begin', name: '시작일자', search: false, sort: true },
                { id: 'close', name: '마감일자', search: false, sort: true },
                { id: 'submit', name: '제출', search: false, sort: false },
                { id: 'actions', name: '', search: false, sort: false }
            ],
            data: rows,
            pagination: { ...DEFAULT_GRID_OPTIONS.pagination, limit: 20 },
            language: { noRecordsFound: '퀴즈가 없습니다.', search: '문항 내용으로 검색' }
        };
        gridInit(options, quizGrid);
        requestAnimationFrame(() => injectTotal(quizGrid, rows.length));
        showQuizList();
    };

    quizGrid?.addEventListener('click', (e) => {
        const viewLink = e.target.closest('[data-action="view-quiz-submissions"]');
        const editLink = e.target.closest('[data-action="edit-quiz"]');
        const delLink = e.target.closest('[data-action="delete-quiz"]');

        if (viewLink) {
            e.preventDefault();
            const quizCode = viewLink.getAttribute('data-quiz-code');
            const titleCell = viewLink.closest('tr')?.querySelector('td:nth-child(2) span[data-full-title]');
            const quizTitle = titleCell?.getAttribute('data-full-title') || titleCell?.textContent?.trim();
            if (quizCode) loadQuizSubmissions(quizCode, quizTitle);
            return;
        }

        if (editLink) {
            e.preventDefault();
            const quizCode = editLink.getAttribute('data-quiz-code');
            const fromState = toArray(window.__INIT_QUIZZES).find(q => String(q.quizCode) === String(quizCode)) || {};
            const quiz = {
                quizCode,
                week: editLink.getAttribute('data-quiz-week') || fromState.week,
                quizBeginDe: editLink.getAttribute('data-quiz-begin') || fromState.quizBeginDe,
                quizClosDe: editLink.getAttribute('data-quiz-close') || fromState.quizClosDe,
                quesCn: editLink.getAttribute('data-quiz-question') || fromState.quesCn,
                quizeExVOList: fromState.quizeExVOList || fromState.quizExVOList || []
            };
            openEditQuizModal(quiz);
            return;
        }

        if (delLink) {
            e.preventDefault();
            const quizCode = delLink.getAttribute('data-quiz-code');
            if (quizCode) handleDeleteQuiz(quizCode);
        }
    });

    const loadQuiz = () => {
        if (!quizGrid) return;
        quizGrid.innerHTML = '<div class="text-muted">퀴즈 데이터를 불러오는 중...</div>';

        fetch(`/learning/prof/quiz?estbllctreCode=${encodeURIComponent(estbllctreCode)}`)
            .then(res => res.ok ? res.json() : Promise.reject(new Error('퀴즈 로드 실패')))
            .then(data => {
                const quizzes = toArray(data?.quizzes);
                window.__INIT_QUIZZES = quizzes; // 편집 시 보기까지 포함된 최신 데이터 유지
                renderQuizGrid(quizzes, toArray(data?.submissions));
            })
            .catch(err => {
                quizGrid.innerHTML = '';
                // 서버 호출 실패 시 초기 서버 렌더 데이터로 대체
                renderQuizGrid(window.__INIT_QUIZZES || [], window.__INIT_QUIZ_PRESENTN || []);
                console.error(err);
            });
    };

    // 초기 과제는 모델 데이터로 즉시 렌더
    renderTasksWithGrid(window.__INIT_TASKS || [], window.__INIT_TASK_PRESENTN || []);

    // 탭 전환 시 비동기 로드
    document.querySelectorAll('#profTabs a[data-bs-toggle="tab"]').forEach(tab => {
        tab.addEventListener('shown.bs.tab', (event) => {
            const id = event.target.getAttribute('href').replace('#', '');
            if (id === 'quiz') loadQuiz();
            if (id === 'board') loadBoard();
            if (id === 'attend') attendanceModule.load();
        });
    });
    if (initialTab === 'quiz') loadQuiz();
    if (initialTab === 'board') loadBoard();
    if (initialTab === 'attend') attendanceModule.load();
    attendGrid?.addEventListener('click', (e) => {
        const link = e.target.closest('[data-action="attend-stats"]');
        if (!link) return;
        e.preventDefault();
        const stdntNo = link.getAttribute('data-stdnt-no');
        const stdntNm = link.getAttribute('data-stdnt-nm');
        renderAttendanceChart(stdntNo, stdntNm);
    });

    const updateTask = e => {
        const editForm = document.querySelector("editTaskForm");

        fetch("/learning/prof/updTask", {
            method: "PUT",
            headers: {
                "Content-Type": "application/json; charset=utf-8"
            },
            data: JSON.stringify(editForm)
        })
            .then(resp => {
                if(resp.ok) {
                    Swal.fire({
                        icon: "success",
                        title: "과제 내용을 수정 했어요.",
                        timer:1000,
                        timerProgressBar: !0,
                        showConfirmButton: 0
                    });
                }
            })
            .catch(err => {
                Swal.fire({
                    icon: "error",
                    title: "과제 내용 수정이 실패 했어요",
                    timer: 1000,
                    timerProgressBar: !0,
                    showConfirmButton: 0
                });
            })
    }
})();
