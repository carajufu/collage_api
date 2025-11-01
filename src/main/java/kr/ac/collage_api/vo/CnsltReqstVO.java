package kr.ac.collage_api.vo;

import lombok.Data;

@Data
public class CnsltReqstVO {
	private int cnsltReqstInnb;     //상담_신청_고유번호(PK)
	private String reqstDe;         //신청_일
	private String cnsltSttus;      //상담_상태
	private String cnsltRequstCn;   //상담_요청_내용
	private int cnsltInnb;          //상담_고유번호(FK)
	private String stdntNo;         //학생_번호(FK)
	private String canclReason;     //취소_이유
	
}



