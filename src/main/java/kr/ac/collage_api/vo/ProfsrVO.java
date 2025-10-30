package kr.ac.collage_api.vo;

import lombok.Data;

//교수 테이블
@Data
public class ProfsrVO {

	private String profsrNo;    //교수_번호(PK)
	private String sklstfId;    //교직원_ID(FK)
	private String subjctCode;    //학과_코드(FK)
	private String clsf;        //직급
	private String labrumLc;    //연구실_위치
	private String nlty;        //국적
}



