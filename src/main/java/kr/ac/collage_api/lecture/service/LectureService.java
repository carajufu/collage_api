package kr.ac.collage_api.lecture.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.vo.EstblCourseVO;

public interface LectureService {

	// 개설 강의 조회
	public List<EstblCourseVO> list(Map<String, Object> map);

	// 담당 강의 목록 조회(교수)
	public List<EstblCourseVO> mylist(Map<String, Object> map);

	// 강의 세부 정보
	public EstblCourseVO detail(EstblCourseVO estblCourseVO);

	// 강의 세부 정보(비동기)
	public EstblCourseVO detailAjax(String estbllctreCode);
	
	// 강의 세부 정보 수정(교수)
	public int edit(EstblCourseVO estblCourseVO);

}
