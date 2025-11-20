package kr.ac.collage_api.graduation.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.graduation.vo.GraduationVO;
import kr.ac.collage_api.vo.StdntVO;
import kr.ac.collage_api.vo.GrdtnRqisitVO;

@Mapper
public interface GraduationMapper {

    // 1) 졸업 신청 내역 조회 (가장 최근 1건)
    GraduationVO getStdntRegist(String stdntNo);

    // 2) 총 취득학점 (SEMSTR_SCRE 기반)
    int getAllPnt(String stdntNo);

    // 3) 지도교수 상담 내역 조회 (있으면 1행 반환, 없으면 null)
    List<Map<String, Object>> getConsult(String stdntNo);

    // 4) 졸업 신청 INSERT
    int applyForGraduation(GraduationVO graduVO);

    // 5) 학생 기본 정보 조회
    StdntVO getStudentInfo(String stdntNo);

    // 6) 수강/성적 내역 (전필/교필/교선/전선/외국어 판별용) — F학점 제외
    List<Map<String, Object>> getSubjectCompletions(String stdntNo);

    // 7) 학과별 필수 과목 기준 목록 조회
    List<GrdtnRqisitVO> getGradCond(String stdntNo);

    // 8) 누적 평점 (GPA)
    double getCumulativeGpa(String stdntNo);
}
