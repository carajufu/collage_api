package kr.ac.collage_api.counsel.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;



@Controller
public class CounselRoom {

	@GetMapping("/counsel/room/{cnsltInnb}")
	public String counselRoom(@PathVariable String cnsltInnb, Model model) {

		model.addAttribute("cnsltInnb",cnsltInnb);

		return "counsel/cnsltvideo";
	}



	//지금 알림 교수 서비스 임플에서 보내고 랜딩페이지됨

}
