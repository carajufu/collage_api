package kr.ac.collage_api.lecture.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.ac.collage_api.lecture.service.LectureEvlService;
import kr.ac.collage_api.lecture.vo.LectureEvlVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/prof/lecture")
public class Prof_LectureEvlController {

    @Autowired
    LectureEvlService lectureService;

	// ------------------------------------------------------------
	// 1. 전체 강의 목록 조회
	// ------------------------------------------------------------
	@GetMapping("/main/All")
	public String main(Model model, String estbllctreCode) {

		// 전체 강의 목록 조회 (ALL_COURSE)
		List<LectureEvlVO> lectureVO = lectureService.getAllCourses(estbllctreCode);
		log.info("allCourseList : {}", lectureVO);

		model.addAttribute("allCourseList", lectureVO);
		return "lecture/profLctreEvlMain";
	}

	// ------------------------------------------------------------
	// 2. 특정 강의 평가 
	// ------------------------------------------------------------
	@GetMapping("/main/detail/{estbllctreCode}")
	public String estblDetail(@PathVariable("estbllctreCode") String estbllctreCode
							 ,@RequestParam(required = false) Integer lctreEvlInnb, Model model) {

		log.info("estbllctreCode : {}", estbllctreCode);

		// 개설 강의 정보 조회 (ESTBL_COURSE)
		LectureEvlVO estblCourseInfo = lectureService.getEstblCourseById(estbllctreCode);

		// 강의 평가 전체 정보 조회 (LCTRE_EVL)
		List<LectureEvlVO> evalList = lectureService.getLectureEvalByEstblCode(estbllctreCode);
		log.info("evalList : {}", evalList);
		
		// 강의 시간표 조회 (LCTRE_TIMETABLE)
		List<LectureEvlVO> timetableList = lectureService.getTimetableByEstblCode(estbllctreCode);

		// 강의 평가 상세 정보 조회(LCTRE_EVL_IEM)
		List<LectureEvlVO> evlIem = lectureService.getEvlIem(lctreEvlInnb);
		
		// View로 전달
		if (estblCourseInfo != null) {
			model.addAttribute("lectureName", estblCourseInfo.getEstbllctreCode());
			log.info("lectureName : {}", estblCourseInfo.getEstbllctreCode());
		} else {
			model.addAttribute("lectureName", "강의 정보 없음");
		}

		model.addAttribute("estblCourseInfo", estblCourseInfo);
		model.addAttribute("evalList", evalList);
		model.addAttribute("timetableList", timetableList);
		model.addAttribute("evlIem", evlIem);

		log.info("lctreEvlInfo : {}", evalList);
		log.info("timetableList : {}", timetableList);

		return "lecture/profLctreEvlDetail";
	}
  

}

