package kr.ac.collage_api.competency.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.ac.collage_api.competency.service.CompetencyService;
import kr.ac.collage_api.competency.vo.CompetencyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/compe")
public class CompetencyController {

    @Autowired
    private CompetencyService competencyService;

    // 메인 폼 조회 (학생별 단일 폼)
    @GetMapping("/main")
    public String main(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();

        CompetencyVO data = competencyService.getFormData(stdntNo);
        if (data == null) {
            data = new CompetencyVO();
        }

        model.addAttribute("form", data);
        return "competency/selfIntro";
    }

    // Gemini 기반 자기소개서 생성
    @PostMapping("/generate")
    public String generate(
            @ModelAttribute CompetencyVO form,
            Model model) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();
        form.setStdntNo(stdntNo);

        competencyService.saveForm(form);

        String resultIntro = competencyService.generateIntro(form);

        model.addAttribute("generatedEssay", resultIntro);
        model.addAttribute("form", form);

        return "competency/selfIntro";
    }
}
