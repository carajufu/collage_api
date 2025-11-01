package kr.ac.collage_api.vo.lecture;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;

import kr.ac.collage_api.vo.LctreEvlVO;
import lombok.Data;

@Data
public class StdntLectureVO {
	
	@Autowired
	LctreEvlVO LctreEvlVO;
	
	
	private String atnlcReqstNo;	//수강신청
	private String reqstYear;		//신청년도
	private String reqstSemstr;		//신청학기
	private String reqstSttus;		//신청상태
	private Date reqstDe;			//신청일
	private Date recentUpdtTime;	//최근수정시간
	private String stdntId;     	//학생Id 
	
	//LCTRE_EVL_IEM
	private int lctreEvlInnb;   	//강의평가 고유번호
	private String evlCn;       	//평가 내용   
	private int evlScore;       	//평가 점수   

	
	//LCTRE_TIMETABLE
	private int timetableNo;    	//시간표 번호  
	private String lctreDfk;    	//강의 요일   
	private Date beginTm;        	//시작 시간   
	private Date endTm;          	//종료 시각 

	//ESTBL_COURSE
	private String estblCourseId;	//개설교과목Id 
	private int acqsPnt;             //취득 학점                
	private int lctreCo;             //강의 횟수                
	private int lctreTime;           //강의 시간                
	private String complSe;          //이수 구문                
	private int atnlcNmpr;           //수강 인원                
	private String lctreUseLang;     //강의 사용 언어             
	private String evlMthd;          //평가 방식                
	private String estblYear;        //개설 년도                
	private String estblSemstr;      //개설 학기                
	private String lctreCode;        //강의 코드                
	private String profsrNo;         //교수 번호                
	
	private String lctreNm;
	
}



















