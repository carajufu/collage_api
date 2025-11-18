package kr.ac.collage_api.admin.dto;

import lombok.Data;

//단과대학 수정한 데이터 받아올 dto
@Data
public class UnivUpdateRequestDto { 
	private String univCode; 	//대학코드 	UNIV_CODE
	private String univNm;      //대학명	UNIV_NM
	private String buldLc;     //건물위치	BULD_LC
	private String profsrNo;   //교수_번호(학장) 
	private String univTelno;  //대학전화번호	UNIV_TELNO
	private int operSttus;     //운영상태	OPER_STTUS
	
	//JSON 파싱 오류 방지
	private String title;
    private String key;
    private String type;
}
