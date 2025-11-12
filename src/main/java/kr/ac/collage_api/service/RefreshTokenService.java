package kr.ac.collage_api.service;

import kr.ac.collage_api.vo.RefreshTokenVO;

public interface RefreshTokenService {
	
	//전달받은 리프레시 토큰으로 리프레시 토큰 객체를 검색해서 전달
	public RefreshTokenVO findByRefreshToken(String refreshToken);
}
