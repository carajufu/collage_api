package kr.ac.collage_api.lecture.controller;

import java.util.List;
import java.util.Map;

import org.apache.catalina.connector.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.ac.collage_api.lecture.service.LectureService;
import kr.ac.collage_api.vo.AllCourseVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/admin/lecture")
@Slf4j
@RestController
public class LectureAdminController {

	@Autowired
	LectureService lectureService;
	
	// 전체 강의 목록 조회
	@GetMapping("/list")
	public ResponseEntity<List<EstblCourseVO>> mnglist(EstblCourseVO estblCourseVO) {
		
		List<EstblCourseVO> list = lectureService.mngList(estblCourseVO);
		log.info("mngList()->estblCourseVO : {}", estblCourseVO);
		
		return ResponseEntity.ok(list);
	}
	
	// 강의 세부 정보 조회
	@ResponseBody
	@GetMapping("/detail/{estbllctreCode}")
	public ResponseEntity<EstblCourseVO> detailCourse(@PathVariable String estbllctreCode) {
		
		EstblCourseVO detail = lectureService.detail(estbllctreCode);
		log.info("detailCourse()->detail : {}", detail);
		
		return ResponseEntity.ok(detail);
	}
	
	// 개설 강의 목록 조회
	@GetMapping("/mng/list")
	public ResponseEntity<List<EstblCourseVO>> mngList(EstblCourseVO estblCourseVO) {
		
		List<EstblCourseVO> list = lectureService.list(estblCourseVO);
		log.info("mngList()->list : {}", list);
		
		return ResponseEntity.ok(list);
	}
	
	// 강의 생성
	@PostMapping("/create")
	public ResponseEntity<AllCourseVO> createCourse(AllCourseVO allCourseVO) {
		
		log.info("createCourse()->allCourseVO : {}", allCourseVO);
		
		lectureService.createCourse(allCourseVO);
		
		return ResponseEntity.ok(allCourseVO);
	}
	
	
}

