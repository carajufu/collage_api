package kr.ac.collage_api.lecture.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.lecture.vo.LectureEvlVO;

@Mapper
public interface LectureEvlMapper {

	List<LectureEvlVO> getAllCourse(String estbllctreCode);
	
	LectureEvlVO getEstblCourseById(String estbllctreCode);
	
	List<LectureEvlVO> getTimetableByEstblCode(String estbllctreCode);

	List<LectureEvlVO> getEvalItemsByEvlNo(int evlNo);

	List<LectureEvlVO> getEvalScoresByEvlNo(int evlNo);

	List<LectureEvlVO> getLectureEvalByEstblCode(String estbllctreCode);

	List<LectureEvlVO> getAll();

	List<LectureEvlVO> getEvlIem(Integer lctreEvlInnb);

	List<LectureEvlVO> getStdAll();

	List<LectureEvlVO> getLectureEvalByStdnt(String estbllctreCode);

	List<LectureEvlVO> getEvlIemList(String estbllctreCode);

	String getLctreCodeByEstbllctreCode(String estbllctreCode);

	LectureEvlVO getLectureByLctreCode(String lctreCode);
	
    Integer getEvlNoByEstbllctreCode(String estbllctreCode);

    // (참고) 학생 평가 저장은 점수 테이블이 맞습니다.
    void insertLectureEval(Map<String, Object> param);

	List<LectureEvlVO> getAllCourses(String estbllctreCode);
	
	
}
