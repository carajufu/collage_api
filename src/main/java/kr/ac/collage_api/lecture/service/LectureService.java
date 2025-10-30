package kr.ac.collage_api.lecture.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.lecture.vo.LectureVO;

@Service
public interface LectureService {

	List<LectureVO> getAllCourses(String estbllctreCode);

	LectureVO getEstblCourseById(String estbllctreCode);

	List<LectureVO> getLectureEvalByEstblCode(String estbllctreCode);

	List<LectureVO> getEvalItemsByEvlNo(int evlNo);

	List<LectureVO> getEvalScoresByEvlNo(int evlNo);

	List<LectureVO> getTimetableByEstblCode(String estbllctreCode);

	List<LectureVO> getAll();

	List<LectureVO> getEvlIem(Integer lctreEvlInnb);

	List<LectureVO> getStdAll();

	List<LectureVO> getEvlIemList(String estbllctreCode);

	String getLctreCodeByEstbllctreCode(String estbllctreCode);

	LectureVO getLectureByLctreCode(String lctreCode);

	void insertLectureEval(String estbllctreCode, String stdntId, List<Integer> evlScore, List<String> evlCn);

	Integer getEvlNoByEstbllctreCode(String estbllctreCode);

	
}
