package kr.ac.collage_api.enrollment.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.ac.collage_api.enrollment.service.EnrollmentService;
import kr.ac.collage_api.security.service.impl.CustomUser;
import kr.ac.collage_api.vo.SknrgsChangeReqstVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/enrollment")
public class EnrollmentController {
	
	@Autowired
	private EnrollmentService enrollmentService;

	//학적 상태 조회
    @GetMapping("/status")
    public String showRegisterPage(Model model, @AuthenticationPrincipal CustomUser customUser) {
    	
    	if (customUser == null) {
            return "redirect:/login";
        }
    
    	StdntVO stdntVO = customUser.getAcntVO().getStdntVO();
    	String stdntNo = stdntVO.getStdntNo();
    	log.info("로그인된 학생 학번 : {}", stdntNo);
    	
    	List<SknrgsChangeReqstVO> historyList = enrollmentService.getHistoryList(stdntNo);
    	
    	model.addAttribute("historyList", historyList);
    	model.addAttribute("stdntInfo", stdntVO); 
    	
    	LocalDate now = LocalDate.now();
    	int year = now.getYear();
		int month = now.getMonthValue();
		
		String currentSemester;
		if(month >= 3 && month <= 8) {
			currentSemester = year + "년 1학기";
		}else {
			currentSemester = year + "년 2학기";
		}
		
		model.addAttribute("currentSemester", currentSemester);
    	
        return "enrollment/enrollment_status";
	}
	
	@GetMapping("/change") 
	public String showApplyForm(Model model) {
		List<String> semesterList = new ArrayList<>();
		LocalDate now = LocalDate.now();
		int currentYear = now.getYear();
		int currentMonth = now.getMonthValue();
		
		if(currentMonth <= 6) {
			semesterList.add((currentYear) + "-1");
			semesterList.add((currentYear) + "-2");
		} else {
			semesterList.add((currentYear) + "-2");
            semesterList.add((currentYear + 1) + "-1");
		}
		model.addAttribute("semesters",semesterList);
		
		return "enrollment/enrollment_change";
	}

	
	//휴학/복학 신청 제출
	@PostMapping("/change")
	public String submitEnrollmentRequest(
            SknrgsChangeReqstVO sknrgsChangeReqstVO,
            @AuthenticationPrincipal CustomUser customUser,
            RedirectAttributes redirectAttributes) {
		    
        if (customUser == null) {
            return "redirect:/login";
        }

		StdntVO stdntVO = customUser.getAcntVO().getStdntVO();
		String stdntNo = stdntVO.getStdntNo();
		String currentStatus = stdntVO.getSknrgsSttus();
        String changeType = sknrgsChangeReqstVO.getChangeTy();

		log.info("신청 학생 학번: '{}', 현재 학적: '{}', 신청 종류: '{}'", stdntNo, currentStatus, changeType);
		    
        if ("휴학".equals(changeType) && !"재학".equals(currentStatus)) {
            redirectAttributes.addFlashAttribute("errorMessage", "재학 상태인 경우에만 휴학 신청이 가능합니다.");
            return "redirect:/enrollment/change";
        }
        if ("복학".equals(changeType) && !"휴학".equals(currentStatus)) {
            redirectAttributes.addFlashAttribute("errorMessage", "휴학 상태인 경우에만 복학 신청이 가능합니다.");
            return "redirect:/enrollment/change";
        }
		
		sknrgsChangeReqstVO.setStdntNo(stdntNo);
		    
		try {
		    enrollmentService.submitRequest(sknrgsChangeReqstVO);
		    log.info("학적 변동 신청 성공. 학번: {}", stdntNo);
		    redirectAttributes.addFlashAttribute("successMessage", "정상적으로 신청되었습니다.");
		    return "redirect:/enrollment/status"; 
		} catch (Exception e) {
		    log.error("학적 변동 신청 처리 중 오류 발생. 학번: {}", stdntNo, e);
            redirectAttributes.addFlashAttribute("errorMessage", "처리 중 오류가 발생했습니다. 다시 시도해주세요.");
		    return "redirect:/enrollment/change";
		}
	}
}