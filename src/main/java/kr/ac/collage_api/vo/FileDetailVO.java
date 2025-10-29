package kr.ac.collage_api.vo;

import java.sql.Date;

import lombok.Data;

//파일디테일
@Data
public class FileDetailVO {        
	private int fileNo;           //파일_번호(PK)
	private long fileGroupNo;      //파일_그룹_번호(PK)(FK)
	private String fileNm;        //파일_이름
	private String fileStreNm;    //파일_저장_이름
	private String fileStreplace; //파일_저장장소
	private long fileMg;           //파일_크기
	private String fileExtsn;     //파일_확장자
	private String fileTy;        //파일_타입
	private Date fileStreDe;      //파일_저장_날짜
	private int fileDwldCo;       //파일_다운로드_수
}

