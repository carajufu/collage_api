package kr.ac.collage_api.dashboard.controller;

import kr.ac.collage_api.dashboard.service.StudentDashboardService;
import kr.ac.collage_api.dashboard.vo.LectureVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.security.Principal;
import java.util.Calendar;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/dashboard")
public class StudentDashboardController {
    @Autowired
    StudentDashboardService studentDashboardService;

    Calendar cal = Calendar.getInstance();

    public String getYear() {
        String year = Integer.toString(cal.get(Calendar.YEAR));
        return year;
    }

    public String getCurrentPeriod() {
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        String currentPeriod = null;

        if(currentMonth >= 3 && currentMonth <= 7) {
            currentPeriod = "1학기";
        } else if(currentMonth >= 9 && currentMonth <= 12) {
            currentPeriod = "2학기";
        }

        return currentPeriod;
    }

    @GetMapping("/student")
    public String selectStudent(Model model,
                          Principal principal) {
        List<LectureVO> lectureVOList;

        lectureVOList = studentDashboardService.selectStudent(principal.getName(), getYear(), getCurrentPeriod());

        model.addAttribute("lectureList", lectureVOList);

        log.info("chkng student (model) > {}", model);

        return "dashboard/student/dashboard";
    }
}
