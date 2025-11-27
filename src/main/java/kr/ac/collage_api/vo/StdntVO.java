package kr.ac.collage_api.vo;

import java.util.Date;

import lombok.Data;

//학생 테이블
@Data
public class StdntVO {
	private String stdntNo;      //학생번호(PK)	STDNT_NO(PK)
	private String acntId;       //계정ID(FK)	ACNT_ID(FK)
	private String subjctCode;   //학과코드(FK)	SUBJCT_CODE(FK)
	private String stdntNm;      //학생명	STDNT_NM
	private String brthdy;       //생년월일	BRTHDY
	private String bassAdres;    //기본주소	BASS_ADRES
	private String detailAdres;  //상세주소	DETAIL_ADRES
	private String zip;          //우편번호	ZIP
	private String cttpc;        //연락처	CTTPC
	private String emgncCttpc;   //비상연락처	EMGNC_CTTPC
	private String grade;        //학년	GRADE
	private String sknrgsSttus;  //학적상태	SKNRGS_STTUS
	private String entschDe;     //입학일자	ENTSCH_DE
	private String grdtnDe;      //졸업일자	GRDTN_DE
	private String bankNm;       //은행명	BANK_NM
	private String acnutno;      //계좌번호	ACNUTNO
	private Date lastUpdatedTime;//최근수정일시	LAST_UPDATED_TIME
	private String fileNm;	//파일 이름

	private SubjctVO subjctVO;	 //학과
	private SubjctVO subjctNm;	 //이름

	private String univCode; //대학코드
}

