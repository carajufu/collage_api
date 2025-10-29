package kr.ac.collage_api.enrollment.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.SknrgsChangeReqstVO;

@Mapper // 이 인터페이스가 MyBatis의 매퍼임을 나타냅니다.
public interface EnrollmentMapper {

    /**
     * 휴학 신청 정보를 데이터베이스에 삽입(INSERT)합니다.
     * @param leaveRequestVO 저장할 휴학 신청 정보
     * @return int 삽입된 행의 수 (보통 1이 반환됩니다)
     */
    int insertEnrollmentRequest(SknrgsChangeReqstVO sknrgsChangeReqstVO);

	List<SknrgsChangeReqstVO> selectHistoryList(String stdntNo);

	List<SknrgsChangeReqstVO> getHistoryList(String stdntNo);


    
}