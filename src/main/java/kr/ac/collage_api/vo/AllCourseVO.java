package kr.ac.collage_api.vo;

import java.util.Date;

import lombok.Data;

//전체강의
@Data
public class AllCourseVO {
	private String lctreCode;   //강의코드(PK)	LCTRE_CODE(PK)
	private String subjctCode;  //학과코드(FK)	SUBJCT_CODE(FK)
	private String preLecture;  //선수_강의(FK)	PRE_LECTURE(FK)
	private String lctreNm;     //강의명	LCTRE_NM
	private String operAt;      //운영여부	OPER_AT	
	private Date recentUpdtDt;  //최근수정일시	RECENT_UPDT_DT	
	
	// 강의 개설 시 필요 (estbl_course 데이터)
	private String estbllctreCode;           //개설강의코드(PK)	ESTBLLCTRE_CODE(PK)
	private int acqsPnt;                     //취득학점	ACQS_PNT
	private String complSe;                  //이수구분	COMPL_SE
	private String profsrNo;
}

