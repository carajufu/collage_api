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
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.collage_api.counsel.service.CounselService;
import kr.ac.collage_api.vo.CnsltAtVO;

@RequestMapping("/counsel")
@Controller
public class CounselController {

	@Autowired
	CounselService counselService;
	
	
	@GetMapping("/prof")
	public String cnsltprof() {
		//교수 상담영역으로 고고
		return "counsel/cnsltat";
				
	}
		
	//내 상담 목록 보기
	@ResponseBody
	@GetMapping("/getlist")
	public Map<String,Object> getlist(Principal principal) {
		String acntId = "P2301";
		
		if(principal != null) {
			acntId = principal.getName();
		} 
		
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
	
	
	
	
}
