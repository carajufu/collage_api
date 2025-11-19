package kr.ac.collage_api.vo;

import java.util.List;

import lombok.Data;

//계정
@Data
public class AcntVO {
	private String acntId;    //계정_ID(PK)
	private long fileGroupNo;  //파일그룹번호
	private String password;  //비밀번호
	private String acntTy;    //계정_유형
	
	private List<AuthorVO> authorVOList;

    private String name;
    private String affiliation;
}
