package kr.ac.collage_api.vo;

import java.util.List;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


//access토큰이 만료되었으므로 
//refresh 토큰을 통해
//새로운 access 토큰 생성을 요청
//비사용
@Data
@ToString
public class CreateAccessTokenRequestVO {
	//refreshToken
	private String refreshToken;
}
