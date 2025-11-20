package kr.ac.collage_api.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

//학과 테이블
@Data
public class SubjctVO {
	private String subjctCode;    //학과코드(PK)	SUBJCT_CODE(PK)
	private String univCode;      //대학코드(FK)	UNIV_CODE(FK)
	private String subjctNm;      //학과명		SUBJCT_NM
	private String subjctTelno;   //학과전화번호	SUBJCT_TELNO
	private String subjctLc;      //학과위치	SUBJCT_LC
	private String fondyear;      //설립년도	FONDYEAR
	private int operSttus;        //운영상태	OPER_STTUS
	private Date recentUpdtDt;    //최근수정일시	RECENT_UPDT_DT
	private String subjctChpt;	  //학과장

	private List<ProfsrVO> profsr; //교수목록

	private String deanNm;		  //학과장 이름 (SKLSTF_NM)
	private String buldNm; 	  	  //단과대 이름 (CODE_NM)
}





