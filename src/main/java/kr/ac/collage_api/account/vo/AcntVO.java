package kr.ac.collage_api.account.vo;

import lombok.Data;

//계정
@Data
public class AcntVO {                      
	private String acntId;   //계정_ID(PK)	  
	private String password; //비밀번호        
	private String acntTy;   //계정_유형       
}                                          


