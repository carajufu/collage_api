package kr.ac.collage_api.lecture.vo;

import java.util.List;

import lombok.Data;

@Data
public class LectureVO {

	// 개설교과목(ESTBL_COURSE) 테이블
	private String estblCourseId;	// 개설_교과목_ID ㅇ
	private int acqsPnt;			// 취득_학점	ㅇ
	private String complSe;			// 이수_구분	ㅇ
	private int atnlcNmpr;			// 수강_인원	ㅇ
	private String lctreUseLang;	// 강의_사용_언어	ㅇ
	private String evlMthd;			// 평가_방식	ㅇ
	private String estblYear;		// 개설_년도	
	private String estblSemstr;		// 개설_학기
	private String lctreCode;		// 강의_코드	
	private String profsrNo;		// 교수_번호	
	private String lctrum;			// 강의실
	
	// 전체교과목(ALL_COURSE) 테이블
//	private String lctreCode;
	private String lctreNm;			// 강의_명
//	private Data recentUpdtTime;	// 최근_수정_시간
	private String operAt;			// 운영_여부
	private String lctreCode2;		// 강의_코드2 (선수과목)
	private String subjctId;		// 학과_ID
	
	// 강의시간표(LCTRE_TIMETABLE) 테이블
	private int timetableNo;		// 시간표 번호
//	private String estblCourseId;	
	private String lctreDfk;		// 강의 요일
	private int beginTm;			// 시작 시각
	private int endTm;				// 종료 시각
	
	// 교직원(SKLSTF) 테이블
	private String sklstfNm;		// 교직원_명
	private String cttpc;			// 연락처
	
	private String labrumLc;		// 교수 연구실
	
	private List<LectureVO> lectureVOList;
	
}
