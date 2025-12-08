package kr.ac.collage_api.regist.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.vo.RegistCtVO;
import kr.ac.collage_api.vo.StdntVO;

@Mapper
public interface RegistCtMapper {

    // 재학생 목록 조회
    List<StdntVO> selectActiveStudents();

    // 등록금 고지 등록 (학과·학년 단위)
    int insertRegist(RegistCtVO registCtVO);

    // 등록금 고지 목록 조회
    List<RegistCtVO> selectRegistList();

    // 중복 등록 확인 (동일 학과·학년·학기)
    int checkDuplicateRegist(RegistCtVO registCtVO);

    // 마지막 등록금 고지번호 조회 — PayInfo 사용
    Integer getLastRegistCtNo(String stdntNo);

    // 단과대 목록
    List<Map<String, Object>> selectUnivList();

    // 단과대별 학과 목록
    List<Map<String, Object>> selectSubjectsByUniv(String univCode);

    List<StdntVO> selectStudentsByDeptAndGrade(@Param("subjctCode") String subjctCode,
                                               @Param("rqestGrade") String rqestGrade);

    // 등록금 미고지 학과 목록
    List<Map<String, Object>> selectUnissuedSubjects(Map<String, Object> params);

    void updateRegistCt(RegistCtVO vo);

    void deleteRegistCt(int registCtNo);

    void deleteByRegistCtNo(int registCtNo);
}