package kr.ac.collage_api.vo;

import lombok.Data;

//등록금 납부정보
@Data
public class PayInfoVO {
	private int payNo;          //납부번호(PK)	PAY_NO(PK)
	private int registCtNo;     //등록비번호(FK)	REGIST_CT_NO(FK)
	private String stdntNo;     //학생번호(FK)	STDNT_NO(FK)
	private String payDe;       //납부일자	PAY_DE
	private int payGld;         //납부금	PAY_GLD
	private String payMthd;     //납부방식	PAY_MTHD
	private String paySttus;    //납부상태	PAY_STTUS
	private int schlship;       //장학금	SCHLSHIP
}


