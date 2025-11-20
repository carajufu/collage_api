package kr.ac.collage_api.graduation.service.impl;

import java.math.BigDecimal; // 정확한 계산을 위해
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

    // --- 졸업 요건 기준 (하드코딩) ---
    private static final int MIN_TOTAL_CREDITS = 130; // 최소 총 이수 학점
    private static final int MIN_MAJOR_ESSENTIAL = 4; // 최소 전공 필수 과목 수
    private static final int MIN_LIBERAL_ESSENTIAL = 4; // 최소 교양 필수 과목 수
    private static final int MIN_FOREIGN_LANG = 2; // 최소 외국어 영역 과목 수
    private static final double MIN_TOTAL_GPA = 2.0; // 총 평점 평균(GPA) 기준
    // ---------------------------------

    @Autowired
    GraduationMapper graduMapper;

    /**
     * 졸업 신청 메인 페이지 데이터 조회
     */
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

        long gyopilCount = 0;   // 교필
        long jeonpilCount = 0;  // 전필
        long foreignLangCount = 0; // 외국어(ENG%)

        if (subjects != null) {
            for (Map<String, Object> s : subjects) {
                Object complSe = s.get("COMPL_SE");
                if (complSe != null) {
                    if ("교필".equals(complSe.toString())) gyopilCount++;
                    if ("전필".equals(complSe.toString())) jeonpilCount++;
                }
                Object subjctCode = s.get("SUBJCT_CODE");
                if (subjctCode != null && subjctCode.toString().startsWith("ENG")) {
                    foreignLangCount++;
                }
            }
        }

        // 6) GPA
        double totalGpa = graduMapper.getCumulativeGpa(stdntNo);
        totalGpa = new BigDecimal(totalGpa).setScale(2, RoundingMode.HALF_UP).doubleValue();

        // 7) 판정값 계산 (등록금 요건 제거, 총 4개 요건만 사용)
        boolean isPntMet = (totalPnt >= MIN_TOTAL_CREDITS);
        boolean isCoreMet = (gyopilCount >= MIN_LIBERAL_ESSENTIAL && jeonpilCount >= MIN_MAJOR_ESSENTIAL);
        boolean isForeignLangMet = (foreignLangCount >= MIN_FOREIGN_LANG);
        boolean isGpaMet = (totalGpa >= MIN_TOTAL_GPA);

        // 8) JSP에서 사용할 값 주입
        Map<String, Object> requirements = new HashMap<>();
        requirements.put("MIN_TOTAL_CREDITS", MIN_TOTAL_CREDITS);
        requirements.put("MIN_MAJOR_ESSENTIAL", MIN_MAJOR_ESSENTIAL);
        requirements.put("MIN_LIBERAL_ESSENTIAL", MIN_LIBERAL_ESSENTIAL);
        requirements.put("MIN_FOREIGN_LANG", MIN_FOREIGN_LANG);
        requirements.put("MIN_TOTAL_GPA", MIN_TOTAL_GPA);

        requirements.put("totalPnt", totalPnt);
        requirements.put("majorEssentialCount", jeonpilCount);
        requirements.put("liberalEssentialCount", gyopilCount);
        requirements.put("foreignLangCount", foreignLangCount);
        requirements.put("totalGpa", totalGpa);

        data.put("requirements", requirements);
        data.put("isPntMet", isPntMet);
        data.put("isCoreMet", isCoreMet);
        data.put("isForeignLangMet", isForeignLangMet);
        data.put("isGpaMet", isGpaMet);

        return data;
    }

    /**
     * 졸업 신청 처리 (INSERT)
     */
    @Override
    public int applyForGraduation(GraduationVO graduVO) {

        String stdntNo = graduVO.getStdntNo();

        // 1) 중복 신청 방지
        GraduationVO existing = this.graduMapper.getStdntRegist(stdntNo);
        if (existing != null) {
            if ("신청".equals(existing.getReqstSttus())) {
                throw new IllegalStateException("이미 '신청' 상태인 내역이 존재합니다.");
            }
            if ("승인".equals(existing.getReqstSttus())) {
                throw new IllegalStateException("이미 '승인'된 내역이 존재합니다.");
            }
        }

        // 2) 서버 사이드 4대 요건 재검증
        int totalPnt = graduMapper.getAllPnt(stdntNo);
        boolean isPntMet = (totalPnt >= MIN_TOTAL_CREDITS);

        List<Map<String, Object>> subjects = graduMapper.getSubjectCompletions(stdntNo);

        long gyopilCount = 0;
        long jeonpilCount = 0;
        long foreignLangCount = 0;

        if (subjects != null) {
            for (Map<String, Object> s : subjects) {
                Object complSe = s.get("COMPL_SE");
                if (complSe != null) {
                    if ("교필".equals(complSe.toString())) gyopilCount++;
                    if ("전필".equals(complSe.toString())) jeonpilCount++;
                }
                Object subjctCode = s.get("SUBJCT_CODE");
                if (subjctCode != null && subjctCode.toString().startsWith("ENG")) {
                    foreignLangCount++;
                }
            }
        }

        boolean isCoreMet = (gyopilCount >= MIN_LIBERAL_ESSENTIAL && jeonpilCount >= MIN_MAJOR_ESSENTIAL);
        double totalGpa = graduMapper.getCumulativeGpa(stdntNo);
        boolean isGpaMet = (totalGpa >= MIN_TOTAL_GPA);
        boolean isForeignLangMet = (foreignLangCount >= MIN_FOREIGN_LANG);

        if (!isPntMet || !isCoreMet || !isForeignLangMet || !isGpaMet) {
            throw new IllegalStateException("현재 졸업 요건을 충족하지 못했습니다. (서버 검증 실패)");
        }

        // 3) INSERT
        graduVO.setChangeTy("졸업");
        graduVO.setReqstSttus("신청");

        return this.graduMapper.applyForGraduation(graduVO);
    }
}
