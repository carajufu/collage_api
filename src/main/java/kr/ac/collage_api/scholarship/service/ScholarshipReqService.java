package kr.ac.collage_api.scholarship.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.vo.ScholarshipReqVO;

public interface ScholarshipReqService {

	// 신규 등록
	int insertScholarship(ScholarshipReqVO vo);

	// 장학금 신청 리스트 (페이징 포함)
	List<ScholarshipReqVO> selectScholarshipList(Map<String, Object> map);

	// 전체 개수 (페이징용)
	int selectScholarshipTotal(Map<String, Object> map);

	// 상태 변경
	int updateStatus(Map<String, Object> map);

	// 지급 처리
	int updatePayInfo(Map<String, Object> map);

	// 단건 조회
	ScholarshipReqVO selectOne(int schlReqNo);

	// 수정하기
	int updateScholarship(ScholarshipReqVO vo);

	// 삭제
	int deleteScholarship(int schlReqNo);

	// 대시보드 통계
	List<Map<String, Object>> getTypeStats();

	List<Map<String, Object>> getStatusStats();

	List<Map<String, Object>> getMonthlyPayStats();
}
