package kr.ac.collage_api.service.impl;

import java.time.Duration;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.config.jwt.TokenProvider;
import kr.ac.collage_api.service.DitAccountService;
import kr.ac.collage_api.service.TokenService;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;

/**
 * TokenServiceImpl
 *
 * 목적
 * - 액세스 토큰(JWT) 발급을 중앙집중 처리.
 * - 스프링 시큐리티 + jjwt 0.12.x 구조에서 TokenProvider를 호출하는 단일 지점.
 *
 * 현재 동작 (개발 단계)
 * - issueAccessToken(acntId):
 *   주어진 계정 ID로 DB 조회
 *   → 계정 유효성 확인
 *   → TokenProvider.generateToken(...) 호출
 *   → 서명된 JWT(access token) 생성 후 반환
 *
 * 만료 시간 정책
 * - AT_TTL = 4시간.
 *   개발 단계에서는 테스트 편의를 위해 길게 유지.
 *   운영 전환 시 30분 등 짧은 값으로 내려갈 예정.
 *
 * 보안
 * - 토큰 전체 문자열을 로그에 남기지 않는다. mask()로 마스킹하여 일부만 기록.
 * - 존재하지 않는 계정에 대해선 예외로 거절.
 *
 * 확장 예정 (아직 미구현)
 * - 리프레시 토큰(Refresh Token, RT) 발급 및 회전.
 *   RT는 DB에 저장해 만료/철회 여부를 검사하고
 *   유효 RT로 새로운 AT를 재발급하는 흐름을 붙일 계획.
 */
@Slf4j
@Service
public class TokenServiceImpl implements TokenService {

    // 액세스 토큰 만료 시간 정책.
    // 개발 단계: 4시간 유지 (테스트 중 세션 끊김 방지 목적)
    // 운영 단계: 수십 분 단위로 축소 예정.
    private static final Duration AT_TTL = Duration.ofHours(4);

    // [변경] 생성자 주입으로 교체(불변성·테스트 용이성·NPE 방지)
    private final TokenProvider tokenProvider;         // TokenProvider(전문용어(서명·클레임 포함 JWT 생성/검증기))
    private final DitAccountService ditAccountService; // DitAccountService(전문용어(ACNT 조회 비즈니스 서비스))

    // [추가] 생성자 주입
    public TokenServiceImpl(TokenProvider tokenProvider,
                            DitAccountService ditAccountService) {
        this.tokenProvider = tokenProvider;
        this.ditAccountService = ditAccountService;
    }

    /**
     * 액세스 토큰(JWT) 발급.
     *
     * 1) acntId 유효성 검사
     * 2) ditAccountService.findById(acntId) 로 계정 로드
     * 3) TokenProvider.generateToken(account, AT_TTL) 로 JWT 생성
     * 4) JWT 문자열 반환
     *
     * 실패 처리
     * - acntId null/blank  -> IllegalArgumentException
     * - 계정 미존재       -> IllegalStateException
     */
    @Override
    public String issueAccessToken(String acntId) {
        if (acntId == null || acntId.isBlank()) {
            throw new IllegalArgumentException("acntId is required");
        }

        // [변경] 정상 경로는 DEBUG 로깅(운영 소음 최소화)
        log.debug("[TokenService:issueAccessToken] request acntId={}", acntId);

        // 계정 로드
        AcntVO account = ditAccountService.findById(acntId);
        if (account == null) {
            // [추가] 미존재는 INFO/경고 레벨로 남김
            log.info("[TokenService:issueAccessToken] account not found acntId={}", acntId);
            throw new IllegalStateException("account_not_found");
        }

        // 액세스 토큰(JWT) 생성
        String accessToken = tokenProvider.generateToken(account, AT_TTL);

        // [유지] 토큰 마스킹 로깅(전문용어(민감토큰 전체 노출 금지 정책))
        log.debug("[TokenService:issueAccessToken] issued accessToken(masked)={}", mask(accessToken));

        return accessToken;
    }

    /**
     * 토큰 마스킹 유틸.
     * 전체 토큰 그대로 로그 남기지 않음.
     * 앞 10글자 + ... + 뒤 6글자만 노출.
     * 길이가 짧으면 "<null/short>" 로만 기록.
     */
    private String mask(String token) {
        if (token == null || token.length() <= 20) return "<null/short>";
        return token.substring(0, 10) + "..." + token.substring(token.length() - 6);
    }

    /* ================== 확장 예정: Refresh Token (현재 미구현) ==================
     * String issueRefreshToken(String acntId);
     * String rotateAccessToken(String refreshToken);
     * AcntVO validateAndLoadUser(String refreshToken);
     * ======================================================================== */
}
