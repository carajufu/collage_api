package kr.ac.collage_api.lecture.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.lecture.mapper.LectureEvlMapper;
import kr.ac.collage_api.lecture.service.LectureEvlService;
import kr.ac.collage_api.lecture.vo.LectureEvlVO;

@Service
public class LectureEvlServiceImpl implements LectureEvlService {

    @Autowired
    private LectureEvlMapper lectureMapper;

    // ------------------------------------------------------------
    //  (공통) ACNT_ID → ID 변환
    // ------------------------------------------------------------
    @Override
    public String getProfsrNoByAcntId(String acntId) {
        return lectureMapper.getProfsrNoByAcntId(acntId);
    }
    
    @Override
    public String getStdntNoByAcntId(String acntId) {
        return lectureMapper.getStdntNoByAcntId(acntId);
    }

    // ------------------------------------------------------------
    //  (교수) 로그인 교수 기준 개설강의 목록 조회
    // ------------------------------------------------------------
    @Override
    public int getTotalCourseCount(String profsrNo) {
        return lectureMapper.getTotalCourseCount(profsrNo);
    }

    @Override
    public List<LectureEvlVO> getPagedCourses(String profsrNo, int start, int size) {
        Map<String, Object> param = new HashMap<>();
        param.put("profsrNo", profsrNo);
        param.put("start", start);
        param.put("size", size);
        return lectureMapper.getPagedCourses(param);
    }


    // ------------------------------------------------------------
    //  (공통) 개설강의 기본정보 + 평가 기본정보 조회
    // ------------------------------------------------------------
    @Override
    public LectureEvlVO getEstblCourseById(String estbllctreCode) {
        return lectureMapper.getEstblCourseById(estbllctreCode);
    }

    @Override
    public List<LectureEvlVO> getTimetableByEstblCode(String estbllctreCode) {
        return lectureMapper.getTimetableByEstblCode(estbllctreCode);
    }
    
    @Override
    public Integer getEvlNoByEstbllctreCode(String estbllctreCode) {
        return lectureMapper.getEvlNoByEstbllctreCode(estbllctreCode);
    }


    // ------------------------------------------------------------
    //  (교수) 강의평가 요약 + 차트용 분포 데이터
    // ------------------------------------------------------------
    @Override
    public List<LectureEvlVO> getLectureEvalSummary(String estbllctreCode) {
        return lectureMapper.getLectureEvalSummary(estbllctreCode);
    }

    @Override
    public List<Integer> getLectureEvalScoreCounts(String estbllctreCode) {
        return lectureMapper.getLectureEvalScoreCounts(estbllctreCode);
    }


    // ------------------------------------------------------------
    //  (학생) 강의평가 목록 및 제출
    // ------------------------------------------------------------

    @Override
    public List<LectureEvlVO> getAllLecturesByStdntNo(String stdntNo) {
        return lectureMapper.getAllLecturesByStdntNo(stdntNo);
    }

    @Override
    @Transactional // 여러 항목을 Insert 하므로 트랜잭션 처리
    public void insertLectureEval(String estbllctreCode, String stdntId,
                                  List<Integer> evlScore, List<String> evlCn) {

        Integer evlNo = lectureMapper.getEvlNoByEstbllctreCode(estbllctreCode);
        if (evlNo == null) {
            throw new RuntimeException("강의평가 정보(EVL_NO)를 찾을 수 없습니다.");
        }

        for (int i = 0; i < evlScore.size(); i++) {
            

            Map<String, Object> param = new HashMap<>();
            
            param.put("stdntId", stdntId); 
            param.put("evlScore", evlScore.get(i));
            param.put("evlCn", (evlCn.size() > i) ? evlCn.get(i) : "");

            lectureMapper.insertLectureEval(param);
        }
    }
    
    // ------------------------------------------------------------
    //  (시스템) 평가 '질문지' 자동 생성 로직
    // ------------------------------------------------------------
    
    /**
     * 기본 평가지를 생성하는 메소드
     */
    @Override
    @Transactional // 마스터/항목 등록이 동시에 성공(Commit)해야 함
    public Integer createDefaultEvaluation(String estbllctreCode) {
        
        int newEvlNo = lectureMapper.getNextEvlNo();
        
        Map<String, Object> masterParam = new HashMap<>();
        masterParam.put("evlNo", newEvlNo);
        masterParam.put("estbllctreCode", estbllctreCode);
        lectureMapper.insertLctreEvlMaster(masterParam);
        
        List<String> defaultQuestions = List.of(
            "강의 내용이 체계적이고 유익했습니다.",
            "교수님의 설명이 명확하고 이해하기 쉬웠습니다.",
            "과제, 시험 등은 강의 목표 달성에 적절했습니다.",
            "전반적으로 이 강의에 만족합니다."
        );
        
        for (String question : defaultQuestions) {
            Map<String, Object> itemParam = new HashMap<>();
            itemParam.put("evlNo", newEvlNo);
            itemParam.put("evlCn", question);
            lectureMapper.insertLctreEvlIem(itemParam);
        }
        
        return newEvlNo;
    }

}
