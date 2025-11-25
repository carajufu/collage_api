package kr.ac.collage_api.vo;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class PayInfoVO {

	private int payNo;
	private int registCtNo;
	private String stdntNo;
	private String payDe;
	private int payGld;
	private String payMthd;
	private String paySttus;

	private String stdntNm;
	private String payYear;

	private String rqestDe;
	private String payEndde;

	private String rqestYear;
	private String rqestSemstr;

	private String rqestUniv;
	private String subjctCode;

	private String rqestGrade;

	private int rqestGld;

	private String vrtlAcntno;

	private String subjctName;
	private String univName;
}
