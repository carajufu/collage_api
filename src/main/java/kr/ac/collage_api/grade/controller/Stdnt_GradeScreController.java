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

import kr.ac.collage_api.grade.service.GradeScreService;
import kr.ac.collage_api.grade.vo.GradeScreVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/stdnt/grade")
public class Stdnt_GradeScreController {

    @Autowired
    private GradeScreService gradeService;

    // 로그인 구현 전 임시
    String stdntNo = "202400001";

    // 학생 과목별 상세 성적
    @GetMapping("/main/All")
    public String stdntGradeDetail(Model model) {
    	
    	List<GradeScreVO> getAllSemstr = gradeService.getAllSemstr(stdntNo);
    	log.info("getAllScore : {}", getAllSemstr);
    	
    	model.addAttribute("getAllScore", getAllSemstr);
    	return "grade/stdntGradeScreMain";
    }
    
    // 학생 성적 메인 목록
    @GetMapping("/main/detail/{sbjectScreInnb}")
    public String stdntGradeMain(Model model) {

        List<GradeScreVO> getAllSemstr = gradeService.getAllSemstr(stdntNo);
        log.info("getAllScore : {}", getAllSemstr);

        model.addAttribute("getAllScore", getAllSemstr);

        return "grade/stdntGradeScreDetail";
    }
}
