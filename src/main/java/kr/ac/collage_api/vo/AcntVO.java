package kr.ac.collage_api.vo;

import lombok.Data;

import java.util.List;

//계정
@Data
public class AcntVO {                      
	private String acntId;   //계정_ID(PK)	  
	private String password; //비밀번호        
	private String acntTy;   //계정_유형
    private String fileGroupNo;

    private List<AuthorVO> authorVOList;
}


