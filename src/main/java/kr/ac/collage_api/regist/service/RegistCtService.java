package kr.ac.collage_api.regist.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.vo.RegistCtVO;

public interface RegistCtService {

    // 등록금 고지 등록 (학과·학년 단위)
    int insertRegist(RegistCtVO registCtVO);

    // 등록금 고지 내역 전체 조회
    List<RegistCtVO> selectRegistList();

    // 중복 등록 확인 (동일 학과·학년·학기)
    int checkDuplicateRegist(RegistCtVO registCtVO);

    // 자동 생성 기능 — 학생별 PayInfo 생성 시 사용
    int autoGenerate(String rqestYear, String rqestSemstr);

    // 단과대 목록
    List<Map<String, Object>> selectUnivList();

    // 단과대별 학과 목록
    List<Map<String, Object>> selectSubjectsByUniv(String univCode);

    List<Map<String, Object>> selectUnissuedSubjects(Map<String, Object> params);

    // 등록금 고지 내역 수정, 삭제
    int updateRegistCt(RegistCtVO vo);

    void deleteRegistCt(int registCtNo);

}