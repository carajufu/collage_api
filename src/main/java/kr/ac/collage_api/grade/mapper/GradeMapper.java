package kr.ac.collage_api.grade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.grade.vo.GradeForm;
import kr.ac.collage_api.grade.vo.GradeVO;

@Mapper
public interface GradeMapper {
	
//---------------------------- 교수용 ---------------------------- 

	List<GradeVO> getAllSbject(String profsrNo);

	List<GradeVO> getCourse(String profsrNo);
	
	List<GradeVO> getSbjectScr(String estbllctreCode);

	int profGradeSubmit(GradeForm gradeForm);

	int profGradeEdit(GradeForm gradeForm);
	
	List<GradeVO> searchStudent(String keyword, String estbllctreCode);

	void updateGrades(@Param("list") List<GradeVO> grades);
	
	void saveGrades(@Param("list") List<GradeVO> grades, @Param("estbllctreCode") String estbllctreCode);

//---------------------------- 학생용 ---------------------------- 
	List<GradeVO> getAllScore(String stdntNo);

	GradeVO getSbjectDetailScore(Map<String, Object> params);

}
