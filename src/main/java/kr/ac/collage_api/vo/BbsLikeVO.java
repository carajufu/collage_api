package kr.ac.collage_api.vo;

import lombok.Data;

@Data
public class BbsLikeVO {
	private int bbscttLikeInnb; //게시글고유번호(PK)
	private String acntId;      //계정_ID(FK)
	private int bbscttNo;       //게시글_번호(FK)
}
