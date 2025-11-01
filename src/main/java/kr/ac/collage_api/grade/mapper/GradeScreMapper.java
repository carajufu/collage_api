package kr.ac.collage_api.grade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.grade.vo.GradeScreForm;
import kr.ac.collage_api.grade.vo.GradeScreVO;

@Mapper
public interface GradeScreMapper {
	
//---------------------------- 교수용 ---------------------------- 

	List<GradeScreVO> getAllSbject(String profsrNo);

	List<GradeScreVO> getCourse(String profsrNo);
	
	List<GradeScreVO> getSbjectScr(String estbllctreCode);

	int profGradeSubmit(GradeScreForm gradeForm);

	int profGradeEdit(GradeScreForm gradeForm);
	
	List<GradeScreVO> searchStudent(String keyword, String estbllctreCode);

	void updateGrades(@Param("list") List<GradeScreVO> grades);
	
	void saveGrades(@Param("list") List<GradeScreVO> grades, @Param("estbllctreCode") String estbllctreCode);

//---------------------------- 학생용 ---------------------------- 
//	List<GradeVO> getAllScore(String stdntNo);

	GradeScreVO getSbjectDetailScore(Map<String, Object> params);

	List<GradeScreVO> getAllSemstr(String stdntNo);

}
