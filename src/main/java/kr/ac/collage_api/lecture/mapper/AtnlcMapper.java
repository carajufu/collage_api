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

	// 1. 중복 강의 검사
	List<String> checkLec(AtnlcReqstVO atnlcReqstVO);

	// 장바구니 강의 담기 취소
	int editMyCart(AtnlcReqstVO atnlcReqstVO);

	// 2. 중복 시간표 검사
	List<String> checkTime(AtnlcReqstVO atnlcReqstVO);

	// 장바구니 인원 계산
	String countTotalReqts(EstblCourseVO estblCourseVO);

}
