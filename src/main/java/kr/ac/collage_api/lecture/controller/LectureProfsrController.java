package kr.ac.collage_api.lecture.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.collage_api.lecture.service.LectureService;
import kr.ac.collage_api.vo.EstblCourseVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/lecture")
@Slf4j
@Controller
public class LectureProfsrController {

	@Autowired
	LectureService lectureService;
	
	// 담당 강의 목록 조회(교수)
	@GetMapping("/mylist")
	public String mylist(Model model, Principal principle, EstblCourseVO estblCourseVO,
						 @RequestParam(value="keyword", required=false, defaultValue="") String keyword,
						 @RequestParam(value="complSe", required=false, defaultValue="") String complSe) {
		
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("complSe", complSe);
		
		String acntId = principle.getName();
		log.info("mylist()->acntId : {}", acntId);
		
		// 로그인한 계정의 교수 번호(profsr_no) 검증
		String profsrNo = lectureService.findProfsrNo(acntId);
		log.info("mylist()->profsrNo : {}", profsrNo);
		map.put("profsrNo", profsrNo);
		
		List<EstblCourseVO> estblCourseVOList = lectureService.mylist(map);
//		log.info("mylist()->estblCourseVOList : ", estblCourseVOList);
		
		model.addAttribute("estblCourseVOList", estblCourseVOList);
		
		return "lecture/mylist";
	}
	
	/*
	// /lecture/edit
	// 강의 세부 정보 수정(교수)
	@PostMapping("/edit")
	@ResponseBody
	public Map<String,Object> edit(@RequestBody EstblCourseVO estblCourseVO) {
		
		int result = lectureService.edit(estblCourseVO);
		log.info("edit()->estblCourseVO : {}", estblCourseVO);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result);
		map.put("estblCourseVO", estblCourseVO);
		
		return map;
	}
	*/
	
	// 강의 계획서 모달 띄우기
	@ResponseBody
	@GetMapping("/detailPlan/{estbllctreCode}")
	public Map<String,Object> detailPlan(@PathVariable String estbllctreCode) {
		log.info("detailPlan()->estbllctreCode : {}", estbllctreCode);
		EstblCourseVO estblCourseVO = lectureService.loadPlanFile(estbllctreCode);
		log.info("detailPlan()->estblCourseVO : {}", estblCourseVO);
		
		int result = 0;
		
		if(estblCourseVO != null) {
			result = 1;
		}
		
		log.info("detailPlan()->result : {}", result);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result);
		map.put("estblCourseVO", estblCourseVO);
		
		return map;
	}
	
	// 강의 계획서 업로드
	@ResponseBody
	@PostMapping("/uploadPlan")
	public Map<String, Object> uploadPlan(EstblCourseVO estblCourseVO) {
		log.info("uploadPlan()->estblCourseVO : {}", estblCourseVO);
		
		int result = lectureService.uploadPlan(estblCourseVO);
		log.info("uploadPlan()->result : {}", result);
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		
		return map;
	}
	
	

}
