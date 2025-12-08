package kr.ac.collage_api.dashboard.service;

import kr.ac.collage_api.dashboard.mapper.DashboardMapper;
import kr.ac.collage_api.dashboard.vo.AcademicProgressRawVO;
import kr.ac.collage_api.dashboard.vo.DashLectureVO;
import kr.ac.collage_api.graduation.mapper.GraduationMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class StudentDashboardService {
    @Autowired
    DashboardMapper dashboardMapper;

    @Autowired
    GraduationMapper graduationMapper;

    private static final int MIN_TOTAL_PNT = 130;
    private static final int MIN_MAJOR_PNT = 54;
    private static final int MIN_LIBERAL_PNT = 30;
    private static final int MIN_FOREIGN_LANG = 2;
    private static final double MIN_TOTAL_GPA = 2.0;

    public List<DashLectureVO> selectStudent(String studentNo, String year, String currentPeriod) {
        return dashboardMapper.selectStudent(studentNo, year, currentPeriod);
    }

    /**
     * 졸업 요건 진행 현황을 대시보드 카드에 주입하기 위한 간략 스냅샷을 계산한다.
     */
    public Map<String, Object> getGraduationSnapshot(String studentNo) {
        Map<String, Object> requirements = new HashMap<>();

        int totalPnt = graduationMapper.getAllPnt(studentNo);
        List<Map<String, Object>> subjects = graduationMapper.getSubjectCompletions(studentNo);

        int majorPnt = 0;
        int liberalPnt = 0;
        long foreignLangCount = 0;

        if (subjects != null) {
            for (Map<String, Object> s : subjects) {
                String complSe = s.get("COMPL_SE") == null ? null : s.get("COMPL_SE").toString();
                String subjctCode = s.get("SUBJCT_CODE") == null ? null : s.get("SUBJCT_CODE").toString();

                int acqsPnt = 0;
                Object acqsPntObj = s.get("ACQS_PNT");
                if (acqsPntObj instanceof Number) {
                    acqsPnt = ((Number) acqsPntObj).intValue();
                } else if (acqsPntObj != null) {
                    try {
                        acqsPnt = Integer.parseInt(acqsPntObj.toString());
                    } catch (NumberFormatException ignored) { }
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

        double totalGpa = graduationMapper.getCumulativeGpa(studentNo);
        totalGpa = BigDecimal.valueOf(totalGpa).setScale(2, RoundingMode.HALF_UP).doubleValue();

        requirements.put("MIN_TOTAL_PNT", MIN_TOTAL_PNT);
        requirements.put("MIN_MAJOR_PNT", MIN_MAJOR_PNT);
        requirements.put("MIN_LIBERAL_PNT", MIN_LIBERAL_PNT);
        requirements.put("MIN_FOREIGN_LANG", MIN_FOREIGN_LANG);
        requirements.put("MIN_TOTAL_GPA", MIN_TOTAL_GPA);

        requirements.put("totalPnt", totalPnt);
        requirements.put("majorPnt", majorPnt);
        requirements.put("liberalPnt", liberalPnt);
        requirements.put("foreignLangCount", foreignLangCount);
        requirements.put("totalGpa", totalGpa);

        return requirements;
    }
    

    // =========================================================================================

    /**
     * 학적 이행(학점/전공/교양/외국어) 집계
     * - 쿼리에서 집계 1행만 나오도록 설계 → 단일 VO 반환
     * - null 값은 여기서 0으로 정규화
     */
    public AcademicProgressRawVO selectAcademicProgress(String stdntNo) {
    	AcademicProgressRawVO raw = dashboardMapper.selectAcademicProgress(stdntNo);
        if (raw == null) {
            raw = new AcademicProgressRawVO();
        }

        if (raw.getTotalCompletedCredits() == null)    raw.setTotalCompletedCredits(0);
        if (raw.getTotalRequiredCredits() == null)     raw.setTotalRequiredCredits(0);

        if (raw.getMajorCompletedCredits() == null)    raw.setMajorCompletedCredits(0);
        if (raw.getMajorRequiredCredits() == null)     raw.setMajorRequiredCredits(0);

        if (raw.getLiberalCompletedCredits() == null)  raw.setLiberalCompletedCredits(0);
        if (raw.getLiberalRequiredCredits() == null)   raw.setLiberalRequiredCredits(0);

        if (raw.getForeignCompletedSubjects() == null) raw.setForeignCompletedSubjects(0);
        if (raw.getForeignRequiredSubjects() == null)  raw.setForeignRequiredSubjects(0);

        return raw;
    }
}
