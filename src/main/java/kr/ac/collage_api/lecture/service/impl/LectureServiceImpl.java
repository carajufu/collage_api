package kr.ac.collage_api.lecture.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.common.attach.service.UploadController;
import kr.ac.collage_api.lecture.controller.PlanUploadController;
import kr.ac.collage_api.lecture.mapper.LectureMapper;
import kr.ac.collage_api.lecture.service.LectureService;
import kr.ac.collage_api.vo.AllCourseVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.ProfsrVO;
import kr.ac.collage_api.vo.WeekAcctoLrnVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class LectureServiceImpl implements LectureService {

	@Autowired
	LectureMapper lectureMapper;
	
	@Autowired
	PlanUploadController uploadController;
	
	@Autowired
	UploadController uploadService;
	
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

	// 강의 세부 정보
	@Override
	public EstblCourseVO detail(String estbllctreCode) {
		
		// 강의 정보 조회
		EstblCourseVO estblCourseVO = lectureMapper.detail(estbllctreCode);
		log.info("detail()->estblCourseVO : {}", estblCourseVO);
		
		// 주차별 학습 목표 조회
		List<WeekAcctoLrnVO> weekAcctoLrnVO = lectureMapper.getWeekList(estbllctreCode);
		estblCourseVO.setWeekAcctoLrnVO(weekAcctoLrnVO);
		log.info("detail()->estblCourseVO : {}", estblCourseVO);
		
		return estblCourseVO;
		
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
	@Transactional
	@Override
	public int createCourse(AllCourseVO allCourseVO) {
		
		List<String> profsrNoList = allCourseVO.getProfsrNoList();
		log.info("createCourse()->profsrNoList : {}", profsrNoList);
		
		if (profsrNoList == null || profsrNoList.isEmpty()) {
			throw new IllegalArgumentException("교수 번호를 받아오지 못했습니다."	);
		}
		
		int totalResult = 0;
		
		int resultA = lectureMapper.createCourseA(allCourseVO);
		
		if (resultA <= 0) {
			throw new RuntimeException("강의코드 생성 중 DB 오류 발생");
		}
		
		String lctreCode = allCourseVO.getLctreCode();
		log.info("createCourse()->(강의코드 생성)lctreCode : {}", lctreCode);
		
		for (String profsrNo : profsrNoList) {
			try {
				
				// 강의 생성 용 복사 데이터 생성(데이터 오염 방지)
				AllCourseVO copy = new AllCourseVO();
				
				copy.setLctreCode(lctreCode);
				copy.setComplSe(allCourseVO.getComplSe());
				copy.setAcqsPnt(allCourseVO.getAcqsPnt());
				copy.setProfsrNo(profsrNo);
				
				int resultE = lectureMapper.createCourseE(copy);
				
				if (resultE > 0) {
					totalResult++;
				}
			} catch(Exception e) {
				log.error("강의 생성 중 오류 발생", e.getMessage());
			}
		}
		
		if (totalResult > 0) {
			return totalResult;
		} else {
			throw new RuntimeException("강의 생성 실패");
		}
	}

	// 개설 강의 목록 조회
	@Override
	public List<EstblCourseVO> allList(EstblCourseVO estblCourseVO) {
		return this.lectureMapper.allList(estblCourseVO);
	}

	// 전체 학과 목록 가져오기
	@Override
	public List<AllCourseVO> getSubjct() {
		return this.lectureMapper.getSubjct();
	}

	// 개설 강의 목록 조회
	@Override
	public List<EstblCourseVO> mngList(EstblCourseVO estblCourseVO) {
		return this.lectureMapper.mngList(estblCourseVO);
	}

	// 선택학과 데이터 가져오기
	@Transactional
	@Override
	public Map<String, Object> getData(String subjctCode) {
		
		log.info("getData()->subjctCode : {}", subjctCode);
		
		// 선수강의 목록 가져오기
		List<EstblCourseVO> preLec = lectureMapper.getPreLec(subjctCode);
		log.info("getData()->preLec : {}", preLec);
		
		// 학과교수 목록 가져오기
		List<ProfsrVO> profsr = lectureMapper.getProfsr(subjctCode);
		log.info("getData()->profsr : {}", profsr);
		
		Map<String, Object> result = new HashMap<>();
		result.put("preLecture", preLec);
		result.put("professor", profsr);
		
		return result;
	}
	
	// 강의 개설 요청 처리
	@Override
	public int updateRequestSttus(EstblCourseVO estbllctreCode) {
		return this.lectureMapper.updateRequestSttus(estbllctreCode);
	}

	// 전체 교과목 목록 조회
	@Override
	public List<AllCourseVO> allCourseList(AllCourseVO allCourseVO) {
		return this.lectureMapper.allCourseList(allCourseVO);
	}
	
	// 전체 교과목 세부 정보 조회
	@Override
	public List<EstblCourseVO> allCourseDetail(String lctreCode) {
		return this.lectureMapper.allCourseDetail(lctreCode);
	}
	
	
	// -------- <교수> --------
	

	// 개설 강의 목록 조회
	@Override
	public List<EstblCourseVO> myMnglist(Map<String, Object> map) {
		return this.lectureMapper.myMngList(map);
	}

	// 개설 강의 정보 입력 페이지
	@Override
	public EstblCourseVO editLoad(String estbllctreCode) {
		
		// 강의 정보 조회
		EstblCourseVO estblCourseVO = lectureMapper.editLoad(estbllctreCode);
		
		// 주차별 학습 목표 조회
		List<WeekAcctoLrnVO> weekAcctoLrnVO = lectureMapper.getWeekList(estbllctreCode);
		estblCourseVO.setWeekAcctoLrnVO(weekAcctoLrnVO);
		
		return estblCourseVO;
	}

	// 개설 강의 정보 저장
	@Transactional
	@Override
	public int confirm(EstblCourseVO estblCourseVO) {
		
		int totalResult = 0;
		
		// 시간표 정보 delete (시간표 중복 생성 방지)
		lectureMapper.deleteTime(estblCourseVO);
		
		// 시간표 정보 insert
		int resultT = lectureMapper.insertTime(estblCourseVO);
		if (resultT < 1) {
			throw new RuntimeException("시간표 정보 입력 중 DB 오류 발생");
		} else {
			totalResult++;
		}
		
		// 주차별 강의 목표 delete
		lectureMapper.deleteWeek(estblCourseVO);
		
		// 주차별 강의 목표 insert
		for (WeekAcctoLrnVO week : estblCourseVO.getWeekAcctoLrnVO()) {
			week.setEstbllctreCode(estblCourseVO.getEstbllctreCode());
			lectureMapper.insertWeek(week);
		}
		
		MultipartFile[] multipartFiles = estblCourseVO.getUploadFile();
		
		// 강의계획서 delete
		lectureMapper.deleteFile(estblCourseVO);
		
		// 강의계획서 업로드
		if (multipartFiles == null || multipartFiles.length == 0) {
			throw new IllegalArgumentException("빈 파일입니다.");
		}
		
		boolean isEmpty = true;
		for (MultipartFile f:multipartFiles) {
			if (!f.isEmpty()) {
				isEmpty = false;
				break;
			}
		}
		
		if (isEmpty) {
			throw new IllegalArgumentException("빈 파일입니다.");
		} else {
		
			long fileGroupNo = uploadService.fileUpload(multipartFiles);
			estblCourseVO.setFileGroupNo(fileGroupNo);
			log.info("confirm()->fileGroupNo : {}", fileGroupNo);
			totalResult++;
		}
		
		// 강의 정보 insert
		int resultE = lectureMapper.confirm(estblCourseVO);
		if (resultE < 1) {
			throw new RuntimeException("강의 정보 입력 중 DB 오류 발생");
		} else {
			totalResult++;
		}

		
		if (totalResult == 3) {
			return totalResult;
		} else {
			throw new RuntimeException("강의 생성 실패");
		}
	}

	// 강의 시간표 조회
	@Override
	public List<EstblCourseVO> timetableLoad() {
		return this.lectureMapper.timetableLoad();
	}

	// 교과목 운영상태 변경
	@Override
	public int allCourseEdit(AllCourseVO allCourseVO) {
		return this.lectureMapper.allCourseEdit(allCourseVO);
	}

	

	


}
