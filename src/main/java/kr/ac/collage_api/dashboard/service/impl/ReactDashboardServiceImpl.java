package kr.ac.collage_api.dashboard.service.impl;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.dashboard.mapper.ReactDashboardMapper;
import kr.ac.collage_api.dashboard.service.ReactDashboardService;
import kr.ac.collage_api.dashboard.vo.ReactDashboardVO;
import kr.ac.collage_api.dashboard.vo.ReactDashboardVO.UnivRankVO;
import kr.ac.collage_api.dashboard.vo.ReactDashboardVO.keyValue;

@Service
public class ReactDashboardServiceImpl implements ReactDashboardService {

	@Autowired
	ReactDashboardMapper reactDashboardMapper;

	@Override
	public ReactDashboardVO selectHomeChartValue() {
		ReactDashboardVO reactDashboardVO = new ReactDashboardVO();

		//현재 재학생 수
		int currnetStdntCount = this.reactDashboardMapper.currentStdntCount();

		//이번학기 진행강의 수
		int currentCourseCount = getyearSemstr();

		//현재 재직중인 교수 수
		int currentProfsrCount = this.reactDashboardMapper.currentProfsrCount();

		reactDashboardVO.setCurrentStdntCount(currnetStdntCount);
		reactDashboardVO.setCurrentCourseCount(currentCourseCount);
		reactDashboardVO.setCurrentProfsrCount(currentProfsrCount);

		//학과별 재학생 수
		List<UnivRankVO> stdntCountInUniv = this.reactDashboardMapper.stdntCountInUniv();
		reactDashboardVO.setStdntCountInUniv(stdntCountInUniv);

		//학적 비율
		//	private List<keyValue> enrollmentRatio;
		List<keyValue> enrollmentRatio = this.reactDashboardMapper.enrollmentRatio();
		reactDashboardVO.setEnrollmentRatio(enrollmentRatio);

		return reactDashboardVO;
	}


	//현재 학기 구함
	public int getyearSemstr() {

		LocalDate date = LocalDate.now();

		int year = date.getYear();
		int month =date.getMonthValue();
		String semstr;
		if (month>=3 && month<=8) {
			semstr = "1학기";
		} else {
			semstr = "2학기";
			if (month ==1 || month ==2) {
				year = year-1;
			};
		}

		String strYear = Integer.toString(year);
		return this.reactDashboardMapper.currentCourseCount(strYear,semstr);
	}

}
