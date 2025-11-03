package kr.ac.collage_api.lecture.vo;

import java.util.Date;
import lombok.Data;

@Data
public class LectureEvlVO {

	// ------------------------------------------------------------
	// LCTRE_EVL (강의평가 요약)
	// ------------------------------------------------------------
	private int evlNo;                   //평가번호(PK)
	private int allEvlAvrg;              //전체평가평균

	// ------------------------------------------------------------
	// LCTRE_EVL_IEM (강의평가 항목)
	// ------------------------------------------------------------
	private int lctreEvlInnb;            //강의평가항목고유번호(PK)
	private String evlCn;                //평가내용
	private int evlScore;                //평가점수

	// ------------------------------------------------------------
	// LCTRE_EVL_SCORE (학생별 평가 제출내역)
	// ------------------------------------------------------------
	private String stdntNo;              //학생번호(FK)
	private String stdntNm;              //학생명 (조인 필요)
	private int submitScore;             //학생이 제출한 점수
	private String submitCn;             //학생이 작성한 의견

	//  강의평가 요약 통계 (JSP 요약박스 표시용)
	private double avgScore;             //평균점수 (AVG)
	private int evlCnt;                  //평가참여학생수 (COUNT)

	// ------------------------------------------------------------
	// LCTRE_TIMETABLE (강의 시간표)
	// ------------------------------------------------------------
	private int timetableNo;             //시간표번호(PK)
	private String lctreDfk;             //강의요일
	private int beginTm;                 //시작시각
	private int endTm;                   //종료시각

	// ------------------------------------------------------------
	// ALL_COURSE (강의 기본정보)
	// ------------------------------------------------------------
	private String lctreCode;            //강의코드(PK)
	private String subjctCode;           //학과코드(FK)
	private String preLecture;           //선수_강의(FK)
	private String lctreNm;              //강의명
	private String operAt;               //운영여부	
	private Date recentUpdtDt;           //최근수정일시

	// ------------------------------------------------------------
	// ESTBL_COURSE (개설강의 정보)
	// ------------------------------------------------------------
	private String estbllctreCode;       //개설강의코드(PK)
	private String profsrNo;             //교수번호(FK)
	private String profsrNm;             // 교수명 (조인 필요)
	private int acqsPnt;                 //취득학점
	private String lctrum;               //강의실
	private String complSe;              //이수구분
	private int atnlcNmpr;               //수강인원
	private String lctreUseLang;         //강의사용언어
	private String evlMthd;              //평가방식
	private int atendScoreReflctRate;    //출석반영비율
	private int taskScoreReflctRate;     //과제반영비율
	private int middleTestScoreReflctRate; //중간반영비율
	private int trmendTestScoreReflctRate; //기말반영비율
	private String estblYear;            //개설년도
	private String estblSemstr;          //개설학기

	// ------------------------------------------------------------
	// STDNT 수강신청 (평가자 확인용)
	// ------------------------------------------------------------
	private String atnlcReqstNo;         //수강신청번호
	private String reqstYear;            //신청년도
	private String reqstSemstr;          //신청학기
	private String reqstSttus;           //신청상태
	private String reqstDe;              //신청일자
}
