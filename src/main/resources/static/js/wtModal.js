const modal = `
     <div class="modal fade" data-bs-backdrop="static" id="modal">
        <div class="modal-dialog modal-dialog-scrollable modal-xl">
            <div class="modal-content pb-5">
                <div class="modal-header">
                    <h4 class="modal-title"></h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <hr/>
                <div class="modal-body"></div>
            </div>
        </div>
    </div>
`;

const frag = document.createRange().createContextualFragment(modal);

const quizModal = `
     <div class="modal fade" data-bs-backdrop="static" id="quizModal">
        <div class="modal-dialog modal-dialog-scrollable modal-xl">
            <div class="modal-content pb-5">
                <div class="modal-header">
                    <h4 class="modal-title"></h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <hr/>
                <div class="modal-body"></div>
            </div>
        </div>
    </div>
`;

const quizFrag = document.createRange().createContextualFragment(quizModal);


/**
 * 모달의 display css 속성의 값을 block으로 변경해 모달을 화면에 표시하는 함수
 *
 * @param {string} modalId - 표시할 modal 요소의 id
 * @return {void} This method does not return a value.
 */
function popModal(modalId) {
    const modal = document.querySelector("#" + modalId);
    modal.style.display = "block";
}

/**
 * modal을 닫는 함수
 *
 * @param {string} modalId - 닫을 modal 요소의 id
 * @return {void} Does not return a value.
 */
// function closeModal(modalId) {
//     const modal = document.querySelector("#" + modalId);
//     modal.style.display = "none";
// }

/**
 * modal의 body에 표시할 내용을 인자로 받아 modal body 내용을 교체하는 함수
 *
 * @param {string} modalId - body 내용을 교체할 modal 요소의 id
 * @param {HTMLElement|string} cont - modal body에 표시할 html element
 * @return {void} Does not return anything.
 */
function changeModalBody(modalId, headCont, cont) {
    const modal = document.querySelector("#" + modalId);

    const modalHead = modal.querySelector(".modal-header h4");
    modalHead.textContent = headCont;

    const modalBody = modal.querySelector(".modal-body");

    modalBody.innerHTML = "";
    modalBody.append(cont);
}

// todo: 뒤로가기 방지 기능 고치기
// let isModalOpen = false;
//
// window.onpopstate(e => {
//     if(isModalOpen) { history.go(1); }
//     if(!isModalOpen) { history.go(-1); }
// })
// isModalOpen = true;
// history.pushState({ isModalOpen: true}, '');
// isModalOpen = false;
// history.pushState({ isModalOpen: false }, '');

