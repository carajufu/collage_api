package kr.ac.collage_api.vo;

import lombok.Data;

//권한
@Data
public class AuthorVO {
	private String authorId;   //권한ID(PK)	AUTHOR_ID(PK)
	private String alwncDe;    //부여일자	ALWNC_DE
	private String authorNm;   //권한_명	AUTHOR_NM
	private String authorDc;   //권한_설명	AUTHOR_DC
	private String acntId;    //계정_ID(FK)
}



