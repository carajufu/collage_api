package kr.ac.collage_api.index.mapper;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.schedule.vo.ScheduleEventVO;
import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface IndexScheduleEventMapper {

    /**
     * index.jsp 메인 학사일정 카드 전용 통합 일정 조회.
     *
     * 예상 파라미터(Map key)
     * - role      : String  (ROLE_STUDENT / ROLE_PROF / ROLE_ADMIN / null or 기타 = guest)
     * - stdntNo   : String  (학생번호, ROLE_STUDENT 전용)
     * - profsrNo  : String  (교수번호, ROLE_PROF 전용)
     * - startDate : String  (YYYYMMDD)
     * - endDate   : String  (YYYYMMDD)
     */
    List<ScheduleEventVO> selectIndexScheduleEvents(Map<String, Object> param);
}
