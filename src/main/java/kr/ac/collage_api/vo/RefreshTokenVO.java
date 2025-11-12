package kr.ac.collage_api.vo;

import lombok.Data;
import java.time.Instant;

/*
리프레시 토큰 VO (DB 매핑 예정, 테이블 생성 보류), //비사용
	필드 의미
	tokenId        -> 리프레시 토큰 레코드 PK 후보. NUMBER / BIGINT 등으로 가정.
	acntId         -> 어떤 계정(ACNT.ACNT_ID) 소속 토큰인지. FK 후보.
	refreshToken   -> 실제 리프레시 토큰 문자열. 일반적으로 난수 기반 긴 문자열.
	expiresAt      -> 만료 시각(Instant). 이 시각 지나면 무효.
	revoked        -> 토큰 강제 폐기 여부. 'Y' or 'N' 과 같은 플래그로 관리 예정.
	createdAt      -> 토큰 발급 시각(Instant). 감사(Audit)용.
	
	생성자/메서드
	- RefreshTokenVO(String acntId, String refreshToken)
	  신규 토큰 발급 시 최소 필수 값만 채워서 VO 생성할 때 사용.
	
	- update(String newRefreshToken)
	  기존 VO에 새 토큰 문자열만 교체하고 자기 자신을 반환.
  	  DB update 후 서비스 레이어에서 체이닝 형태로 사용 가능.
*/
@Data
public class RefreshTokenVO {

    private Long tokenId;          // 토큰 PK 후보
    private String acntId;         // 소유 계정 ID (ACNT.ACNT_ID)
    private String refreshToken;   // 리프레시 토큰 원문
    private Instant expiresAt;     // 만료 시각
    private String revoked;        // 'Y'/'N' 토큰 철회 여부
    private Instant createdAt;     // 발급 시각

    public RefreshTokenVO(String acntId, String refreshToken) {
        this.acntId = acntId;
        this.refreshToken = refreshToken;
    }

    public RefreshTokenVO update(String newRefreshToken) {
        this.refreshToken = newRefreshToken;
        return this;
    }
}
