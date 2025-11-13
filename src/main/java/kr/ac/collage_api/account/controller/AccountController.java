package kr.ac.collage_api.account.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.account.service.AccountService;
import kr.ac.collage_api.vo.StdntVO;
import kr.ac.collage_api.vo.SubjctVO;
import kr.ac.collage_api.vo.UnivVO;
import lombok.extern.slf4j.Slf4j;

@CrossOrigin("*")
@RequestMapping("/admin/acnt")
@Slf4j
@RestController
public class AccountController {
	
	@Autowired
	AccountService accountService; 

	//대학코드 반환
	@GetMapping("/univcn")
	public Map<String,Object> selectUnivCNinfo() {
		
		List<UnivVO> univVOList = this.accountService.selectUnivCNinfo();
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("univVOList",univVOList);
		
		return map;
		
	}

	//학과코드 반환
	@GetMapping("/sbjctcn")
	public Map<String,Object> selectSubjctCNinfo(@RequestParam("univCode") String univCode) {
		
		List<SubjctVO> subjctVOList = this.accountService.selectSubjctCNinfo(univCode);
	
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("subjctVOList",subjctVOList);
		return map;
		
	}
	
	//학생계정생성
	@PostMapping("/insertstd")
	public int insertStdAccount (@RequestBody StdntVO stdntVO) {
		
		int result =this.accountService.insertStdAccount(stdntVO);
		return result;
	}
	
	//학생계정 대량생성
	@PostMapping("/insertstdbulk")
	public int insertStdAccountBulk (@RequestParam("file") MultipartFile uploadFile) {
		log.info("insertStdAccountBulk() -> uploadFile : {}", uploadFile);
		 int result = this.accountService.insertStdAccountBulk(uploadFile);
		
		return result;
	}
	
	/*
	여기서 부터 학생 계정 수정수정
	*/
	
	@GetMapping("/selectStdntInfo")
	public List<StdntVO> selectStdntInfo (@RequestParam("keyword") String keyword){
		
		List<StdntVO> stdntVOList = new ArrayList<>();
		
		stdntVOList = this.accountService.selectStdntInfo(keyword);
		
 		return stdntVOList;
	}
	
	
	@GetMapping("/stdnteditdetail/{stdntNo}")
	public StdntVO selectOneStdntInfo (@PathVariable("stdntNo") String stdntNo){
		return this.accountService.selectOneStdntInfo(stdntNo);
	}
	

	@PutMapping("/updatestd")
	public int updateStdAccount(@RequestBody StdntVO stdntVO) {
		
		
		
		int result = this.accountService.updateStdAccount(stdntVO);;
		
		return result;
	}
	
	
	
	

}
