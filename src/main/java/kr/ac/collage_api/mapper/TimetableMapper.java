package kr.ac.collage_api.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.vo.TimetableEventVO;

@Mapper
public interface TimetableMapper {

    /*
     * [코드 의도]
     * - 교수 계정으로 로그인한 사용자의 "담당 강의 주간 시간표"를 조회하는 쿼리 매퍼.
     * - LCTRE_TIMETABLE, ESTBL_COURSE, ALL_COURSE, ATNLC_REQST 등 누적 스키마를 기준으로
     *   실제 운영 환경 수준의 강의 정보(과목, 강의실, 인원)를 한 번에 가져오는 것을 목표로 함.
     *
     * [데이터 흐름]
     * - 입력:
     *     profsrNo   : 교수 식별자(PROFSR.PROFSR_NO)
     *     startDate  : 조회 시작일(YYYY-MM-DD)
     *     endDate    : 조회 종료일(YYYY-MM-DD)
     * - 내부 처리(쿼리, XML에서 구현):
     *     1) ESTBL_COURSE.PROFSR_NO = profsrNo 인 개설강의 필터링.
     *     2) LCTRE_TIMETABLE 과 조인하여 요일/시간 슬롯 추출.
     *     3) ATNLC_REQST 로 수강 인원 COUNT.
     *     4) ALL_COURSE, 관련 코드 테이블과 조인하여 과목명, 학과, 강의실 등 부가 정보 조회.
     *     5) dayCode + BEGIN_TM/END_TM + startDate/endDate 범위를 기반으로 VO 내 start/endDateTime 구성용 데이터 전달.
     * - 출력:
     *     TimetableEventVO 목록:
     *       - FullCalendar event에 매핑 가능한 필드(과목명, 시간, 장소, 수강 인원, 정원 등)를 포함.
     *
     * [계약]
     * - profsrNo:
     *     타입: String
     *     필수: 필수
     *     의미: 현재 로그인한 교수의 고유 번호.
     * - startDate, endDate:
     *     타입: String
     *     형식: YYYY-MM-DD
     *     필수: 필수
     *     의미: 해당 주(또는 기간)의 캘린더 렌더링 범위.
     * - 반환값:
     *     List<TimetableEventVO>
     *     비어 있을 수 있음(담당 강의 없음 또는 기간 외).
     * - 이 인터페이스는 SQL을 직접 포함하지 않으며, 실제 쿼리는 TimetableMapper.xml에서 동형 이름으로 구현해야 함.
     *
     * [보안·안전 전제]
     * - profsrNo는 컨트롤러 단계에서 인증 정보(principal)와 ACNT 매핑을 통해 파생된 값이어야 함.
     * - 임의 입력값으로 다른 교수 시간표를 조회하는 API를 만들지 말 것:
     *   "ACNT_ID → PROFSR_NO" 매핑은 서버 내부 로직에서만 수행.
     *
     * [유지보수자 가이드]
     * - 학기, 연도 조건(ESTBL_YEAR, ESTBL_SEMSTR)은 XML 쿼리에서 공통 정책으로 강제.
     * - ATNLC_REQST 상태값(승인 여부 코드)이 바뀌면 COUNT 조건도 함께 수정.
     * - LCTRE_DFK(요일 코드) 정의나 BEGIN_TM/END_TM 형식 변경 시,
     *   VO 생성 및 서비스 로직(시간 계산)을 함께 점검.
     *
     * [근거]
     * - Smart LMS 누적 ERD 기준:
     *   ESTBL_COURSE(개설강의), LCTRE_TIMETABLE(시간표 슬롯), ATNLC_REQST(수강 신청),
     *   ALL_COURSE(교과 정보), PROFSR/SKLSTF/SUBJCT(교수 및 학과 정보) 구조에 기반.
     */
    List<TimetableEventVO> getProfessorTimetable(
            @Param("profsrNo") String profsrNo,
            @Param("startDate") String startDate,
            @Param("endDate") String endDate
    );

    /*
     * [코드 의도]
     * - 학생 계정으로 로그인한 사용자의 "본인 수강 강의 주간 시간표"를 조회하는 쿼리 매퍼.
     * - 실무 수준 요구사항에 맞춰, 교수 성명, 전공(학과), 강의명, 강의실 등의 정보를
     *   한 번에 조회하여 프론트에서 추가 API 호출 없이 상세 정보를 활용 가능하게 함.
     *
     * [데이터 흐름]
     * - 입력:
     *     stdntNo    : 학생 식별자(STDNT.STDNT_NO)
     *     startDate  : 조회 시작일(YYYY-MM-DD)
     *     endDate    : 조회 종료일(YYYY-MM-DD)
     * - 내부 처리(쿼리, XML에서 구현):
     *     1) ATNLC_REQST.STDNT_NO = stdntNo 인 수강 신청 내역 조회.
     *     2) ESTBL_COURSE 와 조인해 개설강의 코드, 강의실, 담당 교수, 학기 정보 확보.
     *     3) LCTRE_TIMETABLE 과 조인해 요일/시간 슬롯 확보.
     *     4) ALL_COURSE 로 과목명, 과목 코드 등 조회.
     *     5) PROFSR, SKLSTF, SUBJCT 와 조인해 교수 이름, 교수 소속 학과명 조회.
     *     6) dayCode + BEGIN_TM/END_TM + startDate/endDate 를 기반으로 VO에 캘린더 표시용 데이터 전달.
     * - 출력:
     *     TimetableEventVO 목록:
     *       - FullCalendar event에 필요한 start/end, 제목, 교수명, 강의실 등 포함.
     *
     * [계약]
     * - stdntNo:
     *     타입: String
     *     필수: 필수
     *     의미: 현재 로그인한 학생의 고유 번호.
     * - startDate, endDate:
     *     타입: String
     *     형식: YYYY-MM-DD
     *     필수: 필수
     *     의미: 시간표를 그릴 기간(주간 뷰 기준).
     * - 반환값:
     *     List<TimetableEventVO>
     *     비어 있을 수 있음(수강 내역 없는 경우).
     *
     * [보안·안전 전제]
     * - stdntNo는 반드시 인증 정보에서 유도된 값이어야 함.
     * - 쿼리에서 stdntNo 파라미터는 바인딩(@Param)으로만 사용하고,
     *   클라이언트가 직접 임의 학생 번호를 주입하는 형태의 API는 방지.
     *
     * [유지보수자 가이드]
     * - 수강 상태(ATNLC_REQST 상태값)가 추가되면, 실제 시간표에 포함할 상태만 WHERE 조건에 명시.
     * - 교수·학과 정보 스키마 변경 시(예: PROFSR와 SUBJCT 관계),
     *   본 매퍼 쿼리와 TimetableEventVO 필드를 함께 수정.
     * - 요일, 시간, 학기 계산 규칙은 서비스 레이어에서 캡슐화하고,
     *   매퍼는 "원천 데이터" 제공 역할에만 집중하도록 유지.
     *
     * [근거]
     * - Smart LMS ERD 상 ATNLC_REQST(수강 신청) → ESTBL_COURSE(개설강의)
     *   → LCTRE_TIMETABLE(시간표) → ALL_COURSE(과목 정보)
     *   → PROFSR/SKLSTF/SUBJCT(교수·학과) 관계를 그대로 이용.
     */
    List<TimetableEventVO> getStudentTimetable(
            @Param("stdntNo") String stdntNo,
            @Param("startDate") String startDate,
            @Param("endDate") String endDate
    );
}
