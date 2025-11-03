package kr.ac.collage_api.grade.vo;

import java.util.Date;

import lombok.Data;

@Data
public class GradeVO {
	
	private String profsrNo;    //교수_번호(PK)
	
	private String stdntNo;      //학생번호(PK)	STDNT_NO(PK)
	private String stdntNm;      //학생명	STDNT_NM
	
	private int semstrScreInnb;   //학기성적고유번호(PK)	SEMSTR_SCRE_INNB(PK)
	private int totReqstPnt;      //총신청학점	TOT_REQST_PNT
	private int totAcqsPnt;       //총취득학점	TOT_ACQS_PNT
	private int pntAvrg;          //평점_평균	PNT_AVRG
	private int semstrTotpoint;   //학기_총점	SEMSTR_TOTPOINT
	private String semstr;        //학기	SEMSTR
	private String year;          //년도	YEAR
	
	private String estbllctreCode;           //개설강의코드(PK)	ESTBLLCTRE_CODE(PK)
	private String lctreCode;                //강의코드(FK)	LCTRE_CODE(FK)
	private String lctrum;                   //강의실	LCTRUM
	private String complSe;                  //이수구분	COMPL_SE
	private int atnlcNmpr;                   //수강인원	ATNLC_NMPR
	private String lctreUseLang;             //강의사용언어	LCTRE_USE_LANG
	private String evlMthd;                  //평가방식	EVL_MTHD
	private String estblYear;                //개설년도	ESTBL_YEAR
	private String estblSemstr;              //개설학기	ESTBL_SEMSTR
	
	private String subjctCode;  //학과코드(FK)	SUBJCT_CODE(FK)
	private String preLecture;  //선수_강의(FK)	PRE_LECTURE(FK)
	private String lctreNm;     //강의명	LCTRE_NM
	private String operAt;      //운영여부	OPER_AT	
	private Date recentUpdtDt;  //최근수정일시	RECENT_UPDT_DT	
	
	private int sbjectScreInnb;   //과목성적고유번호(PK)	SBJECT_SCRE_INNB(PK)
	private String atnlcReqstNo;  //수강신청번호(FK)	ATNLC_REQST_NO(FK)
	private String pntGrad;       //학점등급	PNT_GRAD
	private int acqsPnt;          //취득학점	ACQS_PNT
	private int atendScore;       //출석점수	ATEND_SCORE
	private int taskScore;        //과제점수	TASK_SCORE
	private int middleScore;      //중간점수	MIDDLE_SCORE
	private int trmendScore;      //기말점수	TRMEND_SCORE
	private int sbjectTotpoint;   //과목_총점	SBJECT_TOTPOINT

	
}
