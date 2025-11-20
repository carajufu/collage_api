package kr.ac.collage_api.chatbot.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ChatBotVO {

    /* ----------------------- 학생 영역 ----------------------- */

    private String atnlcReqstNo;     // ATNLC_REQST_NO (수강신청번호)
    private String stdntNo;          // STDNT_NO (학생번호)
    private String estbllctreCode;   // ESTBLLCTRE_CODE (개설강의코드)
    private String reqstYear;        // REQST_YEAR (신청년도)
    private String reqstSemstr;      // REQST_SEMSTR (신청학기)
    private String reqstSttus;       // REQST_STTUS (신청상태)
    private String reqstDe;          // REQST_DE (신청일자)
    private Date recentUpdtDt;       // RECENT_UPDT_DT (최근수정일시)

    // ESTBL_COURSE B
    private String profsrNo;         // PROFSR_NO
    private long fileGroupNo;        // FILE_GROUP_NO
    private int acqsPnt;             // ACQS_PNT (취득학점)
    private String lctrum;           // LCTRUM (강의실)
    private String complSe;          // COMPL_SE (이수구분)
    private int atnlcNmpr;           // ATNLC_NMPR (수강인원)
    private String evlMthd;          // EVL_MTHD (평가방식)
    private String estblYear;        // ESTBL_YEAR (개설년도)
    private String estblSemstr;      // ESTBL_SEMSTR (개설학기)

    // ALL_COURSE C
    private String lctreCode;        // LCTRE_CODE (강의코드)
    private String lctreNm;          // LCTRE_NM (강의명)



    /* ----------------------- 교수 영역 ----------------------- */

    // WEEK_ACCTO_LRN A
    private String weekAcctoLrnNo;   // WEEK_ACCTO_LRN_NO (주차별학습번호)
    private int week;                // WEEK (주차)
    private String taskAt;           // TASK_AT (과제 여부)
    private String lrnThema;         // LRN_THEMA (학습주제)
    private String lrnCn;            // LRN_CN (학습내용)
    private String quizAt;           // QUIZ_AT (퀴즈 여부)

    // TASK B
    private String taskNo;           // TASK_NO
    private String taskSj;           // TASK_SJ (과제 제목)
    private String taskCn;           // TASK_CN (과제 내용)
    private String taskBeginDe;      // TASK_BEGIN_DE (과제 시작일)
    private String taskClosDe;       // TASK_CLOS_DE (과제 마감일)

    // TASK_PRESENTN C
    private String taskPresentnNo;   // TASK_PRESENTN_NO (과제 제출번호)
    private String presentnAt;       // PRESENTN_AT (제출 여부)

    /*  
     * LCTRE_TIMETABLE SELECT 시 사용되는 필드 (교수 시간표)
     * getProfLctreTime XML에서 사용됨
     */
    private String timetableNo;      // TIMETABLE_NO
    private String lctreDfk;         // LCTRE_DFK
    private String beginTm;          // BEGIN_TM
    private String endTm;            // END_TM
}
