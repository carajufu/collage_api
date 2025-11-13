package kr.ac.collage_api.enrollment.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.SknrgsChangeHistVO;
import kr.ac.collage_api.vo.SknrgsChangeReqstVO;
import kr.ac.collage_api.vo.StdntVO;

@Mapper
public interface EnrollmentMapper {

	//학생정보
	StdntVO selectStdnt(String stdntNo);
	
	//학적변동내역
	List<SknrgsChangeReqstVO> selectAllHistoryList(String stdntNo);

	//신청내역
	List<SknrgsChangeReqstVO> selectHistoryList(String stdntNo);

	//제출
	void submitRequest(SknrgsChangeReqstVO sknrgsChangeReqstVO);

	//관리자------------------------------------------------------------
	
	//학적변동 신청 목록 조회
	List<SknrgsChangeReqstVO> getAllRequests();

	//상세조회
	SknrgsChangeReqstVO getRequestDetail(int reqId);

	//상태 업데이트
	void updateStatusOnly(Map<String, Object> params);

	//학적 상태 변경
	void changeStdntStatus(String stdntNo, String newStatus);

	//학적 이력 저장
	void insertHistory(SknrgsChangeHistVO histVO);

}