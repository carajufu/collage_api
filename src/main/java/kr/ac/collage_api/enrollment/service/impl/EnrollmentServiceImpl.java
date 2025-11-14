package kr.ac.collage_api.enrollment.service.impl;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.enrollment.mapper.EnrollmentMapper;
import kr.ac.collage_api.enrollment.service.EnrollmentService;
import kr.ac.collage_api.vo.SknrgsChangeHistVO;
import kr.ac.collage_api.vo.SknrgsChangeReqstVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EnrollmentServiceImpl implements EnrollmentService {
	
	@Autowired
	private EnrollmentMapper enrollmentMapper;
	
	//학생정보
	@Override
	public StdntVO getStdnt(String stdntNo) {
		log.info("Service: getStdnt 호출. 학번: {}", stdntNo);
		
		StdntVO stdntVO = enrollmentMapper.selectStdnt(stdntNo);
		
		return stdntVO;
	}

	//학적변동내역
	@Override
	public List<SknrgsChangeReqstVO> getAllHistoryList(String stdntNo) {
		return enrollmentMapper.selectAllHistoryList(stdntNo);
	}
	
	//신청내역
	@Override
	public List<SknrgsChangeReqstVO> getHistoryList(String stdntNo) {
		return enrollmentMapper.selectHistoryList(stdntNo);
	}

	//제출
	@Override
	public void submitRequest(SknrgsChangeReqstVO sknrgsChangeReqstVO) {

		//처리중인 신청내역 확인
		int activeRequestCount = enrollmentMapper.activeRequestByStdntNo(sknrgsChangeReqstVO.getStdntNo());

		if( activeRequestCount > 0) {
			throw new IllegalStateException("처리 중인 신청 내역이 있습니다.");
		}

		enrollmentMapper.submitRequest(sknrgsChangeReqstVO);
	}

	//관리자------------------------------------------------------------------

	//학적변동 신청 목록 조회
	@Override
	public List<SknrgsChangeReqstVO> getAllRequests() {
		return enrollmentMapper.getAllRequests();
	}

	//상세조회
	@Override
	public SknrgsChangeReqstVO getRequestDetail(int reqId) {
		return enrollmentMapper.getRequestDetail(reqId);
	}

	//학적상태 변경
	@Override
	@Transactional
	public void updateRequestStatus(int reqId, SknrgsChangeReqstVO clientVO) {
		
		SknrgsChangeReqstVO originalVO = enrollmentMapper.getRequestDetail(reqId);
		
		if(originalVO == null) {
			throw new RuntimeException("존재하지 않는 신청입니다.");
		}

		Map<String, Object> params = new HashMap<>();
		params.put("reqId", reqId);
		params.put("reqstSttus", clientVO.getReqstSttus());
		params.put("returnResn", clientVO.getReturnResn());
		
		if("승인".equals(clientVO.getReqstSttus())) {
			params.put("confmComptDt", LocalDateTime.now());
		}else {
			params.put("confmComptDt", null);
		}
		
		params.put("lastUpdtTm", LocalDateTime.now());
		
		//상태 업데이트
		enrollmentMapper.updateStatusOnly(params);
		
		//승인일 경우에만 학적 상태 변경
		if("승인".equals(clientVO.getReqstSttus())) {
			
			String newStatus = originalVO.getChangeTy();
			enrollmentMapper.changeStdntStatus(originalVO.getStdntNo(), newStatus);
			
			//학적 이력 저장
			SknrgsChangeHistVO histVO = new SknrgsChangeHistVO();
			histVO.setSknrgsChangeInnb(reqId);
			histVO.setSknrgs(newStatus);
	        histVO.setChangeResn(originalVO.getChangeTy());

	        enrollmentMapper.insertHistory(histVO);
	    }
	}
	


}
