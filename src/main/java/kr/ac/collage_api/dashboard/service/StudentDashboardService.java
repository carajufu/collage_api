package kr.ac.collage_api.dashboard.service;

import kr.ac.collage_api.dashboard.mapper.DashboardMapper;
import kr.ac.collage_api.dashboard.vo.AcademicProgressRawVO;
import kr.ac.collage_api.dashboard.vo.DashLectureVO;
import lombok.extern.slf4j.Slf4j;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class StudentDashboardService {
    @Autowired
    DashboardMapper dashboardMapper;

    public List<DashLectureVO> selectStudent(String studentNo, String year, String currentPeriod) {
        List<DashLectureVO> dashLectureVOList;
        dashLectureVOList = dashboardMapper.selectStudent(studentNo, year, currentPeriod);

        return dashLectureVOList;
    }
    
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
