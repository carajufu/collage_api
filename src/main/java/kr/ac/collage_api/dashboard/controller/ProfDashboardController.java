package kr.ac.collage_api.dashboard.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import kr.ac.collage_api.account.service.UserAccountService;
import kr.ac.collage_api.common.util.CurrentSemstr;
//import kr.ac.collage_api.dashboard.service.ProfDashboardService;
import kr.ac.collage_api.dashboard.vo.DashLectureVO;
import kr.ac.collage_api.index.service.IndexBbsService;
import kr.ac.collage_api.index.service.IndexScheduleEventService;
import kr.ac.collage_api.index.vo.IndexBbsVO;
import kr.ac.collage_api.schedule.service.SpcdeHolidayService;
import kr.ac.collage_api.schedule.service.TimetableService;
import kr.ac.collage_api.schedule.vo.CalendarEventVO;
import kr.ac.collage_api.schedule.vo.ScheduleEventVO;
import kr.ac.collage_api.schedule.vo.TimetableEventVO;
import kr.ac.collage_api.security.mapper.SecurityMapper;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 교수 대시보드 컨트롤러
 * - 좌측: 담당 강의 카드(현재 학기 기준)
 * - 우측: 본인 강의 기준 시간표 + 학사 일정 요약 + 공휴일 + 메인 게시판
 *
 * 비유: 학생판과 같은 보드를 쓰되,
 *       학생 이름 대신 "담당 과목 리스트"를 적어두는 버전이라고 보면 됨.
 */
@Slf4j
@Controller
@RequestMapping("/dashboard")
public class ProfDashboardController {

    @Autowired
    private UserAccountService userAccountService;

    @Autowired
    private SpcdeHolidayService spcdeHolidayService;

    @Autowired
    private IndexScheduleEventService indexScheduleEventService;

    @Autowired
    private TimetableService timetableService;

    @Autowired
    private SecurityMapper securityMapper;

    @Autowired
    private IndexBbsService indexBbsService;

    @GetMapping("/prof")
    public String profDashboard(@RequestParam(value = "year", required = false) Integer year,
                                @RequestParam(value = "month", required = false) Integer month,
                                Model model,
                                Principal principal,
                                HttpServletRequest request) {

        // 인증 안 된 경우 즉시 로그인으로 리다이렉트
        if (principal == null) {
            log.warn("[ProfDashboardController] principal is null (unauthenticated access)");
            return "redirect:/login";
        }

        final String acntId = principal.getName();
        log.info("[ProfDashboardController] request acntId={}", acntId);

        // 1. 년/월 계산 (학생 대시보드와 동일 패턴)
        LocalDate today = LocalDate.now();
        int currentYear  = (year  != null) ? year  : today.getYear();
        int currentMonth = (month != null) ? month : today.getMonthValue();

        YearMonth yearMonth = YearMonth.of(currentYear, currentMonth);
        LocalDate start = yearMonth.atDay(1);
        LocalDate end   = yearMonth.atEndOfMonth();

        DateTimeFormatter basic = DateTimeFormatter.BASIC_ISO_DATE; // yyyyMMdd
        String startDate = start.format(basic);
        String endDate   = end.format(basic);

        YearMonth prev = yearMonth.minusMonths(1);
        YearMonth next = yearMonth.plusMonths(1);

        // 2. ACNT_ID → PROFSR_NO 매핑
        //    학생판의 stdntNo와 같은 역할. 강의 / 시간표 / 학사일정 where 조건에 사용.
        String profsrNo = securityMapper.findProfsrNoByAcntId(acntId);
        log.info("profsrNo : " + profsrNo);
        if (profsrNo == null || profsrNo.isBlank()) {
            log.warn("[ProfDashboardController] ROLE_PROF but no PROFSR_NO, acntId={}", acntId);
            return "redirect:/login";
        }
        // 3. 교수 시간표 (월 범위)
        List<TimetableEventVO> timetable = timetableService.getStudentTimetable(profsrNo, startDate, endDate);
        log.info("[ProfDashboardController] timetable size={}", timetable == null ? 0 : timetable.size());

        // 5. 메인 게시판 (공지/행사/학술/뉴스) — 학생판과 동일하게 재사용
        List<IndexBbsVO> notices_bbs = indexBbsService.selectMainBbsList(1); // 공지사항
        List<IndexBbsVO> events_bbs  = indexBbsService.selectMainBbsList(2); // 행사
        List<IndexBbsVO> papers_bbs  = indexBbsService.selectMainBbsList(3); // 학술/논문
        List<IndexBbsVO> news_bbs    = indexBbsService.selectMainBbsList(7); // 대내외 뉴스
        List<IndexBbsVO> prof_academic = indexBbsService.selectMainBbsList(8); // 교무/행정

        model.addAttribute("notices_bbs", notices_bbs);
        model.addAttribute("events_bbs",  events_bbs);
        model.addAttribute("papers_bbs",  papers_bbs);
        model.addAttribute("news_bbs",    news_bbs);
        model.addAttribute("prof_academic",  prof_academic); // 행정

        // 6. 현재 날짜 라벨 (예: 2025년 11월 26일 수요일)
        DateTimeFormatter formatter =
                DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 EEEE", Locale.KOREAN);

        model.addAttribute("timetable", timetable);
        model.addAttribute("currentDateLabel", today.format(formatter));
        model.addAttribute("currentYear", currentYear);
        model.addAttribute("currentMonth", currentMonth);
        model.addAttribute("prevYear", prev.getYear());
        model.addAttribute("prevMonth", prev.getMonthValue());
        model.addAttribute("nextYear", next.getYear());
        model.addAttribute("nextMonth", next.getMonthValue());

        // 7. 공휴일 목록 (월 범위) — 교수 입장에서도 동일하게 보이도록 유지
        List<CalendarEventVO> holidays = spcdeHolidayService.getSpecialDays(start, end);
        model.addAttribute("holidays", holidays);

        // 8. 계정 정보 + role 세팅
        AcntVO acntVO = userAccountService.findById(acntId);
        model.addAttribute("acntVO", acntVO);

        String role = null;
        if (request.isUserInRole("ROLE_PROF")) {
            role = "ROLE_PROF";
        } else if (request.isUserInRole("ROLE_STUDENT")) {
            // 이 컨트롤러는 원래 교수용이지만, 혹시 잘못 들어왔을 때를 고려
            role = "ROLE_STUDENT";
        } else {
            role = null;
        }

        // 9. 학사 일정 조회 (IndexScheduleEventService 재사용)
        //    - role + profsrNo 기준으로 이 교수에게 의미 있는 일정만 필터링하도록 설계.
        Map<String, Object> param = new HashMap<>();
        param.put("role", role);
        param.put("stdntNo", null);      // 교수 대시보드이므로 학생번호는 사용하지 않음
        param.put("profsrNo", profsrNo); // 교수 번호를 기준으로 조회
        param.put("startDate", startDate);
        param.put("endDate", endDate);

        List<ScheduleEventVO> academicSchedules =
                indexScheduleEventService.selectIndexScheduleEvents(param);
        model.addAttribute("academicSchedules", academicSchedules);

        log.info(
                "[ProfDashboardController] model ready. acntId={}, profsrNo={}, lectures={}, schedules={}, holidays={}",
                acntId,
                profsrNo,
//                lectureList == null ? 0 : lectureList.size(),
                academicSchedules == null ? 0 : academicSchedules.size(),
                holidays == null ? 0 : holidays.size()
        );

        // /WEB-INF/views/dashboard/prof/dashboard.jsp
        return "dashboard/prof/dashboard";
    }
}
