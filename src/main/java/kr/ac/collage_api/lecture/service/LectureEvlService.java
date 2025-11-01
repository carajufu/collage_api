package kr.ac.collage_api.lecture.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.lecture.vo.LectureEvlVO;

@Service
public interface LectureEvlService {

	List<LectureEvlVO> getAllCourses(String estbllctreCode);

	LectureEvlVO getEstblCourseById(String estbllctreCode);

	List<LectureEvlVO> getLectureEvalByEstblCode(String estbllctreCode);

	List<LectureEvlVO> getEvalItemsByEvlNo(int evlNo);

	List<LectureEvlVO> getEvalScoresByEvlNo(int evlNo);

	List<LectureEvlVO> getTimetableByEstblCode(String estbllctreCode);

	List<LectureEvlVO> getAll();

	List<LectureEvlVO> getEvlIem(Integer lctreEvlInnb);

	List<LectureEvlVO> getStdAll();

	List<LectureEvlVO> getEvlIemList(String estbllctreCode);

	String getLctreCodeByEstbllctreCode(String estbllctreCode);

	LectureEvlVO getLectureByLctreCode(String lctreCode);

	void insertLectureEval(String estbllctreCode, String stdntId, List<Integer> evlScore, List<String> evlCn);

	Integer getEvlNoByEstbllctreCode(String estbllctreCode);

	
}
