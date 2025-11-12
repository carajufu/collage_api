package kr.ac.collage_api.mapper;

import kr.ac.collage_api.vo.AcntVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * DitAccountMapper
 *
 * 역할
 * - ACNT / AUTHOR / STDNT 연계 계정 정보 조회 및 등록.
 * - 인증, 권한, 학번 맵핑을 단일 진입점에서 처리.
 *
 * 주요 사용처
 * - 로그인: ACNT + AUTHOR 기반 사용자 정보 로딩.
 * - 일정 조회: ACNT_ID 기준으로 ROLE, 학번(STDNT_NO) 조회.
 */
@Mapper
public interface DitAccountMapper {

    /**
     * ACNT 단일 계정 조회.
     */
    AcntVO findById(@Param("acntId") String acntId);

    /**
     * ACNT 신규 저장.
     */
    int userSave(AcntVO ditAccountVO);

    /**
     * 권한(AUTHOR) 저장.
     * - 구현부에서 AUTHOR 테이블 INSERT 수행.
     */
    int userSaveAuth(AcntVO ditAccountVO);

    /**
     * ACNT_ID 기준 권한 ID 목록 조회.
     * - 테이블: AUTHOR
     * - 반환 예: ["ROLE_STUDENT", "ROLE_PROF"]
     * - /api/schedule/events 등에서 role 결정 시 사용.
     */
    String findAuthoritiesByAcntId(@Param("acntId") String acntId);

    /**
     * ACNT_ID 기준 학생 학번(STDNT_NO) 조회.
     * - 테이블: STDNT
     * - ROLE_STUDENT 인 경우 ScheduleSearchCondition.stdntNo 세팅에 사용.
     */
    String findStdntNoByAcntId(@Param("acntId") String acntId);
    // 교수용
    String findProfsrNoByAcntId(@Param("acntId") String acntId);
}
