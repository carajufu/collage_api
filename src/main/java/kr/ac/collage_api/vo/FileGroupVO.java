package kr.ac.collage_api.vo;

import java.sql.Date;
import java.util.List;

import lombok.Data;

//파일그룹
@Data
public class FileGroupVO {
	private long fileGroupNo;	//파일_그룹_번호
	private Date fileRegistDe;  //파일_등록_날짜
	
	//FILE_GROUP : FILE_DETAIL = 1:N
	private List<FileDetailVO> fileDetailVOList;
}



