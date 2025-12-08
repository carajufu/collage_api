package kr.ac.collage_api.websocket;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;

@Controller
public class ChatController {

	@MessageMapping("/chat.sendMessage") //목적지, 클라이언트가 목적지로 보내면 실행
	@SendTo("/topic/public")			//이 메서드의 반환값을 /topic/public으로 보냄 / 이 목적지를 구독한ㄴ 모든 클라이언트에게 메시지 방송
	public ChatMessage sendMessage(@Payload ChatMessage chatMessage) {

		return chatMessage;
	}

	@MessageMapping("/chat.addUser")
	@SendTo("/topic/public")	//페이로드:
	public ChatMessage addUser(@Payload ChatMessage chatMessage
			, SimpMessageHeaderAccessor headerAccessor ) {

		headerAccessor.getSessionAttributes().put("username", chatMessage.getSender());
		return chatMessage;
	}
}
