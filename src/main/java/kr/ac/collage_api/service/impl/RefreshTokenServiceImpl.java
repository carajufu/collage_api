package kr.ac.collage_api.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.mapper.RefreshTokenMapper;
import kr.ac.collage_api.service.RefreshTokenService;
import kr.ac.collage_api.vo.RefreshTokenVO;

@Service
public class RefreshTokenServiceImpl implements RefreshTokenService {

	@Autowired
	RefreshTokenMapper refreshTokenMapper;
	
	//전달받은 리프레시 토큰으로 리프레시 토큰 객체를 검색해서 전달
	//비사용
	@Override
	public RefreshTokenVO findByRefreshToken(String refreshToken) {
		//refreshToken=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.e..
		return this.refreshTokenMapper.findbyRefreshToken(refreshToken);
	}

}
