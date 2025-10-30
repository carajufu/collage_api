package kr.ac.collage_api.vo;

import lombok.Data;

//과목별 성적
@Data
public class SbjectScreVO {
	private int sbjectScreInnb;   //과목성적고유번호(PK)	SBJECT_SCRE_INNB(PK)
	private int semstrScreInnb;   //학기성적고유번호(FK)	SEMSTR_SCRE_INNB(FK)
	private String atnlcReqstNo;  //수강신청번호(FK)	ATNLC_REQST_NO(FK)
	private String pntGrad;       //학점등급	PNT_GRAD
	private int acqsPnt;          //취득학점	ACQS_PNT
	private int atendScore;       //출석점수	ATEND_SCORE
	private int taskScore;        //과제점수	TASK_SCORE
	private int middleScore;      //중간점수	MIDDLE_SCORE
	private int trmendScore;      //기말점수	TRMEND_SCORE
	private int sbjectTotpoint;   //과목_총점	SBJECT_TOTPOINT
	
}


