package kr.ac.collage_api.competency.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import kr.ac.collage_api.competency.service.CompetencyService;
import kr.ac.collage_api.competency.vo.CompetencyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/compe")
public class CompetencyController {

    @Autowired
    private CompetencyService competencyService;

    // 1. 작성 폼 이동
    @GetMapping("/main")
    public String selfIntroForm() {
    	
        return "competency/selfIntro";
    }
    
    // 2. 생성
    @PostMapping("/generate")
    public String generateSelfIntro(HttpSession session, @ModelAttribute CompetencyVO selfIntroVO) {
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();
        
        selfIntroVO.setStdntNo(stdntNo);

        competencyService.createAndSaveSelfIntro(selfIntroVO);
        
        return "redirect:/compe/main";
    }

    // 3. 상세 보기
    @GetMapping("/detail")
    public String selfIntroDetail(@RequestParam("introNo") int introNo, Model model) {
    	CompetencyVO result = competencyService.getSelfIntroDetail(introNo);
        model.addAttribute("selfIntro", result);
        return "/";
    }
    
}