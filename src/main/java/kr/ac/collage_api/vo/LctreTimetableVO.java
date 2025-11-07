package kr.ac.collage_api.vo;

import lombok.Data;

//강의시간표
@Data
public class LctreTimetableVO {
	private int timetableNo;          //시간표번호(PK)	TIMETABLE_NO(PK)
	private String estbllctreCode;    //개설강의코드(FK)	ESTBLLCTRE_CODE(FK)
	private String lctreDfk;          //강의요일	LCTRE_DFK
	private int beginTm;              //시작시각	BEGIN_TM
	private int endTm;                //종료시각	END_TM
<<<<<<< HEAD

	//상담할때 필요함
	private String profsrNo;    //교수_번호(PK)
	private String sklstfNm;     //교직원명	SKLSTF_NM

=======
>>>>>>> 26a4290 (please)
}




