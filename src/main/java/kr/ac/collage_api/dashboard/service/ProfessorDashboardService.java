package kr.ac.collage_api.dashboard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.dashboard.mapper.DashboardMapper;
import kr.ac.collage_api.dashboard.vo.DashLectureVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ProfessorDashboardService {
	
    @Autowired
    DashboardMapper dashboardMapper;
    public List<DashLectureVO> selectProfessor(String profsrNo, String year, String currentPeriod) {
        return dashboardMapper.selectProfessor(profsrNo, year, currentPeriod);
    }
}
