package kr.ac.collage_api.service;

import kr.ac.collage_api.vo.RefreshTokenVO;
import kr.ac.collage_api.vo.AcntVO;

/**
 * TokenService
 *
 * 역할
 * - 액세스 토큰(JWT) 발급 책임 계층.
 * - 컨트롤러가 직접 TokenProvider를 호출하지 않고 여기만 호출하도록 강제.
 *
 * 현재 단계 (구현 대상)
 * - issueAccessToken(acntId)
 *
 * 향후 단계 (주석만 유지. 아직 미구현)
 * - 리프레시 토큰 발급/회전/검증
 */
public interface TokenService {
    /**
     * 액세스 토큰(JWT) 발급.
     * acntId로 DB 사용자 조회 후 유효하면 JWT 생성해서 반환.
     * 계정이 없으면 예외.
     */
	public String issueAccessToken(String acntId);

    /* ================== 확장 예정: Refresh Token ==================
     *
     * String issueRefreshToken(String acntId);
     *
     * String rotateAccessToken(String refreshToken);
     *
     * AcntVO validateAndLoadUser(String refreshToken);
     *
     * ============================================================= */
}
