package kr.ac.collage_api.lecture.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.AllCourseVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.FileGroupVO;

@Mapper
public interface LectureMapper {

	// 개설 강의 조회
	public List<EstblCourseVO> list(EstblCourseVO estblCourseVO);

	// 담당 강의 목록 조회(교수)
	public List<EstblCourseVO> mylist(Map<String, Object> map);

	// 강의 세부 정보
	public EstblCourseVO detail(String estbllctreCode);

	// 강의 세부 정보 수정(교수)
	public int editEstbl(EstblCourseVO estblCourseVO);
	public int editTimetable(EstblCourseVO estblCourseVO);

	// 강의 계획서 모달 띄우기
	public EstblCourseVO loadPlanFile(String estbllctreCode);
	
	// 강의 계획서 업로드
	public int uploadPlan(EstblCourseVO estblCourseVO);
	// 파일 그룹 생성
	public int insertFileGroup(FileGroupVO fileGroupVO);
	// 파일 디테일 생성
	public int insertFileDetail(FileDetailVO fileDetailVO);

	// 로그인한 계정의 교수 번호 검증
	public String findProfsrNo(String acntId);

	// 강의 계획서 다운로드
	public FileDetailVO getFileDetail(long fileGroupNo);

	
	// -------- <관리자> --------
	
	
	// 강의 생성
	public int createCourse(AllCourseVO allCourseVO);

	// 전체 강의 목록 조회
	public List<EstblCourseVO> allList(EstblCourseVO estblCourseVO);



}
