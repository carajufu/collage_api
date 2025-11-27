package kr.ac.collage_api.schedule.service.impl;


import kr.ac.collage_api.schedule.mapper.ScheduleEventMapper;
import kr.ac.collage_api.schedule.service.ScheduleEventService;
import kr.ac.collage_api.schedule.vo.ScheduleEventVO;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
@Transactional(readOnly = true)
public class ScheduleEventServiceImpl implements ScheduleEventService {

    private final ScheduleEventMapper scheduleEventMapper;

    public ScheduleEventServiceImpl(ScheduleEventMapper scheduleEventMapper) {
        this.scheduleEventMapper = scheduleEventMapper;
    }

    private <T> List<T> safe(List<T> list) {
        return list != null ? list : Collections.emptyList();
    }

    // [0] 통합 학사 일정 (SCHEDULE_EVENT)
    @Override
    public List<ScheduleEventVO> selectScheduleEvents(String role,
                                                      String stdntNo,
                                                      String profsrNo,
                                                      String startDate,
                                                      String endDate) {
        return safe(scheduleEventMapper.selectScheduleEvents(role, stdntNo, profsrNo, startDate, endDate));
    }

    // [1] 정규 수업 시간표
    @Override
    public List<ScheduleEventVO> selectLectureEvents(String role,
                                                     String stdntNo,
                                                     String profsrNo) {
        return safe(scheduleEventMapper.selectLectureEvents(role, stdntNo, profsrNo));
    }

    // [2] 과제 일정
    @Override
    public List<ScheduleEventVO> selectTaskEvents(String role,
                                                  String stdntNo,
                                                  String profsrNo,
                                                  String startDate,
                                                  String endDate) {
        return safe(scheduleEventMapper.selectTaskEvents(role, stdntNo, profsrNo, startDate, endDate));
    }

    // [3] 팀 프로젝트 일정
    @Override
	public List<ScheduleEventVO> selectTeamProjectEvents(String role,
										            String stdntNo,
										            String profsrNo,
										            String startDate,
										            String endDate) {
        return safe(scheduleEventMapper.selectTeamProjectEvents(role, stdntNo, profsrNo, startDate, endDate));
    }

    // [4] 상담 일정
    @Override
    public List<ScheduleEventVO> selectCounselEvents(String role,
                                                     String stdntNo,
                                                     String profsrNo,
                                                     String startDate,
                                                     String endDate) {
        return safe(scheduleEventMapper.selectCounselEvents(role, stdntNo, profsrNo, startDate, endDate));
    }

    // [5] 수강신청 요청 일정
    @Override
    public List<ScheduleEventVO> selectEnrollRequestEvents(String role,
                                                           String stdntNo,
                                                           String profsrNo,
                                                           String startDate,
                                                           String endDate) {
        return safe(scheduleEventMapper.selectEnrollRequestEvents(role, stdntNo, profsrNo, startDate, endDate));
    }

    // [6] 행정/학사 이벤트
    @Override
    public List<ScheduleEventVO> selectAdminEvents(String role,
                                                   String stdntNo,
                                                   String startDate,
                                                   String endDate) {
        return safe(scheduleEventMapper.selectAdminEvents(role, stdntNo, startDate, endDate));
    }

    /**
     * 옵션: 컨트롤러에서 사용하는 통합 조회 메서드.
    */
	@Override
    public List<ScheduleEventVO> getAllEvents(String role,
                                              String stdntNo,
                                              String profsrNo,
                                              String startDate,
                                              String endDate) {

        List<ScheduleEventVO> result = new ArrayList<>();

        // 쿼리 오류 //result.addAll(selectScheduleEvents(role, stdntNo, profsrNo, startDate, endDate));
        result.addAll(selectLectureEvents(role, stdntNo, profsrNo));
        result.addAll(selectTaskEvents(role, stdntNo, profsrNo, startDate, endDate));
        result.addAll(selectTeamProjectEvents(role, stdntNo, profsrNo, startDate, endDate));
        result.addAll(selectCounselEvents(role, stdntNo, profsrNo, startDate, endDate));
        result.addAll(selectEnrollRequestEvents(role, stdntNo, profsrNo, startDate, endDate));
        // 쿼리 오류 //result.addAll(selectAdminEvents(role, stdntNo, startDate, endDate));

        // start(문자열 또는 Comparable) → eventId 기준 정렬
        result.sort((a, b) -> {
            // start 비교 (null last)
            String as = a.getStartDate();
            String bs = b.getStartDate();

            if (as == null && bs != null) return 1;
            if (as != null && bs == null) return -1;
            if (as != null && bs != null) {
                int c = as.compareTo(bs);
                if (c != 0) return c;
            }

            // eventId 비교 (null last)
            String aid = a.getId();
            String bid = b.getId();

            if (aid == null && bid != null) return 1;
            if (aid != null && bid == null) return -1;
            if (aid == null) return 0;
            return aid.compareTo(bid);
        });

        return result;
    }


}
