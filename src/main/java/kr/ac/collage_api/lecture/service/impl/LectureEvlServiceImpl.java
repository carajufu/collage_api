package kr.ac.collage_api.lecture.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.lecture.mapper.LectureEvlMapper;
import kr.ac.collage_api.lecture.service.LectureEvlService;
import kr.ac.collage_api.lecture.vo.LectureEvlVO;


@Service
public class LectureEvlServiceImpl implements LectureEvlService {

	@Autowired
	LectureEvlMapper lectureMapper;

	@Override
	public List<LectureEvlVO> getAllCourses(String estbllctreCode) {
		return lectureMapper.getAllCourses(estbllctreCode);
	}

	@Override
	public LectureEvlVO getEstblCourseById(String estbllctreCode) {
		return lectureMapper.getEstblCourseById(estbllctreCode);
	}

	@Override
	public List<LectureEvlVO> getLectureEvalByEstblCode(String estbllctreCode) {
		return lectureMapper.getLectureEvalByEstblCode(estbllctreCode);
	}
	
	@Override
	public List<LectureEvlVO> getEvalItemsByEvlNo(int evlNo) {
		return lectureMapper.getEvalItemsByEvlNo(evlNo);
	}

	@Override
	public List<LectureEvlVO> getEvalScoresByEvlNo(int evlNo) {
		return lectureMapper.getEvalScoresByEvlNo(evlNo);
	}

	@Override
	public List<LectureEvlVO> getTimetableByEstblCode(String estbllctreCode) {
		return lectureMapper.getTimetableByEstblCode(estbllctreCode);
	}

	@Override
	public List<LectureEvlVO> getAll() {
		return lectureMapper.getAll();
	}

	@Override
	public List<LectureEvlVO> getEvlIem(Integer lctreEvlInnb) {
		return lectureMapper.getEvlIem(lctreEvlInnb);
	}

	@Override
	public List<LectureEvlVO> getStdAll() {
		return lectureMapper.getStdAll();
	}

	@Override
	public List<LectureEvlVO> getEvlIemList(String estbllctreCode) {
		return lectureMapper.getEvlIemList(estbllctreCode);
	}

	@Override
	public LectureEvlVO getLectureByLctreCode(String lctreCode) {
		return lectureMapper.getLectureByLctreCode(lctreCode);
	}

	@Override
	public void insertLectureEval(String estbllctreCode, String stdntId,
	                              List<Integer> evlScore, List<String> evlCn) {

	    int evlNo = lectureMapper.getEvlNoByEstbllctreCode(estbllctreCode);

	    for (int i = 0; i < evlScore.size(); i++) {
	        Map<String, Object> param = new HashMap<>();
	        param.put("lctreEvlInnb", evlNo);
	        param.put("evlCn", evlCn.get(i));
	        param.put("evlScore", evlScore.get(i));

	        lectureMapper.insertLectureEval(param);
	    }
	}

	@Override
	public String getLctreCodeByEstbllctreCode(String estbllctreCode) {
		return lectureMapper.getLctreCodeByEstbllctreCode(estbllctreCode);
	}

	@Override
	public Integer getEvlNoByEstbllctreCode(String estbllctreCode) {
		return lectureMapper.getEvlNoByEstbllctreCode(estbllctreCode);
	}


	
}
