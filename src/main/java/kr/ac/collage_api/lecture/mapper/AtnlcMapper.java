package kr.ac.collage_api.lecture.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.AtnlcReqstVO;

@Mapper
public interface AtnlcMapper {

	// 로그인한 계정의 학생 번호(stdnt_no) 검증
	String findStdntNo(String acntId);

	// 나의 장바구니 목록 불러오기
	List<AtnlcReqstVO> myCartList(String stdntNo);

	// 장바구니에 강의 담기
	int addMyCart(AtnlcReqstVO atnlcReqstVO);

}
