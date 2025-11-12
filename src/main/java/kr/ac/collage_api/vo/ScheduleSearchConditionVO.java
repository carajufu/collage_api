package kr.ac.collage_api.vo;

import lombok.Data;

/**
 * 스케줄 조회 공통 조건 VO
 *
 * Mapper 파라미터로 Map 대신 사용할 경우.
 * mapper의 #{role}, #{stdntNo}, #{profsrNo}, #{start}, #{end} 에 매핑.
 */
@Data
public class ScheduleSearchConditionVO {
    // ROLE_STUDENT / ROLE_PROF / ROLE_ADMIN 등
    private String role;

    // 학생인 경우 세션에서 주입
    private String stdntNo;

    // 교수인 경우 세션에서 주입
    private String profsrNo;

    // 조회 시작일 (YYYYMMDD)
    private String start;

    // 조회 종료일 (YYYYMMDD)
    private String end;
}
