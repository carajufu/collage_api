package kr.ac.collage_api.vo;

import java.util.Date;

import lombok.Data;

@Data
public class GrdtnRqisitVO {
	
	//졸업 조건
	private int grdtnRqisitId;		//GRDTN_RQISIT_ID 졸업요건ID
	private int sknrgsChangeInnb;	//SKNRGS_CHANGE_INNB 학적변동 고유번호
	private String stdntNo;			//STDNT_NO	학생 학번
	private String grdtnRqisitTy;	//GRDTN_RQISIT_TY	졸업 요건 유형(ex.졸업작품, 졸업논문)
	private String registDe;		//REGIST_DE	등록일자
}
