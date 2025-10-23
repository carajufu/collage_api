package kr.ac.collage_api.regist.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RegisterVO {
	private int regNo;
	private String stuId;
	private String year;
	private String semester;
	private int payAmount;
	private String payStatus;
	private String regDate;
}
