package kr.ac.collage_api.counsel.service;

import java.util.List;

import kr.ac.collage_api.vo.CnsltAtVO;
import kr.ac.collage_api.vo.CnsltVO;
import kr.ac.collage_api.vo.LctreTimetableVO;
import kr.ac.collage_api.vo.ProfsrVO;

public interface CounselService {

	
	public List<CnsltAtVO> getCnsltAtVOList(String acntId);

	// 상담 입력
	public int insertCnsltAt(CnsltAtVO cnsltAtVO);


	//상담 테이블 리스트 불러오깅
	public List<CnsltVO> selectCnsltStd(String acntId);

	//상담신청 학생 => 교수
	public int createCnslt(CnsltVO cnsltVO);

	//나와 같은 담당 교수들
	public List<ProfsrVO> selectMyProf(String acntId);
	
	//내 상담교수 찾고 내 상담 교수의 강의 시간 가져오기
	public List<LctreTimetableVO> selectMyProfTimetable(String profsrNo);

	//내 상담교수 의 상담리스트 가져오기
	public List<CnsltVO> profCnsltList(String profsrNo);

	//상담 한개 detail 가져오기
	public CnsltVO seletCnsltDetail(int cnsltInnb);

	//상담 상태에 따른 카운트
	public List<CnsltVO> selectCnsltCount(String acntId);

	public String selectStdntNo(String acntId);


}