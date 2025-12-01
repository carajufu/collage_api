package kr.ac.collage_api.vo;

import lombok.Data;
import lombok.ToString;

@Data
public class PayInfoVO {

    private int payNo;            // PAY_NO
    private int registCtNo;       // REGIST_CT_NO
    private String stdntNo;       // STDNT_NO
    private String payDe;         // PAY_DE
    private int payGld;           // PAY_GLD
    private String payMthd;       // PAY_MTHD
    private String paySttus;      // PAY_STTUS
    private int schlship;         // SCHLSHIP
    private String vrtlAcntno;    // VRTL_ACNTNO

    private String rqestYear;     // RQEST_YEAR
    private String rqestSemstr;   // RQEST_SEMSTR
    private String rqestDe;       // RQEST_DE
    private String payEndde;      // PAY_ENDDE
    private String rqestUniv;     // RQEST_UNIV
    private int rqestGld;         // RQEST_GLD
    private String rqestGrade;    // RQEST_GRADE
    private String stdntNm;       // STDNT_NM
    private String subjctName;    // SUBJCT_NAME
    private String univName;      // UNIV_NAME
}