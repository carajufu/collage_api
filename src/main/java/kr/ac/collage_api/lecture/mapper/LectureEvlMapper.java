package kr.ac.collage_api.lecture.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import kr.ac.collage_api.lecture.vo.LectureEvlVO;

@Mapper
public interface LectureEvlMapper {

    String getProfsrNoByAcntId(String acntId);

    String getStdntNoByAcntId(String acntId);

    int getTotalCourseCount(String profsrNo);

    List<LectureEvlVO> getPagedCourses(Map<String, Object> param);

    LectureEvlVO getEstblCourseById(String estbllctreCode);

    List<LectureEvlVO> getEvlIem(Integer evlNo);

    List<LectureEvlVO> getTimetableByEstblCode(String estbllctreCode);

    Integer getEvlNoByEstbllctreCode(String estbllctreCode);

    List<LectureEvlVO> getLectureEvalSummary(String estbllctreCode);

    List<Integer> getLectureEvalScoreCounts(String estbllctreCode);

    List<LectureEvlVO> getAllLecturesByStdntNo(String stdntNo);

    void insertLectureEval(Map<String, Object> param);

    void insertLctreEvlMaster(Map<String, Object> param);

    void insertLctreEvlIem(Map<String, Object> param);

    int getNextEvlNo();
}
