package kr.ac.collage_api.service;

import java.util.List;
import kr.ac.collage_api.vo.TimetableEventVO;

/**
 * 시간표 조회 서비스
 * - 교수: 담당 강의 시간표
 * - 학생: 본인 수강 시간표
 */
public interface TimetableService {
    List<TimetableEventVO> getProfessorTimetable(String profsrNo,
                                                 String startDate,
                                                 String endDate);

    List<TimetableEventVO> getStudentTimetable(String stdntNo,
                                               String startDate,
                                               String endDate);
}
