package kr.ac.collage_api.lecture.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.ac.collage_api.lecture.service.LectureService;
import kr.ac.collage_api.lecture.vo.LectureVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/lecture")
public class LectureController {
	
	@Autowired
	LectureService lectureService;

	@GetMapping("/evaluation")
	public String evaluation(@ModelAttribute(value="lectureVO")
							LectureVO lectureVO,
							Model model) {
		log.info("lectureVO : ",lectureVO);
		lectureVO = this.lectureService.evl(lectureVO);
		
		model.addAttribute("lectureVO",lectureVO);
		
		return "lecture/main";
	}
}
