package kr.ac.collage_api.config.jwt;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

/*
해당 값들(jwt.issuer,jwt.secret_key)을 변수로 접근하는 데 사용할 JwtProperties 클래스를 만듦. 
config/jwt 패키지에 JwtProperties.java 파일을 만들어 코드를 작성하자. 
이렇게 하면 issuer 필드에는 application.properties에서 설정한 jwt.issuer 값이, 
secretKey에는 jwt.secret_key 값이 매핑됨
 */
@Data
@Component
@ConfigurationProperties("jwt")
public class JwtProperties {
	/* application.properties
	#token secret key
	#토큰 발급자
	jwt.issuer=chemusic@naver.com
	# JWT 키 (여러 문자가 섞일수록 안전하다)
	jwt.secret_key=study-springboot
	 */
	private String issuer;
	private String secretKey;
}
