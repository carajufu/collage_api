package kr.ac.collage_api.competency.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.ac.collage_api.competency.service.CompetencyService;
import kr.ac.collage_api.competency.vo.CompetencyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/compe")
public class CompetencyController {

    @Autowired
    private CompetencyService competencyService;

    // 메인 페이지
    @GetMapping("/main")
    public String main(Model model) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();

        CompetencyVO form = competencyService.getFormData(stdntNo);
        if (form == null) {
            form = new CompetencyVO();
        }

        model.addAttribute("form", form);
        return "competency/selfIntroMain";
    }

    // AI 자기소개서 생성 + 버전 저장
    @PostMapping("/generateAjax")
    public ResponseEntity<Map<String, Object>> generateAjax(@ModelAttribute CompetencyVO form) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();
        form.setStdntNo(stdntNo);

        competencyService.saveForm(form);

        String resultIntro = competencyService.generateIntro(form);

        competencyService.insertManageCn(stdntNo, resultIntro);

        Map<String, Object> res = new HashMap<>();
        res.put("generatedEssay", resultIntro);

        return ResponseEntity.ok(res);
    }

    // 이어쓰기(detail) 페이지
    @GetMapping("/detail")
    public String detail(Model model) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();

        List<CompetencyVO> manageList = competencyService.getManageCnList(stdntNo);

        CompetencyVO form = competencyService.getFormData(stdntNo);
        if (form == null) {
            form = new CompetencyVO();
        }

        model.addAttribute("manageList", manageList);
        model.addAttribute("form", form);

        return "competency/selfIntroDetail";
    }
    
    // 버전 1건 삭제
    @PostMapping("/detail/delete")
    public String deleteOneManageCn(@RequestParam("formId") int formId) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();

        competencyService.deleteOneManageCn(stdntNo, formId);

        return "redirect:/compe/detail";
    }


    // 기본 이력 관리 페이지
    @GetMapping("/manage")
    public String manage(Model model,
                         @RequestParam(value = "save", required = false) String save) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();

        // 기본 폼 : 해당 학생의 최신 이력 1건
        CompetencyVO form = competencyService.getFormData(stdntNo);
        if (form == null) {
            form = new CompetencyVO();
        }

        // 전체 COMPETENCY 데이터 (관리용 리스트)
        List<CompetencyVO> allList = competencyService.getAllByStdntNo(stdntNo);

        model.addAttribute("form", form);
        model.addAttribute("allList", allList);
        model.addAttribute("save", save);

        log.info("form = {}", form);
        log.info("allList = {}", allList);
        log.info("save = {}", save);

        return "competency/selfIntroManage";
    }

    // 기본 폼 데이터 저장
    @PostMapping("/manage/save")
    public String saveManage(@ModelAttribute CompetencyVO form) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();
        form.setStdntNo(stdntNo);

        // 최신 1건 기준 insert / update
        competencyService.saveForm(form);

        return "redirect:/compe/manage?save=ok";
    }

    // 전체 자소서 버전 삭제
    @PostMapping("/manage/delete")
    public String deleteManageCn() {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();

        competencyService.deleteManageCn(stdntNo);

        return "redirect:/compe/main";
    }
}
