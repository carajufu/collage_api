package kr.ac.collage_api.index.controller;

import java.io.IOException;
import java.security.Principal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.ac.collage_api.account.service.UserAccountService;
import kr.ac.collage_api.common.util.BackgroundImageUtils;
import kr.ac.collage_api.index.service.IndexBbsService;
import kr.ac.collage_api.index.service.IndexScheduleEventService;
import kr.ac.collage_api.index.vo.IndexBbsVO;
import kr.ac.collage_api.schedule.service.SpcdeHolidayService;
import kr.ac.collage_api.schedule.vo.CalendarEventVO;
import kr.ac.collage_api.schedule.vo.ScheduleEventVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class IndexController {

    @Autowired
    ResourcePatternResolver resourceResolver;
    
    @Autowired
    UserAccountService ditAccountService;
    
    @Autowired
    IndexBbsService indexBbsService;
    
    @Autowired
    SpcdeHolidayService spcdeHolidayService;
    
    @Autowired
    IndexScheduleEventService indexScheduleEventService;

    // 모든 사용자의 첫 진입점
    @GetMapping({"/", "/index"})
    public String indexPage(@RequestParam(value = "year", required = false) Integer year,
                            @RequestParam(value = "month", required = false) Integer month,
                            Model model,
                            Principal principal,
                            HttpServletRequest request) throws IOException {

        // 배경 이미지
        List<String> backgroundImages =
                BackgroundImageUtils.resolveBackgroundImages(resourceResolver);
        model.addAttribute("background_images", backgroundImages);

        // 년월 + LocalDate 범위 계산
        LocalDate today = LocalDate.now();
        int currentYear  = (year  != null) ? year  : today.getYear();
        int currentMonth = (month != null) ? month : today.getMonthValue();

        YearMonth yearMonth = YearMonth.of(currentYear, currentMonth);
        LocalDate start = yearMonth.atDay(1);              // LocalDate
        LocalDate end   = yearMonth.atEndOfMonth();        // LocalDate

        DateTimeFormatter basic = DateTimeFormatter.BASIC_ISO_DATE; // yyyyMMdd
        String startDate = start.format(basic);
        String endDate   = end.format(basic);

        // 이전/다음 달 정보
        YearMonth prev = yearMonth.minusMonths(1);
        YearMonth next = yearMonth.plusMonths(1);

        model.addAttribute("currentYear", currentYear);
        model.addAttribute("currentMonth", currentMonth);
        model.addAttribute("prevYear", prev.getYear());
        model.addAttribute("prevMonth", prev.getMonthValue());
        model.addAttribute("nextYear", next.getYear());
        model.addAttribute("nextMonth", next.getMonthValue());

        // 공휴일 매핑 - LocalDate 사용
        // 시그니처 예시:
        // List<CalendarEventVO> getSpecialDays(LocalDate start, LocalDate end);
        List<CalendarEventVO> holidays = spcdeHolidayService.getSpecialDays(start, end);
        model.addAttribute("holidays", holidays);
        
        // 로그인 사용자 정보 기반 role/stdntNo/profsrNo 추출
        String role = null;
        String stdntNo = null;
        String profsrNo = null;
        AcntVO acntVO = null;

        if (principal != null) {
            String acntId = principal.getName();
            log.debug("acntId : {}", acntId);

            acntVO = ditAccountService.findById(acntId);
            model.addAttribute("acntVO", acntVO);

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
        } else {
            log.debug("principal is null (guest access)");
            // guest -> role/null, stdntNo/profsrNo 도 null 로 내려감
        }

        // index 전용 학사 일정 조회
        Map<String, Object> param = new HashMap<>();
        param.put("role", role);
        param.put("stdntNo", stdntNo);
        param.put("profsrNo", profsrNo);
        param.put("startDate", startDate); // YYYYMMDD
        param.put("endDate", endDate);     // YYYYMMDD

        List<ScheduleEventVO> schedule = indexScheduleEventService.selectIndexScheduleEvents(param);

        // index.jsp 학사일정 카드에서 사용할 리스트 이름을 JSP 와 맞춤
        // 예: <c:forEach var="sch" items="${academicSchedules}">
        model.addAttribute("academicSchedules", schedule);

        // index 페이지 주요 게시판 목록
        List<IndexBbsVO> notices_bbs = indexBbsService.selectMainBbsList(1); // 공지사항
        List<IndexBbsVO> events_bbs  = indexBbsService.selectMainBbsList(2); // 행사
        List<IndexBbsVO> papers_bbs  = indexBbsService.selectMainBbsList(3); // 학술/논문
        List<IndexBbsVO> news_bbs    = indexBbsService.selectMainBbsList(7); // 대내외 뉴스

        model.addAttribute("notices_bbs", notices_bbs);
        model.addAttribute("events_bbs",  events_bbs);
        model.addAttribute("papers_bbs",  papers_bbs);
        model.addAttribute("news_bbs",    news_bbs);

        // 공통 index 뷰 리턴 (guest / 로그인 모두 동일 뷰)
        return "index";
    }
}
