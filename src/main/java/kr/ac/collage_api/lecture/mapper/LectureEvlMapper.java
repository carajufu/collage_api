package kr.ac.collage_api.lecture.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import kr.ac.collage_api.lecture.vo.LectureEvlVO;

@Mapper
public interface LectureEvlMapper {

    // ------------------------------------------------------------
    //  (공통) ACNT_ID → ID 변환
    // ------------------------------------------------------------
    String getProfsrNoByAcntId(String acntId);
    
    /**  학생용: ACNT_ID -> STDNT_NO */
    String getStdntNoByAcntId(String acntId);

    // ------------------------------------------------------------
    //  (교수) 강의 목록
    // ------------------------------------------------------------
    int getTotalCourseCount(String profsrNo);
    List<LectureEvlVO> getPagedCourses(Map<String, Object> param);


    // ------------------------------------------------------------
    //  (교수) 강의평가 요약
    // ------------------------------------------------------------
    List<LectureEvlVO> getLectureEvalSummary(String estbllctreCode);
    List<Integer> getLectureEvalScoreCounts(String estbllctreCode);


    // ------------------------------------------------------------
    //  (학생) 강의평가 목록 불러오기
    // ------------------------------------------------------------    
    LectureEvlVO getEstblCourseById(String estbllctreCode);
    
    List<LectureEvlVO> getTimetableByEstblCode(String estbllctreCode);
    
    Integer getEvlNoByEstbllctreCode(String estbllctreCode);
    // ------------------------------------------------------------
    //  (학생) 강의평가 제출
    // ------------------------------------------------------------
    
    List<LectureEvlVO> getAllLecturesByStdntNo(String stdntNo);

    void insertLectureEval(Map<String, Object> param);

    void insertLctreEvlMaster(Map<String, Object> param);
    
    void insertLctreEvlIem(Map<String, Object> param);
    
    int getNextEvlNo();
}
