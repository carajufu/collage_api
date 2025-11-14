package kr.ac.collage_api.enrollment.controller;

import java.security.Principal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.common.attach.service.UploadController;
import kr.ac.collage_api.enrollment.service.EnrollmentService;
import kr.ac.collage_api.vo.SknrgsChangeReqstVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/enrollment")
public class EnrollmentController {
	
	@Autowired
	private EnrollmentService enrollmentService;
	
	@Autowired
	private UploadController uploadcontroller;

	//학적 상태 조회
    @GetMapping("/status")
    public String showRegisterPage(Model model, Principal principal) {
    	
    	if (principal == null) {
            return "redirect:/login";
        }
    
    	String stdntNo = principal.getName();
    	StdntVO stdntVO = enrollmentService.getStdnt(stdntNo); 
    	log.info("로그인된 학생 학번 : {}", stdntNo);
    	
    	List<SknrgsChangeReqstVO> historyList = enrollmentService.getHistoryList(stdntNo);
    	List<SknrgsChangeReqstVO> officialList = enrollmentService.getAllHistoryList(stdntNo);
    	
    	model.addAttribute("historyList", historyList);
    	model.addAttribute("officialList", officialList);
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
	
  //휴학,복학 신청 제출 폼
  	@GetMapping("/change") 
  	public String showApplyForm(Model model, Principal principal) {
  		
  		if(principal == null) {
  		 return "redirect:/login";
  		}
  		
  		String stdntNo = principal.getName();
  		StdntVO stdntVO = enrollmentService.getStdnt(stdntNo);
  		
  		model.addAttribute("stdntStatus", stdntVO.getSknrgsSttus());
  		
  		List<String> leaveSemesters = new ArrayList<>();
  		List<String> returnSemesters = new ArrayList<>();
  		
  		LocalDate now = LocalDate.now();
  		int currentYear = now.getYear();
  		int currentMonth = now.getMonthValue();
  		
  		//휴학 신청 학기
  		if(currentMonth <= 6) {
  			leaveSemesters.add((currentYear) + "-1");
  			leaveSemesters.add((currentYear) + "-2");
  		} else {
  			leaveSemesters.add((currentYear) + "-2");
  			leaveSemesters.add((currentYear + 1) + "-1");
  		}
  		
  		//복학 신청 학기
  		if(currentMonth <=6) {
  			returnSemesters.add(currentYear + "-2");
  			returnSemesters.add((currentYear + 1) + "-1");
  		}else {
  			returnSemesters.add((currentYear + 1) + "-1");
  	        returnSemesters.add((currentYear + 1) + "-2");
  		}
  		
  		model.addAttribute("leaveSemesters",leaveSemesters);
  		model.addAttribute("returnSemesters",returnSemesters);
  		
  		return "enrollment/enrollment_change";
  	}

	
	//휴학,복학 신청 제출
		@PostMapping("/change")
		@ResponseBody
		public ResponseEntity<String> submitEnrollmentRequest(
	            SknrgsChangeReqstVO sknrgsChangeReqstVO,
	            MultipartFile[] uploadFile,
				Principal principal) {
			    
	        if (principal == null) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인이 필요합니다.");
	        }

	        String stdntNo = principal.getName();
	        StdntVO stdntVO = enrollmentService.getStdnt(stdntNo); 
			String currentStatus = stdntVO.getSknrgsSttus();
	        String changeType = sknrgsChangeReqstVO.getChangeTy();

			log.info("신청 학생 학번: '{}', 현재 학적: '{}', 신청 종류: '{}'", stdntNo, currentStatus, changeType);
			    
	        if ("휴학".equals(changeType) && !"재학".equals(currentStatus)) {
	            return ResponseEntity.badRequest().body("재학 상태인 경우에만 휴학 신청이 가능합니다.");
	        }
	        if ("복학".equals(changeType) && !"휴학".equals(currentStatus)) {
	            return ResponseEntity.badRequest().body("휴학 상태인 경우에만 복학 신청이 가능합니다.");
	        }
			
			sknrgsChangeReqstVO.setStdntNo(stdntNo);
			
			try {
	            if (uploadFile != null && uploadFile[0].getOriginalFilename().length() > 0) {
	                log.info("파일 업로드");
	                Long fileGroupNo = uploadcontroller.fileUpload(uploadFile);
	                
	                sknrgsChangeReqstVO.setFileGroupNo(fileGroupNo);
	                log.info("파일 업로드 완료. fileGroupNo: {}", fileGroupNo);
	            } else {
	                log.info("첨부파일 없음");
	            }
	            
			    enrollmentService.submitRequest(sknrgsChangeReqstVO);
			    
	            log.info("학적 변동 신청 성공. 학번: {}", stdntNo);
			    return ResponseEntity.ok("정상적으로 신청되었습니다.");
			} catch (IllegalStateException e) {
				log.info("이미 처리중인 학적. 학번: {}", stdntNo);
				return ResponseEntity.badRequest().body("처리 중인 신청 내역이 있습니다.");

			} catch (Exception e) {
			    log.error("학적 변동 신청 처리 중 오류 발생. 학번: {}", stdntNo, e);
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("처리 중 오류가 발생했습니다. 관리자에게 문의해주세요.");
			}
		}
	}