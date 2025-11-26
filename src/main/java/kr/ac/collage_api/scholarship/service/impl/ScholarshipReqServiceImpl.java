package kr.ac.collage_api.scholarship.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.scholarship.mapper.ScholarshipReqMapper;
import kr.ac.collage_api.scholarship.service.ScholarshipReqService;
import kr.ac.collage_api.vo.ScholarshipReqVO;

@Service
public class ScholarshipReqServiceImpl implements ScholarshipReqService {

	@Autowired
	private ScholarshipReqMapper mapper;

	@Override
	public int insertScholarship(ScholarshipReqVO vo) {
		return mapper.insertScholarship(vo);
	}

	@Override
	public List<ScholarshipReqVO> selectScholarshipList(Map<String, Object> map) {
		return mapper.selectScholarshipList(map);
	}

	@Override
	public int selectScholarshipTotal(Map<String, Object> map) {
		return mapper.selectScholarshipTotal(map);
	}

	@Override
	public int updateStatus(Map<String, Object> map) {
		return mapper.updateStatus(map);
	}

	@Override
	public int updatePayInfo(Map<String, Object> map) {
		return mapper.updatePayInfo(map);
	}

	@Override
	public ScholarshipReqVO selectOne(int schlReqNo) {
		return mapper.selectOne(schlReqNo);
	}

	@Override
	public int updateScholarship(ScholarshipReqVO vo) {
		return mapper.updateScholarship(vo);
	}

	@Override
	public int deleteScholarship(int schlReqNo) {
		return mapper.deleteScholarship(schlReqNo);
	}

	@Override
	public List<Map<String, Object>> getTypeStats() {
		return mapper.getTypeStats();
	}

	@Override
	public List<Map<String, Object>> getStatusStats() {
		return mapper.getStatusStats();
	}

	@Override
	public List<Map<String, Object>> getMonthlyPayStats() {
		return mapper.getMonthlyPayStats();
	}
}
