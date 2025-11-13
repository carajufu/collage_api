package kr.ac.collage_api.lecture.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.AtnlcReqstVO;
import kr.ac.collage_api.vo.EstblCourseVO;

@Mapper
public interface AtnlcMapper {

	// 로그인한 계정의 학생 번호(stdnt_no) 검증
	String findStdntNo(String acntId);

	// 나의 장바구니 목록 불러오기
	List<AtnlcReqstVO> myCartList(String stdntNo);

	// 장바구니에 강의 담기
	int addMyCart(AtnlcReqstVO atnlcReqstVO);

	// 1. 중복 강의 검사 (장바구니)
	List<String> checkLecCart(AtnlcReqstVO atnlcReqstVO);

	// 2. 중복 시간표 검사 (장바구니)
	List<String> checkTimeCart(AtnlcReqstVO atnlcReqstVO);
	
	// 1. 중복 강의 검사 (수강신청)
	EstblCourseVO checkLec(AtnlcReqstVO atnlcReqstVO);
	
	// 2. 중복 시간표 검사 (수강신청)
	EstblCourseVO checkTime(AtnlcReqstVO atnlcReqstVO);
	
	// 장바구니 강의 담기 취소
	int editMyCart(AtnlcReqstVO atnlcReqstVO);

	// 장바구니 강의 수강신청
	int submitMyCart(AtnlcReqstVO atnlcReqstVO);

	// 수강정원, 현재 신청중 인원 가져오기 (장바구니)
	EstblCourseVO getCourseInfo(AtnlcReqstVO atnlcReqstVO);

	// 수강정원, 현재 신청완료 인원 가져오기 (수강신청)
	EstblCourseVO getSubmitInfo(AtnlcReqstVO atnlcReqstVO);
	
	// 수강신청
	int submitCourse(AtnlcReqstVO atnlcReqstVO);
	
	// 나의 수강신청 목록 조회
	List<AtnlcReqstVO> stdntLctreList(String stdntNo);


}
