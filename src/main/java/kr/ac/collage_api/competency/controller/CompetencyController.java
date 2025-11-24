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

    // 메인 페이지 (기본 폼 조회)
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

        // 1) 기본 입력데이터 저장
        competencyService.saveForm(form);

        // 2) AI 생성
        String resultIntro = competencyService.generateIntro(form);

        // 3) 생성된 자소서 한 건 저장
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

        // 저장된 자소서 목록
        List<CompetencyVO> manageList = competencyService.getManageCnList(stdntNo);

        // 기본 폼도 불러오기 (학력/군필/자격증/성격/프로젝트)
        CompetencyVO form = competencyService.getFormData(stdntNo);
        if (form == null) form = new CompetencyVO();
        model.addAttribute("manageList", manageList);
        model.addAttribute("form", form);

        return "competency/selfIntroDetail";
    }

    // 기본 이력 관리 페이지
    @GetMapping("/manage")
    public String manage(Model model,
                         @RequestParam(value = "save", required = false) String save) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();

        CompetencyVO form = competencyService.getFormData(stdntNo);
        if (form == null) {
            form = new CompetencyVO();
        }

        model.addAttribute("form", form);
        model.addAttribute("save", save);

        return "competency/selfIntroManage";
    }

    // 기본 폼 데이터 저장
    @PostMapping("/manage/save")
    public String saveManage(@ModelAttribute CompetencyVO form) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();
        form.setStdntNo(stdntNo);

        competencyService.saveForm(form);

        return "redirect:/compe/manage?save=ok";
    }

    //선택 자소서 버전 삭제
    @PostMapping("/detail/delete")
    public String deleteOneManageCn(
            @RequestParam(value="formId", required=false) Integer formId) {

        if (formId == null) {
            return "redirect:/compe/detail?err=noFormId";
        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();

        competencyService.deleteOneManageCn(stdntNo, formId);

        return "redirect:/compe/detail";
    }

}
