package kr.ac.collage_api.grade.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication; // Security 추가
import org.springframework.security.core.context.SecurityContextHolder; // Security 추가
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

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
        String stdntNo = auth.getName(); 

        List<GradeScreVO> semstrList = gradeService.getStudentSemstrList(stdntNo);
        log.info("getStudentSemstrList : {}", semstrList);

        model.addAttribute("getAllSemstr", semstrList);
        return "grade/stdntGradeScreMain"; 
    }

    @GetMapping("/main/detail/{semstrScreInnb}")
    public String stdntGradeDetail(@PathVariable String semstrScreInnb, Model model) {

        List<GradeScreVO> subjectList = gradeService.getStudentSemstrDetail(semstrScreInnb);
        log.info("getStudentSemstrDetail : {}", subjectList);

        model.addAttribute("subjectList", subjectList);
        // model.addAttribute("semesterInfo", ...);

        return "grade/stdntGradeScreDetail";
    }
}
