package kr.ac.collage_api.vo;

import java.util.Date;

import lombok.Data;

//상담_가능_여부 테이블(교수에 의해 먼저 생성됨)
@Data
public class CnsltAtVO {
	private int cnsltInnb;         //상담_고유번호(PK)
	private Date cnsltBeginDe;     //상담_시작_일시
	private String sttus;          //상태 	    1:상담가능,2:예약완료,3,상담취소,4상담완료
	private String cnsltMthd;      //상담_방식    OFFLINE,VIDEO
	private String cnsltResult;    //상담_결과
	private Date registDt;         //등록_일시    SYSDATE
	private String profsrNo;       //교수_번호(FK)
	private String cnsltBeginTime; //상담 시작 시간
	private String cnsltEndTime;   //상담 끝 시간

}












