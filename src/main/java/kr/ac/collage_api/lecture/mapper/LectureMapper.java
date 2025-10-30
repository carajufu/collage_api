package kr.ac.collage_api.lecture.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.lecture.vo.LectureVO;

@Mapper
public interface LectureMapper {

	List<LectureVO> getAllCourse(String estbllctreCode);
	
	LectureVO getEstblCourseById(String estbllctreCode);
	
	List<LectureVO> getTimetableByEstblCode(String estbllctreCode);

	List<LectureVO> getEvalItemsByEvlNo(int evlNo);

	List<LectureVO> getEvalScoresByEvlNo(int evlNo);

	List<LectureVO> getLectureEvalByEstblCode(String estbllctreCode);

	List<LectureVO> getAll();

	List<LectureVO> getEvlIem(Integer lctreEvlInnb);

	List<LectureVO> getStdAll();

	List<LectureVO> getLectureEvalByStdnt(String estbllctreCode);

	List<LectureVO> getEvlIemList(String estbllctreCode);

	String getLctreCodeByEstbllctreCode(String estbllctreCode);

	LectureVO getLectureByLctreCode(String lctreCode);
	
    Integer getEvlNoByEstbllctreCode(String estbllctreCode);

    // (참고) 학생 평가 저장은 점수 테이블이 맞습니다.
    void insertLectureEval(Map<String, Object> param);
	
	
}
