package kr.ac.collage_api.vo;

import java.util.Date;

import lombok.Data;

//증명서 발급 요청
@Data
public class CrtfIssuRequstVO {
	private String crtfIssuInnb; //증명서발급고유번호(PK)	CRTF_ISSU_INNB(PK)
	private String crtfKndNo;    //증명서종류번호(FK)	CRTF_KND_NO(FK)
	private long fileGroupNo;     //파일그룹번호(FK)	FILE_GROUP_NO(FK)
	private String stdntNo;      //학생번호(FK)	STDNT_NO(FK)
	private Date reqstDt;        //신청일시	REQST_DT
	private Date issuDt;         //발급일시	ISSU_DT
	private String issuSttus;    //발급상태	ISSU_STTUS
}



