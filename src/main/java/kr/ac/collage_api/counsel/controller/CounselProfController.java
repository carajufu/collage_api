package kr.ac.collage_api.counsel.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.collage_api.common.config.ArticlePage;
import kr.ac.collage_api.counsel.service.CounselProfService;
import kr.ac.collage_api.vo.CnsltVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/counselprof")
@Controller
public class CounselProfController {

	@Autowired
	CounselProfService counselProfService;

	@GetMapping("/prof")
	public String cnsltProf() {

		return "counsel/cnsltprof";
	}

	@ResponseBody
	@GetMapping("/proflist")
	public Map<String, Object> list(Principal principal
				 	 , @RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage
				 	 , @RequestParam(value="keyword",required=false,defaultValue="") String keyword) {
		int size = 5;

		String acntId = principal.getName();

		// 계정아이디로 교수NO 가져오기
		String profsrNo =  this.counselProfService.getProfsrNo(acntId);

		Map<String,Object> map = new HashMap<String,Object>();

		map.put("currentPage",currentPage);
		map.put("keyword",keyword);
		map.put("profsrNo", profsrNo);
		map.put("size", size);


		//keyword 에는 상태("1,2,3,4") 가 담김 키워드가 안들어가면 그냥 총 목록 개수가 나옴
		int total = this.counselProfService.getTotal(map);

		List<CnsltVO> cnsltVOList = this.counselProfService.list(map);

		//페이지 네이션
		ArticlePage<CnsltVO> articlePage = new ArticlePage<CnsltVO>(total, currentPage, size, cnsltVOList, keyword, "");

		map.put("cnsltVOList", cnsltVOList);
		map.put("articlePage", articlePage);

		map.put("startPage",articlePage.getStartPage());
		map.put("endPage",articlePage.getEndPage());
		map.put("totalPage",articlePage.getTotalPages());


		//나의 상담관리 카운트 하기
		List<CnsltVO> cnsltVOCountList = this.counselProfService.selectProfCnsltCount(profsrNo);
		map.put("cnsltVOCountList", cnsltVOCountList);

		return map;
	}

	@ResponseBody
	@PatchMapping("/patchAccept")
	public int patchAccept(Principal principal
							,@RequestBody CnsltVO cnsltVO) {

		log.info("patchAccept() -> cnsltVO : {}", cnsltVO);

		int result = this.counselProfService.patchAccept(cnsltVO);

		return result;
	}

	@ResponseBody
	@PatchMapping("/patchCancl")
	public int patchCancl(Principal principal
							,@RequestBody CnsltVO cnsltVO) {

		log.info("patchCancl() -> cnsltVO : {}", cnsltVO);

		int result = this.counselProfService.patchCancl(cnsltVO);

		return result;
	}

	@ResponseBody
	@PatchMapping("/patchResult")
	public int patchResult(Principal principal
			,@RequestBody CnsltVO cnsltVO) {

		log.info("patchResult() -> cnsltVO : {}", cnsltVO);

		int result = this.counselProfService.patchResult(cnsltVO);

		return result;
	}

}
