const modal = `
    <style>
        #modal {
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0; 
            background-color: rgba(176, 196, 222, 0.4); 
            display: none;
        }
        #modal #cont {
            width: 80%; height:85%;
            margin: 10px auto;
            position: fixed;
            top: 5%; left: 10%;
            background-color: white;
        }
    </style>
     <div class="modal"id="modal">
        <div id="cont" class="shadow rounded-3"></div> 
    </div>
`;

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
function closeModal(modalId) {
    const modal = document.querySelector("#" + modalId);
    modal.style.display = "none";
}

/**
 * modal의 body에 표시할 내용을 인자로 받아 modal body 내용을 교체하는 함수
 *
 * @param {string} modalId - body 내용을 교체할 modal 요소의 id
 * @param {HTMLElement|string} cont - modal body에 표시할 html element
 * @return {void} Does not return anything.
 */
function changeModalBody(modalId, cont) {
    const modal = document.querySelector("#" + modalId);
    const modalBody = modal.querySelector("#cont");

    modalBody.innerHTML = "";
    modalBody.append(cont);
}