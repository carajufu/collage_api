package kr.ac.collage_api.vo;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

//새로운 access 토큰을 응답
//비사용

@AllArgsConstructor

@Data
public class CreateAccessTokenResponseVO {
	private String accessToken;
	
	CreateAccessTokenResponseVO(CreateAccessTokenResponseVO CreateAccessTokenResponseVO){
		
	}
}
