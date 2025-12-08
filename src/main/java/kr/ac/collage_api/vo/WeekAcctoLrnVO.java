package kr.ac.collage_api.vo;

import java.util.List;

import lombok.Data;

@Data
public class WeekAcctoLrnVO {
	private String weekAcctoLrnNo;
	private String estbllctreCode;
	private int fileGroupNo;
	private int week;
	private String taskAt;
	private String lrnThema;
	private String lrnCn;
	private String quizAt;
	
	private String jsonWeeklyGoals;
	private List<WeekAcctoLrnVO> weekAcctoLrnVO;
}
