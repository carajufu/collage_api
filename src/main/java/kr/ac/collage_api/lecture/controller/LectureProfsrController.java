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
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.ac.collage_api.lecture.service.LectureService;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.LctreTimetableVO;
import kr.ac.collage_api.vo.WeekAcctoLrnVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/prof/lecture")
@Slf4j
@Controller
public class LectureProfsrController {

	@Autowired
	LectureService lectureService;
	
	// 담당 강의 목록 조회(교수)
	@GetMapping("/list")
	public String mylist(Model model, Principal principal, EstblCourseVO estblCourseVO,
						 @RequestParam(value="keyword", required=false, defaultValue="") String keyword,
						 @RequestParam(value="complSe", required=false, defaultValue="") String complSe) throws Exception {
		
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("complSe", complSe);
		
		String acntId = principal.getName();
		log.info("mylist()->acntId : {}", acntId);
		
		// 로그인한 계정의 교수 번호(profsr_no) 검증
		String profsrNo = lectureService.findProfsrNo(acntId);
		log.info("mylist()->profsrNo : {}", profsrNo);
		map.put("profsrNo", profsrNo);
		
		List<EstblCourseVO> estblCourseVOList = lectureService.mylist(map);
//		log.info("mylist()->estblCourseVOList : ", estblCourseVOList);
	
		// 잭슨 라이브러리 변환기  JSON <=> JAVA
		ObjectMapper objMapper = new ObjectMapper();
		String jsonStr = objMapper.writeValueAsString(estblCourseVOList);
		
		model.addAttribute("estblCourseVOList", estblCourseVOList);
		model.addAttribute("jsonStr", jsonStr);
		
		return "lecture/profLctreList";
	}
	
	
	// 개설 강의 정보 입력(교수)
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
	
	
	// 개설 강의 목록 조회
	@GetMapping("/mng/list")
	public String mngList(Model model, Principal principal, EstblCourseVO estblCourseVO,
						  @RequestParam(value="keyword", required=false, defaultValue="") String keyword,
						  @RequestParam(value="complSe", required=false, defaultValue="") String complSe) throws JsonProcessingException {
		
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("complSe", complSe);
		
		String acntId = principal.getName();
		log.info("mylist()->acntId : {}", acntId);
		
		// 로그인한 계정의 교수 번호(profsr_no) 검증
		String profsrNo = lectureService.findProfsrNo(acntId);
		log.info("mylist()->profsrNo : {}", profsrNo);
		map.put("profsrNo", profsrNo);
		
		List<EstblCourseVO> estblCourseVOList = lectureService.myMnglist(map);
//		log.info("mylist()->estblCourseVOList : ", estblCourseVOList);
	
		// 잭슨 라이브러리 변환기  JSON <=> JAVA
		ObjectMapper objMapper = new ObjectMapper();
		String jsonStr = objMapper.writeValueAsString(estblCourseVOList);
		
		model.addAttribute("estblCourseVOList", estblCourseVOList);
		model.addAttribute("jsonStr", jsonStr);
		
		return "lecture/profLctreMngList";
		
	}
	
	
	// 개설 강의 정보 입력 페이지
	@GetMapping("/mng/edit")
	public String editLoad(@RequestParam String estbllctreCode, Model model) {
		
		EstblCourseVO estblCourseVO = lectureService.editLoad(estbllctreCode);
		log.info("editLoad()->estblCourseVOList : {}", estblCourseVO);
		
		model.addAttribute("estblCourseVOList", List.of(estblCourseVO));
		
		return "lecture/profLctreEdit";
	}
	
	// 개설 강의 입력 정보 저장(승인요청)
	@ResponseBody
	@PostMapping("/mng/edit/confirm")
	public Map<String, Object> confirm(EstblCourseVO estblCourseVO,
//									   @RequestParam("timetable") String jsonTimetable,
									   @RequestParam("uploadFile") MultipartFile[] uploadFile) throws JsonMappingException, JsonProcessingException {
		
		ObjectMapper objMapper = new ObjectMapper();
		
		String jsonTimetable = estblCourseVO.getJsonTimetable();
		LctreTimetableVO timetable = objMapper.readValue(
				jsonTimetable, LctreTimetableVO.class
				);
		estblCourseVO.setTimetable(timetable);
		
		String jsonWeeklyGoals = estblCourseVO.getJsonWeeklyGoals();
		List<WeekAcctoLrnVO> weekAcctoLrnVO = objMapper.readValue(
				jsonWeeklyGoals, new TypeReference<List<WeekAcctoLrnVO>>() {}
				);
		estblCourseVO.setWeekAcctoLrnVO(weekAcctoLrnVO);
		
		
		estblCourseVO.setUploadFile(uploadFile);
		log.info("comfirm()->estblCourseVO : {}", estblCourseVO);
		
		int result = lectureService.confirm(estblCourseVO);
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", result);
		
		return map;
	}
	
	// 강의 시간표 조회
	@ResponseBody
	@GetMapping("/mng/edit/timetable")
	public Map<String, Object> timetableLoad(EstblCourseVO estblCourselist) {
		
		List<EstblCourseVO> list = lectureService.timetableLoad();
		log.info("timetableLoad()->list : {}", list);
		
		Map<String, Object> map = new HashMap<>();
		map.put("list", list);
		log.info("timetableLoad()->map : {}", map);
		
		return map;
	}
	
	// 개설 강의 정보 수정 페이지
	@GetMapping("/mng/modify")
	public String editCourseDetail(@RequestParam String estbllctreCode, Model model) {
		
		EstblCourseVO estblCourseVO = lectureService.detail(estbllctreCode);
		log.info("editCourseDetail()->estblCourseVO : {}", estblCourseVO);
		
		model.addAttribute("estblCourseVOList", List.of(estblCourseVO));
		
		return "lecture/profLctreModify";
	}
	

}
