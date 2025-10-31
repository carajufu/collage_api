package kr.ac.collage_api.lecture.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.lecture.mapper.LectureMapper;
import kr.ac.collage_api.lecture.service.LectureService;
import kr.ac.collage_api.vo.EstblCourseVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class LectureServiceImpl implements LectureService {

	@Autowired
	LectureMapper lectureMapper;
	
	// 개설 강의 조회
	@Override
	public List<EstblCourseVO> list(Map<String, Object> map) {
		return this.lectureMapper.list(map);
	}
	
	// 담당 강의 목록 조회(교수)
	@Override
	public List<EstblCourseVO> mylist(Map<String, Object> map) {
		return this.lectureMapper.mylist(map);
	}

	// 강의 세부 정보
	@Override
	public EstblCourseVO detail(EstblCourseVO estblCourseVO) {
		return this.lectureMapper.detail(estblCourseVO);
	}

	// 강의 세부 정보(ajax)
	@Override
	public EstblCourseVO detailAjax(String estbllctreCode) {
		return this.lectureMapper.detailAjax(estbllctreCode);
	}

	// 강의 세부 정보 수정(교수)
	@Transactional
	@Override
	public int edit(EstblCourseVO estblCourseVO) {
		/*
		EstblCourseVO(estbllctreCode=dswef, lctreCode=null, profsrNo=null, fileGroupNo=0, acqsPnt=0, lctrum=B1101
		, complSe=null, atnlcNmpr=0, lctreUseLang=null, evlMthd=null, atendScoreReflctRate=0, taskScoreReflctRate=0
		, middleTestScoreReflctRate=0, trmendTestScoreReflctRate=0, estblYear=null
		, estblSemstr=1, timetable=null, allCourse=null, sklstf=null, profsr=null, estblCourseVOlist=null)
		 */
		log.info("editEstbl()->estblCourseVO : {}", estblCourseVO);
		
		int result = 0;
		//강의실 정보 변경
		
		result += lectureMapper.editEstbl(estblCourseVO);
		//시간표 정보 변경
		result += lectureMapper.editTimetable(estblCourseVO);
		
		log.info("edit()->result : {}", result);
		
		return result;
	}

}
