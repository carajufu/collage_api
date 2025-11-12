package kr.ac.collage_api.config.jwt;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Collections;
import java.util.Date;
import java.util.Map;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

/*
목적
	- 테스트 및 유틸성 JWT 발급기.
	- JJWT 0.12.x 방식으로 HS256 서명된 JWT 문자열을 만들어줌.

구조
	- JwtFactory는 상태 보유용 빌더 역할만 함(subject, iat, exp, claims).
	- JwtProperties는 외부 설정(application.properties)을 통한 issuer, secretKey 주입 담당.
	  -> @ConfigurationProperties("jwt") 기반으로 issuer/secretKey를 스프링이 주입.
	  -> JwtFactory는 해당 빈(JwtProperties)을 @Autowired 받아 사용.
	- 실제 서명은 createToken()에서 수행.

주의
	- secretKey는 최소 32바이트(256비트) 이상이어야 HS256에 사용 가능. 짧으면 예외 발생.
	- 로그에 토큰 전체 또는 secretKey를 직접 출력하면 위험. 이 구현은 마스킹(mask)로만 기록.
	- subject 미지정 시 issuer로 fallback 하도록 하여 단독 테스트 가능. 실서비스에선 계정 ID 등 명시 권장.
*/
@Slf4j
@Data
@Component
public class JwtFactory {
    // 기본 iat/exp: 지금 ~ 14일 뒤
    private Date issuedAt   = new Date();
    private Date expiration = new Date(System.currentTimeMillis() + Duration.ofDays(14).toMillis());

    // 커스텀 클레임 (ex. role 등). 기본 빈 맵
    private Map<String, Object> claims = Collections.emptyMap();

    // 설정값 (jwt.issuer / jwt.secret_key)
    @Autowired
    private JwtProperties jwtProperties;

    // sub 기본값. 없으면 issuer 로 대체
    private String subject = "chemusic@naver.com";

    // 스프링이 사용할 기본 생성자
    public JwtFactory() {
        log.debug("[JwtFactory] default ctor");
    }
    /*
    빌더
	    - 필요한 필드만 선택적으로 덮어쓰기.
	    - null로 들어온 값은 기본값 유지.
	    - subject는 null 허용(나중에 issuer로 대체).
    */
    @Builder
    public JwtFactory(String subject,
                      Date issuedAt,
                      Date expiration,
                      Map<String,Object> claims) {

        this.subject    = (subject    != null ? subject    : this.subject);
        this.issuedAt   = (issuedAt   != null ? issuedAt   : this.issuedAt);
        this.expiration = (expiration != null ? expiration : this.expiration);
        this.claims     = (claims     != null ? claims     : this.claims);

        log.debug("[JwtFactory:builder] effective subject={}, iatEpoch={}, expEpoch={}, ttlSec≈{}",
            this.subject,
            this.issuedAt.getTime() / 1000,
            this.expiration.getTime() / 1000,
            (this.expiration.getTime() - System.currentTimeMillis()) / 1000
        );
    }

    /*
    기본값만으로 JwtFactory 인스턴스 준비.
    테스트 시 매번 수동 세팅 없이 바로 createToken() 호출 가능.
    */
    public static JwtFactory withDefaultValues() {
        log.debug("[JwtFactory:withDefaultValues] using defaults");
        return JwtFactory.builder().build();
    }

    /*
    최종 JWT 생성.
	    - issuer : jwtProperties.getIssuer()
	    - subject: (지정된 subject가 있으면 그 값, 없으면 issuer로 fallback)
	    - issuedAt / expiration : 이 인스턴스가 보유한 값
	    - claims : builder에서 받은 커스텀 데이터들
	    - signWith : HS256 + SecretKey (JJWT 0.12.x 표준)
    
    반환: 직렬화된 compact JWT(String)
    로그:
	    - 누가(issuer) 누구(subject) 토큰을 만들었는지
	    - 만료 시각, TTL(초)
	    - keyBits(시크릿 키 비트 길이)
	    - 토큰은 전체 출력하지 않고 마스킹 처리
    */
    public String createToken() {
        // SecretKey 생성. TokenProvider와 동일 전략: secretKey 문자열 바이트 그대로 사용.
        byte[] raw = jwtProperties.getSecretKey().getBytes(StandardCharsets.UTF_8);
        SecretKey key = Keys.hmacShaKeyFor(raw);

        // subject 우선순위: 명시된 subject > issuer
        String effectiveSubject =
            (this.subject != null && !this.subject.isBlank())
            ? this.subject
            : jwtProperties.getIssuer();

        long ttlSec = (this.expiration.getTime() - System.currentTimeMillis()) / 1000;

        log.info(
            "[JwtFactory:createToken] issuer={}, subject={}, expEpoch={}, ttlSec≈{}, keyBits={}",
            jwtProperties.getIssuer(),
            effectiveSubject,
            this.expiration.getTime() / 1000,
            ttlSec,
            raw.length * 8
        );

        var builder = Jwts.builder()
            .issuer(jwtProperties.getIssuer())
            .subject(effectiveSubject)
            .issuedAt(this.issuedAt)
            .expiration(this.expiration);

        // 커스텀 클레임 추가
        if (this.claims != null && !this.claims.isEmpty()) {
            this.claims.forEach((k, v) -> {
                log.debug("[JwtFactory:createToken] claim {}={}", k, v);
                builder.claim(k, v);
            });
        }

        // 실제 서명 및 최종 compact
        String token = builder
            .signWith(key, Jwts.SIG.HS256)
            .compact();

        log.info(
            "[JwtFactory:createToken] token(masked)={}",
            mask(token)
        );

        return token;
    }

    // 토큰 마스킹 유틸. 전체 노출 금지. 앞 10글자/뒤 6글자만 노출.
    private String mask(String token) {
        if (token == null || token.length() <= 20) return "<null/short>";
        return token.substring(0, 10) + "..." + token.substring(token.length() - 6);
    }
}
