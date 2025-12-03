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
import kr.ac.collage_api.dashboard.vo.AcademicProgressRawVO;
import kr.ac.collage_api.dashboard.vo.DashLectureVO;
import kr.ac.collage_api.graduation.service.GraduationService;
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
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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

    @Autowired
    GraduationService graduService;

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

		// 0. 인증 체크
		if (principal == null) {
			log.warn("[StudentDashboardController] principal is null (unauthenticated access)");
			return "redirect:/login";
		}

		final String acntId = principal.getName();
		log.info("[StudentDashboardController] request acntId={}", acntId);

		// 1. 캘린더용 년/월 계산
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

		// 2. 학생번호 매핑
		String stdntNo = ditAccountMapper.findStdntNoByAcntId(acntId);
		if (stdntNo == null || stdntNo.isBlank()) {
			log.warn("[StudentDashboardController] ROLE_STUDENT but no STDNT_NO, acntId={}", acntId);
			return "redirect:/login";
		}

		// 3. 현재 학기 기준 수강 강의 리스트
		List<DashLectureVO> lectureList =
				studentDashboardService.selectStudent(
						stdntNo,
						currentSemester.getYear(),
						currentSemester.getCurrentPeriod()
						);
		model.addAttribute("lectureList", lectureList);

		// 4. 학생 시간표 (월 범위)
		List<TimetableEventVO> timetable =
				timetableService.getStudentTimetable(stdntNo, startDate, endDate);
		log.info("[StudentDashboardController] timetable size={}", timetable == null ? 0 : timetable.size());

		// 5. 메인 게시판 목록
		List<IndexBbsVO> notices_bbs = indexBbsService.selectMainBbsList(1); // 공지사항
		List<IndexBbsVO> events_bbs  = indexBbsService.selectMainBbsList(2); // 행사
		List<IndexBbsVO> papers_bbs  = indexBbsService.selectMainBbsList(3); // 학술/논문
		List<IndexBbsVO> news_bbs    = indexBbsService.selectMainBbsList(7); // 대내외 뉴스

		model.addAttribute("notices_bbs", notices_bbs);
		model.addAttribute("events_bbs",  events_bbs);
		model.addAttribute("papers_bbs",  papers_bbs);
		model.addAttribute("news_bbs",    news_bbs);

		// 6. 현재 날짜 라벨
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

		// 7. 공휴일 목록 (월 범위)
		List<CalendarEventVO> holidays = spcdeHolidayService.getSpecialDays(start, end);
		model.addAttribute("holidays", holidays);

		// 8. 로그인 계정 정보
		AcntVO acntVO = ditAccountService.findById(acntId);
		model.addAttribute("acntVO", acntVO);

		// 이 컨트롤러는 "학생 대시보드" 전용이므로 role 고정
		final String role = "ROLE_STUDENT";
		final String profsrNo = null; // 학생 대시보드에서는 미사용

		// 학적 이행(학점/전공/교양/외국어) 집계
		AcademicProgressRawVO p = studentDashboardService.selectAcademicProgress(stdntNo);

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        stdntNo = auth.getName();

        model.addAllAttributes(graduService.getGraduMainData(stdntNo));
        model.addAttribute("stdntNo", stdntNo);
        
		// 총 이수학점
		model.addAttribute("totalCompletedCredits",  safeInt(p.getTotalCompletedCredits()));
		model.addAttribute("totalRequiredCredits",   safeInt(p.getTotalRequiredCredits()));
		model.addAttribute("totalCreditRate",
				calcRate(p.getTotalCompletedCredits(), p.getTotalRequiredCredits()));
		model.addAttribute("totalMet",
				isMet(p.getTotalCompletedCredits(), p.getTotalRequiredCredits()));

		// 전공필수
		model.addAttribute("majorCompletedCredits",  safeInt(p.getMajorCompletedCredits()));
		model.addAttribute("majorRequiredCredits",   safeInt(p.getMajorRequiredCredits()));
		model.addAttribute("majorRequiredRate",
				calcRate(p.getMajorCompletedCredits(), p.getMajorRequiredCredits()));
		model.addAttribute("majorMet",
				isMet(p.getMajorCompletedCredits(), p.getMajorRequiredCredits()));

		// 교양필수
		model.addAttribute("liberalCompletedCredits", safeInt(p.getLiberalCompletedCredits()));
		model.addAttribute("liberalRequiredCredits",  safeInt(p.getLiberalRequiredCredits()));
		model.addAttribute("liberalRequiredRate",
				calcRate(p.getLiberalCompletedCredits(), p.getLiberalRequiredCredits()));
		model.addAttribute("liberalMet",
				isMet(p.getLiberalCompletedCredits(), p.getLiberalRequiredCredits()));

		// 외국어
		model.addAttribute("foreignCompletedSubjects", safeInt(p.getForeignCompletedSubjects()));
		model.addAttribute("foreignRequiredSubjects",  safeInt(p.getForeignRequiredSubjects()));
		model.addAttribute("foreignRate",
				calcRate(p.getForeignCompletedSubjects(), p.getForeignRequiredSubjects()));
		model.addAttribute("foreignMet",
				isMet(p.getForeignCompletedSubjects(), p.getForeignRequiredSubjects()));

		// 9. 학사 일정 조회 (IndexScheduleEventService)
		Map<String, Object> param = new HashMap<>();
		param.put("role", role);         // 핵심 : ROLE_STUDENT 명시
		param.put("stdntNo", stdntNo);
		param.put("profsrNo", profsrNo);
		param.put("startDate", startDate);
		param.put("endDate", endDate);

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

		return "dashboard/student/dashboard";
	}

	// === 유틸 매서드 
	private int calcRate(int completed, int required) {
		if (required <= 0) return 0;
		int rate = (int) Math.round(completed * 100.0 / required);
		if (rate < 0)   return 0;
		if (rate > 100) return 100;
		return rate;
	}

	private int safeInt(Integer v) {
		return v == null ? 0 : v;
	}

	// “충족” 기준: completed >= required 인지 여부
	private boolean isMet(Integer completed, Integer required) {
		int c = safeInt(completed);
		int r = safeInt(required);
		if (r <= 0) return false;
		return c >= r;
	}
}