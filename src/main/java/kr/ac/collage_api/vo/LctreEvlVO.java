package kr.ac.collage_api.vo;

import lombok.Data;

// 강의평가
@Data
public class LctreEvlVO {
	private int evlNo;                   //평가번호(PK)	EVL_NO(PK)
	private String estbllctreCode;       //개설강의코드(FK)	ESTBLLCTRE_CODE(FK)
	private int allEvlAvrg;              //전체평가평균	ALL_EVL_AVRG
}




