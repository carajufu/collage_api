package kr.ac.collage_api.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.admin.service.BbsNoticeService;
import kr.ac.collage_api.vo.BbsVO;
import kr.ac.collage_api.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@CrossOrigin(origins = "*" )
@RequestMapping("/admin/bbs")
@Slf4j
@RestController
public class AdminNoticeBoardController {


	@Autowired
	BbsNoticeService bbsNoticeService;


	@GetMapping("/getlist")
	public Map<String,Object> getlist () {
		
		List<BbsVO> bbsVOList = this.bbsNoticeService.adminList();
		log.info("adminList() -> bbsVOList : {}", bbsVOList);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("bbsVOList",bbsVOList);
		return map;
	}
	

	
	@PutMapping("/putdetail")
	public int putdetail(@RequestPart BbsVO bbsVO
						, @RequestPart(value="files", required = false) List<MultipartFile> files
						, @RequestPart(value="deletedFileSns", required=false) List<Integer> deletedFileSns) {
		log.info("putdetail() -> bbsVO : {}", bbsVO);
		log.info("putdetail() -> deletedFileSns : {}", deletedFileSns);
		log.info("putdetail() -> files : {}", files);
		
		int result = this.bbsNoticeService.adminPutDetail(bbsVO, files, deletedFileSns);

		return result;
	}
	

	
	@DeleteMapping("/deletedetail/{bbscttNo}")
	public int deletedetail(@PathVariable int bbscttNo) {
		
		int result = this.bbsNoticeService.adminDeleteDetail(bbscttNo);
		
		return result;
	}
	

	
	@PostMapping("/postdetail")
	public int postdetail(BbsVO bbsVO) {
		String acntId = "a001";
		
		//만약 jwt 토큰을 저장해서 보내왓고, 그걸 pincipal로 Userdetais 객체를 저장했다면
		//if 문 써야 하는데 이건 종우씨한테 물어보기 ㄱㄱ
		
		bbsVO.setAcntId(acntId);
		
		
		log.info("postdetail() -> bbsVO : {}", bbsVO);
		int result = this.bbsNoticeService.adminPostDetail(bbsVO);
		return result;
		
	}
	

	
	@GetMapping("/detail/{bbscttNo}")
	public Map<String,Object> adminDetail(@PathVariable int bbscttNo){
		log.info("adminDetail() -> bbsVO : {}", bbscttNo);
		BbsVO bbsVO = this.bbsNoticeService.adminDetail(bbscttNo);

		Map<String,Object> map = new HashMap<String,Object>();
		map.put("bbsVO",bbsVO);

		if (bbsVO.getFileGroupNo()!=null) {
			Long fileGroupNo = bbsVO.getFileGroupNo();

			List<FileDetailVO> fileDetailVOList = this.bbsNoticeService.getFileDetailList(fileGroupNo);
			log.info("adminDetail() -> fileDetailVOList : {}", fileDetailVOList);
			map.put("fileDetailVOList", fileDetailVOList);
		}



		return map;
	}





}
