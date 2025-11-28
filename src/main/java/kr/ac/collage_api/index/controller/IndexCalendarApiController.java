package kr.ac.collage_api.index.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import kr.ac.collage_api.account.service.UserAccountService;
import kr.ac.collage_api.index.service.IndexBbsService;
import kr.ac.collage_api.index.service.IndexScheduleEventService;
import kr.ac.collage_api.index.vo.IndexCalendarEventVO;
import kr.ac.collage_api.schedule.service.SpcdeHolidayService;
import kr.ac.collage_api.schedule.vo.ScheduleEventVO;
import kr.ac.collage_api.security.mapper.SecurityMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletRequest;
import kr.ac.collage_api.vo.AcntVO;
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
    UserAccountService ditAccountService;

    @Autowired
    SecurityMapper ditAccountMapper;

    @Autowired
    IndexBbsService indexBbsService;

    @Autowired
    SpcdeHolidayService spcdeHolidayService;

    @Autowired
    IndexScheduleEventService indexScheduleEventService;

    /**
     * 메인 인덱스 학사일정 AJAX 엔드포인트
     * 코드 의도
     *  - index.jsp 메인 카드에서 월 이동시 전체 페이지 새로고침 없이
     *    해당 월의 학사 등록 행사 일정을 JSON 으로 반환
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
     *      4 role stdntNo profsrNo startYmd endYmd 를 Map 에 담아 서비스 호출
     *      5 ScheduleEventVO 리스트를 IndexCalendarEventVO 리스트로 변환
     *  - 출력
     *      JSON 배열 List IndexCalendarEventVO
     *
     * 계약
     *  - year month 는 유효한 달이어야 함 1 12 범위 이외는 서비스 단에서 예외 처리
     *  - 로그인하지 않은 경우 role stdntNo profsrNo 는 모두 null guest 로 취급
     *  - indexScheduleEventService.selectIndexScheduleEvents 는
     *    전달받은 기간과 사용자 정보에 맞는 일정만 반환해야 함
     *
     * 보안
     *  - 권한 판별은 HttpServletRequest.isUserInRole 사용
     *  - 학번 교수번호는 로그인 사용자의 계정에서만 추출 외부 입력 금지
     *
     * 유지보수자 가이드
     *  - 일정 필터 조건이 추가되면 param Map 키와 서비스 Mapper 쿼리를 동시에 수정
     *  - 날짜 포맷을 바꾸고 싶으면 DateTimeFormatter 와 IndexCalendarEventVO.startLabel 생성 부분을 함께 수정
     */
    @GetMapping("/calendar")
    public List<IndexCalendarEventVO> getCalendarEvents(
            Principal principal,
            @RequestParam("year") int year,
            @RequestParam("month") int month,
            Authentication authentication,
            HttpServletRequest request
    ) {

        // 1 year month 로 해당 월 1일과 말일 계산
        LocalDate firstDay = LocalDate.of(year, month, 1);
        LocalDate lastDay  = firstDay.with(TemporalAdjusters.lastDayOfMonth());

        String startDate = firstDay.format(DateTimeFormatter.BASIC_ISO_DATE); // 예 20251101
        String endDate   = lastDay.format(DateTimeFormatter.BASIC_ISO_DATE);  // 예 20251130

        // 2 로그인 사용자 정보 기반 role 학번 교수번호 추출
        String role = null;
        String stdntNo = null;
        String profsrNo = null;

        if (principal != null) {
            String acntId = principal.getName();
            log.debug("index calendar acntId {}", acntId);

            AcntVO acntVO = ditAccountService.findById(acntId);

            if (request.isUserInRole("ROLE_STUDENT")) {
                role = "ROLE_STUDENT";
                // AcntVO 에서 학생 식별자 필드 사용
                stdntNo = acntVO != null ? acntVO.getAcntId() : null;
            } else if (request.isUserInRole("ROLE_PROF")) {
                role = "ROLE_PROF";
                // AcntVO 에서 교수 식별자 필드 사용
                profsrNo = acntVO != null ? acntVO.getAcntId() : null;
            } else if (request.isUserInRole("ROLE_ADMIN")) {
                role = "ROLE_ADMIN";
            } else {
                // 그 외 권한은 guest 와 동일 처리
                role = null;
            }
        }

        // 3 서비스 조회 파라미터 구성
        Map<String, Object> param = new HashMap<>();
        param.put("role", role);
        param.put("stdntNo", stdntNo);
        param.put("profsrNo", profsrNo);
        param.put("startDate", startDate); // YYYYMMDD
        param.put("endDate", endDate);     // YYYYMMDD

        // 4 일정 조회 서비스 호출
        List<ScheduleEventVO> events = indexScheduleEventService.selectIndexScheduleEvents(param);

        // 5 VO 변환 후 JSON 으로 리턴
        return events.stream()
                .map(this::toVo)
                .collect(Collectors.toList());
    }

    /**
     * ScheduleEventVO → IndexCalendarEventVO 변환
     *
     * 코드 의도
     *  - DB 조회용 VO를 프론트 전용 VO로 변환해서
     *    화면에서 필요한 필드와 포맷만 노출
     *
     * 데이터 흐름
     *  - 입력 ScheduleEventVO type title memo startDate 등
     *  - 가공
     *      type 을 calGroup ACAD REGI EVENT 로 매핑
     *      startDate YYYY MM DD 에서 MM dd 라벨 생성
     *  - 출력 IndexCalendarEventVO
     *
     * 계약
     *  - startDate 는 최소 yyyy-MM-dd 형식을 가정 substr 사용
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

        // startDate 예시 2025 11 03 형식 문자열 사용
        indexCalendarEventVO.setStartDate(vo.getStartDate());
        if (vo.getStartDate() != null && vo.getStartDate().length() >= 10) {
            String mm = vo.getStartDate().substring(5, 7);
            String dd = vo.getStartDate().substring(8, 10);
            indexCalendarEventVO.setStartLabel(mm + "." + dd);
        }

        return indexCalendarEventVO;
    }
}
