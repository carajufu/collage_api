package kr.ac.collage_api.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.vo.ScheduleEventVO;

public interface IndexScheduleEventService {
	List<ScheduleEventVO> selectIndexScheduleEvents(Map<String, Object> param);
}
