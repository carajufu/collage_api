package kr.ac.collage_api.vo;

import lombok.Data;

//공통코드
@Data
public class CmmnCodeVO {
	private String codeNo;      // 코드번호(PK) CODE_NO(PK)
    private String groupCode;   // 그룹코드(FK) GROUP_CODE(FK)
    private String codeNm;      // 코드명 CODE_NM
    private String codeDc;      // 코드설명 CODE_DC
    private String useAt;		//사용여부 USE_AT
}
