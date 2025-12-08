package kr.ac.collage_api.websocket;

import java.awt.TrayIcon.MessageType;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessage {
	private MessageType type;
	private String content;
	private String sender;
	private String ntcnItnadr;
	private int ntcnNo;

	public enum MessageType {
		CHAT,
		JOIN,
		LEAVE,
		VIDEO_REQUEST
	}
}
