package kr.ac.collage_api.vo;

import lombok.Data;

//교수학위
@Data
public class ProfsrDgriVO {
	private String dgriNo;    //학위번호(PK)	DGRI_NO(PK)
	private String profsrNo;  //교수번호(FK)	PROFSR_NO(FK)
	private String major;     //전공	MAJOR
	private String lastDgri;  //최종학위	LAST_DGRI
	private String acqsEngn;  //취득기관	ACQS_ENGN
	private String acqsDe;    //취득일자	ACQS_DE
}


