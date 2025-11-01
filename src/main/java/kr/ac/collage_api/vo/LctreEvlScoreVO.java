package kr.ac.collage_api.vo;

import lombok.Data;

//강의평가점수
@Data
public class LctreEvlScoreVO {
	private String lctreEvlSn;    //강의평가일련번호(PK)	LCTRE_EVL_SN(PK)
	private String stdntNo;       //학생번호(FK)	STDNT_NO(FK)
	private int lctreEvlInnb;     //강의평가고유번호(FK)	LCTRE_EVL_INNB(FK)
	private String evlScore;      //평가점수	EVL_SCORE
	private String evlCn;         //평가내용	EVL_CN
}




