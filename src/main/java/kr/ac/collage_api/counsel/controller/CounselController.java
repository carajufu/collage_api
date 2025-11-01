package kr.ac.collage_api.counsel.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.collage_api.counsel.service.CounselService;
import kr.ac.collage_api.vo.CnsltAtVO;
import kr.ac.collage_api.vo.CnsltVO;
import kr.ac.collage_api.vo.LctreTimetableVO;
import kr.ac.collage_api.vo.ProfsrVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/counsel")
@Controller
public class CounselController {

	@Autowired
	CounselService counselService;
	
	
	
	@GetMapping("/std")
	public String cnsltstd() {
		
		//학생상담 페이지로 이동
		return "counsel/cnsltstdnt";
	}
	
	///counsel/stdlist
	@ResponseBody
	@GetMapping("/stdlist")
	public Map<String,Object> stdlist(Principal principal) {

		// 화면에 보여주는 리스트를 보여줘야행
		String acntId = principal.getName();
		
		log.info("stdlist() -> acntId : {}", acntId);
		
		List<CnsltVO> cnsltVOList = this.counselService.selectCnsltStd(acntId);

		//담당교수
		List<ProfsrVO> profsrVOList = this.counselService.selectMyProf(acntId);
		
		//상담완료 건수, 상담요청 건수
		List<CnsltVO> cnsltVOCountList = this.counselService.selectCnsltCount(acntId);
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("success", "success");
		map.put("cnsltVOList", cnsltVOList);
		map.put("profsrVOList", profsrVOList);
		map.put("cnsltVOCountList", cnsltVOCountList);
		
		
		return map;
		
	}
	

	
	//학생 아이디와 학과가 같은 교수 아이디 + 이름 가져오기 + 상담시간 가져오기
	
	//그 교수가 개설한 강의의 강의 시간표 확인 - lctre_timetable  
	// fetch("/counsel/myprof",{
	
	
	
	@ResponseBody
	@GetMapping("/myprof")
	public Map<String,Object> myprof(@RequestParam String profsrNo) {
			
		log.info("myprof() -> profsrNo : {}", profsrNo);
			
		//상담가능시간 가져오기
		// 교수님의 강의 시간 가져오기
		//만약 이기간이 아니라면 상담기간이 아닌거임 (이건 자바스크립트로 막아!!)
		List<LctreTimetableVO> lctreTimetableVOList = this.counselService.selectMyProfTimetable(profsrNo);
		log.info("myprof() -> lctreTimetableVOList : {}", lctreTimetableVOList);
		
		List<CnsltVO> cnsltVOList = this.counselService.profCnsltList(profsrNo);
		
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("lctreTimetableVOList", lctreTimetableVOList);
		map.put("cnsltVOList", cnsltVOList);
		return map;
	}
	
	
	//String acntId = "241011001"; //테헤란로사는 갑부 김철수 학생님
	
	//	/ fetch("/counsel/create"
	//상담신청 
	@ResponseBody
	@PostMapping("/create")
	public Map<String,Object> create(Principal principal
								 , @RequestBody CnsltVO cnsltVO) {
		
		String acntId = principal.getName();
		
		String stdntNo = this.counselService.selectStdntNo(acntId);
		
		cnsltVO.setStdntNo(stdntNo);
		
		log.info("create() -> cnsltVO : {}", cnsltVO);
		int result = this.counselService.createCnslt(cnsltVO);
				
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("success","success");
		map.put("result",result);
		
		
		return map;
		
	}
	
	
	///아래는 안쓰는거.. 일단안지움 쓰는거 섞여있을수도 있을것 같아 일단 안지움////
	
	@GetMapping("/prof")
	public String cnsltprof() {
		//교수 상담영역으로 고고
		return "counsel/cnsltat";
				
	}
		
	//내 상담 목록 보기
	@ResponseBody
	@GetMapping("/getlist")
	public Map<String,Object> getlist(Principal principal) {
		String acntId = principal.getName();
		 
		
		// 계정아이디에 해당되는 상담 가능 테이블 리스트 가져오기 
		List<CnsltAtVO> cnsltAtVOList = new ArrayList<CnsltAtVO>();
		
		cnsltAtVOList = this.counselService.getCnsltAtVOList(acntId);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("cnsltAtVOList", cnsltAtVOList);
		map.put("result","데헤헷");
		return map;
	}
	
	
	//상담가능 내용 입력
	@ResponseBody
	@PostMapping("/insertCnsltAt")
	public int insertCnsltAt(@RequestBody CnsltAtVO cnsltAtVO) {
				
		int result = this.counselService.insertCnsltAt(cnsltAtVO);
		
		return result;
	}
	
	//fetch(`/counsel/seletCnsltDetail?cnsltInnb=\${cnsltInnb}`,{
    
	
	@ResponseBody
	@GetMapping("/seletCnsltDetail")
	public Map<String,Object> seletCnsltDetail (@RequestParam int cnsltInnb) {
				
		CnsltVO cnsltVO = this.counselService.seletCnsltDetail(cnsltInnb);
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("cnsltVO",cnsltVO);
				
		return map;
	}
	
	

	
	
	
	
	
}
