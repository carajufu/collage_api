package kr.ac.collage_api.vo;

import java.util.Date;
<<<<<<< HEAD
import java.util.List;
=======
>>>>>>> 6ae9e540d3b43b69545922be45285f7574a2c132

import lombok.Data;

//수강신청
@Data
public class AtnlcReqstVO {
	private String atnlcReqstNo;     //수강신청번호(PK)    
	private String stdntNo;          //학생번호(FK)	                
	private String estbllctreCode;   //개설강의코드(FK)    
	private String reqstYear;        //신청년도		                        
	private String reqstSemstr;      //신청학기		                    
	private String reqstSttus;       //신청상태		                    
	private String reqstDe;          //신청일자		                           
	private Date recentUpdtDt;       //최근수정일시	 	
	
	private EstblCourseVO estblCourse;
//	private LctreTimetableVO timetable;
	private AllCourseVO allCourse;
	private SklstfVO sklstf;
	private ProfsrVO profsr;
	
	private List<String> estbllctreCodes;
	
	
}
