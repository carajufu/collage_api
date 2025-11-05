package kr.ac.collage_api.enrollment.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.ac.collage_api.account.mapper.AccountMapper;
import kr.ac.collage_api.common.config.BeanController;
import kr.ac.collage_api.enrollment.service.EnrollmentService;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.SknrgsChangeReqstVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
//@CrossOrigin(origins = "*")
@RequestMapping("/admin/enrollment")
public class EnrollmentAdminController {

    @Autowired
    private EnrollmentService enrollmentService;
    
    @Autowired
    private BeanController beanController;
    
    @Autowired
    private AccountMapper accountMapper;

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
    	
    	String newStatus = requestVO.getReqstSttus();
        log.info("===== React에서 받은 데이터 확인 =====");
        log.info("reqId: {}", reqId);
        log.info("React에서 받은 reqstSttus: {}", newStatus);
        log.info("React에서 받은 returnResn: {}", requestVO.getReturnResn());
        log.info("====================================");
    	
    	try { 
    		enrollmentService.updateRequestStatus(reqId, requestVO); 
    		
    		newStatus = requestVO.getReqstSttus();
            log.info("학적변동 상태 변경: reqId={}, 상태={}", reqId, newStatus);
            return ResponseEntity.ok("상태가 '" + newStatus + "'으로 변경되었습니다.");
            
        } catch (Exception e) {
            log.error("학적변동 상태 변경 중 오류 발생: {}", e.getMessage());
            return ResponseEntity.internalServerError().body("처리 중 오류가 발생했습니다."); 
        }

    }
    
    //파일
    @GetMapping("/download/file/{fileGroupNo}")
    public ResponseEntity<Resource> downloadFile(@PathVariable long fileGroupNo) {
        
        //파일 정보 조회
        FileDetailVO fileDetail = accountMapper.getFileDetailByGroupNo(fileGroupNo);

        if (fileDetail == null) {
            log.warn("파일을 찾을 수 없습니다. FileGroupNo: {}", fileGroupNo);
            return ResponseEntity.notFound().build();
        }

        try {
        	//파일 경로 설정
            String fullPath = beanController.getUploadFolder() + fileDetail.getFileStreplace();
            Path filePath = Paths.get(fullPath);
            Resource resource = new UrlResource(filePath.toUri());

            if (!resource.exists() || !resource.isReadable()) {
                log.error("파일을 읽을 수 없습니다. Path: {}", fullPath);
                return ResponseEntity.notFound().build();
            }

            //다운로드
            String originalFilename = URLEncoder.encode(fileDetail.getFileNm(), "UTF-8").replaceAll("\\+", "%20");

            HttpHeaders headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + originalFilename + "\"");
            headers.add(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM_VALUE);

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(resource);

        } catch (IOException e) {
            log.error("파일 다운로드 중 오류 발생", e);
            return ResponseEntity.internalServerError().build();
        }
    }
	  
}
