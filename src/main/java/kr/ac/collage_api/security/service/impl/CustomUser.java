package kr.ac.collage_api.security.service.impl;

import java.io.Serial;
import java.util.Collection;
import java.util.Collections;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.AuthorVO;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

/*
코드 의도
- 우리 DB 스키마(ACNT + AUTHOR)에서 조회한 AcntVO를 Spring Security의 User(전문용어(인증 주체를 표현하는 표준 구현체))로 변환.
- SecurityContextHolder(전문용어(요청별 인증 컨텍스트 보관소))에 저장될 principal을 표준 User 기반으로 제공하되, 원본 AcntVO도 보관.

데이터 흐름(입력·가공·출력)
- 입력: AcntVO(acntId, password(해시), authorList(권한 목록))
- 가공: authorList → ROLE_ 접두어 정규화 → SimpleGrantedAuthority 세트로 변환
- 출력: super(username, password, authorities)로 상위 User 생성, this.acntVO에 원본 유지

계약(전제/성공/에러)
- 전제: AcntVO.password는 해시(BCrypt 등)여야 함. 평문 금지.
- 성공: getAuthorities()가 "ROLE_*" 형태 권한을 반환해 인가 처리 가능해야 함.
- 에러: authorList가 null/빈이어도 NPE 없이 빈 권한 세트 반환(인가 실패 시 403은 Security 레이어에서 처리).

파라미터 명세
- 생성자 CustomUser(AcntVO acntVO)
  - acntVO: kr.ac.collage_api.vo.AcntVO, 필수. acntId(String), password(String, 해시), authorList(List<AuthorVO>) 사용.
- 생성자 CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities)
  - 테스트/수동 주입용. 운영 경로는 AcntVO 생성자 사용 권장.

보안·안전 전제
- 권한 문자열은 normalizeRole()에서 ROLE_ 접두어를 강제해 인가 규칙과 정합성 유지.
- 로그에 비밀번호·민감정보 미노출. 권한·계정 식별자만 디버그 레벨로 기록.

유지보수자 가이드
- DB 컬럼/VO 필드명이 바뀌면 resolveAuthorities()의 매핑 지점(AuthorVO::getAuthorNm)을 동기화.
- JSP/EL, 바인딩 호환을 위해 JavaBeans 표준(getAcntVO/setAcntVO)로 접근자 명명 유지.
*/
@Slf4j
@Data
public class CustomUser extends User {

    @Serial
    private static final long serialVersionUID = 1L;

    // 원본 계정 정보(화면/비즈니스 로직에서 세부값이 필요할 때 사용)
    private AcntVO acntVO;
    private String name;
    private String affiliation;

    /*
    부생성자(테스트/수동 주입용)
    - username/password/authorities를 직접 지정해 principal 생성.
    - 운영 경로는 아래 AcntVO 생성자 사용 권장.
    */
    public CustomUser(String username,
                      String password,
                      Collection<? extends GrantedAuthority> authorities) {
        super(username, password, authorities);
        log.debug("[CustomUser:<String,..>] username={}, authorities={}",
                username,
                authorities.stream().map(GrantedAuthority::getAuthority).collect(Collectors.toSet()));
    }

    /*
    주 생성자
    - 우리 도메인 객체 AcntVO → Spring Security User로 변환.
      1) username = acntVO.acntId
      2) password = acntVO.password(해시)
      3) authorities = authorList → ROLE_* 정규화 → SimpleGrantedAuthority 세트
    */
    public CustomUser(AcntVO acntVO) {
        super(
            acntVO != null ? acntVO.getAcntId()   : "anonymous",
            acntVO != null ? acntVO.getPassword() : "",
            resolveAuthorities(acntVO)
        );

        this.acntVO = acntVO;
        this.name = acntVO.getName();
        this.affiliation = acntVO.getAffiliation();

        log.debug("[CustomUser:<AcntVO>] acntId={}, authorities={}",
                (acntVO != null ? acntVO.getAcntId() : "null"),
                getAuthorities().stream().map(GrantedAuthority::getAuthority).collect(Collectors.toSet()));
    }

    /*
    권한 변환
    - AUTHOR.authorNm을 권한 이름으로 사용(예: STUDENT, ADMIN, ROLE_ADMIN 등 혼재 가능).
    - ROLE_ 접두어 정규화(없으면 붙임)로 인가 규칙과 상합성 유지.
    - null/빈 목록 방어.
    */
    private static Collection<? extends GrantedAuthority> resolveAuthorities(AcntVO vo) {
        if (vo == null || vo.getAuthorVOList() == null || vo.getAuthorVOList().isEmpty()) {
            log.info("[CustomUser:resolveAuthorities] acntId={} no author rows",
                    vo != null ? vo.getAcntId() : "null");
            return Collections.emptySet();
        }

        Set<SimpleGrantedAuthority> authSet =
            vo.getAuthorVOList().stream()
              .map(AuthorVO::getAuthorNm)                 // 권한명 소스(예: STUDENT / ROLE_STUDENT)
              .filter(roleName -> roleName != null && !roleName.isBlank())
              .map(CustomUser::normalizeRole)             // ROLE_ 접두어 보정
              .map(SimpleGrantedAuthority::new)
              .collect(Collectors.toSet());

        log.debug("[CustomUser:resolveAuthorities] acntId={}, resolvedAuth={}",
                vo.getAcntId(),
                authSet.stream().map(GrantedAuthority::getAuthority).collect(Collectors.toSet()));
        return authSet;
    }

    // ROLE_ 접두어 정규화(인가 규칙이 기대하는 표준 권한 네임스페이스를 강제))
    private static String normalizeRole(String role) {
        String r = role.trim();
        return r.startsWith("ROLE_") ? r : "ROLE_" + r;
    }

    // 표준 getter(JavaBeans 규약). JSP/EL, 바인더와 정합성 유지.
    public AcntVO getAcntVO() {
        log.debug("[CustomUser:getAcntVO] called for acntId={}",
                (acntVO != null ? acntVO.getAcntId() : "null"));
        return acntVO;
    }

    // 표준 setter(JavaBeans 규약)
    public void setAcntVO(AcntVO acntVO) {
        log.debug("[CustomUser:setAcntVO] update principal detail acntId={}",
                (acntVO != null ? acntVO.getAcntId() : "null"));

        this.acntVO = acntVO;
        this.name = acntVO.getName();
        this.affiliation = acntVO.getAffiliation();
    }

    /*
    하위 호환 목적의 대체 세터(이전 호출부가 남아있는 경우를 위한 브리지)
    - 호출부 정리 완료 시 제거 가능.
    */
    @Deprecated
    public void setTblUsersVO(AcntVO acntVO) {
        log.debug("[CustomUser:setTblUsersVO] (deprecated) acntId={}",
                (acntVO != null ? acntVO.getAcntId() : "null"));

        this.acntVO = acntVO;
        this.name = acntVO.getName();
        this.affiliation = acntVO.getAffiliation();
    }
}