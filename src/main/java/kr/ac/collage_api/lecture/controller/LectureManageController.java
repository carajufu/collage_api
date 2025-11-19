//package kr.ac.collage_api.lecture.controller;
//
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PathVariable;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.ResponseBody;
//
//import kr.ac.collage_api.lecture.service.LectureService;
//import kr.ac.collage_api.vo.EstblCourseVO;
//import lombok.extern.slf4j.Slf4j;
//
//@RequestMapping("/lecture")
//@Slf4j
//@Controller
//public class LectureManageController {
//
//	@Autowired
//	LectureService lectureService;
//	
//	// 담당 강의 목록 조회(교수)
//	@GetMapping("/mylist")
//	public String mylist(Model model, EstblCourseVO estblCourseVO,
//						 @RequestParam(value="keyword", required=false, defaultValue="") String keyword,
////						 @RequestParam(value="profsrNo", required=false, defaultValue="") String profsrNo,
//						 @RequestParam(value="complSe", required=false, defaultValue="") String complSe) {
//		
//		Map<String, Object> map = new HashMap<>();
//		map.put("keyword", keyword);
////		map.put("profsrNo", profsrNo);
//		map.put("complSe", complSe);
//		
//		List<EstblCourseVO> estblCourseVOList = lectureService.mylist(map);	//여기 나중에 mylist로 수정해야함
////		log.info("mylist()->estblCourseVOList : ", estblCourseVOList);
//		
//		model.addAttribute("estblCourseVOList", estblCourseVOList);
//		
//		return "lecture/mylist";
//	}
//	
//	// 강의 세부 정보(교수)
//	@GetMapping("/detail")
//	public String detail(EstblCourseVO estblCourseVO,
//						 @RequestParam String estbllctreCode, Model model) {
//		
//		estblCourseVO = this.lectureService.detail(estblCourseVO);
//		log.info("detail()->estblCourseVO : {}", estblCourseVO);
//		
//		model.addAttribute("estblCourseVO", estblCourseVO);
//		
//		return "lecture/detail";
//	}
//	
//	@GetMapping("/detailAjax/{estbllctreCode}")
//	@ResponseBody
//	public Map<String,Object> detailAjax(@PathVariable String estbllctreCode) {
//		log.info("detailAjax()->estbllctreCode : {}", estbllctreCode);
//		EstblCourseVO estblCourseVO = lectureService.detailAjax(estbllctreCode);
//		log.info("detailAjax()->estblCourseVO : {}", estblCourseVO);
//		
//		int result = 0;
//		
//		if(estblCourseVO != null) {
//			result = 1;
//		}
//		
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("result", result);
//		map.put("estblCourseVO", estblCourseVO);
//		
//		return map;
//	}
//	
//	// /lecture/edit
//	// 강의 세부 정보 수정(교수)
//	@PostMapping("/edit")
//	@ResponseBody
//	public Map<String,Object> edit(@RequestBody EstblCourseVO estblCourseVO) {
//		
//		int result = lectureService.edit(estblCourseVO);
//		log.info("edit()->estblCourseVO : {}", estblCourseVO);
//		
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("result", result);
//		map.put("estblCourseVO", estblCourseVO);
//		
//		return map;
//	}
//	
//	
//	
//	// 강의 계획서 작성, 업로드
////	@PostMapping("/upload")
////	public String 
//}
