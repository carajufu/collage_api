package kr.ac.collage_api.campus.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.collage_api.campus.service.CampusMapService;

@Controller
@RequestMapping("/info")
public class CampusMapController {
	
	@Autowired
	private CampusMapService service;

	@GetMapping("/campus/map")
	public String campusMap(Principal principal) {
		
		if (principal == null) {
            return "redirect:/login";
        }
		return "campus/campus_map";
	}
	
	//학과 정보
	@GetMapping("/getDeptList")
    @ResponseBody
    public List<String> getDeptList(@RequestParam("code") String univCode) {
		
        return service.getDeptList(univCode);
    }
	
}
