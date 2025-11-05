package kr.ac.collage_api.enrollment.service;

import java.util.List;

import kr.ac.collage_api.vo.SknrgsChangeReqstVO;
import kr.ac.collage_api.vo.StdntVO;

public interface EnrollmentService {

	//학생정보
	StdntVO getStdnt(String stdntNo);
	
	//학적변동내역
	List<SknrgsChangeReqstVO> getAllHistoryList(String stdntNo);

	//신청내역
	List<SknrgsChangeReqstVO> getHistoryList(String stdntNo);
	//반환 타입							메서드 이름		

	//제출
	void submitRequest(SknrgsChangeReqstVO sknrgsChangeReqstVO);

	
	//관리자 -------------------------------------------------------
	
	//학적변동 신청 목록 조회
	List<SknrgsChangeReqstVO> getAllRequests();

	//상세조회
	SknrgsChangeReqstVO getRequestDetail(int reqId);

	//학적상태 변경
	void updateRequestStatus(int reqId, SknrgsChangeReqstVO requestVO);




}
