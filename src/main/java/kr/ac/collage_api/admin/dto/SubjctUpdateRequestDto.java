package kr.ac.collage_api.admin.dto;

import lombok.Data;

//학과 수정한 데이터 받아올 dto
@Data
public class SubjctUpdateRequestDto {
	private String subjctCode;    //학과코드(PK)	SUBJCT_CODE(PK)
	private String subjctNm;      //학과명		SUBJCT_NM
	private String subjctLc;      //학과위치	SUBJCT_LC
	private String subjctChpt;	  //학과장
	private String subjctTelno;   //학과전화번호	SUBJCT_TELNO
	private int operSttus;        //운영상태	OPER_STTUS
	
	private String univCode;	//대학코드(PK)	UNIV_CODE(PK)
	
	//JSON 파싱 오류 방지
	private String title;
    private String key;
    private String type;
	
}
