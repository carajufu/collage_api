package kr.ac.collage_api.lecture.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.lecture.mapper.AtnlcMapper;
import kr.ac.collage_api.lecture.service.AtnlcService;
import kr.ac.collage_api.vo.AtnlcReqstVO;

@Service
public class AtnlcServiceImpl implements AtnlcService {

	@Autowired
	AtnlcMapper atnlcMapper;
	
	// 로그인한 계정의 학생 번호(stdnt_no) 검증
	@Override
	public String findStdntNo(String acntId) {
		return this.atnlcMapper.findStdntNo(acntId);
	}

	// 나의 장바구니 목록 불러오기
	@Override
	public List<AtnlcReqstVO> myCartList(String stdntNo) {
		return this.atnlcMapper.myCartList(stdntNo);
	}

	// 장바구니에 강의 담기
	@Override
	public int addMyCart(AtnlcReqstVO atnlcReqstVO) {
		return this.atnlcMapper.addMyCart(atnlcReqstVO);
	}

}
