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
}

