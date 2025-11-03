package kr.ac.collage_api.grade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.grade.vo.GradeScreVO;


@Mapper
public interface GradeScreMapper {

    // ----------------------교수용 메서드 ----------------------
    String getProfsrNoByAcntId(String acntId);
    List<GradeScreVO> getAllSbject(String profsrNo);
    List<GradeScreVO> getCourse(String profsrNo);
    GradeScreVO getCourseDetail(String estbllctreCode);
    List<GradeScreVO> getSbjectScr(String estbllctreCode);
    void updateGrades(@Param("list") List<GradeScreVO> grades);
    void saveGrades(
        @Param("list") List<GradeScreVO> grades,
        @Param("estbllctreCode") String estbllctreCode
    );
    List<GradeScreVO> searchStudent(
        @Param("keyword") String keyword,
        @Param("estbllctreCode") String estbllctreCode
    );

    // ---------------------- 학생용 메서드 ----------------------
    
    /**
     * (학생) 학기별 성적 목록 조회 (SEMSTR_SCRE)
     */
    List<GradeScreVO> getStudentSemstrList(String stdntNo);

    /**
     * (학생) 특정 학기의 과목별 상세 성적 조회 (SBJECT_SCRE)
     */
    List<GradeScreVO> getStudentSemstrDetail(String semstrScreInnb);
}
