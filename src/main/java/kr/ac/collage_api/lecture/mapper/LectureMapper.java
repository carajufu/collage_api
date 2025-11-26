package kr.ac.collage_api.lecture.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.AllCourseVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.FileGroupVO;
import kr.ac.collage_api.vo.ProfsrVO;
import kr.ac.collage_api.vo.WeekAcctoLrnVO;

@Mapper
public interface LectureMapper {

	// 개설 강의 조회
	public List<EstblCourseVO> list(EstblCourseVO estblCourseVO);

	// 담당 강의 목록 조회(교수)
	public List<EstblCourseVO> mylist(Map<String, Object> map);

	// 강의 세부 정보
	public EstblCourseVO detail(String estbllctreCode);

	// 주차별 학습 목표 조회
	public List<WeekAcctoLrnVO> getWeekList(String estbllctreCode);

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
	public int createCourseA(AllCourseVO allCourseVO);
	public int createCourseE(AllCourseVO allCourseVO);

	// 전체 강의 목록 조회
	public List<EstblCourseVO> allList(EstblCourseVO estblCourseVO);

	// 전체 학과 목록 가져오기
	public List<AllCourseVO> getSubjct();
	
	// 개설 강의 목록 조회
	public List<EstblCourseVO> mngList(EstblCourseVO estblCourseVO);

	// 선수강의 목록 가져오기
	public List<EstblCourseVO> getPreLec(String subjctCode);

	// 학과교수 목록 가져오기
	public List<ProfsrVO> getProfsr(String subjctCode);
	
	// 강의 개설 요청 처리
	public int updateRequestSttus(EstblCourseVO estbllctreCode);

	
	
	// -------- <교수> --------
	

	// 개설 강의 목록 조회
	public List<EstblCourseVO> myMngList(Map<String, Object> map);

	// 개설 강의 정보 입력 페이지
	public EstblCourseVO editLoad(String estbllctreCode);
	
	// 시간표 정보 delete (시간표 중복 생성 방지)
	public int deleteTime(EstblCourseVO estblCourseVO);

	// 시간표 정보 insert
	public int insertTime(EstblCourseVO estblCourseVO);
	
	// 주차별 강의 목표 delete
	public int deleteWeek(EstblCourseVO estblCourseVO);
	
	// 주차별 강의 목표 insert
	public int insertWeek(WeekAcctoLrnVO week);

	// 강의계획서 delete
	public void deleteFile(EstblCourseVO estblCourseVO);
	
	// 개설 강의 정보 저장
	public int confirm(EstblCourseVO estblCourseVO);

	// 강의 시간표 조회
	public List<EstblCourseVO> timetableLoad();






}
