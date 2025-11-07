package kr.ac.collage_api.lecture.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.collage_api.lecture.service.AtnlcService;
import kr.ac.collage_api.lecture.service.LectureService;
import kr.ac.collage_api.vo.AtnlcReqstVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/atnlc")
@Slf4j
@Controller
public class AtnlcController {

	@Autowired
	AtnlcService atnlcService;
	
	@Autowired
	LectureService lectureService;
	
	@GetMapping
	public String atnlcPage(Principal principal, Model model) {
		
		String acntId = principal.getName();
		
		// 로그인한 계정의 학생 번호(stdnt_no) 검증
		String stdntNo = atnlcService.findStdntNo(acntId);
		log.info("atnlcPage()->stdntNo : {}", stdntNo);
		
		model.addAttribute("stdntNo", stdntNo);
		
		return "lecture/atnlc";
	}
	
	// 개설 강의 조회
	@ResponseBody
	@GetMapping("/load")
	public Map<String, Object> list(EstblCourseVO estblCourseVO,
			   @RequestParam(value="keyword", required=false, defaultValue="") String keyword,
			   @RequestParam(value="complSe", required=false, defaultValue="") String complSe) {
		
		log.info("list()->keyword : {}", keyword);
		log.info("list()->complSe : {}", complSe);
		estblCourseVO.setKeyword(keyword);
		estblCourseVO.setComplSe(complSe);
		
		List<EstblCourseVO> estblCourseVOList = lectureService.list(estblCourseVO);
		log.info("list()->estblCourseVOList : {}", estblCourseVOList);
		
		Map<String, Object> map = new HashMap<>();
		map.put("estblCourseVOList", estblCourseVOList);
		
		return map;
	}
	
	// 나의 장바구니 목록 조회
	@ResponseBody
	@GetMapping("/mycart")
	public Map<String, Object> myCartList(AtnlcReqstVO atnlcReqstVO)  {

		Map<String, Object> map = new HashMap<>();
		
		String stdntNo = atnlcReqstVO.getStdntNo();
		log.info("myCartList()->stdntNo : {}", stdntNo);
		
		List<AtnlcReqstVO> atnlcReqstVOList = atnlcService.myCartList(stdntNo);
		log.info("myCartList()->atnlcReqstVOList : {}", atnlcReqstVOList);
		
		log.info("myCartList()->atnlcReqstVOList : {}", atnlcReqstVOList);
		map.put("atnlcReqstVOList", atnlcReqstVOList);
		
		return map;
	}
	
	// 장바구니에 강의 담기
	@ResponseBody
	@PostMapping("/mycart/add")
	public Map<String, Object> addMyCart(@RequestBody AtnlcReqstVO atnlcReqstVO) {
		
		log.info("addMyCart()->stdntNo : {}", atnlcReqstVO.getStdntNo());
		
		Map<String, Object> result = atnlcService.addMyCart(atnlcReqstVO);
		log.info("addMyCart()->result : {}", result);
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		
		return map;
	}
	
	// 장바구니 강의 담기 취소
	@ResponseBody
	@PostMapping("/mycart/edit")
	public Map<String, Object> editMyCart(@RequestBody AtnlcReqstVO atnlcReqstVO) {
		
		List<String> codes = atnlcReqstVO.getEstbllctreCodes();
		int result = 0;
		
		if(codes != null && !codes.isEmpty()) {
			for(String code: codes) {
				atnlcReqstVO.setEstbllctreCode(code);
				
				// 취소 실행
				result += atnlcService.editMyCart(atnlcReqstVO);
			}
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		
		return map;
	}
	
}
