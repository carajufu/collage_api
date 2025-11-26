package kr.ac.collage_api.vo;

import java.util.List;

import lombok.Data;

// 강의 시간표 조회용 VO
@Data
public class EstblTimetableVO {
	private String estbllctreCode;
	private String lctreNm;
	private String lctrum;
	private String cmmn;
	private String lctreDfk;
	private int beginTm;
	private int endTm;
	private String sklstfNm;
	
	private List<LctreTimetableVO> timetableList;
}
