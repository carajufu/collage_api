package kr.ac.collage_api.lecture.vo;

import java.util.Date;

import lombok.Data;

@Data
public class LectureVO {
	//Prof
	
	//LCTRE_EVL
	private int evlNo;                   //평가번호(PK)	EVL_NO(PK)
	private int allEvlAvrg;              //전체평가평균	ALL_EVL_AVRG
	
	//LCTRE_EVL_IEM
	private int lctreEvlInnb;      //강의평가고유번호(PK)	LCTRE_EVL_INNB(PK)
	private String evlCn;          //평가내용	EVL_CN
	private int evlScore;          //평가점수	EVL_SCORE
	
	//LCTRE_TIMETABLE
	private int timetableNo;          //시간표번호(PK)	TIMETABLE_NO(PK)
	private String lctreDfk;          //강의요일	LCTRE_DFK
	private int beginTm;              //시작시각	BEGIN_TM
	private int endTm;                //종료시각	END_TM

	//All_COURSE
	private String lctreCode;   //강의코드(PK)	LCTRE_CODE(PK)
	private String subjctCode;  //학과코드(FK)	SUBJCT_CODE(FK)
	private String preLecture;  //선수_강의(FK)	PRE_LECTURE(FK)
	private String lctreNm;     //강의명	LCTRE_NM
	private String operAt;      //운영여부	OPER_AT	
	private Date recentUpdtDt;  //최근수정일시	RECENT_UPDT_DT	  

	//ESTBL_COURSE
	private String estbllctreCode;           //개설강의코드(PK)	ESTBLLCTRE_CODE(PK)
	private String profsrNo;                 //교수번호(FK)	PROFSR_NO(FK)
	private int fileGroupNo;                 //파일그룹번호(FK)	FILE_GROUP_NO(FK)
	private int acqsPnt;                     //취득학점	ACQS_PNT
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
	
	
	//Stdnt
	private String atnlcReqstNo;     //수강신청번호(PK)    
	private String stdntNo;          //학생번호(FK)	      
	private String reqstYear;        //신청년도		                        
	private String reqstSemstr;      //신청학기		                    
	private String reqstSttus;       //신청상태		                    
	private String reqstDe;          //신청일자		
}










