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
	//교직원VO에 있는거 가져옴 교수명임
	private String sklstfNm;     //교직원명	SKLSTF_NM
	private String subjctNm;      //학과명		SUBJCT_NM
	private String emailAdres;

}



