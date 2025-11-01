package kr.ac.collage_api.vo;

import lombok.Data;

//팀 정보
@Data
public class TeamInfoVO {
	private String teamId;        //팀ID(PK)	TEAM_ID(PK)
	private String teamPrjctId;   //팀프로젝트아이디(FK)	TEAM_PRJCT_ID(FK)
	private String teamNm;        //팀명	TEAM_NM
	private String teamFdbck;     //팀피드백	TEAM_FDBCK
	private int teamScore;        //팀점수	TEAM_SCORE
}



