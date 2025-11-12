package kr.ac.collage_api.config.jwt;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import jakarta.annotation.PostConstruct;
import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.security.Keys;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.AuthorVO;
import lombok.extern.slf4j.Slf4j;

/*
목적: JJWT 0.12.5 기준 토큰 생성/검증/파싱. 기존 아키텍쳐 최대한 유지.
조건:
- Spring Security 6.x (stateless) 환경에서 JWT를 인증 소스로 사용.
- 시크릿 키는 서버만 알고 있는 대칭키(HS256)로 서명.

핵심 특징:
- signWith(SecretKey, Jwts.SIG.HS256) 사용. (JJWT 0.12.x 권장 방식)
- parser().verifyWith(key).build().parseSignedClaims(token) 사용.
- roles 클레임에 DB 권한(authorNm: ROLE_STUDENT 등) 싣고 복원.
- 민감정보 전체 로그 금지. 토큰은 마스킹 처리.
*/
@Service
@Slf4j
public class TokenProvider {

    @Autowired
    JwtProperties jwtProperties;

    private SecretKey key; // HS256 서명/검증용 키

    @PostConstruct
    void init() {
        byte[] raw = jwtProperties.getSecretKey().getBytes(StandardCharsets.UTF_8);
        this.key = Keys.hmacShaKeyFor(raw); // 최소 256비트 이상 아니면 WeakKeyException
        log.info("[TokenProvider:init] issuer={}, keyBits={}", jwtProperties.getIssuer(), raw.length * 8);
    }

    /*
     * generateToken
     * 입력: 로그인에 성공한 계정 정보(AcntVO) + TTL(Duration)
     * 동작: 만료일 계산 뒤 makeToken 호출
     * 결과: Access Token(JWT 문자열)
     */
    public String generateToken(AcntVO acntVO, Duration expiredAt) {
        Date exp = new Date(System.currentTimeMillis() + expiredAt.toMillis());
        log.debug("[TokenProvider] generateToken subject={}, ttlSec={}", acntVO.getAcntId(), expiredAt.toSeconds());
        return makeToken(acntVO, exp);
    }

    /*
     * makeToken
     * 역할: 실제 JWT 생성
     *
     * sub  = 사용자의 계정 ID (acntId)
     * iss  = 발급자 (application.properties jwt.issuer)
     * iat  = 발급 시각
     * exp  = 만료 시각
     * id   = 계정 식별자 (중복 저장)
     * roles= 이 계정의 권한 목록 (AUTHOR.AUTHOR_NM 값들, 예: ROLE_STUDENT, ROLE_PROF 등)
     *
     * 주의:
     * - authorList는 DitAccountMapper.findById() 조인 결과로 채워진다.
     *   즉 로그인 시점에서만 보장됨.
     * - roles 클레임은 이후 요청마다 DB를 다시 조회하지 않고 인가에 쓰인다.
     *   즉 JWT 만료 전까지 권한 변경이 즉각 반영되지 않는다는 특성이 생긴다.
     */
    public String makeToken(AcntVO acntVO, Date expiry) {
        log.debug("[TokenProvider] makeToken");
        Instant now = Instant.now();
        String subject = acntVO.getAcntId();

        // DB 권한 → JWT roles 클레임에 싣는다.
        // authorNm 컬럼: ROLE_STUDENT, ROLE_PROF 등 시큐리티 권한 문자열
        List<String> roles =
            (acntVO.getAuthorList() == null)
                ? Collections.emptyList()
                : acntVO.getAuthorList().stream()
                        .map(AuthorVO::getAuthorNm) // AUTHOR.AUTHOR_NM
                        .collect(Collectors.toList());

        String token = Jwts.builder()
            .issuer(jwtProperties.getIssuer())      // iss
            .subject(subject)                       // sub
            .issuedAt(Date.from(now))               // iat
            .expiration(expiry)                     // exp
            .claim("id", subject)                   // 식별자 중복 저장
            .claim("roles", roles)                  // 권한 목록 저장
            .signWith(key, Jwts.SIG.HS256)          // HS256 서명
            .compact();

        log.info("[TokenProvider] issued subject={}, expEpoch={}, roles={}, token(masked)={}",
            subject,
            expiry.getTime() / 1000,
            roles,
            mask(token)
        );

        return token;
    }

    /*
     * validToken
     * 역할: 토큰이 서명 무결성과 만료(exp) 조건을 만족하는지 확인.
     * 성공 시 true. 실패 시 false.
     * 내부: parseSignedClaims 호출 시 서명/만료 모두 검증됨.
     */
    public boolean validToken(String token) {
        try {
            var jws = Jwts.parser()
                          .verifyWith(key)
                          .build()
                          .parseSignedClaims(token);

            log.debug("[TokenProvider] valid subject={}, expEpoch={}",
                jws.getPayload().getSubject(),
                jws.getPayload().getExpiration().getTime() / 1000
            );
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            log.info("[TokenProvider] invalid reason={}, token(masked)={}",
                e.getClass().getSimpleName(),
                mask(token)
            );
            return false;
        }
    }

    /*
     * getAuthentication
     * 역할: JWT -> Spring Security Authentication 변환.
     * 사용처: TokenAuthenticationFilter
     *
     * 처리 순서:
     * 1) 토큰에서 Claims 파싱
     * 2) roles 클레임(List<String>)을 SimpleGrantedAuthority 세트로 변환
     * 3) UsernamePasswordAuthenticationToken 생성
     *
     * fallback:
     * - roles가 비어 있으면 최소 권한으로 ROLE_STUDENT만 넣어준다.
     *   (레거시 토큰 호환 목적. 추후 제거 가능)
     */
    public Authentication getAuthentication(String token) {
        Claims claims = getClaims(token);

        @SuppressWarnings("unchecked")
        List<String> roles = (List<String>) claims.get("roles");

        Set<SimpleGrantedAuthority> authorities =
            (roles == null || roles.isEmpty())
                ? Collections.singleton(new SimpleGrantedAuthority("ROLE_STUDENT"))
                : roles.stream()
                       .map(SimpleGrantedAuthority::new)
                       .collect(Collectors.toSet());

        log.debug("[TokenProvider] auth subject={}, authorities={}",
            claims.getSubject(),
            authorities
        );

        return new UsernamePasswordAuthenticationToken(
            new org.springframework.security.core.userdetails.User(
                claims.getSubject(), // username = acntId
                "",                  // password 불필요. 토큰 자체가 인증 수단
                authorities
            ),
            token,
            authorities
        );
    }

    /*
     * getUserId
     * 역할: 토큰의 "id" 클레임을 Long으로 리턴.
     * 숫자 또는 문자열 모두 허용.
     */
    public Long getUserId(String token) {
        Claims claims = getClaims(token);
        Object v = claims.get("id");
        if (v instanceof Number n) return n.longValue();
        if (v instanceof String s) {
            try {
                return Long.valueOf(s);
            } catch (NumberFormatException ignored) {
                // 문자열이 Long 변환 불가하면 null 리턴
            }
        }
        return null;
    }

    /*
     * getClaims
     * 역할: 토큰 파싱 후 Claims(페이로드)만 추출.
     * parser().verifyWith(key).build().parseSignedClaims(token)
     * 자체가 유효성(서명/만료) 검증을 포함한다.
     */
    public Claims getClaims(String token) {
        var payload = Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();

        log.debug("[TokenProvider] claims subject={}, expEpoch={}",
                  payload.getSubject(),
                  payload.getExpiration().getTime() / 1000);

        return payload;
    }

    /*
     * mask
     * 역할: 로그 출력 시 토큰 전체가 노출되지 않도록 앞/뒤 일부만 남기고 중간을 가림.
     */
    private String mask(String token) {
        if (token == null || token.length() <= 20) return "<null/short>";
        return token.substring(0, 10) + "..." + token.substring(token.length() - 6);
    }
}
