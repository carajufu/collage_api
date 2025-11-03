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
    private GradeScreService gradeService;

    @GetMapping("/main/All")
    public String stdntGradeMain(Model model) {

        // Spring Security에서 로그인한 사용자 정보(학번) 가져오기
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName(); // 로그인 ID가 학번(STDNT_NO)이라고 가정

        // (신규) 학생의 '학기별' 성적 목록 조회
        List<GradeScreVO> semstrList = gradeService.getStudentSemstrList(stdntNo);
        log.info("getStudentSemstrList : {}", semstrList);

        // [수정] JSP에서 사용하는 "getAllSemstr"로 모델 속성명 변경
        model.addAttribute("getAllSemstr", semstrList);
        return "grade/stdntGradeScreMain"; // stdntGradeScreMain.jsp
    }

    @GetMapping("/main/detail/{semstrScreInnb}")
    public String stdntGradeDetail(@PathVariable String semstrScreInnb, Model model) {

        // (신규) 해당 학기의 '과목별' 상세 성적 목록 조회
        List<GradeScreVO> subjectList = gradeService.getStudentSemstrDetail(semstrScreInnb);
        log.info("getStudentSemstrDetail : {}", subjectList);

        // (참고) stdntGradeScreDetail.jsp에서 사용할 모델
        model.addAttribute("subjectList", subjectList);
        // model.addAttribute("semesterInfo", ...); // 필요시 학기 정보도 조회

        return "grade/stdntGradeScreDetail"; // stdntGradeScreDetail.jsp
    }
}
