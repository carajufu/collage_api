package kr.ac.collage_api.counsel.dto;

import java.util.List;
import java.util.Map;

import lombok.Data;

@Data
public class CounselAdminChartDTO {

	private int todayRequestCount;		//오늘 상담 신청 건수
	private int monthRequestCount;		//이번달 신청 건수
	private int currentWaitingCount;	//지금 현재 대기중인 (처리안된 상담건수)

	//올해 처리 비율
	private List<StatusVO> statusRatio;

	//올해 교수별 상담 랭킹 top5( 막대차트용)
	private List<ProfsrRankVO> topFiveProfsr;

	private List<WeeklyTrendVO> weeklyTrend;


	@Data
	public static class StatusVO{
		private String name;
		private int value;
		private String Color;
	}


	@Data
	public static class ProfsrRankVO {
		private String name;
		private int count;

		public ProfsrRankVO(String name,int count) {
			this.name = name;
			this.count = count;
		}
	}

	@Data  //내부 static : 부모객체 없어도 new 객체를만듬
	public static class WeeklyTrendVO {
		private String day;
		private int count;

		public WeeklyTrendVO(String day,int count) {
			this.day = day;
			this.count = count;
		}

	}






}
