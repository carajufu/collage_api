package kr.ac.collage_api.vo;

import java.util.Date;

import lombok.Data;

//상담!
@Data
public class CnsltVO {

	private int cnsltInnb;            //상담고유번호(PK)	CNSLT_INNB(PK)
	private Date cnsltRequstDe;       //상담_요청_일	CNSLT_REQUST_DE
	private String cnsltRequstHour;   //상담요청시	CNSLT_REQUST_HOUR
	private String cnsltRequstCn;     //상담요청내용	CNSLT_REQUST_CN
	private Date reqstDe;             //신청_일	REQST_DE
	private String sttus;             //상태	STTUS 	1,(학생:상담예약 진행중)(교수: 상담예약대기중), 2.상담예약완료, 3.상담취소완료 4.상담 진행 완료
	private String cnsltMthd;         //상담방식	CNSLT_MTHD
	private String canclReason;       //취소이유	CANCL_REASON
	private String cnsltResult;       //상담결과	CNSLT_RESULT
	private String profsrNo;          //교수번호(FK)	PROFSR_NO(FK)
	private String stdntNo;           //학생번호(FK)	STDNT_NO(FK)
	
	//상담디테일 보려고 가져감
	private String sklstfNm;     //교직원명	SKLSTF_NM
	
	//카운트
	private int cnt;		// 통계를 위한
	
	
	//페이징을 위한 rnum 가져옴
	private int rnum;

}



