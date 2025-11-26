package kr.ac.collage_api.scholarship.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.ScholarshipReqVO;

@Mapper
public interface ScholarshipReqMapper {

	int insertScholarship(ScholarshipReqVO vo);

	List<ScholarshipReqVO> selectScholarshipList(Map<String, Object> map);

	int selectScholarshipTotal(Map<String, Object> map);

	int updateStatus(Map<String, Object> map);

	int updatePayInfo(Map<String, Object> map);

	ScholarshipReqVO selectOne(int schlReqNo);

	int updateScholarship(ScholarshipReqVO vo);

	int deleteScholarship(int schlReqNo);

	List<Map<String, Object>> getTypeStats();

	List<Map<String, Object>> getStatusStats();

	List<Map<String, Object>> getMonthlyPayStats();

}
