<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../../header.jsp" %>
    <!-- dropzone -->
    <link type="text/css" href="/assets/libs/dropzone/basic.css" />
    <link type="text/css" href="/assets/libs/dropzone/dropzone.css" />
    <script type="text/javascript" src="/assets/libs/dropzone/dropzone-min.js"></script>

    <!-- sweetalert2 -->
    <link href="/assets/libs/sweetalert2/sweetalert2.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/assets/libs/sweetalert2/sweetalert2.min.js"></script>

    <!-- girdJs -->
    <link href="/assets/libs/gridjs/theme/mermaid.min.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/assets/libs/gridjs/gridjs.umd.js"></script>

    <!-- custom -->
    <script type="text/javascript" src="/js/wtModal.js"></script>
    <script type="text/javascript" src="/js/wtGrid.js"></script>

    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", () => {
            if(window.Waves) {
                Waves.init();
                Waves.attach(".waves-effect", ["waves-light"]);
            }

            document.querySelector("body").appendChild(frag);
            document.querySelector("body").appendChild(quizFrag);

            // 선택한 주차의 과제 리스트를 보여주는 모달
            const tModal = document.querySelector("#modal");
            let modalId = tModal.id;

            // .task : 과제 여부 알려주는 뱃지
            const taskItems = document.querySelectorAll(".task-item");
            const quizItems = document.querySelectorAll(".quiz-item");

            const taskSubmitBadges = document.querySelectorAll(".task-submit-badge");

            taskSubmitBadges.forEach(async badge => {
                const taskNo = badge.dataset.taskNo;
                try{
                    const submit = await isSubmit(taskNo);
                    if (submit && submit.presentnAt === "1") {
                        badge.textContent = "제출";
                        badge.classList.remove("bg-danger", "bg-secondary");
                        badge.classList.add("bg-success");
                    } else {
                        badge.textContent = "미제출";
                        badge.classList.remove("bg-success", "bg-secondary");
                        badge.classList.add("bg-danger");
                    }
                } catch (e) {
                    badge.textContent = "확인불가";
                    badge.classList.remove("bg-success", "bg-danger");
                    badge.classList.add("bg-secondary");
                }
            });

            const quizSubmitBadges = document.querySelectorAll(".quiz-submit-badge");

            quizSubmitBadges.forEach(async badge => {
                const quizCode = badge.dataset.quizCode;
                try{
                    const submit = await isSubmit(quizCode, { type: "quiz" });
                    if (submit && submit.presentnAt === "1") {
                        badge.textContent = "제출";
                        badge.classList.remove("bg-danger", "bg-secondary");
                        badge.classList.add("bg-success");
                    } else {
                        badge.textContent = "미제출";
                        badge.classList.remove("bg-success", "bg-secondary");
                        badge.classList.add("bg-danger");
                    }
                } catch (e) {
                    badge.textContent = "확인불가";
                    badge.classList.remove("bg-success", "bg-danger");
                    badge.classList.add("bg-secondary");
                }
            });

           // 각 과제 badge의 popModal 호출하는 클릭 이벤트 리스너 등록
            taskItems.forEach(item => {
                item.addEventListener("click", () => {
                    const currentUrl = new URL(window.location.href);
                    const lecNo = currentUrl.searchParams.get("lecNo");
                    const weekNo = item.dataset.weekNo;

                    fetch("/learning/student/task", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json;charset=UTF-8"
                        },
                        body: JSON.stringify({ lecNo, weekNo })
                    })
                        .then(resp => resp.json())
                        .then(rslt => {
                            console.log("chkng rslt > ", rslt);
                            renderList(modalId, rslt.result, {
                                headerTitle: "과제 목록",
                                getTitle: task => task.taskSj,
                                onClick: ( { modalId, items, idx } ) => renderTaskDetail(modalId, items, idx)
                            });
                      })
                      .catch(err => console.error(err));
              });
           });

          quizItems.forEach(e => {
              e.addEventListener("click", () => {
                  const currentUrl = new URL(window.location.href);
                  let lecNo = currentUrl.searchParams.get("lecNo");
                  let weekNo = e.dataset.weekNo;
                  const clickedQuizCode = e.dataset.quizCode;

                  console.log("lecNo, weekNo > ", lecNo, ", ", weekNo);

                  // 해당 주차의 과제 목록 조회하는 post 요청
                  fetch("/learning/student/quiz", {
                      method: "POST",
                      headers: {
                          "Content-Type": "application/json;charset=UTF-8"
                      },
                      body: JSON.stringify({
                          "lecNo": lecNo,
                          "weekNo": weekNo
                      })
                  })
                      .then(resp => resp.json())
                      .then(rslt => {
                          const quizzes = rslt.result || [];
                          if(!quizzes.length) return;

                          const idx = quizzes.findIndex(q => q.quizCode === clickedQuizCode);
                          const startIdx = idx === -1 ? 0 : idx;

                          renderQuizDetail(modalId, quizzes, startIdx);
                      })
                      .catch(err => console.error(err));
              });
          });

           // 모달 외부 영역에만 한정해 closeModal 호출
           //  tModal.addEventListener("click", () => closeModal(tModal.id));
           //  tModal.querySelector("#cont").addEventListener("click", e => e.stopPropagation());
        });

        /**
         * 과제 목록을 생성해 모달 바디에 주입
         * @param {string} modalId - 과제 목록이 주입될 모달의 id
         * @param {Array<Object>} tasks - 응답 받은 과제의 배열
         * @return {void} This function does not return a value.
         */
        function renderList(modalId, items, { headerTitle, getTitle, onClick }) {
            const container = document.createElement("div");
            container.className = "container";

            const group = document.createElement("div");
            group.className = "list-group shadow-sm rounded-3";
            group.id = "listGroup";

            items.forEach((item, idx) => {
                const anchor = document.createElement("a");
                anchor.className = "list-group-item list-group-item-action";
                anchor.style = "cursor: pointer";
                anchor.textContent = getTitle(item, idx); // 콜백으로 필드 이름 일반화

                anchor.addEventListener("click", e => {
                    e.preventDefault();
                    onClick({ modalId, items, idx, item }); // 콜백으로 동작 위임
                });

                group.appendChild(anchor);
            });

            container.appendChild(group);
            changeModalBody(modalId, headerTitle, container);
        }

        /**
         * <p>과제별 상세 내용을 담은 요소를 동적으로 생성해 해당 요소를 화면에 그리는 메서드</p>
         *
         * @param modalId  요소가 나타날 모달의 id
         * @param tasks  해당 주차의 과제 배열
         * @param idx  과제 배열 인덱스
         */
        function renderTaskDetail(modalId, tasks, idx) {
            const chkRoot = document.querySelector("#taskBodyRoot");
            if(chkRoot) { chkRoot.remove(); }

            const root = document.createElement("div");
            root.className = "container mt-4";
            root.id = "taskBodyRoot";

            const grid = document.createElement("div");
            grid.className = "row";
            root.appendChild(grid);

            const side = document.createElement("div");
            side.className = "col-3";
            side.id = "side"
            grid.appendChild(side);

            let group = document.createElement("div");
            group.className = "list-group shadow-sm rounded-3";
            side.appendChild(group);


            let titles = [];            // 선택한 주차의 과제 목록 제목을 담은 배열
            const listGroup = document.querySelector("#listGroup");
            titles = listGroup.querySelectorAll(".list-group-item-action");

            let body = document.createElement("div");
            body.className = "col d-flex flex-column border shadow-sm rounded-3 me-2";
            body.id = "body";
            grid.appendChild(body);

            // 과제 갯수만큼 제목 리스트를 만듬
            for(let i = 0; i < titles.length; i++) {
                let element = document.createElement("button");
                element.className = "list-group-item list-group-item-action";
                element.textContent = titles[i].textContent;

                if(i == idx) { element.classList.add("active"); }

                element.addEventListener("click", () => {
                    side.querySelectorAll(".list-group-item").forEach(el => el.classList.remove("active"));
                    element.classList.add("active");

                    taskDetail(body, tasks[i]);
                });

                group.appendChild(element);
            }

            console.log("chkng before change body >  ", root);
            changeModalBody(modalId, "과제 상세", root);

            if (Array.isArray(tasks) && tasks.length && idx >= 0 && idx < tasks.length) {
                taskDetail(body, tasks[idx]);
            }
        }

        /**
         * <p>선택된 과제의 상세 내용을 본문 영역에 렌더링한다.<br>
         * 기존 본문 요소를 비우고(article 재구성) 제목, 등록/수정 일시, 과제 기간, 본문 내용을 순서대로 추가한다.<br>
         * 날짜는 Asia/Seoul 타임존 기준 로컬 포맷으로 표기한다.
         * @param {HTMLElement} body  상세 내용을 렌더링할 컨테이너 요소
         * @param {Object} detail  상세 내용을 렌더링할 컨테이너 요소
         *  {string} detail.taskSj - 과제 제목 <br>
         *  {string} detail.taskCn - 과제 내용 <br>
         *  {string} detail.taskBeginDe - 과제 시작 일자 <br>
         *  {string} detail.taskClosDe - 과제 종료 일자 <br>
         *  {string} detail.registDt - 등록 일시(ISO/타임스탬프) <br>
         *  {string} [detail.updtDt] - 수정 일시(선택) <br>
         * @returns {void}
         */
        async function taskDetail(body, detail) {
            if(!body || !detail) return;

            body.replaceChildren();

            const article = document.createElement("article");
            article.className = "p-3";
            article.id = "article";

            const taskRow = document.createElement("div");
            taskRow.className = "row";
            taskRow.id = "taskRow";
            article.appendChild(taskRow);

            const tCol = document.createElement("div");
            tCol.className = "col";
            taskRow.appendChild(tCol);

            const title = document.createElement("h3");
            title.textContent = detail.taskSj;
            tCol.appendChild(title);

            const meta = document.createElement("div");

            let registTime = new Date(detail.registDt).toLocaleString("ko-KR", {timeZone: "Asia/Seoul"});
            let registMsg = "작성 일시 : " + registTime;

            let updateTime = "";
            if(detail.updtDt) {
                updateTime = new Date(detail.updtDt).toLocaleString("ko-KR", {timeZone: "Asia/Seoul"});
            }
            let updateMsg = updateTime ? "수정 일시 : " + updateTime : "";

            meta.className = "text-muted fw-lighter small";
            meta.textContent = registMsg + updateMsg;
            tCol.appendChild(meta);

            const deadLine = document.createElement("div");
            deadLine.className = "text-muted fw-lighter mb-3 small";
            deadLine.textContent = "제출기간 : " + detail.taskBeginDe + " ~ " + detail.taskClosDe;
            tCol.appendChild(deadLine);

            article.appendChild(document.createElement("hr"));

            const content = detail.taskCn;
            const pContent = document.createElement("p");
            pContent.className = "my-4";
            pContent.textContent = content;
            article.appendChild(pContent);

            article.appendChild( await renderSubmitBtn(detail.taskNo) );

            body.appendChild(article);
        }

        /**
         * 퀴즈 상세 영역을 렌더링하는 함수 (과제 상세와 레이아웃 공유)
         * @param modalId 요소가 그려질 모달의 id
         * @param quizzes 해당 주차의 퀴즈 배열
         * @param idx 퀴즈 배열 인덱스
         */
        function renderQuizDetail(modalId, quizzes, idx) {
            const chkRoot = document.querySelector("#quizBodyRoot");
            if (chkRoot) { chkRoot.remove(); }

            const root = document.createElement("div");
            root.className = "container mt-4";
            root.id = "quizBodyRoot";

            const grid = document.createElement("div");
            grid.className = "row";
            root.appendChild(grid);

            const side = document.createElement("div");
            side.className = "col-3";
            side.id = "quizSide";
            grid.appendChild(side);

            const group = document.createElement("div");
            group.className = "list-group shadow-sm rounded-3";
            side.appendChild(group);

            const listGroup = document.querySelector("#listGroup");
            const titles = listGroup ? listGroup.querySelectorAll(".list-group-item-action") : [];

            const body = document.createElement("div");
            body.className = "col d-flex flex-column border shadow-sm rounded-3 me-2";
            body.id = "quizBody";
            grid.appendChild(body);

            quizzes.forEach((quiz, i) => {
                const btn = document.createElement("button");
                btn.className = "list-group-item list-group-item-action";
                btn.textContent = quiz.quesCn; // 퀴즈의 질문 텍스트 사용

                if (i === idx) btn.classList.add("active"); // 클릭된 퀴즈 활성화

                btn.addEventListener("click", () => {
                    side.querySelectorAll(".list-group-item").forEach(el => el.classList.remove("active"));
                    btn.classList.add("active");
                    quizDetail(body, quizzes[i]);
                });

                group.appendChild(btn);
            });

            changeModalBody(modalId, "퀴즈 상세", root);

            if (Array.isArray(quizzes) && quizzes.length && idx >= 0 && idx < quizzes.length) {
                quizDetail(body, quizzes[idx]);
            }
        }

        /**
         * 선택한 퀴즈의 본문/보기 목록을 렌더링
         * @param {HTMLElement} body 상세 내용을 렌더링할 컨테이너 요소
         * @param {Object} quiz QuizVO (quesCn, quizeExVOList 등)
         */
        function quizDetail(body, quiz) {
            if (!body || !quiz) return;

            body.replaceChildren();

            const article = document.createElement("article");

            const title = document.createElement("h3");
            title.className = "mt-3 mb-3";
            title.textContent = quiz.quesCn;
            article.appendChild(title);

            if (Array.isArray(quiz.quizeExVOList) && quiz.quizeExVOList.length) {
                const list = document.createElement("ol");
                list.className = "list-group mb-3";

                quiz.quizeExVOList.forEach(ex => {
                    const label = document.createElement("label");
                    label.className = "list-group-item waves-effect waves-light";

                    const radio = document.createElement("input")
                    radio.className = "form-check-input";
                    radio.setAttribute("name", "quiz-" + quiz.quizCode);
                    radio.value =ex.quizExCode;
                    radio.setAttribute("type", "radio");
                    label.appendChild(radio);

                    const exCnWrapper = document.createElement("span");
                    exCnWrapper.textContent = ex.exCn;
                    label.appendChild(exCnWrapper);

                    list.appendChild(label);
                });

                article.appendChild(list);

                article.querySelectorAll("input.form-check-input[type='radio']").forEach(r => r.checked = false);
            }

            const btnWrapper = document.createElement("div");
            btnWrapper.className = "d-flex justify-content-end my-3"; // right align

            article.appendChild(btnWrapper);     // append the div to the article

             const qzSubmBtn = document.createElement("button");
            qzSubmBtn.className = "btn btn-primary w-xs";
            qzSubmBtn.id = "qzSubmBtn";
            qzSubmBtn.textContent = "등록";

            qzSubmBtn.addEventListener("click", () => {
                const selected = article.querySelector(`input.form-check-input[type="radio"]:checked`);
                console.log(article);
                console.log(selected);
                if (!selected) {
                    Swal.fire({
                        icon:"warning",
                        title:"정답을 선택 해주세요.",
                        timer:1000,
                        timerProgressBar: !0,
                        showConfirmButton: 0
                    });
                    return;
                }
                const quizExCode = selected.value;

                const payload = {
                    quizExCode,
                    quizCode: quiz.quizCode
                }

               axios.get("/learning/student/quizSubmit", {
                   params: payload
               })
                   .then(resp => {
                       const isCorrect = resp.data.isCorrect;

                       Swal.fire({
                           icon: isCorrect === "Correct" ? "success" : "error",
                           title: isCorrect === "Correct" ? "정답을 제출 했어요." : "오답을 제출 했어요.",
                           timer:1000,
                           timerProgressBar: !0,
                           showConfirmButton: 0
                       });
                   })
                   .catch(err => {
                       console.log(err.toJSON());
                       Swal.fire({
                           icon:"error",
                           title:"제출이 실패 했어요.",
                           timer:1000,
                           timerProgressBar: !0,
                           showConfirmButton: 0
                       });
                   })
            });

            btnWrapper.appendChild(qzSubmBtn);

            body.appendChild(article);
        }

        /**
         * <p>
         * 현재 학생이 부여된 과제를 제출 했는지 제출 여부를 체크하는 메서드 <br>
         * 제출 데이터를 JSON 형식으로 응답받는 비동기 GET 요청을 서버에 전송한다 <br>
         * 응답 받은 데이터가 존재하지 않으면 null을 반환하고, <br>
         * 데이터가 존재하고 제출 여부 필드가 1이라면 JSON 객체인 데이터를 반환한다 <br>
         * </p>
         * @param { string | number } taskNo 제출 여부를 검색하기 위한 과제 번호
         * @returns {Promise<null>} 데이터 존재 여부에 따라 null 또는 제출 데이터
         */
        async function isSubmit(id, { type = "task" } = {}) {
            let data = null;
            let resp, rslt;

            const config = type === "quiz"
                ? { url: "/learning/student/isQuizSubmit", param: "quizCode" }
                : { url: "/learning/student/isSubmit", param: "taskNo"};

            try {
                const qs = `\${config.param}=\${encodeURIComponent(id)}`;
                resp = await fetch(`\${config.url}?\${qs}`,
                    { method: "GET" });
                rslt = await resp.json();

                if(!rslt.data) { return data; }
                if(rslt.data.presentnAt === "1") { data = rslt.data; }
            } catch(err) {
                console.error("failed get response reason > {}", resp.status);
            }

            return data;
        }

         async function renderSubmitBtn(taskNo) {
            const container = document.createElement("div");
            container.className = "container d-flex justify-content-end gap-3 my-3";
            container.id = "btnContainer";

            const submit = await isSubmit(taskNo);

            const state = { mode: "form" };
            if(!submit) {
                const dz = document.createElement("div");
                dz.className = "dropzone dz-clickable d-flex align-items-center justify-content-center mb-3";
                dz.setAttribute("style", "min-height: 240px");
                dz.id = "taskDz";

                const dzMsg = document.createElement("div");
                dzMsg.className = "dz-message needsclick d-flex flex-column align-items-center text-center";
                dz.appendChild(dzMsg);

                const dzWrapper = document.createElement("div");
                dzMsg.appendChild(dzWrapper);

                const dzIcon = document.createElement("i");
                dzIcon.className = "display-4 text-muted ri-upload-cloud-2-fill";
                dzWrapper.appendChild(dzIcon);

                const dzMent = document.createElement("h4");
                dzMent.textContent = "파일을 이곳에 끌어놓아 업로드 하세요";
                dzMsg.appendChild(dzMent);

                const dzPreview = document.createElement("ul");
                dzPreview.id = "dropzone-preview";
                dzPreview.className = "list-unstyled mb-0";

                const btnContainer = document.createElement("div");
                btnContainer.className = "m-3 fs-6";

                const submitBtn = document.createElement("button");
                submitBtn.className = "btn btn-primary w-xs";
                submitBtn.textContent = "등록";
                submitBtn.id = "submitBtn";

                const cancleBtn = document.createElement("button");
                cancleBtn.className = "btn btn-danger w-xs";
                cancleBtn.id = "submitCanBtn";
                cancleBtn.textContent = "취소";

                let taskDz;
                // todo: (Level 5) 제출한 파일 목록 보기 및 수정
                submitBtn.addEventListener("click", () => {
                    if(state.mode === "form") {
                        const exist = document.querySelector("#taskDz");
                        if(exist) { exist.remove(); }

                        if(taskDz) {
                            taskDz.destroy();
                            taskDz = null;
                        }

                        const oldTitle = document.querySelector("#submitTitle");
                        if(oldTitle) { oldTitle.remove(); }

                        console.log("submit btn clicked");

                        const submitTitle = document.createElement("h4");
                        submitTitle.className = "m-3"
                        submitTitle.id = "submitTitle";
                        submitTitle.textContent = "제출하기";
                        container.before(submitTitle);

                        container.before(dz);
                        container.before(dzPreview);

                        const template = document.querySelector("#preview-template");
                        Dropzone.autoDiscover = false;
                        taskDz = new Dropzone("#taskDz", {
                            url: "/learning/student/fileUpload",
                            paramName: "uploadFiles",
                            previewsContainer: "#dropzone-preview",
                            previewTemplate: template.innerHTML,
                            autoProcessQueue: false,
                            uploadMultiple: true,
                            parallelUploads: 100,
                            maxFilesize: 10,
                            timeout: 0
                        });

                        taskDz.on("addedfile", () => state.mode = "upload");
                        taskDz.on("sendingmultiple", (file, xhr, formData) => {
                            formData.append("taskPresentnNo", taskNo);
                        });
                        taskDz.on("successmultiple", (file, resp) => {
                            Swal.fire({
                                icon: "success",
                                title: "제출이 완료 되었어요",
                                showConfirmButton: 0,
                                timer: 1000,
                                timerProgressBar: !0
                            });
                        });
                        taskDz.on("errormultiple", (files, resp) => {
                           Swal.fire({
                               icon: "error",
                               title: "제출이 실패 되었어요",
                               timer: 1000,
                               timerProgressBar: !0,
                               showConfirmButton: 0,
                               text: String(msg),
                           });
                        });
                        taskDz.on("queuecomplete", () => {
                            const dzEl = document.querySelector("#taskDz");
                            if(dzEl) { dzEl.remove(); }

                            const title = document.querySelector("#submitTitle");
                            if(title) { title.remove(); }

                            if(taskDz) {
                                taskDz.removeAllFiles(true);
                                taskDz.destroy();
                                taskDz = null;
                            }

                            document.querySelector("#submitBtn").remove();
                            document.querySelector("#submitCanBtn").remove();

                            const updateBtn = document.createElement("button");
                            updateBtn.className = "btn btn-outline-primary w-xs";
                            updateBtn.textContent = "수정";

                            updateBtn.addEventListener("click", e => upHandler({ e, taskNo, container, updateBtn: e.currentTarget }));

                            container.appendChild(updateBtn);
                        });
                    }

                    container.appendChild(cancleBtn);

                    if(state.mode === "upload") {
                        console.log("upload btn clicked")
                        fileSubmit(taskDz);

                        state.mode = "form";
                    }
                });

                cancleBtn.addEventListener("click", e => {
                    const dzEl = document.querySelector("#taskDz");
                    if(dzEl) { dzEl.remove(); }

                    const title = document.querySelector("#submitTitle");
                    if(title) { title.remove(); }

                    const prev = document.querySelector("#dropzone-preview");
                    if (prev) prev.remove();

                    if(taskDz) {
                        taskDz.removeAllFiles(true);
                        taskDz.destroy();
                        taskDz = null;
                    }

                    state.mode = "form";

                   e.target.remove();
                });

                container.appendChild(submitBtn);
            }

            if(submit) {
                const updateBtn = document.createElement("button");
                updateBtn.className = "btn btn-outline-primary w-xs";
                updateBtn.textContent = "수정";
                //todo : 수정 이벤트 핸들러 작성
                updateBtn.addEventListener("click", e => upHandler({ e, taskNo, container, updateBtn: e.currentTarget }));
                container.appendChild(updateBtn);
            }

            return container;
        }

        // todo: 수정 버튼 클릭 시 dropzone 레이아웃 화면에 출력 및 Dropzone.displayExistingFile() 이용해 업로드 되었떤 파일 목록 출력
        function upHandler(ctx) {
            const { e, taskNo, container, updateBtn } = ctx || {};
            if (e) { e.preventDefault(); e.stopPropagation(); }
            if (!taskNo || !container || !updateBtn) return;

            ["#taskDz", "#dropzone-preview", "#submitTitle"].forEach(sel => {
                const el = document.querySelector(sel);
                if (el) el.remove();
            });

            const submitTitle = document.createElement("h4");
            submitTitle.className = "m-3";
            submitTitle.id = "submitTitle";
            submitTitle.textContent = "수정하기";
            container.before(submitTitle);

            const dz = document.createElement("div");
            dz.className = "dropzone dz-clickable d-flex align-items-center justify-content-center mb-3";
            dz.style.minHeight = "240px";
            dz.id = "taskDz";

            const dzMsg = document.createElement("div");
            dzMsg.className = "dz-message needsclick d-flex flex-column align-items-center text-center";
            const dzWrapper = document.createElement("div");
            const dzIcon = document.createElement("i");
            dzIcon.className = "display-4 text-muted ri-upload-cloud-2-fill";
            dzWrapper.appendChild(dzIcon);
            const dzMent = document.createElement("h4");
            dzMent.textContent = "파일을 이곳에 끌어놓아 업로드 하세요";
            dzMsg.appendChild(dzWrapper);
            dzMsg.appendChild(dzMent);
            dz.appendChild(dzMsg);
            container.before(dz);

            const dzPreview = document.createElement("ul");
            dzPreview.id = "dropzone-preview";
            dzPreview.className = "list-unstyled mb-0";
            container.before(dzPreview);

            const template = document.querySelector("#preview-template");
            Dropzone.autoDiscover = false;
            const dzInst = new Dropzone("#taskDz", {
                url: "/learning/student/fileUpload",
                paramName: "uploadFiles",
                previewsContainer: "#dropzone-preview",
                previewTemplate: template.innerHTML,
                autoProcessQueue: false,
                uploadMultiple: true,
                parallelUploads: 100,
                maxFilesize: 10,
                timeout: 0,
                addRemoveLinks: false
            });

            const FALLBACK_THUMB = "<c:url value='/assets/images/placeholder.png'/>";
            dzInst.on("thumbnail", (file, dataUrl) => {
                const img = file.previewElement?.querySelector("[data-dz-thumbnail]");
                if(!img) return;

                const isImage = !!dataUrl || (file.type && file.type.indexOf("image/") === 0);

                if (!isImage) {
                    // 이미지가 아닌 경우 (PDF, ZIP 등)
                    img.onerror = null;
                    img.src = FALLBACK_THUMB;
                } else {
                    // 이미지 파일인 경우: 썸네일 로드 실패 시(404 등) 대비하여 onerror를 설정
                    img.onerror = () => {
                        img.onerror = null;
                        img.src = FALLBACK_THUMB;
                    };
                }
            })

            // Track existing files and deletions so they’re “included” unless removed
            const existingMetas = [];               // { fileNo, fileGroupNo, fileNm, fileStreplace, fileMg, fileExtsn }
            const deletedExistingNos = new Set();   // fileNo strings
            let startedUpload = false;

            dzInst.on("removedfile", file => {
                if (file.isExisting && file.meta && file.meta.fileNo != null) {
                    deletedExistingNos.add(String(file.meta.fileNo));
                }
            });

            // Load existing uploaded files and show them
            isSubmit(taskNo)
                .then(data => {
                    const list = (data && data.fileDetailVOList) || [];
                    list.forEach(f => {
                        const mock = { name: f.fileNm, size: Number(f.fileMg) || 0, accepted: true };
                        mock.isExisting = true;
                        mock.meta = {
                            fileNo: f.fileNo,
                            fileGroupNo: f.fileGroupNo,
                            fileNm: f.fileNm,
                            fileStreplace: f.fileStreplace,
                            fileMg: f.fileMg,
                            fileExtsn: f.fileExtsn
                        };
                        existingMetas.push(mock.meta);
                        dzInst.displayExistingFile(mock, f.fileStreplace);
                    });
                })
                .catch(err => console.error("failed to load existing files", err));

            dzInst.on("sendingmultiple", (files, xhr, formData) => {
                startedUpload = true;
                formData.append("taskPresentnNo", taskNo);

                // Include existing files (that the user did not remove) as metadata
                const retained = existingMetas.filter(m => !deletedExistingNos.has(String(m.fileNo)));
                formData.append("retainedExisting", JSON.stringify(retained));
                // Optionally include explicit deletions if you want to handle removes server-side
                formData.append("deletedExisting", JSON.stringify([...deletedExistingNos]));
            });

            // Turn modify button into upload
            const cloned = updateBtn.cloneNode(true);
            updateBtn.replaceWith(cloned);
            cloned.textContent = "수정";
            cloned.addEventListener("click", async () => {
                const hasNew = dzInst.getQueuedFiles().length > 0;
                if (hasNew) { dzInst.processQueue(); return; }

                // 새 파일이 없는 경우, 삭제 여부 확인
                const retained = existingMetas.filter(m => !deletedExistingNos.has(String(m.fileNo)));
                const hasDeletes = deletedExistingNos.size > 0;

                // 변경 사항이 전혀 없는 경우
                if (!hasDeletes) {
                    Swal.fire({
                        icon:"info",
                        title:"변경된 내용이 없습니다.",
                        timer:1000,
                        timerProgressBar: !0,
                        showConfirmButton: 0
                    });
                    return;
                }

                // 삭제만 있는 경우: 메타데이터만 포함하여 수동 전송
                const formData = new FormData();
                formData.append("taskPresentnNo", taskNo);
                formData.append("retainedExisting", JSON.stringify(retained));
                formData.append("deletedExisting", JSON.stringify([...deletedExistingNos]));

                try {
                    const resp = await fetch("/learning/student/fileUpdate", { method: "POST", body: formData });
                    if (!resp.ok) throw new Error("request failed");
                    Swal.fire({
                        icon:"success",
                        title:"수정 완료",
                        timer:1000,
                        timerProgressBar: !0,
                        showConfirmButton: 0
                    });
                    resetUI();
                } catch(e) {
                    Swal.fire({
                        icon:"error",
                        title:"수정 실패",
                        timer:1000,
                        timerProgressBar: !0,
                        showConfirmButton: 0
                    });
                }
            });

            // Add a cancel button
            let cancelBtn = container.querySelector("#updateCancelBtn");
            if (!cancelBtn) {
                cancelBtn = document.createElement("button");
                cancelBtn.id = "updateCancelBtn";
                cancelBtn.className = "btn btn-danger w-xs";
                cancelBtn.textContent = "취소";
                container.appendChild(cancelBtn);
            }

            const resetUI = () => {
                ["#taskDz", "#dropzone-preview", "#submitTitle"].forEach(sel => {
                    const el = document.querySelector(sel);
                    if (el) el.remove();
                });
                if (cancelBtn && cancelBtn.parentNode) cancelBtn.remove();

                const resetClone = cloned.cloneNode(true);
                cloned.replaceWith(resetClone);
                resetClone.textContent = "수정";
                resetClone.addEventListener("click", ev =>
                    upHandler({ e: ev, taskNo, container, updateBtn: ev.currentTarget })
                );
            };

            cancelBtn.addEventListener("click", () => {
                if (dzInst) { dzInst.removeAllFiles(true); dzInst.destroy(); }
                resetUI();
            });

            dzInst.on("queuecomplete", () => {
                if (!startedUpload) return; // don’t reset if we only showed existing files
                if (dzInst) { dzInst.removeAllFiles(true); dzInst.destroy(); }
                resetUI();
            });
        }

        function fileSubmit(dz) {
            dz.processQueue();
        }
    </script>

    <script type="text/javascript">

    </script>

        <div class="row pt-3 px-5">
            <div class="col-xxl-12 col-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item active"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
                        <li class="breadcrumb-item active" aria-current="page">${learnInfo.lecInfo.LCTRE_NM}</li>
                    </ol>
                </nav>
            </div>
            <div class="col-12 page-title mt-2">
                <h2 class="fw-semibold">${learnInfo.lecInfo.LCTRE_NM}</h2>
                <div class="mt-2 d-flex flex-wrap align-items-center text-muted small">
                    <i class="las la-info-circle me-2"></i>
                    <span class="me-3">${learnInfo.lecInfo.SKLSTF_NM}</span>
                    <span class="me-3">${learnInfo.lecInfo.LCTRUM}</span>
                    <span class="me-3">${learnInfo.lecInfo.ESTBL_YEAR}년</span>
                    <span class="me-3">${learnInfo.lecInfo.ESTBL_SEMSTR}</span>
                    <span class="me-3">${learnInfo.lecInfo.COMPL_SE}</span>
                    <span class="me-3">${learnInfo.lecInfo.ACQS_PNT}학점</span>
                </div>
                <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
            </div>
            <div class="col-xxl-7 col-7">
                <!-- 반복문을 통해 아코디언 리스트 생성 -->
                <div class="card card-height-100 border border-1 shadow rounded-3">
                    <div class="card-title">
                        <ul class="nav nav-tabs" role="tablist">
                            <li class="nav-item waves-effect waves-light" role="presentation">
                                <a href="#lecture" class="nav-link active" role="tab" data-bs-toggle="tab" aria-selected="true"><h6>주차 학습</h6></a>
                            </li>
                            <li class="nav-item waves-effect waves-light" role="presentation">
                                <a href="#info" class="nav-link" role="tab" data-bs-toggle="tab" aria-selected="false"><h6>학습 정보</h6></a>
                            </li>
                            <li class="nav-item waves-effect waves-light" role="presentation">
                                <a href="#task" class="nav-link" role="tab" data-bs-toggle="tab" aria-selected="false"><h6>과제</h6></a>
                            </li>
                            <li class="nav-item waves-effect waves-light" role="presentation">
                                <a href="#quiz" class="nav-link" role="tab" data-bs-toggle="tab" aria-selected="false"><h6>퀴즈</h6></a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body p-0" style="min-height: 330px;">
                        <div data-simplebar style="max-height: 330px;" class="px-3">
                            <div class="tab-content">
                                <div class="tab-pane active show" id="lecture" role="tabpanel">
                                    <div class="accordion accordion-flush" id="accordionFlush">
                                        <c:forEach var="week" items="${learnInfo.weekList}">
                                            <div class="accordion-item">
                                                <h2 class="accordion-header" id="flush-heading${week.WEEK}">
                                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse${week.WEEK}" aria-expanded="false" aria-controls="flush-collapse${week.WEEK}">
                                                        <div class="d-flex w-100 align-items-center">
                                                            <div class="d-flex align-items-center">
                                                                <span class="fw-bold fs-5 mx-1">[${week.WEEK}주차]</span><span class="fs-5">${week.LRN_THEMA}</span>
                                                            </div>
                                                            <div class="d-flex align-items-center gap-1 ms-auto badge-group">
                                                                <c:if test="${week.TASK_AT eq '0'}">
                                                                    <span class="badge rounded-pill border boder-light text-body text-center lh-sm">과제</span>
                                                                </c:if>
                                                                <c:if test="${week.TASK_AT eq '1'}">
                                                                    <span class="badge rounded-pill bg-primary text-center lh-sm">과제</span>
                                                                </c:if>
                                                                <c:if test="${week.QUIZ_AT eq '0'}">
                                                                    <span class="badge rounded-pill border boder-light text-center text-body lh-sm me-3">퀴즈</span>
                                                                </c:if>
                                                                <c:if test="${week.QUIZ_AT eq '1'}">
                                                                    <span class="badge rounded-pill bg-primary text-center lh-sm me-3">퀴즈</span>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </button>
                                                </h2>
                                                <div id="flush-collapse${week.WEEK}" class="accordion-collapse collapse p-4" aria-labelledby="flush-heading${week.WEEK}" data-bs-parent="#accordionFlush">
                                                    <p class="fs-5">${week.LRN_CN}</p>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="tab-pane" id="info" role="tabpanel">

                                </div>
                                <div class="tab-pane" id="task" role="tabpanel">
                                    <div class="list-group list-group-flush">
                                        <c:forEach var="week" items="${learnInfo.weekList}">
                                            <c:if test="${week.TASK_AT eq '1'}">
                                                <!-- Week-level parent row -->
                                                <div class="list-group-item bg-light fw-semibold">
                                                    <span class="me-2">[${week.WEEK}주차]</span>
                                                    <span>${week.LRN_THEMA}</span>
                                                </div>

                                                <!-- Child assignments for that week -->
                                                <c:forEach var="task" items="${week.taskList}">
                                                    <button type="button"
                                                            class="list-group-item list-group-item-action ps-2 task-item"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#modal"
                                                            data-week-no="${week.WEEK}"
                                                            data-task-no="${task.taskNo}">
                                                        <div class="row w-100 align-items-center g-0">
                                                            <div class="col-6 pe-2">
                                                                <span class="fw-semibold d-block text-truncate">${task.taskSj}</span>
                                                            </div>
                                                            <div class="col-3 small text-muted text-nowrap">
                                                                    ${fn:substring(task.taskBeginDe, 4, 8)} ~ ${fn:substring(task.taskClosDe, 4, 8)}
                                                            </div>
                                                            <div class="col-3 text-end">
                                                                <span class="badge rounded-pill text-center lh-sm ms-1 task-submit-badge" data-task-no="${task.taskNo}">확인중</span>
                                                            </div>
                                                        </div>
                                                    </button>
                                                </c:forEach>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="tab-pane" id="quiz" role="tabpanel">
                                    <div class="list-group list-group-flush">
                                        <c:forEach var="week" items="${learnInfo.weekList}">
                                            <c:if test="${week.QUIZ_AT eq '1'}">
                                                <!-- Week-level parent row -->
                                                <div class="list-group-item bg-light fw-semibold">
                                                    <span class="me-2">[${week.WEEK}주차]</span>
                                                    <span>${week.LRN_THEMA}</span>
                                                </div>

                                                <!-- Child assignments for that week -->
                                                <c:forEach var="quiz" items="${week.quizList}">
                                                    <button type="button"
                                                            class="list-group-item list-group-item-action ps-2 quiz-item"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#modal"
                                                            data-week-no="${week.WEEK}"
                                                            data-quiz-code="${quiz.quizCode}">
                                                        <div class="row w-100 align-items-center g-0">
                                                            <div class="col-6 pe-2">
                                                                <span class="fw-semibold d-block text-truncate">${quiz.quesCn}</span>
                                                            </div>
                                                            <div class="col-3 small text-muted text-nowrap">
                                                                    ${fn:substring(quiz.quizBeginDe, 4, 8)} ~ ${fn:substring(quiz.quizClosDe, 4, 8)}
                                                            </div>
                                                            <div class="col-3 text-end">
                                                                <span class="badge rounded-pill text-center lh-sm ms-1 quiz-submit-badge" data-quiz-code="${quiz.quizCode}">확인중</span>
                                                            </div>
                                                        </div>
                                                    </button>
                                                </c:forEach>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xxl-5 col-5">
                <div class="card card-height-100 border border-1 shadow rounded-3">
                    <div class="card-title">
                        <ul class="nav nav-tabs" role="tablist">
                            <li class="nav-item waves-effect waves-light" role="presentation">
                                <a href="#attend" class="nav-link active" role="tab" data-bs-toggle="tab" aria-selected="true"><h6>출결</h6></a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body p-0" style="min-height: 330px;">
                        <div class="tab-content">
                            <div class="tab-pane active show" id="attend" role="tabpanel">

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row pt-3 px-5">
            <div class="col-xxl-7 col-7 ">
                <div class="card card-height-100 border border-1 shadow rounded-3">
                    <div class="card-title">
                        <ul class="nav nav-tabs" role="tablist">
                            <li class="nav-item waves-effect waves-light" role="presentation">
                                <a href="#notice" class="nav-link active" role="tab" data-bs-toggle="tab" aria-selected="true"><h6>공지사항</h6></a>
                            </li>
                            <li class="nav-item waves-effect waves-light" role="presentation">
                                <a href="#resource" class="nav-link" role="tab" data-bs-toggle="tab" aria-selected="false"><h6>자료실</h6></a>
                            </li>
                            <li class="nav-item waves-effect waves-light" role="presentation">
                                <a href="#question" class="nav-link" role="tab" data-bs-toggle="tab" aria-selected="false"><h6>질문</h6></a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body p-0" style="min-height: 330px;">
                        <div class="tab-content">
                            <div class="tab-pane active show" id="notice" role="tabpanel">
                                <div class="card h-100">
                                    <div data-simplebar style="max-height: 330px;">
                                        <div class="card-body">
                                            <div id="noticeTable"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="resource" role="tabpanel">
                                <div class="card h-100">
                                    <div data-simplebar style="max-height: 330px;">
                                        <div class="card-body">
                                            <div id="resourceTable"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="question" role="tabpanel">
                                <div class="card h-100">
                                    <div data-simplebar style="max-height: 330px;">
                                        <div class="card-body">
                                            <div id="questionTable"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xxl-5 col-5">
                <div class="card card-height-100 border border-1 shadow rounded-3">
                    <div class="card-title">
                        <ul class="nav nav-tabs" role="tablist">
                            <li class="nav-item waves-effect waves-light" role="presentation">
                                <a href="#progress" class="nav-link active" role="tab" data-bs-toggle="tab" aria-selected="true"><h6>학습 진척도</h6></a>
                            </li>
                        </ul>
                    </div>
                    <div class="card-body p-0" style="min-height: 330px;">
                        <div class="tab-content">
                            <div class="tab-pane" id="progress" role="tabpanel">

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <script type="text/javascript">
        function dtFmt(t) {
            const date = new Date(t);

            const month = String(date.getMonth() + 1).padStart(2, "0");
            const day   = String(date.getDate()).padStart(2, "0");

            return `\${month}-\${day}`;
        }

        const notice = document.querySelector("#noticeTable");
        const noticeColumns = ["글번호", "제목", "등록일자"];
        const noticeData = [
            <c:forEach var="row" items="${learnInfo.notice.lectureBbsCttVOList}" varStatus="st">
            [
                "${row.bbscttNo}",
                gridjs.html(
                    "<a href='/learning/student/board?no=${row.bbscttNo}&code=${row.bbsCode}'>${row.bbscttSj}</a>"
                ),
                dtFmt(${row.bbscttWritngDe.time})
            ] ,
            </c:forEach>
        ]

        gridInit({ columns: noticeColumns, data: noticeData }, notice);

        let resourceInited = false;
        let questionInited = false;

        const resourceColumns = ["글번호", "제목", "등록일자"];
        const resourceData = [
            <c:forEach var="row" items="${learnInfo.notice.lectureBbsCttVOList}" varStatus="st">
            [
                "${row.bbscttNo}",
                gridjs.html(
                    "<a href='/learning/student/board?no=${row.bbscttNo}&code=${row.bbsCode}'>${row.bbscttSj}</a>"
                ),
                dtFmt(${row.bbscttWritngDe.time})
            ] ,
            </c:forEach>
        ]

        const questionColumns = ["글번호", "제목", "등록일자"];
        const questionData = [
            <c:forEach var="row" items="${learnInfo.notice.lectureBbsCttVOList}" varStatus="st">
            [
                "${row.bbscttNo}",
                gridjs.html(
                    "<a href='/learning/student/board?no=${row.bbscttNo}'>${row.bbscttSj}</a>"
                ),
                dtFmt(${row.bbscttWritngDe.time})
            ] ,
            </c:forEach>
        ]

        document.querySelectorAll('a[data-bs-toggle="tab"]').forEach(tab => {
            tab.addEventListener('shown.bs.tab', (e) => {
                const targetId = e.target.getAttribute('href'); // "#notice", "#resource", "#question"

                if (targetId === '#resource' && !resourceInited) {
                    const node = document.querySelector("#resourceTable");
                    gridInit({ columns: resourceColumns, data: resourceData }, node);
                    resourceInited = true;
                }

                if (targetId === '#question' && !questionInited) {
                    const node = document.querySelector("#questionTable");
                    gridInit({ columns: questionColumns, data: questionData }, node);
                    questionInited = true;
                }
            });
        });
    </script>

    <div id="preview-template" style="display:none;">
        <div class="dz-preview dz-file-preview border rounded p-2">
            <div class="d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center">
                    <div class="flex-shrink-0 me-3">
                        <div class="avatar-sm bg-light rounded">
                            <img data-dz-thumbnail class="img-fluid rounded d-block" alt="">
                        </div>
                    </div>
                    <div class="flex-grow-1">
                        <h5 class="fs-14 mb-1" data-dz-name>File Name</h5>
                    </div>
                </div>
                <div class="flex-shrink-0 ms-3 d-flex align-items-center">
                    <button data-dz-remove class="btn btn-sm btn-danger">Delete</button>
                </div>
            </div>
        </div>
    </div>

<%@ include file="../../footer.jsp" %>