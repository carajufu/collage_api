package kr.ac.collage_api.lecture.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.vo.AtnlcReqstVO;
import kr.ac.collage_api.vo.EstblCourseVO;

public interface AtnlcService {

	// 로그인한 계정의 학생 번호(stdnt_no) 검증
	String findStdntNo(String acntId);

	// 나의 장바구니 목록 불러오기
	List<AtnlcReqstVO> myCartList(String stdntNo);

	// 장바구니에 강의 담기
	Map<String, Object> addMyCart(AtnlcReqstVO atnlcReqstVO);

	// 장바구니 강의 담기 취소
	int editMyCart(AtnlcReqstVO atnlcReqstVO);

	// 장바구니 강의 수강신청
	Map<String, Object> submitMyCart(AtnlcReqstVO atnlcReqstVO);

	// 수강신청
	Map<String, Object> submitCourse(AtnlcReqstVO atnlcReqstVO);

	// 나의 수강신청 목록 조회
	List<AtnlcReqstVO> stdntLctreList(String stdntNo);

}
