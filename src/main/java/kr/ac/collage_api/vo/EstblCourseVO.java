package kr.ac.collage_api.vo;

import lombok.Data;

//개설강의
@Data
public class EstblCourseVO {
	private String estbllctreCode;           //개설강의코드(PK)	ESTBLLCTRE_CODE(PK)
	private String lctreCode;                //강의코드(FK)	LCTRE_CODE(FK)
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
	
//	private AllCourseVO lctreNm;
//	
//	private LctreTimetableVO lctreDfk;
//	private LctreTimetableVO beginTm;
//	private LctreTimetableVO endTm;
//	
//	private SklstfVO sklstfNm;
//	private SklstfVO cttpc;
//	
//	private ProfsrVO labrumLc;
	
	private LctreTimetableVO timetable;		//lctreDfk(LCTRE_DFK), beginTm(BEGIN_TM), endTm(END_TM)
	private AllCourseVO allCourse;			//lctreNm(LCTRE_NM)
	private SklstfVO sklstf;				//sklstfNm(SKLSTF_NM), cttpc(CTTPC)
	private ProfsrVO profsr;				//labrumLc(LABRUM_LC)
	
	
	private List<EstblCourseVO> estblCourseVOlist;
}



