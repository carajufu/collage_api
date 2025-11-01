package kr.ac.collage_api.vo;

import lombok.Data;

//팀 프로젝트 과제
@Data
public class TeamPrjctVO {
	private String teamPrjctId;       //팀프로젝트아이디(PK)	TEAM_PRJCT_ID(PK)
	private String estbllctreCode;    //개설강의코드(FK)	ESTBLLCTRE_CODE(FK)
	private String prjctSj;           //프로젝트제목	PRJCT_SJ
	private String beginDe;           //시작일자	BEGIN_DE
	private String closDe;            //마감일자	CLOS_DE
}


