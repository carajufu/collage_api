package kr.ac.collage_api.counsel.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.ac.collage_api.counsel.dto.CounselAdminChartDTO;
import kr.ac.collage_api.counsel.service.CounselAdminService;
import kr.ac.collage_api.vo.CnsltVO;
import lombok.extern.slf4j.Slf4j;

@CrossOrigin(origins = "*")
@RequestMapping("/admin/cnslt")
@Slf4j
@RestController
public class CounselAdminController {

	@Autowired
	CounselAdminService counselAdminService;

	//상담 리스트 불러오기
	@GetMapping("/list")
	public List<CnsltVO> selectCnsltList() {
		return this.counselAdminService.selectCnsltList();
	}

	//상담 디테일(기본키:cnsltInnb) 불러오기
	@GetMapping("/detail/{cnsltInnb}")
	public CnsltVO selectCnsltDetail(@PathVariable("cnsltInnb") int cnsltInnb) {
		return this.counselAdminService.selectCnsltDetail(cnsltInnb);
	}

	//상담 대쉬보드 CHART VALUE 가져오기
	@GetMapping("/chartvalue")
	public CounselAdminChartDTO selectCnlstChartValue() {
		return this.counselAdminService.selectCnlstChartValue();
	}

}
