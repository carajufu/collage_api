package kr.ac.collage_api.vo;

import lombok.Data;

//공통코드그룹
@Data
public class CmmnCodeGroupVO {
	private String groupCode; // 그룹코드(PK) GROUP_CODE(PK)
    private String groupNm;   // 그룹명 GROUP_NM
    private String groupDc;   // 그룹설명 GROUP_DC
    private String useAt;	  // 사용여부 USE_AT
}
