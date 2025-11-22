package kr.ac.collage_api.account.dto;

import lombok.Data;

@Data
public class ProfSelectEditDetailDTO {
	public String profsrNo;   //교번, sklstfId 와 동일 / 자동생성
	public String subjctCode; //학과코드
	public String clsf;       //정교수, 부교수
	public String labrumLc;   //사무실
	public String nlty;      //국적
	public String emailAdres; //이메일주소

	/*sklstf 교직원 table*/
	public String sklstfNm;   //이름
	public String ecnyDe;     //입사일  input type은 Date 지만 string으로 받고 서버에서 하이픈 제거
	public String retireDe;   //퇴사일
	public String brthdy;     //생일
	public String cttpc;      //전화번호
	public String emgncCttpc; //임시전화번호
	public String psitnDept;  //소속부서 한글로 "학과"이름 들어감
	public String rspofc;     //정교수, 부교수, 조교수 profsr테이블의 clsf 와동일
	public String hffcSttus;  //재직상태 "1"로 표현  다른표현?
	public String bankNm;     //은행명
	public String acnutno;    //계좌명
	public String bassAdres;  //기분주소
	public String detailAdres; //상세주소
	public String zip;          //zip code

	public String univCode; //대학코드

}
