package kr.ac.collage_api.grade.vo;

import lombok.Data;

@Data
public class GradeScreVO {

    // ----------------------교수용/과목 성적 ----------------------
    private String profsrNo;			//교수_번호(PK)
    private String estbllctreCode;		//개설강의코드(PK)	ESTBLLCTRE_CODE(PK)
    private String lctreCode;			//강의코드(FK)	LCTRE_CODE(FK)
    private String lctrum;				//강의명	LCTRE_NM
    private String lctreNm;				//강의실	LCTRUM
    private String complSe;				//이수구분	COMPL_SE
    private String estblYear;			//개설년도	ESTBL_YEAR
    private String estblSemstr;			//개설학기	ESTBL_SEMSTR
    private String stdntNo;				//학생번호(PK)	STDNT_NO(PK)
    private String stdntNm;				//학생명	STDNT_NM
    private String atnlcReqstNo;		//수강신청번호(FK)	ATNLC_REQST_NO(FK)
    private double atendScore;			//출석점수	ATEND_SCORE
    private double taskScore;			//과제점수	TASK_SCORE
    private double middleScore;			//중간점수	MIDDLE_SCORE
    private double trmendScore;			//기말점수	TRMEND_SCORE
    private double sbjectTotpoint;		//과목_총점	SBJECT_TOTPOINT
    private String pntGrad;				//학점등급	PNT_GRAD
    private double pntAvrg;				//평점_평균	PNT_AVRG
    

    // ---------------------- 학생용 학기별 성적 ----------------------
    private String semstrScreInnb;  // 학기성적 PK (SEMSTR_SCRE_INNB)
    private String year;            // 년도 (YEAR)
    private String semstr;          // 학기 (SEMSTR)
    private double semstrTotpoint;  // 학기 총점 (SEMSTR_TOTPOINT)
    private int totAcqsPnt;         // 학기 총취득학점 (TOT_ACQS_PNT)
    private int acqsPnt;            // 이수학점 (ACQS_PNT)
    
    // 학기별 과목 성적 개수 (4개 이상일 때만 총점/평균/등급 표시용)
    private Integer sbjectCnt;
}
