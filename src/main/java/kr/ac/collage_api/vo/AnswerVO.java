package kr.ac.collage_api.vo;

import java.sql.Date;

import lombok.Data;

//게시판-댓글
@Data
public class AnswerVO {
	private int answerNo;         //댓글_번호(PK)
	private String answerCn;      //댓글_내용
	private Date answerWritngDt;  //댓글_작성_일시
	private int bbscttNo;         //게시글_번호(FK)
	private int parntsAnswerNo;   //부모_댓글_번호(FK)
}



