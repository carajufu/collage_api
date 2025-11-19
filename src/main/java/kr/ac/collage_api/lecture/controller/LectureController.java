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
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//
//import kr.ac.collage_api.lecture.service.LectureService;
//import kr.ac.collage_api.vo.EstblCourseVO;
//import lombok.extern.slf4j.Slf4j;
//
//@RequestMapping("/lecture")
//@Slf4j
//@Controller
//public class LectureController {
//
//	@Autowired
//	LectureService lectureService;
//	
//	// 개설 강의 조회
//	@GetMapping("/list")
//	public String list(Model model, EstblCourseVO estblCourseVO, 
//					   @RequestParam(value="keyword", required=false, defaultValue="") String keyword,
//					   @RequestParam(value="complSe", required=false, defaultValue="") String complSe) {
//		
//		Map<String, Object> map = new HashMap<>();
//		map.put("keyword", keyword);
//		map.put("complSe", complSe);
//		
//		List<EstblCourseVO> estblCourseVOList = lectureService.list(map);
//		log.info("list()->estblCourseVOList : {}", estblCourseVOList);
//		
//		model.addAttribute("estblCourseVOList", estblCourseVOList);
//		
//		return "lecture/list";
//	}
//}
