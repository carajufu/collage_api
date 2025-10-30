<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../../header.jsp" %>
    <style>
        .blog-post-meta {
            /* 폰트 크기를 작게 설정 */
            font-size: 85%;
            /* 색상을 연하게 설정 */
            color: #6c757d; /* 부트스트랩의 secondary 색상과 유사 */
            /* 상단에 약간의 마진 추가 (필요하다면) */
            margin-top: 0.5rem;
            /* (선택 사항) 기울임꼴 */
            font-style: italic;
        }
    </style>
    <script type="text/javascript" src="/js/wtModal.js"></script>
    <script type="text/javascript">
        function renderTaskDetail(modalId, tasks, idx) {
            const chkRoot = document.querySelector("#taskBodyRoot");
            if(chkRoot) { chkRoot.remove(); }

            const root = document.createElement("div");
            root.className = "container";
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

            let titles = [];
            const listGroup = document.querySelector("#listGroup");
            titles = listGroup.querySelectorAll(".list-group-item-action");

            let body = document.createElement("div");
            body.className = "col d-flex flex-column border shadow-sm rounded-3";
            body.id = "body";
            grid.appendChild(body);

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


            // todo: 제출 여부에 따른 제출 버튼 추가

            console.log("chkng before change body >  ", root);
            changeModalBody(modalId, root);

            if (Array.isArray(tasks) && tasks.length && idx >= 0 && idx < tasks.length) {
                taskDetail(body, tasks[idx]);
            }
        }

        function taskDetail(body, detail) {
            if(!body || !detail) return;

            body.replaceChildren();

            const article = document.createElement("article");
            article.className = "blog-post";
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



            body.appendChild(article);
        }

        function addButton() {

        }

        /**
         * 과제 목록을 생성해 모달 바디에 주입
         * @param {string} modalId - 과제 목록이 주입될 모달의 id
         * @param {Array<Object>} tasks - 응답 받은 과제의 배열
         * @return {void} This function does not return a value.
         */
        function renderList(modalId, tasks) {
            const container = document.createElement("div");
            container.className = "container";

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

    </script>

    <div id="main-container" class="container-fluid overflow-scroll">
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
    </div>
</main>

<%@ include file="../../footer.jsp" %>