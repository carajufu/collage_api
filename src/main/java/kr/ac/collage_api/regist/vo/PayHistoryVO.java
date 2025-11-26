package kr.ac.collage_api.regist.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class PayHistoryVO {
    private int payNo;
    private int registCtNo;
    private String stdntNo;
    private String payDe;
    private int payGld;
    private String payMthd;
    private String paySttus;
    private int schlship;
    private String vrtlAcntno;
    private String rqestYear;
    private String rqestSemstr;
}
