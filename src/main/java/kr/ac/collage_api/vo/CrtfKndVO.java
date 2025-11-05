package kr.ac.collage_api.vo;

import lombok.Data;

//
@Data
public class CrtfKndVO {
	private String crtfKndNo;      //증명서종류번호(PK)	CRTF_KND_NO(PK)
	private String crtfNm;         //증명서명	CRTF_NM
	private String crtfDc;         //증명서설명	CRTF_DC
	private int issuFee;           //발급수수료	ISSU_FEE
	private String crtfIssuForm;   //증명서발급양식	CRTF_ISSU_FORM
	
}



