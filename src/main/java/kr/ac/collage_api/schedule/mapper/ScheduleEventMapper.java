package kr.ac.collage_api.schedule.mapper;

import java.util.List;

import kr.ac.collage_api.schedule.vo.ScheduleEventVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ScheduleEventMapper {

    /**
     * [0] 통합 학사 일정 (SCHEDULE_EVENT)
     * XML: selectScheduleEvents
     */
    List<ScheduleEventVO> selectScheduleEvents(
            @Param("role")     String role,
            @Param("stdntNo")  String stdntNo,
            @Param("profsrNo") String profsrNo,
            @Param("startDate")    String startDate,
            @Param("endDate")      String endDate
    );

    /**
     * [1] 정규 수업 시간표
     * XML: selectLectureEvents
     */
    List<ScheduleEventVO> selectLectureEvents(
            @Param("role")     String role,
            @Param("stdntNo")  String stdntNo,
            @Param("profsrNo") String profsrNo
    );

    /**
     * [2] 과제 일정
     * XML: selectTaskEvents
     */
    List<ScheduleEventVO> selectTaskEvents(
            @Param("role")     String role,
            @Param("stdntNo")  String stdntNo,
            @Param("profsrNo") String profsrNo,
            @Param("startDate")    String startDate,
            @Param("endDate")      String endDate
    );

    /**
     * [3] 팀 프로젝트 일정
     * XML: selectTeamProjectEvents
     */
    List<ScheduleEventVO> selectTeamProjectEvents(
            @Param("role")     String role,
            @Param("stdntNo")  String stdntNo,
            @Param("profsrNo") String profsrNo,
            @Param("startDate")    String startDate,
            @Param("endDate")      String endDate
    );

    /**
     * [4] 상담 일정
     * XML: selectCounselEvents
     */
    List<ScheduleEventVO> selectCounselEvents(
            @Param("role")     String role,
            @Param("stdntNo")  String stdntNo,
            @Param("profsrNo") String profsrNo,
            @Param("startDate")    String startDate,
            @Param("endDate")      String endDate
    );

    /**
     * [5] 수강신청 요청 일정
     * XML: selectEnrollRequestEvents
     */
    List<ScheduleEventVO> selectEnrollRequestEvents(
            @Param("role")     String role,
            @Param("stdntNo")  String stdntNo,
            @Param("profsrNo") String profsrNo,
            @Param("startDate")    String startDate,
            @Param("endDate")      String endDate
    );

    /**
     * [6] 행정/학사 이벤트
     * XML: selectAdminEvents
     */
    List<ScheduleEventVO> selectAdminEvents(
            @Param("role")     String role,
            @Param("stdntNo")  String stdntNo,
            @Param("startDate")    String startDate,
            @Param("endDate")      String endDate
    );
}
