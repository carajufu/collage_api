package kr.ac.collage_api.chatbot.vo;

import java.util.Date;

import lombok.Data;

@Data	
public class ChatBotVO {
	//학생
	private String atnlcReqstNo;     //수강신청번호(PK)     
	private String stdntNo;          		 //학생번호(FK)	
	private String reqstYear;        //신청년도		                        
	private String reqstSemstr;      //신청학기		                    
	private String reqstSttus;       //신청상태		                    
	private String reqstDe;          //신청일자		   
	private Date recentUpdtDt;       //최근수정일시
	
	private String estbllctreCode;           //개설강의코드(PK)	ESTBLLCTRE_CODE(PK)
	private long fileGroupNo;                 //파일그룹번호(FK)	FILE_GROUP_NO(FK) 오버플로우로 인한 long타입으로 변경
	private int acqsPnt;                     //취득학점	ACQS_PNT
	private String lctrum;                   //강의실	LCTRUM
	private String complSe;                  //이수구분	COMPL_SE
	private int atnlcNmpr;                   //수강인원	ATNLC_NMPR
	private String evlMthd;                  //평가방식	EVL_MTHD
	private String estblYear;                //개설년도	ESTBL_YEAR
	private String estblSemstr;              //개설학기	ESTBL_SEMSTR
	private String lctreCode;   //강의코드(PK)	LCTRE_CODE(PK)
	private String lctreNm;     //강의명	LCTRE_NM	
	
	//교수
	private String weekAcctoLrnNo;   // WEEK_ACCTO_LRN_NO  (주차별학습번호)
	private int week;                // WEEK               (주차)
	private String taskAt;           // TASK_AT            (과제여부)
	private String lrnThema;         // LRN_THEMA          (학습주제)
	private String lrnCn;            // LRN_CN             (학습내용)
	private String quizAt;           // QUIZ_AT            (퀴즈여부)
	private String profsrNo;         // PROFSR_NO          (교수번호)
	private String taskNo;           // TASK_NO            (과제번호)
	private String taskSj;           // TASK_SJ            (과제제목 / 과제명)
	private String taskCn;           // TASK_CN            (과제내용)
	private String taskBeginDe;      // TASK_BEGIN_DE      (과제시작일자)
	private String taskClosDe;       // TASK_CLOS_DE       (과제마감일자)
	private String taskPresentnNo;   // TASK_PRESENTN_NO   (과제제출번호)
	private String presentnAt;       // PRESENTN_AT        (제출여부)

}
