package kr.ac.collage_api.vo;

import java.util.Date;

import lombok.Data;

@Data
public class GrduCondVO {
	
	//졸업 조건
	private int gradCondId;				//졸업 조건번호(PK)		GRAD_COND_ID
	private String gradCondTy;			//졸업 조건유형			GRAD_COND_TY
	private Date regDt;					//등록일				REG_DT
	private String stdntNo;      		//학생번호(FK)			STDNT_NO
	private int sknrgsChangeInnb;       //학적변동고유번호(FK)	SKNRGS_CHANGE_INNB(PK)
}
