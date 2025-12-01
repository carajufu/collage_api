package kr.ac.collage_api.dashboard.controller;

import kr.ac.collage_api.common.util.CurrentSemstr;
import kr.ac.collage_api.dashboard.service.StudentDashboardService;
import kr.ac.collage_api.dashboard.vo.DashLectureVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
    
import java.security.Principal;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/dashboard")
public class StudentDashboardController {
	
    @Autowired
    StudentDashboardService studentDashboardService;

    @Autowired
    CurrentSemstr currentSemester;

    @GetMapping("/student")
    public String selectStudent(Model model,
                          Principal principal) {
        List<DashLectureVO> dashLectureVOList;

        dashLectureVOList = studentDashboardService.selectStudent(principal.getName(),
                currentSemester.getYear(),
                currentSemester.getCurrentPeriod());

        model.addAttribute("lectureList", dashLectureVOList);
        model.addAttribute("requirements", studentDashboardService.getGraduationSnapshot(principal.getName()));

        log.info("chkng student (model) > {}", model);

        return "dashboard/student/dashboard";
    }
}
