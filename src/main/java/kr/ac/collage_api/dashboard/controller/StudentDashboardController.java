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
import kr.ac.collage_api.dashboard.service.StudentDashboardService;
import kr.ac.collage_api.dashboard.vo.DashLectureVO;
import kr.ac.collage_api.index.service.IndexBbsService;
import kr.ac.collage_api.index.service.IndexScheduleEventService;
import kr.ac.collage_api.index.vo.IndexBbsVO;
import kr.ac.collage_api.schedule.service.SpcdeHolidayService;
import kr.ac.collage_api.schedule.service.TimetableService;
import kr.ac.collage_api.schedule.vo.CalendarEventVO;
import kr.ac.collage_api.schedule.vo.ScheduleEventVO;
import kr.ac.collage_api.schedule.vo.TimetableEventVO;
import kr.ac.collage_api.security.mapper.DitAccountMapper;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Slf4j
@Controller
@RequestMapping("/dashboard")
public class StudentDashboardController {

    @Autowired
    StudentDashboardService studentDashboardService;

    @Autowired
    CurrentSemstr currentSemester;

    @Autowired
    UserAccountService ditAccountService;

    @Autowired
    SpcdeHolidayService spcdeHolidayService;

    @Autowired
    IndexScheduleEventService indexScheduleEventService;

    @Autowired
    TimetableService timetableService;

    @Autowired
    DitAccountMapper ditAccountMapper;

    @Autowired
    IndexBbsService indexBbsService;

    /**
     * 학생 대시보드
     * - 좌측: 수강 강의 카드 리스트(현재 학기 기준)
     * - 우측: 학사 일정 요약(월 범위) + 공휴일 정보 등
     */
    @GetMapping("/student")
    public String studentDashboard(@RequestParam(value = "year", required = false) Integer year,
                                   @RequestParam(value = "month", required = false) Integer month,
                                   Model model,
                                   Principal principal,
                                   HttpServletRequest request) {

        // 인증 안 된 경우 즉시 로그인으로 리다이렉트
        if (principal == null) {
            log.warn("[StudentDashboardController] principal is null (unauthenticated access)");
            return "redirect:/login";
        }

        final String acntId = principal.getName();
        log.info("[StudentDashboardController] request acntId={}", acntId);

        // 1. 현재 학기 기준 수강 강의 리스트
        List<DashLectureVO> lectureList =
                studentDashboardService.selectStudent(
                        acntId,
                        currentSemester.getYear(),
                        currentSemester.getCurrentPeriod()
                );
        model.addAttribute("lectureList", lectureList);

        // 2. 캘린더용 년/월 계산 (IndexController 패턴과 동일)
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

        // ACNT_ID → STDNT_NO 매핑 (학번/내부 학생키)
        String stdntNo = ditAccountMapper.findStdntNoByAcntId(acntId);
        if (stdntNo == null || stdntNo.isBlank()) {
            // 계정-학생번호 매핑 깨진 경우: 데이터 정합성 문제
            log.warn("[StudentDashboardController] ROLE_STUDENT but no STDNT_NO, acntId={}", acntId);
            return "redirect:/login";
        }

        // 3. 학생 시간표 (월 범위)
        List<TimetableEventVO> timetable = timetableService.getStudentTimetable(stdntNo, startDate, endDate);
        log.info("[StudentDashboardController] timetable size={}", timetable == null ? 0 : timetable.size());

        // 4. 메인 게시판 목록
        List<IndexBbsVO> notices_bbs = indexBbsService.selectMainBbsList(1); // 공지사항
        List<IndexBbsVO> events_bbs  = indexBbsService.selectMainBbsList(2); // 행사
        List<IndexBbsVO> papers_bbs  = indexBbsService.selectMainBbsList(3); // 학술/논문
        List<IndexBbsVO> news_bbs    = indexBbsService.selectMainBbsList(7); // 대내외 뉴스

        model.addAttribute("notices_bbs", notices_bbs);
        model.addAttribute("events_bbs",  events_bbs);
        model.addAttribute("papers_bbs",  papers_bbs);
        model.addAttribute("news_bbs",    news_bbs);

        // 5. 현재 날짜 라벨 (예: 2025년 11월 26일 수요일)
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

        // 6. 공휴일 목록 (월 범위)
        List<CalendarEventVO> holidays = spcdeHolidayService.getSpecialDays(start, end);
        model.addAttribute("holidays", holidays);

        // 7. 로그인 계정 정보 및 role / stdntNo / profsrNo 추출
        String role = null;
        String profsrNo = null; // 교수 번호는 현재 학생 대시보드에서는 사용 안 함

        AcntVO acntVO = ditAccountService.findById(acntId);
        model.addAttribute("acntVO", acntVO);
        
        // 8. 학사 일정 조회 (IndexScheduleEventService 재사용)
        Map<String, Object> param = new HashMap<>();
        param.put("role", role);
        param.put("stdntNo", stdntNo);   // 여기서 stdntNo는 mapper 기준 학생번호 유지
        param.put("profsrNo", profsrNo);
        param.put("startDate", startDate); // YYYYMMDD
        param.put("endDate", endDate);     // YYYYMMDD

        List<ScheduleEventVO> academicSchedules =
                indexScheduleEventService.selectIndexScheduleEvents(param);
        model.addAttribute("academicSchedules", academicSchedules);

        log.info(
                "[StudentDashboardController] model ready. acntId={}, role={}, lectures={}, schedules={}, holidays={}",
                acntId,
                role,
                lectureList == null ? 0 : lectureList.size(),
                academicSchedules == null ? 0 : academicSchedules.size(),
                holidays == null ? 0 : holidays.size()
        );

        // /WEB-INF/views/dashboard/student/dashboard.jsp
        return "dashboard/student/dashboard";
    }
}
