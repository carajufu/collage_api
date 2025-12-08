package kr.ac.collage_api.grade.vo;

import java.util.List;

import lombok.Data;

@Data
public class GradeScreForm {
	
	//gradeVO의 데이터를 묶어서 컨트롤러에 전송하기 위한 매서드
	private List<GradeScreVO> grades;
	
}
