<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

</div>
<!-- container-fluid -->
</div>
<!-- End Page-content -->
</div>
<!-- end main content-->
</div>
<!-- END layout-wrapper -->

<!--preloader-->
<div id="preloader">
    <div id="status">
        <div class="spinner-border text-primary avatar-sm" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>
</div>

<style>
  .chatbot-icon {
    display: inline-block !important;
    transform-origin: center !important;
    backface-visibility: hidden;
    animation: robotFloat 4s ease-in-out infinite !important;
  }

  @keyframes robotFloat {
    0%   { transform: scale(1) translateY(0) rotate(0deg); }
    10%  { transform: scale(1) translateY(-2px) rotate(0deg); }
    25%  { transform: scale(1) translateY(-4px) rotate(360deg); }
    40%  { transform: scale(1) translateY(0) rotate(360deg); }
    100% { transform: scale(1) translateY(0) rotate(360deg); }
  }
</style>

<div class="customizer-setting d-none d-md-block">
  <div class="btn-info rounded-pill shadow-lg btn btn-icon btn-lg p-2"
       data-bs-toggle="offcanvas"
       data-bs-target="#chatbot-offcanvas"
       aria-controls="chatbot-offcanvas">
       <i class="mdi mdi-robot-outline fs-22 chatbot-icon"></i>
  </div>
</div>

<div class="offcanvas offcanvas-end border-primary" tabindex="-1" id="chatbot-offcanvas"
		data-bs-backdrop="false" style="width: 600px;">
  <div class="d-flex align-items-center bg-primary bg-gradient p-3 offcanvas-header">
    <div style="font-size: 18px; font-weight: 600; color: #fff; text-shadow: 0 0 1px rgba(0,0,0,0.3);">
      SMART_LMS 챗봇
    </div>
    <button type="button" class="btn-close btn-close-white ms-auto" data-bs-dismiss="offcanvas"></button>
  </div>

  <div class="offcanvas-body d-flex flex-column" style="height:100%; padding: 0;"> <div style="flex: 0 0 auto; border-bottom: 1px solid #ddd; background-color: #f8f9fa; padding: 15px;">
	  <div class="d-flex align-items-start">
	    <img src="/img/chatbothandshk.jpg?ver=1"
	         alt="챗봇"
	         class="rounded-circle me-2"
	         draggable="false"
	         style="pointer-events:none; width:50px; height:50px;">

	    <div>
	      <div style="font-weight: 600; font-size: 16px;">안녕하세요. SMART_LMS 도우미 챗봇입니다</div>
	      <div class="text-muted" style="font-size: 14px;">
	        LMS 관련 내용을 입력하거나 아래 버튼을 눌러보세요.
	      </div>
	    </div>
	  </div>
    </div>

	<div id="chatbot-tags"
	     class="card shadow-sm border-primary mt-0"
	     style="position:sticky; top:0; z-index:10; background:white; flex: 0 0 auto; border-radius: 0; border-top: 0; border-bottom: 1px solid #ddd;">

	    <div class="card-header bg-primary bg-gradient text-white fw-bold py-2 d-flex justify-content-between align-items-center" style="border-radius: 0;">
	      <span>챗봇 빠른 메뉴</span>
	      <button id="toggle-menu-btn"
	              class="btn btn-sm btn-light fw-semibold no-send"
	              style="padding:2px 10px; font-size:12px;">
	        접기
	      </button>
	    </div>

	    <div id="chatbot-menu-body" class="card-body">
	      <div class="row g-2">

	        <div class="col-6">
	          <button class="btn btn-outline-primary w-100 py-2 fw-semibold">수강신청</button>
	        </div>

	        <div class="col-6">
	          <button class="btn btn-outline-primary w-100 py-2 fw-semibold">등록금</button>
	        </div>

	        <div class="col-6">
	          <button class="btn btn-outline-primary w-100 py-2 fw-semibold">출석현황</button>
	        </div>

	        <div class="col-6">
	          <button class="btn btn-outline-primary w-100 py-2 fw-semibold">성적조회</button>
	        </div>

	        <div class="col-6">
	          <button class="btn btn-outline-primary w-100 py-2 fw-semibold">강의평가</button>
	        </div>

	        <div class="col-6">
	          <button class="btn btn-outline-primary w-100 py-2 fw-semibold">상담예약</button>
	        </div>

	        <div class="col-6">
	          <button class="btn btn-outline-primary w-100 py-2 fw-semibold">졸업조건</button>
	        </div>

	        <div class="col-6">
	          <button class="btn btn-outline-primary w-100 py-2 fw-semibold">문의사항</button>
	        </div>

	      </div>
	    </div>
	</div>

    <div id="chatbot-messages" style="flex: 1 1 auto; overflow-y: auto; padding: 15px;
         background-color: #ffffff; min-height: 300px; display: flex; flex-direction: column; justify-content: flex-start;">
      <div style="text-align:center; color:#888; margin-top:50px;">
        <small>대화를 시작하려면 메시지를 입력하세요.</small>
      </div>
    </div>

    <div class="input-group" style="flex: 0 0 auto; border-top: 1px solid #ccc;">
      <input type="text" id="chatbot-input" class="form-control rounded-start" placeholder="메시지를 입력하세요...">
      <button class="btn btn-primary rounded-end" id="chatbot-send">전송</button>
    </div>

  </div>
</div>




<!-- 아마 필요 없을 거 같은디 -->
<script src="/assets/libs/feather-icons/feather.min.js"></script>

<!-- apexcharts -->
<script src="/assets/libs/apexcharts/apexcharts.min.js"></script>

<!-- Vector map-->
<script src="/assets/libs/jsvectormap/jsvectormap.min.js"></script>
<script src="/assets/libs/jsvectormap/maps/world-merc.js"></script>

<!-- Dashboard init -->
<script src="/assets/js/pages/dashboard-analytics.init.js"></script>
<script src="/assets/js/app.js"></script>

<script>
if (!window.chatbotInitialized) {
    window.chatbotInitialized = true;

    document.addEventListener("DOMContentLoaded", function() {
        const messages = document.getElementById("chatbot-messages");
        const input = document.getElementById("chatbot-input");
        const sendBtn = document.getElementById("chatbot-send");

        function scrollToBottom() {
            setTimeout(() => {
                if(messages) {
                    messages.scrollTop = messages.scrollHeight;
                }
            }, 0);
        }


        function appendMessage(text, sender, type = "text") {
            const wrapper = document.createElement("div");
            wrapper.classList.add("d-flex", "mb-3");

            if (sender === "me") {
                wrapper.classList.add("justify-content-end");
                wrapper.innerHTML =
                    '<div class="p-2 rounded-3 bg-primary text-white shadow-sm" ' +
                    'style="max-width:75%; word-wrap:break-word;">' +
                    text +
                    '</div>';
            } else {
                if (type === "card") {
                    wrapper.innerHTML =
                        '<img src="/img/chatbot.jpg" alt="bot" class="rounded-circle me-2" ' +
                        'style="width:40px; height:40px;">' +
                        '<div class="p-3 bg-light border rounded-3 shadow-sm" ' +
                        'style="max-width:85%; word-wrap:break-word;">' +
                        text +
                        '</div>';
                } else {
                    wrapper.innerHTML =
                        '<img src="/img/chatbothandshk.jpg" alt="bot" class="rounded-circle me-2" ' +
                        'style="width:40px; height:40px;">' +
                        '<div class="p-2 rounded-3 bg-light text-dark shadow-sm" ' +
                        'style="max-width:75%; word-wrap:break-word;">' +
                        text +
                        '</div>';
                }
            }

            messages.appendChild(wrapper);
            scrollToBottom();
        }


        function showLoading() {
            const loader = document.createElement("div");
            loader.classList.add("d-flex", "mb-3");
            loader.innerHTML = `
                <img src="/img/chatbothandshk.jpg" alt="bot" class="rounded-circle me-2"
                     style="width:40px; height:40px;">
                <div class="p-2 rounded-3 bg-light text-muted shadow-sm" style="max-width:75%;">...</div>`;
            messages.appendChild(loader);
            scrollToBottom();
            return loader;
        }


        function sendMessage(text) {
            const placeholder = messages.querySelector("div[style*='text-align:center']");
            if (placeholder) {
                messages.innerHTML = "";
            }

            appendMessage(text, "me");
            input.value = "";

            const loader = showLoading();

            fetch("/chatbot/api", {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({ message: text })
            })
            .then(res => res.json())
            .then(data => {
                setTimeout(() => {
                    loader.remove();
                    if (data.answer) {
                        appendMessage(data.answer, "bot");
                    } else {
                        appendMessage("서버 응답 오류입니다.", "bot");
                    }

                }, 700);
            })
            .catch(() => {
                loader.remove();
                appendMessage("서버와 연결할 수 없습니다.", "bot");
            });
        }


        sendBtn.addEventListener("click", function() {
            const text = input.value.trim();
            if (!text) return;
            sendMessage(text);
        });

        input.addEventListener("keydown", function(e) {
            if (e.key === "Enter") {
                e.preventDefault();
                const text = input.value.trim();
                if (text) sendMessage(text);
            }
        });

        const tagContainer = document.getElementById("chatbot-tags");
        if (tagContainer) {
            tagContainer.querySelectorAll("button:not(.no-send)").forEach(btn => {
                btn.addEventListener("click", () => {
                    const text = btn.textContent.trim();
                    sendMessage(text);
                });
            });
        }

        const menuBody = document.getElementById("chatbot-menu-body");
        const toggleBtn = document.getElementById("toggle-menu-btn");
        let isOpen = true;

        toggleBtn.addEventListener("click", function() {
            if (isOpen) {
                menuBody.style.display = "none";
                toggleBtn.textContent = "펼치기";
            } else {
                menuBody.style.display = "block";
                toggleBtn.textContent = "접기";
            }
            isOpen = !isOpen;

            scrollToBottom();
        });

    });
}
</script>


</body>
</html>