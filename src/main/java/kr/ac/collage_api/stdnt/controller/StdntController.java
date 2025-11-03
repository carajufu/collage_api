package kr.ac.collage_api.stdnt.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.ac.collage_api.enrollment.service.EnrollmentService;
import kr.ac.collage_api.stdnt.service.StdntService;
import kr.ac.collage_api.vo.SknrgsChangeReqstVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class StdntController {

    @Autowired
    private StdntService stdntService;

    @Autowired
    private EnrollmentService enrollmentService;

    // 학적 상태 조회
    @GetMapping("/status")
    public String showStdntStatusPage(Model model, Principal principal) {
        if (principal == null) {
            return "redirect:/login";
        }
        
        String stdntNo = principal.getName();
        
        log.info("학생 아이디: ", stdntNo);

        StdntVO stdntInfo = stdntService.getStdntInfo(stdntNo);

        List<SknrgsChangeReqstVO> historyList = enrollmentService.getHistoryList(stdntNo);

        model.addAttribute("stdntInfo", stdntInfo);
        model.addAttribute("historyList", historyList);

        return "enrollment/enrollment_status";
    }
}
