package kr.ac.collage_api.vo;

import lombok.Data;
import lombok.ToString;
import java.lang.Integer;

@ToString
//등록금
@Data
public class RegistCtVO {
	private int registCtNo; // 등록비번호(PK) REGIST_CT_NO(PK)
	private String subjctCode; // 학과코드(FK) SUBJCT_CODE(FK)
	private String rqestYear; // 청구년도 RQEST_YEAR
	private String rqestSemstr; // 청구학기 RQEST_SEMSTR
	private String rqestUniv; // 청구대학 RQEST_UNIV
	private String rqestGrade; // 청구학년 RQEST_GRADE
	private int rqestGld; // 청구금 RQEST_GLD
	private String rqestDe; // 청구일자 RQEST_DE
	private String payEndde; // 납부만료일 PAY_ENDDE

	private Integer schlship; // 장학금 금액 <-- 나중에 추가하게 되면 사용할 것. 지금은 없어도 되긴 함!

	private String subjctName;
	private String univName;
}
