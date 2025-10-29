package kr.ac.collage_api.enrollment.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.enrollment.mapper.EnrollmentMapper;
import kr.ac.collage_api.enrollment.service.EnrollmentService;
import kr.ac.collage_api.stdnt.service.StdntService;
import kr.ac.collage_api.vo.SknrgsChangeReqstVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EnrollmentServiceImpl implements EnrollmentService {
	
	@Autowired
	private EnrollmentMapper enrollmentMapper;
	
	@Autowired
	private StdntService stdntService;

	@Transactional
	@Override
	public void submitRequest(SknrgsChangeReqstVO sknrgsChangeReqstVO) {
		
		sknrgsChangeReqstVO.setReqstSttus("신청");
		
		enrollmentMapper.insertEnrollmentRequest(sknrgsChangeReqstVO);
		
		log.info("{} 학생의 휴학 신청이 처리되었습니다.", sknrgsChangeReqstVO.getStdntNo());
	}

	@Override
	public List<SknrgsChangeReqstVO> getHistoryList(String stdntNo) {
		return enrollmentMapper.getHistoryList(stdntNo);
	}



}
