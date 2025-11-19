package kr.ac.collage_api.grade.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.grade.vo.GradeForm;
import kr.ac.collage_api.grade.vo.GradeVO;

@Service
public interface GradeService {

// ----------------------------- 교수용 -----------------------------
	
	//전체 개설교과목 불러오기
	List<GradeVO> getAllSbject(String profsrNo);

	List<GradeVO> getCourse(String profsrNo);
	
	List<GradeVO> getSbjectScr(String estbllctreCode);

	int profGradeSubmit(GradeForm gradeForm);

	int profGradeEdit(GradeForm gradeForm);

	List<GradeVO> searchStudent(String keyword, String estbllctreCode);

	void updateGrades(List<GradeVO> grades);

	void saveGrades(List<GradeVO> grades, String estbllctreCode);

// ----------------------------- 학생용 -----------------------------	
	
	List<GradeVO> getAllScore(String stdntNo);

	GradeVO getSbjectDetailScore(Map<String, Object> params);


}
