package kr.ac.collage_api.dashboard.service;

import kr.ac.collage_api.dashboard.mapper.DashboardMapper;
import kr.ac.collage_api.dashboard.vo.LectureVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class StudentDashboardService {
    @Autowired
    DashboardMapper dashboardMapper;

    public List<LectureVO> selectStudent(String studentNo, String year, String currentPeriod) {
        List<LectureVO> lectureVOList;
        lectureVOList = dashboardMapper.selectStudent(studentNo, year, currentPeriod);

        return lectureVOList;
    }
}
