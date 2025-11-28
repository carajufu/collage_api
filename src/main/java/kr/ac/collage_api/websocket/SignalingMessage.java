package kr.ac.collage_api.websocket;

import lombok.Data;

@Data
public class SignalingMessage {

	private MessageType type;
	private String sender;
	private String roomId;
	private Object data;

	public enum MessageType {
		JOIN,
		OFFER,		//교수(제안자) => 학생(수신자) : 나랑 통신하자
		ANSWER,		//학생(수신자) => 교수(제안자) : 통신 수락한다
		ICE			//양방향 통신. 해당 ip 주소, 포트주소로 통신연결해봐
	}

}
