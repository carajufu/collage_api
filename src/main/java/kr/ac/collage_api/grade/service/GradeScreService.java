package kr.ac.collage_api.grade.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.grade.vo.GradeScreForm;
import kr.ac.collage_api.grade.vo.GradeScreVO;

@Service
public interface GradeScreService {

// ----------------------------- 교수용 -----------------------------
	
	//전체 개설교과목 불러오기
	List<GradeScreVO> getAllSbject(String profsrNo);

	List<GradeScreVO> getCourse(String profsrNo);
	
	List<GradeScreVO> getSbjectScr(String estbllctreCode);

	int profGradeSubmit(GradeScreForm gradeForm);

	int profGradeEdit(GradeScreForm gradeForm);

	List<GradeScreVO> searchStudent(String keyword, String estbllctreCode);

	void updateGrades(List<GradeScreVO> grades);

	void saveGrades(List<GradeScreVO> grades, String estbllctreCode);

// ----------------------------- 학생용 -----------------------------	
	
	//학기별 성적조회
	List<GradeScreVO> getAllSemstr(String stdntNo);
//	//과목별 성적조회
//	List<GradeVO> getAllScore(String stdntNo);

//	GradeVO getSbjectDetailScore(Map<String, Object> params);



}
