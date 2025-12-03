package kr.ac.collage_api.dashboard.vo;

import java.util.List;

import lombok.Data;

@Data
public class ReactDashboardVO {
	private int currentStdntCount;	//재학중인 학생수
	private int currentCourseCount;	//현재 개설 과목 수
	private int currentProfsrCount; //재직중인 교수 수

	private List<UnivRankVO> stdntCountInUniv;
	private List<keyValue> enrollmentRatio;

	@Data
	public static class UnivRankVO {
		private String name;
		private int count;
	}

	@Data
	public static class keyValue{
		private String name;
		private int count;
	}
}
