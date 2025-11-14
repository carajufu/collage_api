package kr.ac.collage_api.lecture.service;

import java.util.List;

import org.springframework.stereotype.Service;
import kr.ac.collage_api.lecture.vo.LectureEvlVO;

@Service
public interface LectureEvlService {

    // ------------------------------------------------------------
    //  (공통) ACNT_ID → ID 변환
    // ------------------------------------------------------------
    
    /** 교수용: ACNT_ID -> PROFSR_NO */
    String getProfsrNoByAcntId(String acntId);
    
    /** 학생용: ACNT_ID -> STDNT_NO */
    String getStdntNoByAcntId(String acntId);

    
    // ------------------------------------------------------------
    //  (교수) 강의 목록
    // ------------------------------------------------------------
    int getTotalCourseCount(String profsrNo);
    List<LectureEvlVO> getPagedCourses(String profsrNo, int start, int size);


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
    void insertLectureEval(String estbllctreCode, String stdntId,
                           List<Integer> evlScore, List<String> evlCn);
    
    // ------------------------------------------------------------
    //  (시스템) 평가 '질문지' 자동 생성용
    // ------------------------------------------------------------
    
    Integer createDefaultEvaluation(String estbllctreCode);
}
