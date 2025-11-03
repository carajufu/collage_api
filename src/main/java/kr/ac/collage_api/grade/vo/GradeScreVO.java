package kr.ac.collage_api.grade.vo;

import lombok.Data;

@Data
public class GradeScreVO {

    // ----------------------교수용/과목 성적 ----------------------
    private String profsrNo;
    private String estbllctreCode;
    private String lctreCode;
    private String lctreNm;
    private String lctrum;
    private String complSe;
    private String estblYear;
    private String estblSemstr;
    private String stdntNo;
    private String stdntNm;
    private String atnlcReqstNo;
    private double atendScore;
    private double taskScore;
    private double middleScore;
    private double trmendScore;
    private double sbjectTotpoint;
    private String pntGrad;
    private double pntAvrg;
    

    // ---------------------- 학생용 학기별 성적 ----------------------
    private String semstrScreInnb;  // 학기성적 PK (SEMSTR_SCRE_INNB)
    private String year;            // 년도 (YEAR)
    private String semstr;          // 학기 (SEMSTR)
    private double semstrTotpoint;  // 학기 총점 (SEMSTR_TOTPOINT)
    private int totAcqsPnt;         // 학기 총취득학점 (TOT_ACQS_PNT)
    private int acqsPnt;            // 이수학점 (ACQS_PNT)
}