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
	
	// 장바구니 페이지
	@GetMapping("/cart")
	public String cartPage(Principal principal, Model model) {
		
		String acntId = principal.getName();
		
		// 로그인한 계정의 학생 번호(stdnt_no) 검증
		String stdntNo = atnlcService.findStdntNo(acntId);
		log.info("atnlcPage()->stdntNo : {}", stdntNo);
		
		model.addAttribute("stdntNo", stdntNo);
		
		return "lecture/cart";
	}
	
	// 개설 강의 조회(장바구니)
	@ResponseBody
	@GetMapping("/cart/load")
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
	@GetMapping("/cart/mycart")
	public Map<String, Object> myCartList(AtnlcReqstVO atnlcReqstVO)  {

		Map<String, Object> map = new HashMap<>();
		
		String stdntNo = atnlcReqstVO.getStdntNo();
		log.info("myCartList()->stdntNo : {}", stdntNo);
		
		List<AtnlcReqstVO> atnlcReqstVOList = atnlcService.myCartList(stdntNo);
		log.info("myCartList()->atnlcReqstVOList : {}", atnlcReqstVOList);
		
		map.put("atnlcReqstVOList", atnlcReqstVOList);
		
		return map;
	}
	
	// 장바구니에 강의 담기
	@ResponseBody
	@PostMapping("/cart/mycart/add")
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
	@PostMapping("/cart/mycart/edit")
	public Map<String, Object> editMyCart(@RequestBody AtnlcReqstVO atnlcReqstVO) {
		
		log.info("editMyCart()->estbllctreCode : {}", atnlcReqstVO.getEstbllctreCode());
		
		int result = atnlcService.editMyCart(atnlcReqstVO);
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		
		return map;
	}
	
	// 장바구니 강의 수강신청
	@ResponseBody
	@PostMapping("/cart/mycart/submit")
	public Map<String, Object> submitMyCart(@RequestBody AtnlcReqstVO atnlcReqstVO) {
		
		log.info("submitMyCart()->stdntNo : {}", atnlcReqstVO.getStdntNo());
		log.info("submitMyCart()->estbllctreCode : {}", atnlcReqstVO.getEstbllctreCode());
		
		Map<String, Object> result = atnlcService.submitMyCart(atnlcReqstVO);
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		
		return map;
	}
	
	// 수강신청 페이지
	@GetMapping("/submit")
	public String submitPage(Principal principal, Model model) {
		
		String acntId = principal.getName();
		
		// 로그인한 계정의 학생 번호(stdnt_no) 검증
		String stdntNo = atnlcService.findStdntNo(acntId);
		log.info("submitPage()->stdntNo : {}", stdntNo);
		
		model.addAttribute("stdntNo", stdntNo);
		
		return "lecture/stdntLctreSubmit";
	}
	
	// 개설 강의 조회(수강신청)
	@ResponseBody
	@GetMapping("/submit/load")
	public Map<String, Object> atnlcList(EstblCourseVO estblCourseVO,
			   @RequestParam(value="keyword", required=false, defaultValue="") String keyword,
			   @RequestParam(value="complSe", required=false, defaultValue="") String complSe) {
		
		log.info("atnlcList()->keyword : {}", keyword);
		log.info("atnlcList()->complSe : {}", complSe);
		estblCourseVO.setKeyword(keyword);
		estblCourseVO.setComplSe(complSe);
		
		List<EstblCourseVO> estblCourseVOList = lectureService.list(estblCourseVO);
		log.info("atnlcList()->estblCourseVOList : {}", estblCourseVOList);
		
		Map<String, Object> map = new HashMap<>();
		map.put("estblCourseVOList", estblCourseVOList);
		
		return map;
	}
	
	// 수강신청
	@ResponseBody
	@PostMapping("/submit/add")
	public Map<String, Object> submitCoruse(@RequestBody AtnlcReqstVO atnlcReqstVO) {
		
		log.info("submitCoruse()->stdntNo : {}", atnlcReqstVO.getStdntNo());
		
		Map<String, Object> result = atnlcService.submitCourse(atnlcReqstVO);
		log.info("submitCoruse()->result : {}", result);
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		
		return map;
	}
	
	// 나의 수강신청 목록 페이지
	@GetMapping("/stdntLctreList")
	public String stdntLctreList(Principal principal, Model model, AtnlcReqstVO atnlcReqstVO) {
		
		String acntId = principal.getName();
		
		String stdntNo = atnlcService.findStdntNo(acntId);
		log.info("stdntLctreList()->stdntNo : {}", stdntNo);
		
		model.addAttribute("stdntNo", stdntNo);
		
		List<AtnlcReqstVO> atnlcReqstVOList = atnlcService.stdntLctreList(stdntNo);
		log.info("stdntLctreList()->atnlcReqstVOList : {}", atnlcReqstVOList);
		
		model.addAttribute("atnlcReqstVOList", atnlcReqstVOList);
		
		return "lecture/stdntLctreList";
	}
	
	// 수강신청 취소
	@ResponseBody
	@PostMapping("/stdntLctreList/edit")
	public Map<String, Object> editStdntLctre(@RequestBody AtnlcReqstVO atnlcReqstVO) {
		
		String code = atnlcReqstVO.getEstbllctreCode();
		log.info("editStdntLctre()->code : {}", code);
		
		int result = 0;
		if(code != null) {
			// 취소 실행
			result = atnlcService.editMyCart(atnlcReqstVO);
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		
		return map;
	}
	
}
