package kr.ac.collage_api.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletRequest;
import kr.ac.collage_api.mapper.DitAccountMapper;
import kr.ac.collage_api.service.DitAccountService;
import kr.ac.collage_api.service.IndexBbsService;
import kr.ac.collage_api.service.IndexScheduleEventService;
import kr.ac.collage_api.service.SpcdeHolidayService;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.CalendarEventVO;
import kr.ac.collage_api.vo.IndexCalendarEventVO;
import kr.ac.collage_api.vo.ScheduleEventVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/index")
@RequiredArgsConstructor
public class IndexCalendarApiController {

    @Autowired
    ResourcePatternResolver resourceResolver;

    @Autowired
    DitAccountService ditAccountService;

    @Autowired
    DitAccountMapper ditAccountMapper;

    @Autowired
    IndexBbsService indexBbsService;

    @Autowired
    SpcdeHolidayService spcdeHolidayService;

    @Autowired
    IndexScheduleEventService indexScheduleEventService;

    /**
     * 메인 index.jsp 학사일정 AJAX 엔드포인트
     *
     * 코드 의도
     *  - index.jsp 메인 카드에서 월 이동 시 전체 페이지 새로고침 없이
     *    해당 월의 학사/등록/행사 일정과 공휴일을 JSON 으로 반환
     *
     * 데이터 흐름
     *  - 입력
     *      year  요청 쿼리스트링 YYYY
     *      month 요청 쿼리스트링 M 또는 MM
     *      principal 현재 로그인 계정 아이디
     *      request 서블릿 요청 객체(권한 체크용)
     *  - 가공
     *      1 LocalDate 로 해당 월 1일과 말일 계산
     *      2 BASIC_ISO_DATE 포맷으로 YYYYMMDD 문자열 범위 생성
     *      3 계정 아이디로 AcntVO 조회 후 역할별 식별자 추출
     *      4 role, stdntNo, profsrNo, startYmd, endYmd 를 Map 에 담아 학사 일정 조회
     *      5 SpcdeHolidayService 로 공휴일 목록 조회
     *      6 학사 일정 + 공휴일을 IndexCalendarEventVO 리스트로 변환
     *  - 출력
     *      JSON 배열 List<IndexCalendarEventVO>
     *
     * 계약
     *  - year, month 는 유효한 달이어야 함 (1~12) 범위 이외는 서비스 단에서 예외 처리
     *  - 로그인하지 않은 경우 role, stdntNo, profsrNo 는 모두 null (guest)
     *  - indexScheduleEventService.selectIndexScheduleEvents 는
     *    전달받은 기간과 사용자 정보에 맞는 일정만 반환해야 함
     *  - spcdeHolidayService.getSpecialDays(start, end) 는
     *    [start, end] 구간의 모든 공휴일을 반환해야 함
     *
     * 보안
     *  - 권한 판별은 HttpServletRequest.isUserInRole 사용
     *  - 학번/교수번호는 로그인 사용자의 계정에서만 추출, 외부 입력 금지
     *
     * 유지보수자 가이드
     *  - 일정 필터 조건이 추가되면 param Map 키와 서비스 Mapper 쿼리를 동시에 수정
     *  - 날짜 포맷을 바꾸고 싶으면 DateTimeFormatter 와
     *    IndexCalendarEventVO.startLabel 생성 부분을 함께 수정
     *  - 공휴일 UI 스타일이 바뀌면 toHolidayVo 의 type/calGroup/title/memo 매핑만 조정
     */
    @GetMapping("/calendar")
    public List<IndexCalendarEventVO> getCalendarEvents(
            Principal principal,
            @RequestParam("year") int year,
            @RequestParam("month") int month,
            Authentication authentication,
            HttpServletRequest request
    ) {

        // 1. year, month 로 해당 월 1일과 말일 계산
        LocalDate firstDay = LocalDate.of(year, month, 1);
        LocalDate lastDay  = firstDay.with(TemporalAdjusters.lastDayOfMonth());

        String startDate = firstDay.format(DateTimeFormatter.BASIC_ISO_DATE); // 예: 20251101
        String endDate   = lastDay.format(DateTimeFormatter.BASIC_ISO_DATE);  // 예: 20251130

        // 2. 로그인 사용자 정보 기반 role / 학번 / 교수번호 추출
        String role = null;
        String stdntNo = null;
        String profsrNo = null;
        AcntVO acntVO = null;

        if (principal != null) {
            String acntId = principal.getName();
            log.debug("[IndexCalendarApiController] getCalendarEvents : acntId={}", acntId);

            acntVO = ditAccountService.findById(acntId);

            if (request.isUserInRole("ROLE_STUDENT")) {
                role = "ROLE_STUDENT";
                stdntNo = acntVO != null ? acntVO.getUserNo() : null;
            } else if (request.isUserInRole("ROLE_PROF")) {
                role = "ROLE_PROF";
                profsrNo = acntVO != null ? acntVO.getUserNo() : null;
            } else if (request.isUserInRole("ROLE_ADMIN")) {
                role = "ROLE_ADMIN";
            } else {
                role = null; // guest
            }
        }

        // 3. 서비스 조회 파라미터 구성
        Map<String, Object> param = new HashMap<>();
        param.put("role", role);
        param.put("stdntNo", stdntNo);
        param.put("profsrNo", profsrNo);
        param.put("startDate", startDate); // YYYYMMDD
        param.put("endDate", endDate);     // YYYYMMDD

        List<IndexCalendarEventVO> result = new ArrayList<>();

        // 4. 학사 일정 조회 및 매핑
        List<ScheduleEventVO> events = indexScheduleEventService.selectIndexScheduleEvents(param);
        if (events != null && !events.isEmpty()) {
            result.addAll(
                    events.stream()
                          .map(this::toVo)
                          .collect(Collectors.toList())
            );
        }

        // 5. 공휴일 조회 및 매핑
        List<CalendarEventVO> holidays = spcdeHolidayService.getSpecialDays(firstDay, lastDay);
        if (holidays != null && !holidays.isEmpty()) {
            result.addAll(
                    holidays.stream()
                            .map(this::toHolidayVo)
                            .collect(Collectors.toList())
            );
        }

        log.info("[IndexCalendarApiController] getCalendarEvents : year={}, month={}, role={}, academicEvents={}, holidays={}, total={}",
                year,
                month,
                role,
                events == null ? 0 : events.size(),
                holidays == null ? 0 : holidays.size(),
                result.size());

        return result;
    }

    /**
     * ScheduleEventVO → IndexCalendarEventVO 변환
     *
     * 코드 의도
     *  - DB 조회용 VO를 프론트 전용 VO로 변환해서
     *    화면에서 필요한 필드와 포맷만 노출
     *
     * 데이터 흐름
     *  - 입력: ScheduleEventVO (type, title, memo, startDate 등)
     *  - 가공:
     *      type 을 calGroup(ACAD/REGI/EVENT) 로 매핑
     *      startDate yyyy-MM-dd 에서 MM.dd 라벨 생성
     *  - 출력: IndexCalendarEventVO
     *
     * 계약
     *  - startDate 는 최소 yyyy-MM-dd 형식을 가정 (substring 사용)
     *  - type 값이 정의되지 않은 경우 기본 그룹은 ACAD
     *
     * 유지보수자 가이드
     *  - 프런트에서 사용하는 필드가 늘어나면 이 메서드에만 추가하면 됨
     *  - type 과 calGroup 매핑 규칙이 바뀌면 여기 한 곳만 수정
     */
    private IndexCalendarEventVO toVo(ScheduleEventVO vo) {
        IndexCalendarEventVO indexCalendarEventVO = new IndexCalendarEventVO();

        indexCalendarEventVO.setType(vo.getType());

        // type → calGroup 매핑
        String calGroup;
        if ("ADMIN_REGIST".equals(vo.getType())) {
            calGroup = "REGI";
        } else if ("ADMIN_EVENT".equals(vo.getType())) {
            calGroup = "EVENT";
        } else {
            calGroup = "ACAD";
        }
        indexCalendarEventVO.setCalGroup(calGroup);

        indexCalendarEventVO.setTitle(vo.getTitle());
        indexCalendarEventVO.setMemo(vo.getMemo());

        // startDate 예시: 2025-11-03 형식 문자열 사용
        indexCalendarEventVO.setStartDate(vo.getStartDate());
        if (vo.getStartDate() != null && vo.getStartDate().length() >= 10) {
            String mm = vo.getStartDate().substring(5, 7);
            String dd = vo.getStartDate().substring(8, 10);
            indexCalendarEventVO.setStartLabel(mm + "." + dd);
        }

        return indexCalendarEventVO;
    }

    /**
     * CalendarEventVO(공휴일) → IndexCalendarEventVO 변환
     *
     * 코드 의도
     *  - 공휴일 VO를 메인 학사일정 카드에서 재사용 가능한 형태로 변환
     *  - type/calGroup 을 고정 값으로 둬서 프론트에서 스타일링 분기 가능하게 함
     *
     * 데이터 흐름
     *  - 입력: CalendarEventVO (start, title, category, holiday 여부)
     *  - 가공:
     *      1 type = HOLIDAY 또는 category
     *      2 calGroup = HOLI 고정
     *      3 start(yyyy-MM-dd) 를 MM.dd 라벨로 변환
     *      4 title 을 휴일 명칭으로 사용, memo 에 "구분 : ..." 형식 텍스트 부여
     *  - 출력: IndexCalendarEventVO
     *
     * 계약
     *  - CalendarEventVO.getStart() 는 "yyyy-MM-dd" 형식 문자열이라고 가정
     *  - null 이거나 형식이 다르면 startLabel 은 세팅하지 않음
     *
     * 유지보수자 가이드
     *  - CalendarEventVO 필드명 변경 시 이 메서드만 수정하면 됨
     *  - 프론트에서 공휴일 색상/아이콘 등을 바꾸고 싶으면
     *    type/HOLIDAY 또는 calGroup/HOLI 로 조건부 렌더링
     */
    private IndexCalendarEventVO toHolidayVo(CalendarEventVO h) {
        IndexCalendarEventVO indexCalendarEventVO = new IndexCalendarEventVO();

        // 공휴일 타입/그룹
        indexCalendarEventVO.setType(h.isHoliday() ? "HOLIDAY" : h.getCategory());
        indexCalendarEventVO.setCalGroup("HOLI");

        // 휴일 명칭
        indexCalendarEventVO.setTitle(h.getTitle());

        // 메모: 학사일정 카드의 "구분 : ..." 패턴 맞추기
        if (h.isHoliday()) {
        	indexCalendarEventVO.setMemo("구분 : 공휴일 | 출처 : 공공데이터포털");
        } else {
        	indexCalendarEventVO.setMemo("구분 : 기념일/국경일 | 출처 : 공공데이터포털");
        }

        // 날짜 매핑 (start: yyyy-MM-dd)
        String startIso = h.getStart();
        indexCalendarEventVO.setStartDate(startIso);

        if (startIso != null && startIso.length() >= 10) {
            String mm = startIso.substring(5, 7);
            String dd = startIso.substring(8, 10);
            indexCalendarEventVO.setStartLabel(mm + "." + dd);
        }

        return indexCalendarEventVO;
    }
}
