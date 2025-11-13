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

		// 1. 중복 강의 검사
		List<String> alreadyLec = atnlcMapper.checkLecCart(atnlcReqstVO);
		// 2. 중복 시간표 검사
		List<String> perLec = atnlcMapper.checkTimeCart(atnlcReqstVO);
		
		Set<String> alreadySet = new HashSet<>(alreadyLec);
		Set<String> perSet = new HashSet<>(perLec);
		
		if(!alreadySet.isEmpty() || !perSet.isEmpty()) {
			Map<String, Object> map = new HashMap<>();
			map.put("insertCnt", 0);
			map.put("alreadyLecCode", alreadyLec);
			map.put("perLecCode", perLec);
			map.put("success", false);
			
			return map;
		}
		
		int insertCnt = atnlcMapper.addMyCart(atnlcReqstVO);
		
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

	// 장바구니 강의 수강신청
	@Transactional
	@Override
	public Map<String, Object> submitMyCart(AtnlcReqstVO atnlcReqstVO) {

		// 수강정원, 현재 신청중 인원 가져오기 (장바구니)
		EstblCourseVO estblCourseVO = atnlcMapper.getSubmitInfo(atnlcReqstVO);

		int totalSubmit = estblCourseVO.getTotalSubmit();
		int atnlcNmpr = estblCourseVO.getAtnlcNmpr();

		if(totalSubmit > atnlcNmpr) {
			Map<String, Object> map = new HashMap<>();

			map.put("submitCnt", 0);
			map.put("success", false);
			return map;
		}

		int submitCnt = atnlcMapper.submitMyCart(atnlcReqstVO);

		Map<String, Object> map = new HashMap<>();
		map.put("submitCnt", submitCnt);
		map.put("success", true);

		return map;
	}

	// 수강신청
	@Transactional
	@Override
	public Map<String, Object> submitCourse(AtnlcReqstVO atnlcReqstVO) {

		String code = atnlcReqstVO.getEstbllctreCode();
		log.info("submitCourse()->code : {}", code);
		EstblCourseVO alreadyLec = atnlcMapper.checkLec(atnlcReqstVO);
		// 2. 중복 시간표 검사
		EstblCourseVO perLec = atnlcMapper.checkTime(atnlcReqstVO);
		// 3. 수강 정원 초과 검사
		EstblCourseVO estblCourseVO = atnlcMapper.getSubmitInfo(atnlcReqstVO);
		int totalSubmit = estblCourseVO.getTotalSubmit();
		int atnlcNmpr = estblCourseVO.getAtnlcNmpr();

		if(alreadyLec != null || perLec != null || totalSubmit > atnlcNmpr) {
			Map<String, Object> map = new HashMap<>();
			map.put("insertCnt", 0);
			map.put("alreadyLec", alreadyLec);
			map.put("perLec", perLec);
			map.put("success", false);

			return map;
		}

		atnlcReqstVO.setEstbllctreCode(code);
		int insertCnt = atnlcMapper.submitCourse(atnlcReqstVO);

		Map<String, Object> map = new HashMap<>();
		map.put("insertCnt", insertCnt);
		map.put("success", true);
		log.info("submitCourse()->map : {}", map);

		return map;
	}

	// 나의 수강신청 목록 조회
	@Override
	public List<AtnlcReqstVO> stdntLctreList(String stdntNo) {
		return this.atnlcMapper.stdntLctreList(stdntNo);
	}
}
