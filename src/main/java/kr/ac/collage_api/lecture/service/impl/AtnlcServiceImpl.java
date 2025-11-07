package kr.ac.collage_api.lecture.service.impl;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.lecture.mapper.AtnlcMapper;
import kr.ac.collage_api.lecture.service.AtnlcService;
import kr.ac.collage_api.vo.AtnlcReqstVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
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

	@Transactional
	@Override
	// 장바구니에 강의 담기
	public Map<String, Object> addMyCart(AtnlcReqstVO atnlcReqstVO) {
		
		List<String> codes = atnlcReqstVO.getEstbllctreCodes();
		
		// 1. 중복 강의 검사
		List<String> alreadyLecList = atnlcMapper.checkLec(atnlcReqstVO);
		// 2. 중복 시간표 검사
		List<String> perLecList = atnlcMapper.checkTime(atnlcReqstVO);
		
		Set<String> alreadySet = new HashSet<>(alreadyLecList);
		Set<String> perSet = new HashSet<>(perLecList);
		
		if(!alreadySet.isEmpty() || !perSet.isEmpty()) {
			Map<String, Object> map = new HashMap<>();
			map.put("insertCnt", 0);
			map.put("alreadyLecCodes", alreadyLecList);
			map.put("perLecCodes", perLecList);
			map.put("success", false);
			
			return map;
		}
		
		int insertCnt = 0;
		for (String code: codes) {
			atnlcReqstVO.setEstbllctreCode(code);
			
			insertCnt += atnlcMapper.addMyCart(atnlcReqstVO);
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("insertCnt", insertCnt);
		map.put("success", true);
		log.info("addMyCart()->map : {}", map);
		
		return map;
	}

	// 장바구니 강의 담기 취소
	@Override
	public int editMyCart(AtnlcReqstVO atnlcReqstVO) {
		return this.atnlcMapper.editMyCart(atnlcReqstVO);
	}

	// 장바구니 인원 계산
	@Override
	public String countTotalReqst(EstblCourseVO estblCourseVO) {
		return this.atnlcMapper.countTotalReqts(estblCourseVO);
	}

}
