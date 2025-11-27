package kr.ac.collage_api.graduation.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.graduation.mapper.GraduationMapper;
import kr.ac.collage_api.graduation.service.GraduationService;
import kr.ac.collage_api.graduation.vo.GraduationVO;

@Service
public class GraduationServiceImpl implements GraduationService {

    // --- 졸업 요건 기준 (예시 값, 학교 규정에 맞게 조정) ---
    private static final int MIN_TOTAL_PNT    = 130;
    private static final int MIN_MAJOR_PNT    = 54;
    private static final int MIN_LIBERAL_PNT  = 30;
    private static final int MIN_FOREIGN_LANG = 2;
    private static final double MIN_TOTAL_GPA = 2.0;
    // -----------------------------------------------------

    @Autowired
    private GraduationMapper graduMapper;

    @Override
    public Map<String, Object> getGraduMainData(String stdntNo) {

        Map<String, Object> data = new HashMap<>();

        // 1) 최근 졸업 신청 현황
        data.put("graduinfo", graduMapper.getStdntRegist(stdntNo));

        // 2) 학생 기본 정보
        data.put("stdntInfo", graduMapper.getStudentInfo(stdntNo));

        // 3) 지도교수 상담 내역
        List<Map<String, Object>> stdConsult = graduMapper.getConsult(stdntNo);
        data.put("stdConsult", (stdConsult == null || stdConsult.isEmpty()) ? null : stdConsult);

        // 4) 총 이수학점
        int totalPnt = graduMapper.getAllPnt(stdntNo);

        // 5) 과목 이수 내역
        List<Map<String, Object>> subjects = graduMapper.getSubjectCompletions(stdntNo);

        int majorPnt = 0;
        int liberalPnt = 0;
        long foreignLangCount = 0;

        if (subjects != null) {
            for (Map<String, Object> s : subjects) {
                Object complSeObj = s.get("COMPL_SE");
                Object subjctCodeObj = s.get("SUBJCT_CODE");
                Object acqsPntObj = s.get("ACQS_PNT");

                String complSe = (complSeObj == null) ? null : complSeObj.toString();
                String subjctCode = (subjctCodeObj == null) ? null : subjctCodeObj.toString();

                int acqsPnt = 0;
                if (acqsPntObj != null) {
                    if (acqsPntObj instanceof Number) {
                        acqsPnt = ((Number) acqsPntObj).intValue();
                    } else {
                        try {
                            acqsPnt = Integer.parseInt(acqsPntObj.toString());
                        } catch (NumberFormatException e) {
                            acqsPnt = 0;
                        }
                    }
                }

                if ("전필".equals(complSe)) {
                    majorPnt += acqsPnt;
                } else if ("교필".equals(complSe)) {
                    liberalPnt += acqsPnt;
                }

                if (subjctCode != null && subjctCode.startsWith("ENG")) {
                    foreignLangCount++;
                }
            }
        }

        // 6) GPA
        double totalGpa = graduMapper.getCumulativeGpa(stdntNo);
        totalGpa = new BigDecimal(totalGpa).setScale(2, RoundingMode.HALF_UP).doubleValue();

        // 7) 판정값 계산
        boolean isPntMet          = (totalPnt       >= MIN_TOTAL_PNT);
        boolean isMajorPntMet     = (majorPnt       >= MIN_MAJOR_PNT);
        boolean isLiberalPntMet   = (liberalPnt     >= MIN_LIBERAL_PNT);
        boolean isForeignLangMet  = (foreignLangCount >= MIN_FOREIGN_LANG);
        boolean isGpaMet          = (totalGpa       >= MIN_TOTAL_GPA);

        // 8) JSP에서 사용할 값 주입
        Map<String, Object> requirements = new HashMap<>();
        requirements.put("MIN_TOTAL_PNT",    MIN_TOTAL_PNT);
        requirements.put("MIN_MAJOR_PNT",    MIN_MAJOR_PNT);
        requirements.put("MIN_LIBERAL_PNT",  MIN_LIBERAL_PNT);
        requirements.put("MIN_FOREIGN_LANG", MIN_FOREIGN_LANG);
        requirements.put("MIN_TOTAL_GPA",    MIN_TOTAL_GPA);

        requirements.put("totalPnt",         totalPnt);
        requirements.put("majorPnt",         majorPnt);
        requirements.put("liberalPnt",       liberalPnt);
        requirements.put("foreignLangCount", foreignLangCount);
        requirements.put("totalGpa",         totalGpa);

        data.put("requirements", requirements);
        data.put("isPntMet", isPntMet);
        data.put("isMajorPntMet", isMajorPntMet);
        data.put("isLiberalPntMet", isLiberalPntMet);
        data.put("isForeignLangMet", isForeignLangMet);
        data.put("isGpaMet", isGpaMet);

        return data;
    }

    @Override
    public int applyForGraduation(GraduationVO graduVO) {

        String stdntNo = graduVO.getStdntNo();

        // 1) 중복 신청 방지
        GraduationVO existing = graduMapper.getStdntRegist(stdntNo);
        if (existing != null) {
            if ("신청".equals(existing.getReqstSttus())) {
                throw new IllegalStateException("이미 '신청' 상태인 내역이 존재합니다.");
            }
            if ("승인".equals(existing.getReqstSttus())) {
                throw new IllegalStateException("이미 '승인'된 졸업 신청 내역이 존재합니다.");
            }
        }

        // 2) 서버 사이드 요건 재검증 (프론트와 동일 기준)
        int totalPnt = graduMapper.getAllPnt(stdntNo);

        List<Map<String, Object>> subjects = graduMapper.getSubjectCompletions(stdntNo);

        int majorPnt = 0;
        int liberalPnt = 0;
        long foreignLangCount = 0;

        if (subjects != null) {
            for (Map<String, Object> s : subjects) {
                Object complSeObj = s.get("COMPL_SE");
                Object subjctCodeObj = s.get("SUBJCT_CODE");
                Object acqsPntObj = s.get("ACQS_PNT");

                String complSe = (complSeObj == null) ? null : complSeObj.toString();
                String subjctCode = (subjctCodeObj == null) ? null : subjctCodeObj.toString();

                int acqsPnt = 0;
                if (acqsPntObj != null) {
                    if (acqsPntObj instanceof Number) {
                        acqsPnt = ((Number) acqsPntObj).intValue();
                    } else {
                        try {
                            acqsPnt = Integer.parseInt(acqsPntObj.toString());
                        } catch (NumberFormatException e) {
                            acqsPnt = 0;
                        }
                    }
                }

                if ("전필".equals(complSe)) {
                    majorPnt += acqsPnt;
                } else if ("교필".equals(complSe)) {
                    liberalPnt += acqsPnt;
                }

                if (subjctCode != null && subjctCode.startsWith("ENG")) {
                    foreignLangCount++;
                }
            }
        }

        double totalGpa = graduMapper.getCumulativeGpa(stdntNo);

        boolean isPntMet          = (totalPnt       >= MIN_TOTAL_PNT);
        boolean isMajorPntMet     = (majorPnt       >= MIN_MAJOR_PNT);
        boolean isLiberalPntMet   = (liberalPnt     >= MIN_LIBERAL_PNT);
        boolean isForeignLangMet  = (foreignLangCount >= MIN_FOREIGN_LANG);
        boolean isGpaMet          = (totalGpa       >= MIN_TOTAL_GPA);

        if (!isPntMet || !isMajorPntMet || !isLiberalPntMet || !isForeignLangMet || !isGpaMet) {
            throw new IllegalStateException("현재 졸업 요건을 충족하지 못했습니다. (서버 검증 실패)");
        }

        graduVO.setChangeTy("졸업");
        graduVO.setReqstSttus("신청");

        return graduMapper.applyForGraduation(graduVO);
    }
}
