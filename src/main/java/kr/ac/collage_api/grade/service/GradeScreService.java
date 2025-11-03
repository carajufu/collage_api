package kr.ac.collage_api.grade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.grade.vo.GradeScreVO;

/**
 * [수정 사항]
 * - 학생 성적 조회 기능(Stdnt_GradeScreController)에 필요한
 * getStudentSemstrList, getStudentSemstrDetail 메서드 2개를 추가했습니다.
 */
@Service
public interface GradeScreService {

    // ---------------------- (기존) 교수용 메서드 ----------------------
    String getProfsrNoByAcntId(String acntId);
    List<GradeScreVO> getAllSbject(String profsrNo);
    List<GradeScreVO> getSbjectScr(String estbllctreCode);
    void saveGrades(List<GradeScreVO> grades, String estbllctreCode);
    List<GradeScreVO> searchStudent(String keyword, String estbllctreCode);
    GradeScreVO getCourseDetail(String estbllctreCode);
    
    // ---------------------- [신규] 학생용 메서드 ----------------------

    /**
     * (학생) 학기별 성적 목록 조회 (stdntGradeScreMain.jsp 용)
     */
    List<GradeScreVO> getStudentSemstrList(String stdntNo);

    /**
     * (학생) 특정 학기의 과목별 상세 성적 조회 (stdntGradeScreDetail.jsp 용)
     */
    List<GradeScreVO> getStudentSemstrDetail(String semstrScreInnb);
}