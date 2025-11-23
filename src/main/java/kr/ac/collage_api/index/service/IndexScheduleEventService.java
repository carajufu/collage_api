package kr.ac.collage_api.index.service;

import kr.ac.collage_api.schedule.vo.ScheduleEventVO;

import java.util.List;
import java.util.Map;


public interface IndexScheduleEventService {
	List<ScheduleEventVO> selectIndexScheduleEvents(Map<String, Object> param);
}
