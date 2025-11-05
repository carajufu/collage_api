<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../../header.jsp" %>
    <style>
        .blog-post-meta { font-size: 85%; margin-top: 0.5rem; font-style: italic; }
    </style>
    <script type="text/javascript" src="/js/wtModal.js"></script>
    <script type="text/javascript">


        document.addEventListener("DOMContentLoaded", () => {
            document.querySelector("body").innerHTML += modal;

            // 선택한 주차의 과제 리스트를 보여주는 모달
            const tModal = document.querySelector("#modal");
            let modalId = tModal.id;

            // .task : 과제 여부 알려주는 뱃지
           const taskBadge = document.querySelectorAll(".task");

           // 각 과제 badge의 popModal 호출하는 클릭 이벤트 리스너 등록
           taskBadge.forEach(e => {
              e.addEventListener("click", () => {
                  // URL의 query string에서 현재 강의 일련번호 구함
                  const currentUrl = new URL(window.location.href);
                  let lecNo = currentUrl.searchParams.get("lecNo");
                  let weekNo = e.dataset.weekNo;
                  console.log("lecNo, weekNo > ", lecNo, ", ", weekNo);

                  // 해당 주차의 과제 목록 조회하는 post 요청
                  fetch("/learning/student/task", {
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
                            console.log("chkng rslt > ", rslt);
                            renderList(modalId, rslt.result);
                      })
                      .catch(err => console.error(err));

                popModal(modalId);
              });
           });

           // 모달 외부 영역에만 한정해 closeModal 호출
            tModal.addEventListener("click", () => closeModal(tModal.id));
            tModal.querySelector("#cont").addEventListener("click", e => e.stopPropagation());
        });

        /**
         * 과제 목록을 생성해 모달 바디에 주입
         * @param {string} modalId - 과제 목록이 주입될 모달의 id
         * @param {Array<Object>} tasks - 응답 받은 과제의 배열
         * @return {void} This function does not return a value.
         */
        function renderList(modalId, tasks) {
            const container = document.createElement("div");
            container.className = "container mt-4";

            const group = document.createElement("div");
            group.className = "list-group shadow-sm rounded-3";
            group.id = "listGroup";

            // group list의 header
            const groupHeader = document.createElement("div");
            groupHeader.className = "list-group-item d-flex active";
            groupHeader.style = "-bs-list-group-active-bg: var(--bs-primary); --bs-list-group-active-border-color: var(--bs-primary);"
            groupHeader.textContent = "과제";

            group.appendChild(groupHeader);

            // 과제 배열의 각 요소 마다 a 태그 생성해 group list의 요소로 등록
            tasks.forEach((task, idx) => {
                let anchor = document.createElement("a");
                anchor.className = "list-group-item list-group-item-action";
                anchor.style = "cursor: pointer";
                anchor.textContent = task.taskSj;

                anchor.addEventListener("click", e => {
                    e.preventDefault();

                    renderTaskDetail(modalId, tasks, idx);
                });

                group.appendChild(anchor);
            });

            container.appendChild(group);

            changeModalBody(modalId, container);
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
            group.className = "list-group";
            side.appendChild(group);


            let titles = [];            // 선택한 주차의 과제 목록 제목을 담은 배열
            const listGroup = document.querySelector("#listGroup");
            titles = listGroup.querySelectorAll(".list-group-item-action");

            let body = document.createElement("div");
            body.className = "col d-flex flex-column border shadow-sm rounded-3";
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
            changeModalBody(modalId, root);

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
            article.className = "blog-post p-3";
            article.id = "article";

            const title = document.createElement("h3");
            title.textContent = detail.taskSj;
            article.appendChild(title);

            const meta = document.createElement("p");

            let registTime = new Date(detail.registDt).toLocaleString("ko-KR", {timeZone: "Asia/Seoul"});
            let registMsg = "작성 일시 : " + registTime;

            let updateTime = "";
            if(detail.updtDt) {
                updateTime = new Date(detail.updtDt).toLocaleString("ko-KR", {timeZone: "Asia/Seoul"});
            }
            let updateMsg = updateTime ? "수정 일시 : " + updateTime : "";

            meta.className = "blog-post-meta";
            meta.textContent = registMsg + updateMsg;
            article.appendChild(meta);

            const deadLine = document.createElement("p");
            deadLine.className = "blog-post-meta";
            deadLine.textContent = detail.taskBeginDe + " ~ " + detail.taskClosDe;
            article.appendChild(deadLine);

            article.appendChild(document.createElement("hr"));

            const content = detail.taskCn;
            const pContent = document.createElement("p");
            pContent.style.whiteSpace = "break-spaces";
            pContent.textContent = content;
            article.appendChild(pContent);

            article.appendChild( await renderSubmitBtn(detail.taskNo) );

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
        async function isSubmit(taskNo) {
            let data = null;
            let resp, rslt;

            try {
                resp = await fetch("/learning/student/isSubmit?taskNo=" + taskNo,
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
            container.className = "container d-flex justify-content-center gap-3";

            const submit = await isSubmit(taskNo);

            const state = { mode: "form" };
            if(!submit) {
                // form의 부모 div
                const frmContainer = document.createElement("div");
                frmContainer.className = "container m-3 border rounded-2"
                frmContainer.id = "frmContainer";

                //form
                const frm = document.createElement("form");

                // 버튼 부모 div
                const btnContainer = document.createElement("div");
                btnContainer.className = "m-3 fs-6";

                const label = document.createElement("label")
                label.className = "form-label";
                label.setAttribute("for", "formFile");
                label.textContent = "파일을 업로드 하세요.";

                const fileInput = document.createElement("input");
                fileInput.className = "form-control";
                fileInput.id = "formFile";
                fileInput.setAttribute("type", "file");
                fileInput.setAttribute("multiple", "");
                fileInput.addEventListener("change", () => state.mode = "upload");

                const submitBtn = document.createElement("button");
                submitBtn.className = "btn btn-primary btn-lg";
                submitBtn.textContent = "제출";
                submitBtn.id = "submitBtn";

                const cancleBtn = document.createElement("button");
                cancleBtn.className = "btn btn-danger btn-lg";
                cancleBtn.textContent = "취소";
                // todo: (Level 5) 제출한 파일 목록 보기 및 수정
                submitBtn.addEventListener("click", () => {
                    if(state.mode === "form") {
                        const exist = document.querySelector("#frmContainer");
                        if(exist) { exist.remove(); }

                        console.log("submit btn clicked")

                        container.before(frmContainer);

                        frmContainer.appendChild(frm);

                        frm.appendChild(btnContainer);

                        btnContainer.appendChild(label);
                        btnContainer.appendChild(fileInput);
                    }

                    if(state.mode === "upload") {
                        console.log("upload btn clicked")
                        fileSubmit(fileInput, taskNo);
                        state.mode = "form";
                    }

                    container.appendChild(cancleBtn);
                });

                cancleBtn.addEventListener("click", e => {
                   frmContainer.remove();
                   e.target.remove();
                });

                container.appendChild(submitBtn);
            }

            if(submit) {
                const updateBtn = document.createElement("button");
                updateBtn.className = "btn btn-secondary btn-lg";
                updateBtn.textContent = "수정";

                //todo : 수정 이벤트 핸들러 작성

                container.appendChild(updateBtn);
            }

            return container;
        }

        function fileSubmit(input, taskPresentnNo) {
            const formData = new FormData();

            const files = input.files;
            Array.prototype.forEach.call(files, file => formData.append("uploadFiles", file));
            formData.append("taskPresentnNo", taskPresentnNo);

            fetch("/learning/student/fileUpload", {
                method: "POST",
                body: formData
            })
                .then(resp => resp.json())
                .then(rslt => console.log(rslt))
                .catch(err => console.error(err));
        }
    </script>

        <div class="flex-grow-1 mx-5">
            <!-- 반복문을 통해 아코디언 리스트 생성 -->
            <div class="accordion accordion-flush" id="accordionFlush">
                <c:forEach var="week" items="${weekList}">
                        <div class="accordion-item shadow rounded-3">
                            <h2 class="accordion-header" id="flush-heading${week.WEEK}">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapse${week.WEEK}" aria-expanded="false" aria-controls="flush-collapse${week.WEEK}">
                                    <strong>#${week.WEEK}</strong>${week.LRN_THEMA}
                                </button>
                            </h2>
                            <div id="flush-collapse${week.WEEK}" class="accordion-collapse collapse p-4" aria-labelledby="flush-heading${week.WEEK}" data-bs-parent="#accordionFlush">
                                <p>${week.LRN_CN}</p>
                                <!-- 부여 여부에 따른 요소 출력 -->
                                <c:if test="${week.TASK_AT eq '0'}">
                                    <span class="badge rounded-pill bg-primary task" style="cursor: pointer;" data-week-no="${week.WEEK}">과제</span>
                                </c:if>
                                <c:if test="${week.TASK_AT eq '1'}">
                                    <span class="badge rounded-pill bg-secondary">과제</span>
                                </c:if>
                            </div>
                        </div>
                </c:forEach>
            </div>
        </div>

<%@ include file="../../footer.jsp" %>