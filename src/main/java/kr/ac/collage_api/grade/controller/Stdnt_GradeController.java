package kr.ac.collage_api.grade.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.ac.collage_api.grade.service.GradeService;
import kr.ac.collage_api.grade.vo.GradeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/stdnt/grade")
public class Stdnt_GradeController {

    @Autowired
    private GradeService gradeService;

    // 로그인 구현 전 임시
    String stdntNo = "202400001";

    // 학생 성적 메인 목록
    @GetMapping("/main/All")
    public String stdntGradeMain(Model model) {

        List<GradeVO> getAllScore = gradeService.getAllScore(stdntNo);
        log.info("getAllScore : {}", getAllScore);

        model.addAttribute("getAllScore", getAllScore);

        return "grade/stdntGradeMain";
    }

    // 학생 과목별 상세 성적
    @GetMapping("/main/detail/{semstrScreInnb}")
    public String stdntGradeDetail(@PathVariable("semstrScreInnb") String semstrScreInnb, Model model) {

        Map<String, Object> params = new HashMap<>();
        params.put("stdntNo", stdntNo);
        params.put("semstrScreInnb", semstrScreInnb);

        GradeVO detailScore = gradeService.getSbjectDetailScore(params);
        log.info("detailScore : {}", detailScore);

        model.addAttribute("detailScore", detailScore);

        return "grade/stdntGradeDetail";
    }
}
