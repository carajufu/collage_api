package kr.ac.collage_api.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.vo.ScoreRowVO;
import kr.ac.collage_api.vo.StudentDocxVO;

@Mapper
public interface StudentDocxMapper {
    // 재학증명서 등 기본 신원블록
    StudentDocxVO selectStudentBasic(@Param("stdntNo") String stdntNo);

    // 졸업증명서 본문용
    StudentDocxVO selectGraduationInfo(@Param("stdntNo") String stdntNo);

    // 휴학증명서 본문용
    StudentDocxVO selectLeaveInfo(@Param("stdntNo") String stdntNo);

    // 성적증명서 과목별 상세 라인들
    List<ScoreRowVO> selectScoreRows(@Param("stdntNo") String stdntNo);

    // 성적증명서 하단 요약(총 취득학점, 누적평점 등)
    StudentDocxVO selectScoreSummary(@Param("stdntNo") String stdntNo);
}
