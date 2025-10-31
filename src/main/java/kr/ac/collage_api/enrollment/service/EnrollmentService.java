package kr.ac.collage_api.enrollment.service;

import java.util.List;

import kr.ac.collage_api.vo.SknrgsChangeReqstVO;
import kr.ac.collage_api.vo.StdntVO;

public interface EnrollmentService {

	// 휴학신청
	public void submitRequest(SknrgsChangeReqstVO sknrgsChangeReqstVO);

	public List<SknrgsChangeReqstVO> getHistoryList(String stdntNo);

    StdntVO getStdnt(String stdntNo);
}
