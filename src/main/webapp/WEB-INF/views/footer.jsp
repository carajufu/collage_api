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
	    <img src="/img/chatbot/chatbothandshk.jpg?ver=1"
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
                        '<img src="/img/chatbot/chatbot.jpg" alt="bot" class="rounded-circle me-2" ' +
                        'style="width:40px; height:40px;">' +
                        '<div class="p-3 bg-light border rounded-3 shadow-sm" ' +
                        'style="max-width:85%; word-wrap:break-word;">' +
                        text +
                        '</div>';
                } else {
                    wrapper.innerHTML =
                        '<img src="/img/chatbot/chatbothandshk.jpg" alt="bot" class="rounded-circle me-2" ' +
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
                <img src="/img/chatbot/chatbothandshk.jpg" alt="bot" class="rounded-circle me-2"
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


<!-- 알림창 시작 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<sec:authorize access="isAuthenticated()">
<script>
let stompClient = null;

// 문서가 다 로드되면 실행 (위치가 어디든 상관없이 작동하게 해줌)
$(document).ready(function() {
    connect();
    loadOldNotifications();
});

//시간함수
const calculateTimeAgo = (dateString) => {
    if (!dateString) return "방금 전";

    const now = new Date();
    const past = new Date(dateString);
    const diffMs = now - past; // 밀리초 차이 계산

    const diffMins = Math.floor(diffMs / (1000 * 60));
    const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

    if (diffMins < 1) return "방금 전";
    if (diffMins < 60) return `\${diffMins}분 전`;
    if (diffHours < 24) {
        // 1시간이 넘으면 "1시간 20분 전" 처럼 표시
        const remainMins = diffMins % 60;
        return `\${diffHours}시간 \${remainMins}분 전`;
    }
    if (diffDays < 7) return `\${diffDays}일 전`;

    // 7일이 넘으면 그냥 날짜를 보여줌 (예: 2024-11-21)
    const year = past.getFullYear();
    const month = ('0' + (past.getMonth() + 1)).slice(-2);
    const day = ('0' + past.getDate()).slice(-2);
    return `\${year}-\${month}-\${day}`;
};

//안읽은 메시지 불러오기
const loadOldNotifications = () => {
	fetch("/ntcn/unread")
		.then((resp)=> resp.json())
		.then((list)=>{

			if (!list || list.length ===0) {
				return;
			}
			console.log("list",list);

			list.forEach((item) => {
				let  msgObj = {
					id:item.ntcnNo,
					content:item.ntcnCn,
					sender:item.sender,
					url:item.ntcnItnadr,
					time:item.registDt
				}
				showNotification(msgObj);
			});
		});
}

const connect = () => {
    const socket = new SockJS('${pageContext.request.contextPath}/ws');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, (frame) => {
        console.log(`Websocket Connected: ${frame}`);

        stompClient.subscribe('/user/queue/notifications', (notification) => {
            showNotification(JSON.parse(notification.body));
        });
    });
};


const readAndMove = (ntcnNo,targetURL) => {
	fetch("/ntcn/read",{
		method : "POST",
		headers : {
			"Content-type" :"application/json",
		},
		body:JSON.stringify({ntcnNo:ntcnNo})
	}).then(resp => {
		if (resp.ok) {
			console.log("읽음 처리 성공")
		}else {
			console.log("읽음처리 실패");
		}

	}).catch(err => console.error(err))
	.finally(() => {
					window.location.href=targetURL
				}
	)

}

const showNotification = (messageObj) => {
    // 1. 종 흔들기 효과
    const $icon = $("#notification-icon");
    $icon.addClass("bell-ringing");
    setTimeout(() => { $icon.removeClass("bell-ringing"); }, 2000);

    // 2. 뱃지 숫자 올리기
    const $badge = $("#notification-badge");
    let currentCount = parseInt($badge.text()) || 0;
    $badge.text(currentCount + 1);
    $badge.removeClass("d-none");

    // 3. 데이터 준비 (콘솔에 찍힌 내용 가져오기)
    // messageObj.content가 "241011001 학생이..." 이 텍스트입니다.
    const content = messageObj.content || "새로운 알림이 도착했습니다.";
    const sender = messageObj.sender || "시스템 알림";
    const url = messageObj.url|| messageObj.ntcnItnadr;
    const id = messageObj.id || messageObj.ntcnNo;

    const timeStr = calculateTimeAgo(messageObj.time);

    // 4. HTML 만들기 (디자인)
    const newNotiHtml = `
        <div class="text-reset notification-item d-block dropdown-item position-relative">
            <div class="d-flex">
                <div class="avatar-xs me-3 flex-shrink-0">
                    <span class="avatar-title bg-primary-subtle text-primary rounded-circle fs-16">
                        <i class='bx bx-message-rounded-dots'></i>
                    </span>
                </div>
                <div class="flex-grow-1">
                    <a href="javascript:void(0);"
                    	onClick="readAndMove(\${id},'\${url}')" class="stretched-link">
                        <h6 class="mt-0 mb-1 fs-13 fw-semibold">\${sender}</h6>
                    </a>
                    <div class="fs-13 text-muted">
                        <p class="mb-1">\${content}</p>
                    </div>
                    <p class="mb-0 fs-11 fw-medium text-uppercase text-muted">
                        <span><i class="mdi mdi-clock-outline"></i> \${timeStr}</span>
                    </p>
                </div>
            </div>
        </div>`;

    // 5. 리스트에 추가하기 (ID 매칭 성공!)
    const $container = $("#my-notification-list");
    const $simpleBarContent = $container.find(".simplebar-content");

    // "알림 없음" 문구 숨기기
    $container.find(".empty-notification-elem").hide();

    // SimpleBar 라이브러리 사용 시 내부 구조가 바뀔 수 있어서 체크
    if ($simpleBarContent.length > 0) {
        $simpleBarContent.prepend(newNotiHtml);
    } else {
        $container.prepend(newNotiHtml);
    }
};

</script>
</sec:authorize>

<!-- 알림창 끝 -->

</body>
</html>