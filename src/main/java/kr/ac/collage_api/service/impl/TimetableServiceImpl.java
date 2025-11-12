package kr.ac.collage_api.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.mapper.TimetableMapper;
import kr.ac.collage_api.service.TimetableService;
import kr.ac.collage_api.vo.TimetableEventVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TimetableServiceImpl implements TimetableService {

    private final TimetableMapper timetableMapper;
    /*
     * [코드 의도]
     * - 시간표 조회 도메인의 서비스 레이어 구현체.
     * - 컨트롤러에서 전달받은 교수번호/학생번호와 기간(startDate, endDate)을 기반으로
     *   TimetableMapper에 질의를 위임하고, FullCalendar용 VO 리스트를 반환.
     * - 비즈니스 로직 최소화: 조회 전용(readOnly) 서비스로 유지하여 책임을 명확히 분리.
     *
     * [데이터 흐름]
     * - 입력:
     *     - profsrNo 또는 stdntNo: 인증 정보에서 유도된 주체 식별자.
     *     - startDate, endDate: 조회 기간(YYYY-MM-DD), 주간 뷰 기준.
     * - 처리:
     *     - TimetableMapper의 getProfessorTimetable / getStudentTimetable 호출.
     *     - Mapper에서 LCTRE_TIMETABLE, ESTBL_COURSE, ALL_COURSE, ATNLC_REQST 등 조인.
     * - 출력:
     *     - TimetableEventVO 리스트:
     *       각 VO는 FullCalendar event로 직접 매핑 가능한 데이터(강의명, 시간, 장소, 수강 인원 등)를 포함.
     *
     * [계약]
     * - 이 서비스는 "조회 전용"이다.
     *   - @Transactional(readOnly = true)로 명시, DB 변경 금지.
     * - 전달받는 profsrNo/stdntNo는 유효한 주체 식별자라고 가정한다.
     *   - 유효성 검증과 권한 검증은 컨트롤러 및 상위 인증 계층에서 수행.
     *
     * [보안·안전 전제]
     * - 외부에서 임의 번호를 주입하지 않고, 항상 인증 컨텍스트에서 유도된 값만 들어와야 한다.
     * - 권한 확인(ROLE_STUDENT/ROLE_PROF 등)은 컨트롤러 또는 SecurityConfig에서 처리하고,
     *   이 서비스는 "이미 필터링된 주체"를 대상으로만 조회한다고 가정한다.
     *
     * [유지보수자 가이드]
     * - 학기/연도/상태값(예: 수강 승인 여부) 등의 정책 변경은 TimetableMapper XML의 WHERE 조건에서 관리.
     * - 이 클래스에 비즈니스 조건을 과도하게 추가하지 말고,
     *   공통 정책이 필요하면 별도 도메인 서비스 또는 Mapper 레이어에서 캡슐화.
     * - 시간 계산(요일 코드 → 실제 날짜 매핑, HHMM → LocalTime 변환 등)이 필요할 경우
     *   TimetableEventVO 생성 책임을 전용 Factory/Util로 분리하여 서비스의 역할을 단순 유지.
     *
     * [근거]
     * - Smart LMS 누적 ERD 및 기존 설계:
     *   TimetableMapper가 LCTRE_TIMETABLE/ESTBL_COURSE/ATNLC_REQST/ALL_COURSE 등에서
     *   정제된 시간표 데이터를 반환하는 구조를 이미 채택.
     */

    /**
     * [의도]
     * - 특정 교수(profsrNo)의 담당 강의 시간표를 기간 내에서 조회.
     *
     * [데이터 흐름]
     * - 입력: profsrNo, startDate, endDate
     * - 위임: timetableMapper.getProfessorTimetable(...)
     * - 출력: TimetableEventVO 리스트
     *
     * [계약]
     * - profsrNo는 인증된 교수 계정에서 유도된 값이어야 한다.
     * - startDate/endDate는 YYYY-MM-DD 형식, Mapper 쿼리와 동일 규격 유지.
     */
    @Override
    public List<TimetableEventVO> getProfessorTimetable(String profsrNo, String startDate, String endDate) {
        return timetableMapper.getProfessorTimetable(profsrNo, startDate, endDate);
    }

    /**
     * [의도]
     * - 특정 학생(stdntNo)의 본인 수강 강의 시간표를 기간 내에서 조회.
     *
     * [데이터 흐름]
     * - 입력: stdntNo, startDate, endDate
     * - 위임: timetableMapper.getStudentTimetable(...)
     * - 출력: TimetableEventVO 리스트
     *
     * [계약]
     * - stdntNo는 인증된 학생 계정에서 유도된 값이어야 한다.
     * - startDate/endDate는 YYYY-MM-DD 형식, Mapper 쿼리와 동일 규격 유지.
     */
    @Override
    public List<TimetableEventVO> getStudentTimetable(String stdntNo, String startDate, String endDate) {
        return timetableMapper.getStudentTimetable(stdntNo, startDate, endDate);
    }
}
