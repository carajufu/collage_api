package kr.ac.collage_api.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.ac.collage_api.admin.service.BbsNoticeService;
import kr.ac.collage_api.vo.BbsVO;
import kr.ac.collage_api.common.config.ArticlePage;
import lombok.extern.slf4j.Slf4j;


@RequestMapping("/bbs")
@Slf4j
@Controller
public class BbsNoticeContorller {

	@Autowired
	BbsNoticeService bbsNoticeService;
	
	@GetMapping("/list")
	public String list(Model model,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword) {
		
		int size = 10;	//한페이지에 보여지는 수
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		
		// "keyword" 가 null이면 공지사항 유형의게시글만 가지고오고,
		// "keyword"가 있으면 공지사항 유형 + keyword를 검색해서 관련 글의 총갯수를 가지고 옴
		int total = this.bbsNoticeService.getTotal(map);
		
		//bbsVOList에는 현재 페이지에 맞는 목록 만 가지고 옴
		List<BbsVO> bbsVOList = this.bbsNoticeService.list(map);
		
		//페이지네이션
		ArticlePage<BbsVO> articlePage = new ArticlePage<BbsVO>(total,currentPage,size,bbsVOList,keyword,"/bbs/list");
		
		model.addAttribute("bbsVOList",bbsVOList);
		model.addAttribute("articlePage",articlePage);
		
		return "bbsnotice";
	}
	
	//http://localhost:8085/bbs/detail?bbscttNo=7
	@GetMapping("/detail")
	public String detail(Model model
						,@RequestParam(value="bbscttNo",required=false,defaultValue="") int bbscttNo) {
		
		BbsVO bbsVO = this.bbsNoticeService.detail(bbscttNo);
		
		model.addAttribute("bbsVO",bbsVO);
				
		return "bbsdetail";
	}
	
	@PostMapping("/delete")
	public String delete(@RequestParam(value="id") int bbscttNo) {
		
		
		int result = this.bbsNoticeService.delete(bbscttNo);
		
		
		
		return "redirect:/bbs/list";
	}
	
	
}
