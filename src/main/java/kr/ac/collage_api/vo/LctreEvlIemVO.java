package kr.ac.collage_api.vo;

import lombok.Data;

//강의 평가 항목
@Data
public class LctreEvlIemVO {
	private int lctreEvlInnb;      //강의평가고유번호(PK)	LCTRE_EVL_INNB(PK)
	private int evlNo;             //평가번호(FK)	EVL_NO(FK)
	private String evlCn;          //평가내용	EVL_CN
	private int evlScore;          //평가점수	EVL_SCORE
}



