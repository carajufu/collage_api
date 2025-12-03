package kr.ac.collage_api.dashboard.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import kr.ac.collage_api.account.service.UserAccountService;
import kr.ac.collage_api.index.service.IndexBbsService;
import kr.ac.collage_api.index.service.IndexScheduleEventService;
import kr.ac.collage_api.index.vo.IndexBbsVO;
import kr.ac.collage_api.schedule.service.SpcdeHolidayService;
import kr.ac.collage_api.schedule.vo.ScheduleEventVO;
import kr.ac.collage_api.security.mapper.DitAccountMapper;
import kr.ac.collage_api.security.mapper.SecurityMapper;
import kr.ac.collage_api.security.service.DitAccountService;
import kr.ac.collage_api.vo.AcntVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@Slf4j
@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardApiController {

    // 서비스 의존성: 생성자 주입 (불변성 유지)
    private final DitAccountService ditAccountService;          // 향후 계정 정보 확장용
    private final IndexBbsService indexBbsService;               // 메인 공지/뉴스/행사/학술
    private final IndexScheduleEventService indexScheduleEventService; // 학사 일정 조회

    // 공지사항
    @GetMapping("/notices")
    public List<IndexBbsVO> getNotices() {
        // 게시판 ID 1번 = 공지사항
        return indexBbsService.selectMainBbsList(1);
    }

    // 뉴스
    @GetMapping("/news")
    public List<IndexBbsVO> getNews() {
        // 게시판 ID 7번 = 대내외 뉴스
        return indexBbsService.selectMainBbsList(7);
    }

    // 행사
    @GetMapping("/events")
    public List<IndexBbsVO> getEvents() {
        // 게시판 ID 2번 = 행사
        return indexBbsService.selectMainBbsList(2);
    }

    // 학술/논문
    @GetMapping("/papers")
    public List<IndexBbsVO> getPapers() {
        // 게시판 ID 3번 = 학술/논문
        return indexBbsService.selectMainBbsList(3);
    }
    
    // 교무/행정
    @GetMapping("/prof-academic")
    public List<IndexBbsVO> getProfessorAcademicNotices() {
        // 게시판 ID 8번 = 교무/행정
        return indexBbsService.selectMainBbsList(8);
    }
    /**
     * 이번 달 학사 일정
     * - year/month 없으면 서버 현재 년/월 기준
     * - ROLE_STUDENT면 stdntNo 기준 개인화 일정
     * - ROLE_PROF면 추후 profsrNo 매핑 확장
     * - 그 외 role=null → 공개 대상 일정만
     */
    @GetMapping("/academic")
    public List<ScheduleEventVO> getAcademics(@RequestParam(value = "year", required = false) Integer year,
                                              @RequestParam(value = "month", required = false) Integer month,
                                              Principal principal,
                                              HttpServletRequest request) {

        // 0. 인증 체크 (대시보드 API이므로 로그인 필수)
        if (principal == null) {
            log.warn("[DashboardApiController] /academic unauthenticated access");
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }

        final String acntId = principal.getName();
        log.debug("[DashboardApiController] /academic request acntId={}", acntId);

        // 1. 기준 년/월 계산 (기본: 오늘 기준)
        LocalDate today = LocalDate.now();
        int currentYear = (year != null) ? year : today.getYear();
        int currentMonth = (month != null) ? month : today.getMonthValue();

        YearMonth ym = YearMonth.of(currentYear, currentMonth);
        LocalDate start = ym.atDay(1);
        LocalDate end   = ym.atEndOfMonth();

        DateTimeFormatter basic = DateTimeFormatter.BASIC_ISO_DATE; // yyyyMMdd
        String startDate = start.format(basic);
        String endDate   = end.format(basic);

        // 2. role / stdntNo / profsrNo 분기
        // 로그인 사용자 정보 기반 role/stdntNo/profsrNo 추출
        String role = null;
        String stdntNo = null;
        String profsrNo = null;
        AcntVO acntVO = null;

        log.debug("acntId : {}", acntId);

        acntVO = ditAccountService.findById(acntId);

        // 권한은 HttpServletRequest 에서 직접 판별
        if (request.isUserInRole("ROLE_STUDENT")) {
            role = "ROLE_STUDENT";
            // AcntVO 구조에 맞게 필드명 맞출 것
            stdntNo = acntVO.getAcntId();
        } else if (request.isUserInRole("ROLE_PROF")) {
            role = "ROLE_PROF";
            // AcntVO 에 교수번호가 있다면 해당 필드 사용
            profsrNo = acntVO.getAcntId();
        } else if (request.isUserInRole("ROLE_ADMIN")) {
            role = "ROLE_ADMIN";
        } else {
            // 그 외 권한은 guest 와 동일 취급
            role = null;
        }
        
        // 3. 학사 일정 조회 파라미터 구성
        Map<String, Object> param = new HashMap<>();
        param.put("role", role);
        param.put("stdntNo", stdntNo);
        param.put("profsrNo", profsrNo);
        param.put("startDate", startDate); // YYYYMMDD
        param.put("endDate", endDate);     // YYYYMMDD

        List<ScheduleEventVO> schedule = indexScheduleEventService.selectIndexScheduleEvents(param);

        log.info(
                "[DashboardApiController] /academic ready. acntId={}, role={}, yearMonth={}-{}, events={}",
                acntId,
                role,
                currentYear,
                String.format("%02d", currentMonth),
                schedule == null ? 0 : schedule.size()
        );

        return schedule;
    }
}
