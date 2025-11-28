package kr.ac.collage_api.vo;

/**
 * AcntVO
 *
 * 1) 코드 의도
 *    - 로그인 계정 1건에 대한 정보(ACNT)와 권한 목록(AUTHOR),
 *      그리고 상단 헤더/포털 영역에서 사용할 표시용 정보를 한 번에 담는 VO.
 *    - UserDetailsService, 세션 저장, JSP 헤더 표시 영역에서 공통으로 사용.
 *
 * 2) 데이터 흐름
 *    - 입력 소스
 *      · ACNT.ACNT_ID, FILE_GROUP_NO, PASSWORD, ACNT_TY
 *      · AUTHOR.* (권한 목록) → authorList
 *      · 파생 컬럼(USER_NM, USER_STTUS_NM, USER_SUBJCT_NM, USER_NO)
 *        ↳ STDNT / SKLSTF / PROFSR / SUBJCT 조인 결과 기반
 *    - 사용 위치
 *      · Spring Security CustomUser / UserDetails 구현체
 *      · index.jsp 상단 “OOO 학우님 반갑습니다.” 드롭다운
 *
 * 3) 계약
 *    - acntId 는 ACNT.ACNT_ID 와 1:1로 매핑되는 PK.
 *    - password 는 반드시 해시(Bcrypt 등) 상태 문자열이어야 하며 평문 금지.
 *    - authorList 는 동일 acntId 에 대해 0..N 개의 ROLE_* 을 보유할 수 있음.
 *    - userNo
 *      · ROLE_STUDENT → STDNT.STDNT_NO(학번)
 *      · ROLE_PROF    → SKLSTF.SKLSTF_ID(교번)
 *      · 그 외(관리자 등) → null 가능.
 *
 * 4) 보안·안전 전제
 *    - 이 VO 는 password + 실명(user_nm) + 학번/교번(userNo)을 동시에 들고 있음.
 *      → 컨트롤러에서 그대로 JSON 응답/로그로 노출하면 보안 사고.
 *      → 외부 반환 시에는 전용 DTO 로 변환해서 민감 필드를 제거해야 함.
 *    - authorList 의 ROLE_* 값은 인가 판단에 직접 사용되므로
 *      DB 외부에서 임의로 세팅하거나 변조하면 안 됨.
 *
 * 5) 유지보수자 가이드
 *    - MyBatis resultMap(acntMap) 과 컬럼 alias 와의 매핑을 항상 함께 확인할 것.
 *      · USER_NM         ↔ user_nm
 *      · USER_STTUS_NM   ↔ userSttusNm
 *      · USER_SUBJCT_NM  ↔ userSubjctNm
 *      · USER_NO         ↔ userNo
 *    - ROLE_* 네이밍, STDNT/SKLSTF/PROFSR/SUBJCT DDL 변경 시
 *      · SELECT 쿼리, 이 VO, JSP 헤더 표시 로직을 동시에 조정해야 정합성 유지.
 */

import java.util.List;

import lombok.Data;

@Data
public class AcntVO {

    /** 로그인 아이디 (ACNT.ACNT_ID, PK, UserDetails.username 에 매핑) */
    private String acntId;

    /** 프로필 이미지 등 첨부파일 그룹 번호 (ACNT.FILE_GROUP_NO, FK 추정) */
    private Long fileGroupNo;

    /**
     * 비밀번호 해시 (ACNT.PASSWORD)
     * - BCrypt/Argon2 등으로 해시된 값만 저장.
     * - 절대 평문 비밀번호를 넣거나 노출하지 말 것.
     */
    private String password;

    /**
     * 계정 유형 코드 (ACNT.ACNT_TY)
     * - 예: 1=학생, 2=교수, 9=관리자 등 프로젝트 규약에 따름.
     * - 실제 인가 판단은 authorList 의 ROLE_* 기준으로 하고,
     *   acntTy 는 보조 분류로만 사용.
     */
    private String acntTy;

    /**
     * 표시용 사용자 이름 (USER_NM 파생 컬럼)
     * - ROLE_STUDENT : STDNT.STDNT_NM
     * - ROLE_PROF    : SKLSTF.SKLSTF_NM
     * - ROLE_ADMIN   : '관리자'
     * - JSP 헤더 “OOO 학우님 / 교수님 / 관리자님 반갑습니다.” 에 사용.
     */
    private String user_nm;

    /**
     * 표시용 상태명 (USER_STTUS_NM 파생 컬럼)
     * - 학생(ROLE_STUDENT)
     *   · STDNT.SKNRGS_STTUS = '재학' → '등록생'
     *   · 그 외(휴학/군휴학/졸업 등) → 원본값 그대로
     * - 교수(ROLE_PROF)
     *   · '재직'
     * - 관리자/기타 → null 가능
     * - 헤더 드롭다운에서 “학적 상태 : 등록생 / 휴학 / 재직 …” 출력에 사용.
     */
    private String userSttusNm;

    /**
     * 소속 학과명 (USER_SUBJCT_NM 파생 컬럼)
     * - 학생 : STDNT.SUBJCT_CODE → SUBJCT.SUBJCT_NM
     * - 교수 : PROFSR.SUBJCT_CODE → SUBJCT.SUBJCT_NM
     * - 관리자/기타 → null 가능
     * - 헤더 드롭다운 “소속 학과 : 컴퓨터과학과” 에 사용.
     */
    private String userSubjctNm;

    /**
     * 번호(학생/교수 구분된 조합 키) (USER_NO 파생 컬럼)
     * - ROLE_STUDENT : STDNT.STDNT_NO (학번)
     * - ROLE_PROF    : SKLSTF.SKLSTF_ID (교번)
     * - 관리자/기타  : null 가능
     * - 헤더 드롭다운에서 “학번 : 202034-243539 (클릭 시 복사)” 등으로 사용.
     */
    private String userNo;
<<<<<<< Updated upstream
<<<<<<< Updated upstream

    /**
     * 계정이 가진 권한 목록 (AUTHOR 테이블 다건 매핑)
     * - 예: [ROLE_STUDENT], [ROLE_PROF], [ROLE_ADMIN], 복수 권한 가능.
     * - Spring Security 의 GrantedAuthority 로 변환해 인가 판단에 사용.
     */
    private List<AuthorVO> authorList;

=======
    
>>>>>>> Stashed changes
=======
    
>>>>>>> Stashed changes
}

/*
- ACNT : AUTHOR = 1 : N
- 이 계정(ACNT_ID)에 연결된 AUTHOR 행들(권한/역할 정보)을 보유
*/