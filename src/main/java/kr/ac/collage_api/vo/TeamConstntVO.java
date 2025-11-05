package kr.ac.collage_api.vo;

import lombok.Data;

//팀_구성원
@Data
public class TeamConstntVO {
	private String teamwonNo; //팀원넘버(PK)	TEAMWON_NO(PK)
	private String teamId;    //팀ID(FK)	TEAM_ID(FK)
	private String stdntNo;   //학생번호(FK)	STDNT_NO(FK)
	private int indvdlScore;  //개인점수	INDVDL_SCORE
}


