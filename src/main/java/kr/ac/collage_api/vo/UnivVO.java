package kr.ac.collage_api.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

//단과대학 테이블
@Data
public class UnivVO {
	private String univCode;   //대학코드(PK)	UNIV_CODE(PK)
	private String profsrNo;   //학장(FK)	PROFSR_NO(FK)
	private String univNm;     //대학명	UNIV_NM
	private String buldLc;     //건물위치(FK)	BULD_LC(FK)
	private String univTelno;  //대학전화번호	UNIV_TELNO
	private String fondYear;   //설립년도	FOND_YEAR
	private int operSttus;     //운영상태	OPER_STTUS
	private Date recentUpdtDt; //최근수정일시	RECENT_UPDT_DT
	
	private List<SubjctVO> children; //학과목록
	private List<ProfsrVO> profsr; //교수목록
	
	private String prexNm; 		//학장 이름 (SKLSTF_NM)
	private String buldNm;		//단과대 이름 (CODE_NM)
}



