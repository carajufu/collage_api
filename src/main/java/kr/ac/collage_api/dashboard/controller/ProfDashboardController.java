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

	@GetMapping("/prof")
	public String professorDashboard(@RequestParam(value = "year", required = false) Integer year,
			@RequestParam(value = "month", required = false) Integer month,
			Model model,
			Principal principal,
			HttpServletRequest request) {

		// 0. 인증 체크
		if (principal == null) {
			log.warn("[ProfessorDashboardController] principal is null (unauthenticated access)");
			return "redirect:/login";
		}

		final String acntId = principal.getName();
		log.info("[ProfessorDashboardController] request acntId={}", acntId);

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

		// 2. 교수번호 매핑
		String profsrNo = ditAccountMapper.findProfsrNoByAcntId(acntId);
		if (profsrNo == null || profsrNo.isBlank()) {
			log.warn("[ProfessorDashboardController] ROLE_PROF but no PROFSR_NO, acntId={}", acntId);
			return "redirect:/login";
		}

		/*
		 * // 3. 현재 학기 기준 담당 강의 리스트 // StudentDashboardService 에 교수용 조회 메서드가 없으면 추가 필요
		 * List<DashLectureVO> lectureList =
		 * studentDashboardService.selectProfessorLectures( profsrNo,
		 * currentSemester.getYear(), currentSemester.getCurrentPeriod() );
		 * model.addAttribute("lectureList", lectureList);
		 */
		// 4. 교수 시간표 (월 범위)
		List<TimetableEventVO> timetable =
				timetableService.getProfessorTimetable(profsrNo, startDate, endDate);
		log.info("[ProfessorDashboardController] timetable size={}", timetable == null ? 0 : timetable.size());

		// 5. 메인 게시판 목록 (학생/교수 공통 탭 재사용)
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

		// 이 컨트롤러는 "교수 대시보드" 전용이므로 role 고정
		final String role = "ROLE_PROF";
		final String stdntNo = null; // 교수 대시보드에서는 미사용

		// 9. 학사 일정 조회 (IndexScheduleEventService)
		Map<String, Object> param = new HashMap<>();
		param.put("role", role);         // 핵심 : ROLE_PROF 명시
		param.put("stdntNo", stdntNo);
		param.put("profsrNo", profsrNo);
		param.put("startDate", startDate);
		param.put("endDate", endDate);

		List<ScheduleEventVO> academicSchedules =
				indexScheduleEventService.selectIndexScheduleEvents(param);
		model.addAttribute("academicSchedules", academicSchedules);

		log.info(
				"[ProfessorDashboardController] model ready. acntId={}, role={}, lectures={}, schedules={}, holidays={}",
				acntId,
				role,
				academicSchedules == null ? 0 : academicSchedules.size(),
						holidays == null ? 0 : holidays.size()
				);

		// /WEB-INF/views/dashboard/prof/dashboard.jsp
		return "dashboard/prof/dashboard";
	}
}
