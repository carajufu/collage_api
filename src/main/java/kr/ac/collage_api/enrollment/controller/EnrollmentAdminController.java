package kr.ac.collage_api.enrollment.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import kr.ac.collage_api.enrollment.service.EnrollmentService;
import kr.ac.collage_api.vo.SknrgsChangeReqstVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/admin/enrollment")
public class EnrollmentAdminController {
	//123
    @Autowired
    private EnrollmentService enrollmentService;

    //학적변동 신청 목록 조회
    @GetMapping("/requests")
    public ResponseEntity<List<SknrgsChangeReqstVO>> getAllRequests() {
        List<SknrgsChangeReqstVO> list = enrollmentService.getAllRequests();
        log.info("list : {}", list);
        return ResponseEntity.ok(list);
    }

    //상세조회
    @GetMapping("/requests/{reqId}")
    public ResponseEntity<SknrgsChangeReqstVO> getRequestDetail(@PathVariable("reqId") int reqId) {
        SknrgsChangeReqstVO detail = enrollmentService.getRequestDetail(reqId);
        if (detail == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(detail);
    }

	
    //학적상태 변경
    @PutMapping("/requests/{reqId}") public ResponseEntity<String>
    updateRequestStatus( @PathVariable("reqId") int reqId,
    					 @RequestBody SknrgsChangeReqstVO requestVO) { 
    	try { 
    		enrollmentService.updateRequestStatus(reqId, requestVO); 
    		
    		String newStatus = requestVO.getReqstSttus();
            log.info("학적변동 상태 변경: reqId={}, 상태={}", reqId, newStatus);
            return ResponseEntity.ok("상태가 '" + newStatus + "'으로 변경되었습니다.");
            
        } catch (Exception e) {
            log.error("학적변동 상태 변경 중 오류 발생: {}", e.getMessage());
            return ResponseEntity.internalServerError().body("처리 중 오류가 발생했습니다."); 
        }

    }
	  
}
