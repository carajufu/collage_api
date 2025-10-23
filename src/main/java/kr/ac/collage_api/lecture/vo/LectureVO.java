package kr.ac.collage_api.lecture.vo;

import java.util.Date;

import lombok.Data;

@Data
public class LectureVO {
	private int evlNo;          	//평가 번호   
	private int allEvlAvrg;     	//전체 평가 평균
	private String estblCourseId;	//개설교과목Id 
	private int lctreEvlInnb;   	//강의평가 고유번
	private String evlCn;       	//평가 내용   
	private int evlScore;       	//평가 점수   
	private String stdntId;     	//학생Id    
	private int timetableNo;    	//시간표 번호  
	private String lctreDfk;    	//강의 요일   
	private int beginTm;        	//시작 시간   
	private int endTm;          	//종료 시각 
	
	private String lctreCode;       //강의코드    
	private String lctreNm;         //강의 명    
	private Date recentUpdtTime;    //최근수정시간  
	private String operAt;          //운영여부    
	private String lctreCode2;      //강의코드2   
	private String subjctId;        //학과ID    
	
}










