package kr.ac.collage_api.lecture.service.impl;

import java.util.ArrayList;
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
    //  공통 ACNT_ID → 교수번호 / 학번 변환
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
    //  (교수) 개설강의 목록
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
    //  공통 개설강의 / 시간표 / 평가마스터 조회
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
    //  (교수) 강의평가 요약 / 점수 분포 / 주관식
    // ------------------------------------------------------------
    @Override
    public List<LectureEvlVO> getLectureEvalSummary(String estbllctreCode) {
        // 문항별 평균 점수, 응답자 수 조회
        return lectureMapper.getLectureEvalSummary(estbllctreCode);
    }

    @Override
    public List<Integer> getLectureEvalScoreCounts(String estbllctreCode) {
        // DB에서는 {SCORE: 5, CNT: 10}, {SCORE: 3, CNT: 2} 형태로 넘어옴
        List<Map<String, Object>> rawCounts = lectureMapper.getLectureEvalScoreCountsMap(estbllctreCode);
        
        // 차트용 [1점개수, 2점개수, 3점개수, 4점개수, 5점개수] 리스트 초기화
        List<Integer> result = new ArrayList<>(List.of(0, 0, 0, 0, 0));
        
        for (Map<String, Object> map : rawCounts) {
            // DB 컬럼이 VARCHAR2일 수 있으므로 안전하게 파싱
            int score = Integer.parseInt(String.valueOf(map.get("SCORE"))); 
            int cnt = Integer.parseInt(String.valueOf(map.get("CNT")));
            
            // 점수가 1~5 사이일 때만 해당 인덱스에 매핑 (1점 -> index 0)
            if (score >= 1 && score <= 5) {
                result.set(score - 1, cnt);
            }
        }
        return result;
    }

    @Override
    public List<LectureEvlVO> getLectureEvalNarratives(String estbllctreCode) {
        // 주관식 코멘트가 있는 항목만 조회
        return lectureMapper.getLectureEvalNarratives(estbllctreCode);
    }

    // ------------------------------------------------------------
    //  (학생) 강의목록 + 평가여부
    // ------------------------------------------------------------
    @Override
    public List<LectureEvlVO> getAllLecturesByStdntNo(String stdntNo) {
        return lectureMapper.getAllLecturesByStdntNo(stdntNo);
    }

    @Override
    public boolean isLectureEvaluatedByStdnt(String estbllctreCode, String stdntNo) {
        Map<String, Object> param = new HashMap<>();
        param.put("estbllctreCode", estbllctreCode);
        param.put("stdntNo", stdntNo);
        int cnt = lectureMapper.isLectureEvaluatedByStdnt(param);
        return cnt > 0;
    }

    // ------------------------------------------------------------
    //  (학생) 강의 평가 항목 목록
    // ------------------------------------------------------------
    @Override
    public List<LectureEvlVO> getEvalItemsByEstbllctreCode(String estbllctreCode) {
        return lectureMapper.getEvalItemsByEstbllctreCode(estbllctreCode);
    }

    // ------------------------------------------------------------
    //  (학생) 강의 평가 제출
    // ------------------------------------------------------------
    @Override
    @Transactional
    public void insertLectureEval(String estbllctreCode,
                                  String stdntNo,
                                  List<Integer> lctreEvlInnb,
                                  List<Integer> evlScore,
                                  List<String> evlCn) {

        Integer evlNo = lectureMapper.getEvlNoByEstbllctreCode(estbllctreCode);
        if (evlNo == null) {
            throw new RuntimeException("평가 기준(EVL_NO)이 존재하지 않아 평가를 진행할 수 없습니다.");
        }

        // 반복문을 통해 항목별 점수 저장
        for (int i = 0; i < evlScore.size(); i++) {
            Map<String, Object> param = new HashMap<>();
            param.put("stdntId", stdntNo);                  
            param.put("lctreEvlInnb", lctreEvlInnb.get(i)); 
            param.put("evlScore", String.valueOf(evlScore.get(i))); // DB가 VARCHAR2이므로 String 변환
            param.put("evlCn", evlCn.get(i));               // 주관식 의견
            
            lectureMapper.insertLectureEval(param);
        }
    }

    // ------------------------------------------------------------
    //  (시스템) 기본 평가지 자동 생성
    // ------------------------------------------------------------
    @Override
    @Transactional
    public Integer createDefaultEvaluation(String estbllctreCode) {

        int newEvlNo = lectureMapper.getNextEvlNo();

        Map<String, Object> masterParam = new HashMap<>();
        masterParam.put("evlNo", newEvlNo);
        masterParam.put("estbllctreCode", estbllctreCode);
        lectureMapper.insertLctreEvlMaster(masterParam);

        // 기본 문항 세트
        List<String> defaultQuestions = List.of(
              "이 강의의 수업 목표가 명확하게 제시되었습니까?"
            , "교수님은 강의 준비를 충실히 하였습니까?"
            , "강의 내용은 체계적이고 유익했습니까?"
            , "과제 및 시험에 대한 피드백이 적절히 이루어졌습니까?"
            , "전반적으로 이 강의에 만족합니까?"
        );

        for (String question : defaultQuestions) {
            Map<String, Object> item = new HashMap<>();
            item.put("evlNo", newEvlNo);
            item.put("evlCn", question);
            lectureMapper.insertLctreEvlIem(item);
        }

        return newEvlNo;
    }

    @Override
    public int countEvlItems(Integer evlNo) {
        return lectureMapper.countEvlItems(evlNo);
    }
}