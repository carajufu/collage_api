package kr.ac.collage_api.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class IntegratedSearchCcontroller {

    @GetMapping("/search")
    public String search(@RequestParam(name = "q", required = false) String keyword,
                         Model model) {
    	

        // 검색 로직 …
        model.addAttribute("q", keyword);
        return "search/search";
    }
    
    
}
