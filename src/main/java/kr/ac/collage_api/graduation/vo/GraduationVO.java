package kr.ac.collage_api.graduation.vo;

import java.util.Date;

import lombok.Data;

@Data
public class GraduationVO {

	//학기별성적
	private int semstrScreInnb;   //학기성적고유번호(PK)	SEMSTR_SCRE_INNB(PK)
	private int totReqstPnt;      //총신청학점	TOT_REQST_PNT
	private int totAcqsPnt;       //총취득학점	TOT_ACQS_PNT
	private int pntAvrg;          //평점_평균	PNT_AVRG
	private int semstrTotpoint;   //학기_총점	SEMSTR_TOTPOINT
	private String semstr;        //학기	SEMSTR
	private String year;          //년도	YEAR
    private int acqsPnt;            // 이수학점 (ACQS_PNT)

    //학적변동 신청
	private int sknrgsChangeInnb;          //학적변동고유번호(PK)	SKNRGS_CHANGE_INNB(PK)
	private String stdntNo;                //학생번호(FK)	STDNT_NO(FK)
	private String changeTy;                 //변경 유형  휴학신청인지, 복학신청인지
	private String tmpabssklTy;				//휴학유형   휴학할때 군휴학인지, 일반휴학인지..
	private String efectOccrrncSemstr;     //효력발생학기	EFECT_OCCRRNC_SEMSTR
	private String reqstResn;              //신청사유	REQST_RESN
	private Date changeReqstDt;            //변동신청일시	CHANGE_REQST_DT
	private String reqstSttus;             //신청상태	REQST_STTUS
	private Date confmComptDt;             //승인완료일시	CONFM_COMPT_DT
	private String returnResn;             //반려사유	RETURN_RESN
	private Date lastUpdtTm;               //최종수정일시	LAST_UPDT_TM

	//전체교과목
	private String lctreCode;   //강의코드(PK)	LCTRE_CODE(PK)
	private String subjctCode;  //학과코드(FK)	SUBJCT_CODE(FK)
	private String preLecture;  //선수_강의(FK)	PRE_LECTURE(FK)
	private String lctreNm;     //강의명	LCTRE_NM
	private String operAt;      //운영여부	OPER_AT
	private Date recentUpdtDt;  //최근수정일시	RECENT_UPDT_DT

	//개설교과목
	private String estbllctreCode;           //개설강의코드(PK)	ESTBLLCTRE_CODE(PK)
	private String profsrNo;                 //교수번호(FK)	PROFSR_NO(FK)
	private int fileGroupNo;                 //파일그룹번호(FK)	FILE_GROUP_NO(FK)
	private String lctrum;                   //강의실	LCTRUM
	private String complSe;                  //이수구분	COMPL_SE
	private int atnlcNmpr;                   //수강인원	ATNLC_NMPR
	private String lctreUseLang;             //강의사용언어	LCTRE_USE_LANG
	private String evlMthd;                  //평가방식	EVL_MTHD
	private int atendScoreReflctRate;        //출석점수반영비율	ATEND_SCORE_REFLCT_RATE
	private int taskScoreReflctRate;         //과제점수반영비율	TASK_SCORE_REFLCT_RATE
	private int middleTestScoreReflctRate;   //중간시험점수반영비율	MIDDLE_TEST_SCORE_REFLCT_RATE
	private int trmendTestScoreReflctRate;   //기말시험점수반영비율	TRMEND_TEST_SCORE_REFLCT_RATE
	private String estblYear;                //개설년도	ESTBL_YEAR
	private String estblSemstr;              //개설학기	ESTBL_SEMSTR




}
