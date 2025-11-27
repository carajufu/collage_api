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
    const toArray = val => Array.isArray(val) ? val : (Array.isArray(val?.data) ? val.data : []);

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

        const rows = toArray(list).map(item => [
            item.stdntNo,
            item.stdntNm,
            item.presentnAt === '1' ? '제출' : '미제출',
            item.taskPresentnDe || '-',
            item.fileGroupNo || '-'
        ]);

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
        const link = e.target.closest('[data-action="view-submissions"]');
        if (!link) return;
        e.preventDefault();
        const taskNo = link.getAttribute('data-task-no');
        const taskTitle = link.closest('tr')?.querySelector('td:nth-child(2)')?.textContent?.trim();
        if (taskNo) loadSubmissions(taskNo, taskTitle);
    });

    submissionBackBtn && submissionBackBtn.addEventListener('click', showTasks);

    const renderTasksWithGrid = (tasks, submissions) => {
        const byTask = submissions.reduce((acc, s) => {
            acc[s.taskNo] = acc[s.taskNo] || { total: 0, submitted: 0 };
            acc[s.taskNo].total += 1;
            if (s.presentnAt === '1') acc[s.taskNo].submitted += 1;
            return acc;
        }, {});

        const rows = (tasks || []).map(t => {
            const stat = byTask[t.taskNo] || { total: 0, submitted: 0 };
            return [
                t.taskNo,
                t.taskSj,
                t.week,
                `${t.taskBeginDe} ~ ${t.taskClosDe}`,
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
                            <li><a class="dropdown-item" href="#">과제 수정</a></li>
                            <li><a class="dropdown-item" href="#" data-action="view-submissions" data-task-no="${t.taskNo}">제출 확인</a></li>
                            <li><div class="dropdown-divider"></div></li>
                            <li><a class="dropdown-item text-danger" href="#">삭제</a></li>
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
                    id: 'period',
                    name: '기간',
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

    const loadQuiz = () => {
        const target = document.getElementById('quizTable');
        fetch(`/learning/prof/quiz?estbllctreCode=${encodeURIComponent(estbllctreCode)}`)
            .then(res => res.ok ? res.json() : Promise.reject(new Error('퀴즈 로드 실패')))
            .then(data => target.innerHTML = JSON.stringify(data))
            .catch(err => target.innerHTML = `<div class="text-danger">${err.message}</div>`);
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
                            <li><a class="dropdown-item" href="#">출석률 보기</a></li>
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

                if (state.allRows.length) {
                    state.attendDate = normalizeDate(state.allRows[0].lctreDe);
                } else {
                    state.attendDate = todayStr();
                }

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

        return { load };
    })();


    const loadBoard = () => {
        const target = document.getElementById('boardTable');
        fetch(`/learning/prof/board?estbllctreCode=${encodeURIComponent(estbllctreCode)}`)
            .then(res => res.ok ? res.json() : Promise.reject(new Error('게시판 로드 실패')))
            .then(data => target.innerHTML = JSON.stringify(data))
            .catch(err => target.innerHTML = `<div class="text-danger">${err.message}</div>`);
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
})();
