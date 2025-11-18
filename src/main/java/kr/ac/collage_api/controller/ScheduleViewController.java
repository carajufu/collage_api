package kr.ac.collage_api.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/schedule")
public class ScheduleViewController {

    /**
     * 학사 일정 캘린더 화면
     * GET /schedule
     * -> /WEB-INF/views/schedule/calendar.jsp
     */
	@GetMapping("/calendar")
    public String scheduleCalendarView() {
        log.info("[ScheduleView] /schedule view requested");
        return "schedule/calendar";
    }

    /**
     * 수강 시간표 화면
     * GET /schedule/timetable
     * -> /WEB-INF/views/schedule/timetable.jsp
     */
    @GetMapping("/timetable")
    public String timetableView() {
        log.info("[ScheduleView] /schedule/timetable view requested");
        return "schedule/timetable";
    }
}
