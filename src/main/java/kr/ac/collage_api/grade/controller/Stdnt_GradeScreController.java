package kr.ac.collage_api.grade.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.ac.collage_api.grade.service.GradeScreService;
import kr.ac.collage_api.grade.vo.GradeScreVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/stdnt/grade")
public class Stdnt_GradeScreController {

    @Autowired
    GradeScreService gradeService;

    @GetMapping("/main/All")
    public String stdntGradeMain(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();  // 학생 번호 동일 가정
    	
        List<GradeScreVO> semList = gradeService.getStudentSemstrList(stdntNo);
        model.addAttribute("semList", semList);
        return "grade/stdntGradeScreMain";
    }

    @GetMapping("/semstr/detail")
    public String semstrDetail(@RequestParam String semstrScreInnb, Model model) {
        List<GradeScreVO> list = gradeService.getSbjectScreListBySemstr(semstrScreInnb);
        model.addAttribute("detail", list);
        return "grade/stdntGradeScreDetail";
    }
}
