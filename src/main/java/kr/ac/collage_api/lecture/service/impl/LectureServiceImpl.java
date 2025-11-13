package kr.ac.collage_api.lecture.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.lecture.controller.PlanUploadController;
import kr.ac.collage_api.lecture.mapper.LectureMapper;
import kr.ac.collage_api.lecture.service.LectureService;
import kr.ac.collage_api.vo.AllCourseVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class LectureServiceImpl implements LectureService {

	@Autowired
	LectureMapper lectureMapper;
	
	@Autowired
	PlanUploadController uploadController;
	
	// 개설 강의 조회
	@Override
	public List<EstblCourseVO> list(EstblCourseVO estblCourseVO) {
		return this.lectureMapper.list(estblCourseVO);
	}

	// 로그인한 계정의 교수 번호 검증
	@Override
	public String findProfsrNo(String acntId) {
		return this.lectureMapper.findProfsrNo(acntId);
	}
	
	// 담당 강의 목록 조회(교수)
	@Override
	public List<EstblCourseVO> mylist(Map<String, Object> map) {
		return this.lectureMapper.mylist(map);
	}

	// 강의 세부 정보(ajax)
	@Override
	public EstblCourseVO detail(String estbllctreCode) {
		return this.lectureMapper.detail(estbllctreCode);
	}

	// 강의 세부 정보 수정(교수)
	@Transactional
	@Override
	public int edit(EstblCourseVO estblCourseVO) {
		
		log.info("editEstbl()->estblCourseVO : {}", estblCourseVO);
		
		int result = 0;
		//강의실 정보 변경
		
		result += lectureMapper.editEstbl(estblCourseVO);
		//시간표 정보 변경
		result += lectureMapper.editTimetable(estblCourseVO);
		
		log.info("edit()->result : {}", result);
		
		return result;
	}
	
	// 강의 계획서 모달 띄우기
		@Override
		public EstblCourseVO loadPlanFile(String estbllctreCode) {
			return this.lectureMapper.loadPlanFile(estbllctreCode);
		}

	// 강의 계획서 업로드
	@Transactional
	@Override
	public int uploadPlan(EstblCourseVO estblCourseVO) {
		
		MultipartFile[] uploadFile = estblCourseVO.getUploadFile();
		
		if(uploadFile!=null) {
			if(uploadFile[0].getOriginalFilename().length()>0) {
				long fileGroupNo = this.uploadController.multiFileUpload(uploadFile);
				estblCourseVO.setFileGroupNo(fileGroupNo);
			}
		}
		
		int result = lectureMapper.uploadPlan(estblCourseVO);
		log.info("uploadPlan()->result(후) : {}", result);
		
		return result;
	}

	// 강의 계획서 다운로드
	@Override
	public FileDetailVO getFileDetail(long fileGroupNo) {
		return this.lectureMapper.getFileDetail(fileGroupNo);
	}


	// -------- <관리자> --------

	// 강의 생성
	@Override
	public int createCourse(AllCourseVO allCourseVO) {
		return this.lectureMapper.createCourse(allCourseVO);
	}

	// 개설 강의 목록 조회
	@Override
	public List<EstblCourseVO> allList(EstblCourseVO estblCourseVO) {
		return this.lectureMapper.allList(estblCourseVO);
	}
	
	
	

}
