package kr.ac.collage_api.stdnt.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.SemstrScreVO;
import kr.ac.collage_api.vo.StdntVO;

public interface StdntService {

    StdntVO getStdntInfo(String stdntNo);
    StdntVO getStdntInfoByName(String stdntNm);

    AcntVO getAcntInfo(String acntId);

    List<SemstrScreVO> getSemstrList(String stdntNo);

    // 선택 학기(year, semstr) 도출
    Map<String, String> getYearSemBySemstrInnb(Integer semstrScreInnb);

    // 수강 목록 (선택 학기 필터 가능)
    List<EstblCourseVO> getCourseList(String stdntNo, String year, String semstr);

    // 총 이수 학점 합계
    int getTotalAcqsPnt(String stdntNo);

    // 이수구분별(전필/전선/교필/교선) 합계
    List<Map<String, Object>> getPntByComplSe(String stdntNo, String year, String semstr);

    // 출결 요약 (코드별 개수)
    List<Map<String, Object>> getAttendanceSummary(String stdntNo);

}
