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

    @Override
    public String getProfsrNoByAcntId(String acntId) {
        return lectureMapper.getProfsrNoByAcntId(acntId);
    }

    @Override
    public String getStdntNoByAcntId(String acntId) {
        return lectureMapper.getStdntNoByAcntId(acntId);
    }

    @Override
    public LectureEvlVO getEstblCourseById(String estbllctreCode) {
        return lectureMapper.getEstblCourseById(estbllctreCode);
    }

    @Override
    public List<LectureEvlVO> getEvlIem(Integer evlNo) {
        return lectureMapper.getEvlIem(evlNo);
    }

    @Override
    public List<LectureEvlVO> getTimetableByEstblCode(String estbllctreCode) {
        return lectureMapper.getTimetableByEstblCode(estbllctreCode);
    }

    @Override
    public Integer getEvlNoByEstbllctreCode(String estbllctreCode) {
        return lectureMapper.getEvlNoByEstbllctreCode(estbllctreCode);
    }

    @Override
    public List<LectureEvlVO> getLectureEvalSummary(String estbllctreCode) {
        return lectureMapper.getLectureEvalSummary(estbllctreCode);
    }

    @Override
    public List<Integer> getLectureEvalScoreCounts(String estbllctreCode) {
        return lectureMapper.getLectureEvalScoreCounts(estbllctreCode);
    }

    @Override
    public List<LectureEvlVO> getAllLecturesByStdntNo(String stdntNo) {
        return lectureMapper.getAllLecturesByStdntNo(stdntNo);
    }

    @Override
    @Transactional
    public void insertLectureEval(String estbllctreCode, String stdntId,
                                  List<Integer> evlScore, List<String> evlCn) {
        Integer evlNo = lectureMapper.getEvlNoByEstbllctreCode(estbllctreCode);
        List<LectureEvlVO> evlItems = lectureMapper.getEvlIem(evlNo);

        for (int i = 0; i < evlItems.size(); i++) {
            LectureEvlVO item = evlItems.get(i);
            Map<String, Object> param = new HashMap<>();
            param.put("lctreEvlInnb", item.getLctreEvlInnb());
            param.put("stdntId", stdntId);
            param.put("evlScore", evlScore.get(i));
            param.put("evlCn", evlCn.get(i));
            lectureMapper.insertLectureEval(param);
        }
    }

    @Override
    @Transactional
    public Integer createDefaultEvaluation(String estbllctreCode) {
        Integer exists = lectureMapper.getEvlNoByEstbllctreCode(estbllctreCode);
        if (exists != null) {
            return exists;
        }
        int newEvlNo = lectureMapper.getNextEvlNo();
        Map<String, Object> masterParam = new HashMap<>();
        masterParam.put("evlNo", newEvlNo);
        masterParam.put("estbllctreCode", estbllctreCode);
        lectureMapper.insertLctreEvlMaster(masterParam);

        List<String> defaultQuestions = List.of(
            "강의 내용이 체계적이고 유익했습니다.",
            "교수님의 설명이 명확하고 이해하기 쉬웠습니다.",
            "과제 / 시험 등이 강의 목표 달성에 적절했습니다.",
            "전반적으로 강의에 만족합니다."
        );

        for (String q : defaultQuestions) {
            Map<String, Object> itemParam = new HashMap<>();
            itemParam.put("evlNo", newEvlNo);
            itemParam.put("evlCn", q);
            lectureMapper.insertLctreEvlIem(itemParam);
        }
        return newEvlNo;
    }

    @Override
    public int getTotalCourseCount(String profsrNo) {
        return 0;
    }

    @Override
    public List<LectureEvlVO> getPagedCourses(String profsrNo, int start, int size) {
        return null;
    }
}
