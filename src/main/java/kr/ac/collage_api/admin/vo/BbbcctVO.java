package kr.ac.collage_api.admin.vo;

import lombok.Data;

//게시판-좋아요
@Data
public class BbbcctVO {
	private int bbscttLikeInnb; //게시글고유번호(PK)
	private String acntId;      //계정_ID(FK)
	private int bbscttNo;       //게시글_번호(FK)
}

