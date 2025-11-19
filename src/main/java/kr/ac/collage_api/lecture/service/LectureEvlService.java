package kr.ac.collage_api.lecture.service;

import java.util.List;

import kr.ac.collage_api.lecture.vo.LectureEvlVO;

public interface LectureEvlService {

    String getProfsrNoByAcntId(String acntId);

    String getStdntNoByAcntId(String acntId);

    int getTotalCourseCount(String profsrNo);

    List<LectureEvlVO> getPagedCourses(String profsrNo, int start, int size);

    LectureEvlVO getEstblCourseById(String estbllctreCode);

    List<LectureEvlVO> getEvlIem(Integer evlNo);

    List<LectureEvlVO> getTimetableByEstblCode(String estbllctreCode);

    Integer getEvlNoByEstbllctreCode(String estbllctreCode);

    List<LectureEvlVO> getLectureEvalSummary(String estbllctreCode);

    List<Integer> getLectureEvalScoreCounts(String estbllctreCode);

    List<LectureEvlVO> getAllLecturesByStdntNo(String stdntNo);

    void insertLectureEval(String estbllctreCode, String stdntId,
                           List<Integer> evlScore, List<String> evlCn);

    Integer createDefaultEvaluation(String estbllctreCode);
}
