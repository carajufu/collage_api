package kr.ac.collage_api.schedule.service;

import java.time.LocalDate;
import java.util.List;

import kr.ac.collage_api.schedule.vo.ScheduleEventVO;
import org.apache.ibatis.annotations.Param;

/**
 * ScheduleEventService
 *
 * 역할
 * - FullCalendar 등 클라이언트에서 사용하는 일정 이벤트를 단일 형식으로 제공.
 * - 내부적으로 MyBatis Mapper(select*Events)를 호출하여 ScheduleEventVO 리스트 반환.
 *
 * 공통 규칙
 * - 모든 메서드는 인자로 받은 condition.validate()를 통과해야 함.
 * - 반환값은 null 금지, 항상 빈 리스트 또는 데이터 리스트.
 * - ROLE/STUDENT/PROF/ADMIN에 따른 데이터 범위 제한은 구현체에서 Mapper 호출 시 반드시 적용.
 */
public interface ScheduleEventService {

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

	/**
	 * 옵션: 컨트롤러에서 사용하는 통합 조회 메서드.
	*/
	List<ScheduleEventVO> getAllEvents(
	        String role,
	        String stdntNo,
	        String profsrNo,
	        String startDateYmd,
	        String endDateYmd
			);
 }
