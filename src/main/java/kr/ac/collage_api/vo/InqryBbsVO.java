package kr.ac.collage_api.vo;

import lombok.Data;

// 1:1 문의 게시판
@Data
public class InqryBbsVO {
	private int inqryInnb;          //문의고유번호(PK)	INQRY_INNB(PK)
	private String sklstfId;        //교직원ID(FK)	SKLSTF_ID(FK)
	private String stdntNo;         //학생번호(FK)	STDNT_NO(FK)
	private String inqryTy;         //문의유형	INQRY_TY
	private String inqrySj;         //문의제목	INQRY_SJ
	private String qestnCn;         //질문내용	QESTN_CN
	private String answerCn;        //리플내용	ANSWER_CN
	private String processSttus;    //처리상태	PROCESS_STTUS
	private String qestnDe;         //질문일자	QESTN_DE
	private String answerDe;        //답변일자	ANSWER_DE
}


