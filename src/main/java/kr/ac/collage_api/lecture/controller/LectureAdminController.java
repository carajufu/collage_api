package kr.ac.collage_api.lecture.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.catalina.connector.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
	@GetMapping("/allList")
	public ResponseEntity<List<EstblCourseVO>> allList(EstblCourseVO estblCourseVO) {
		
		List<EstblCourseVO> list = lectureService.allList(estblCourseVO);
		log.info("allList()->estblCourseVO : {}", estblCourseVO);
		
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
		
		List<EstblCourseVO> list = lectureService.mngList(estblCourseVO);
		log.info("mngList()->list : {}", list);
		
		return ResponseEntity.ok(list);
	}
	
	// 강의 생성
//	@ResponseBody
	@PostMapping("/mng/create")
	public ResponseEntity<AllCourseVO> createCourse(@RequestBody AllCourseVO allCourseVO) {
		
		log.info("createCourse()->allCourseVO : {}", allCourseVO);
		
		lectureService.createCourse(allCourseVO);
		
		return ResponseEntity.ok(allCourseVO);
	}
	
	// 전체 학과 목록 가져오기
	@GetMapping("/mng/create/getSubjct")
	public ResponseEntity<List<AllCourseVO>> getSubjct(String subjctCode) {
		
		List<AllCourseVO> subjcts = lectureService.getSubjct();
		log.info("getSubjct()->subjcts : {}", subjcts);
		
		return ResponseEntity.ok(subjcts);
	}
	
	// 선택학과 데이터 가져오기
	@GetMapping("/mng/create/getData")
	public ResponseEntity<Map<String, Object>> getData(@RequestParam("subjctCode") String subjctCode) {
		
		Map<String, Object> map = lectureService.getData(subjctCode);
		
		log.info("getData()->map : {}", map);
		
		return ResponseEntity.ok(map);
	}
	
	// 강의 개설 요청 조회
	@GetMapping("/mng/request/{estbllctreCode}")
	public ResponseEntity<EstblCourseVO> requestDetail(@PathVariable("estbllctreCode") String estbllctreCode) {
		
		EstblCourseVO detail = lectureService.detail(estbllctreCode);
		log.info("requestDetail()->detail : {}", detail);
		
		return ResponseEntity.ok(detail);
	}
	
	// 강의 개설 요청 처리
	@PutMapping("/mng/request/{estbllctreCode}")
	public ResponseEntity<Integer> updateRequestSttus(@PathVariable("estbllctreCode") String estbllctreCode,
												  @RequestBody EstblCourseVO estblCourseVO) {
		
		estblCourseVO.setEstbllctreCode(estbllctreCode);
		int result = lectureService.updateRequestSttus(estblCourseVO);
		
		return  ResponseEntity.ok(result);
	}
	
	// 전체 교과목 목록 조회
	@GetMapping("/allCourseList")
	public ResponseEntity<List<AllCourseVO>> allCourseList(AllCourseVO allCourseVO) {
		
		List<AllCourseVO> list = lectureService.allCourseList(allCourseVO);
		log.info("allCourseList()->allCourseVO : {}", allCourseVO);
		
		return ResponseEntity.ok(list);
	}
	
	// 전체 교과목 세부 정보 조회
	@GetMapping("/allCourse/{lctreCode}")
	public ResponseEntity<List<EstblCourseVO>> allCourseDetail(@PathVariable("lctreCode") String lctreCode) {
		
		List<EstblCourseVO> detail = lectureService.allCourseDetail(lctreCode);
		log.info("requestDetail()->detail : {}", detail);
		
		return ResponseEntity.ok(detail);
	}
	
	// 교과목 운영상태 변경
	@PutMapping("/allCourse/edit")
	public ResponseEntity<Integer> allCourseEdit(@RequestBody AllCourseVO allCourseVO) {
		
		int result = lectureService.allCourseEdit(allCourseVO);
		
		return ResponseEntity.ok(result);
	}
}

