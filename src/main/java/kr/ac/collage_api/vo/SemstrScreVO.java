package kr.ac.collage_api.vo;

import lombok.Data;

//학기별 성적
@Data
public class SemstrScreVO {
	private int semstrScreInnb;   //학기성적고유번호(PK)	SEMSTR_SCRE_INNB(PK)
	private String stdntNo;       //학생번호(FK)	STDNT_NO(FK)
	private int totReqstPnt;      //총신청학점	TOT_REQST_PNT
	private int totAcqsPnt;       //총취득학점	TOT_ACQS_PNT
	private int pntAvrg;          //평점_평균	PNT_AVRG
	private int semstrTotpoint;   //학기_총점	SEMSTR_TOTPOINT
	private String semstr;        //학기	SEMSTR
	private String year;          //년도	YEAR
}


