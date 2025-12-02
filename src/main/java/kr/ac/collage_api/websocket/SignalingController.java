package kr.ac.collage_api.websocket;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class SignalingController {

	@MessageMapping("/chat/{roomId}")
	@SendTo("/topic/room/{roomId}")
	public SignalingMessage handleSignal(@DestinationVariable String roomId,
								@Payload SignalingMessage message) {

		log.info("handleSignal() -> Type : {}, Sender : {}, RoomId : {}"
				, message.getType(),message.getSender(), message.getRoomId());

		return message;
	}

}
