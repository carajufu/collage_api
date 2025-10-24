package kr.ac.collage_api.vo;

import lombok.Data;

@Data
public class SklstfVO {
	private String sklstfId;	//교직원_ID
	private String sklstfNm;	//교직원_명
	private String encpn;		//입사일
	private String brthdy;		//생년월일	
	private String cttpc;		//연락처
	private String psitnDept;	//소속_부서	
	private String rspofc;		//직책
	private String hffcSttus;	//재직_상태
	private String acntId;		//계정_ID(FK)	
	private int fileGroupNo;	//파일_그룹_번호(FK)
}


	

	

	
	

	
