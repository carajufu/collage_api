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

//테이블 완성되면 나중에 vo, mapper, service, serviceImpl, controller 수정 필요함
