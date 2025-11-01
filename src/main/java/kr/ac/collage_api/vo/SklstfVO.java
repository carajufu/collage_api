package kr.ac.collage_api.vo;

import lombok.Data;

//교직원 테이블
@Data
public class SklstfVO {
	private String sklstfId;       //교직원ID(PK)	SKLSTF_ID(PK)
	private String acntId;         //계정ID(FK)	ACNT_ID(FK)
	private String sklstfNm;       //교직원명	SKLSTF_NM
	private String ecnyDe;         //입사일자	ECNY_DE
	private String retireDe;       //퇴사일자	RETIRE_DE
	private String brthdy;         //생년월일	BRTHDY
	private String cttpc;          //연락처	CTTPC
	private String emgncCttpc;     //비상연락처	EMGNC_CTTPC
	private String psitnDept;      //소속부서	PSITN_DEPT
	private String rspofc;         //직책	RSPOFC
	private String hffcSttus;      //재직상태	HFFC_STTUS
	private String bankNm;         //은행명	BANK_NM
	private String acnutno;        //계좌번호	ACNUTNO
	private String bassAdres;      //기본주소	BASS_ADRES
	private String detailAdres;    //상세주소	DETAIL_ADRES
	private String zip;            //우편번호	ZIP
}





	

	


	
	

	
