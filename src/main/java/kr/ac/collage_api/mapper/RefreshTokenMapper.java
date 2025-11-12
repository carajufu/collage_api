package kr.ac.collage_api.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.vo.RefreshTokenVO;

@Mapper
public interface RefreshTokenMapper {
	RefreshTokenVO findbyUserId(Long userId);
	RefreshTokenVO findbyRefreshToken(String refreshToken);
	int save(RefreshTokenVO refreshTokenVO);
	
	
    RefreshTokenVO findByToken(@Param("refreshToken") String refreshToken);
    int revokeByToken(@Param("refreshToken") String refreshToken);
    int revokeByAccount(@Param("acntId") String acntId);
}
