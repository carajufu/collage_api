package kr.ac.collage_api.vo;

import java.util.Date;

import lombok.Data;

//학적 변동 신청
@Data
public class SknrgsChangeReqstVO {
	private int sknrgsChangeInnb;          //학적변동고유번호(PK)	SKNRGS_CHANGE_INNB(PK)
	private String stdntNo;                //학생번호(FK)	STDNT_NO(FK)
	private Long fileGroupNo;                 //파일그룹번호(FK)	FILE_GROUP_NO(FK)
	private String changeTy;                 //변경 유형  휴학신청인지, 복학신청인지
	private String tmpabssklTy;				//휴학유형   휴학할때 군휴학인지, 일반휴학인지..
	private String efectOccrrncSemstr;     //효력발생학기	EFECT_OCCRRNC_SEMSTR
	private String reqstResn;              //신청사유	REQST_RESN
	private Date changeReqstDt;            //변동신청일시	CHANGE_REQST_DT
	private String reqstSttus;             //신청상태	REQST_STTUS
	private Date confmComptDt;             //승인완료일시	CONFM_COMPT_DT
	private String returnResn;             //반려사유	RETURN_RESN
	private Date lastUpdtTm;               //최종수정일시	LAST_UPDT_TM

	private StdntVO stdntVO;	//학생
}


