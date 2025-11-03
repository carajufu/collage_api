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
    //  (공통) 상세 조회 + 평가 정보 조회
    // ------------------------------------------------------------
    LectureEvlVO getEstblCourseById(String estbllctreCode);
    List<LectureEvlVO> getEvlIem(Integer evlNo);
    List<LectureEvlVO> getTimetableByEstblCode(String estbllctreCode);
    Integer getEvlNoByEstbllctreCode(String estbllctreCode);

    // ------------------------------------------------------------
    //  (교수) 강의평가 요약
    // ------------------------------------------------------------
    List<LectureEvlVO> getLectureEvalSummary(String estbllctreCode);
    List<Integer> getLectureEvalScoreCounts(String estbllctreCode);


    // ------------------------------------------------------------
    //  (학생) 강의평가 목록 및 제출
    // ------------------------------------------------------------
    
    List<LectureEvlVO> getAllLecturesByStdntNo(String stdntNo);

    /** 학생이 제출한 강의평가 저장 */
    void insertLectureEval(Map<String, Object> param);

    /**
     * 1. LCTRE_EVL (마스터) INSERT
     * @param param (evlNo, estbllctreCode)
     */
    void insertLctreEvlMaster(Map<String, Object> param);
    
    /**
     * 2. LCTRE_EVL_IEM (질문 항목) INSERT
     * @param param (evlNo, evlCn)
     */
    void insertLctreEvlIem(Map<String, Object> param);
    
    /**
     * 3. 다음 EVL_NO 시퀀스 값(MAX+1) 가져오기
     */
    int getNextEvlNo();
}
