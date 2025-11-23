package kr.ac.collage_api.grade.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import kr.ac.collage_api.grade.service.GradeScreService;
import kr.ac.collage_api.grade.vo.GradeScreForm;
import kr.ac.collage_api.grade.vo.GradeScreVO;

@Controller
@RequestMapping("/prof/grade")
public class Prof_GradeScreController {

    @Autowired
    GradeScreService gradeService;

    /**
     * 개설 강의 목록 (수정 없음)
     */
    @GetMapping("/main/All")
    public String profGradeMain(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId = auth.getName();
        String profsrNo = gradeService.getProfsrNoByAcntId(acntId);

        List<GradeScreVO> allSbject = gradeService.getAllSbject(profsrNo);
        model.addAttribute("allCourseList", allSbject);

        return "grade/profGradeScreMain";
    }

    /**
     * 강의 상세 / 성적 목록 화면
     * (detail.jsp와 모델 속성이 일치하므로 수정 없음)
     */
    @GetMapping("/main/detail/{estbllctreCode}")
    public String profGradeDetail(@PathVariable String estbllctreCode, Model model) {

        // 1. 강의 기본 정보 (detail.jsp의 ${selSbject}와 매핑)
        GradeScreVO selSbject = gradeService.getCourseDetail(estbllctreCode);

        // 2. 강의 수강 학생 성적 목록 (detail.jsp의 ${sbjectScr}와 매핑)
        List<GradeScreVO> sbjectScr = gradeService.getSbjectScr(estbllctreCode);

        model.addAttribute("selSbject", selSbject);
        model.addAttribute("sbjectScr", sbjectScr);

        return "grade/profGradeScreDetail";
    }

    @PostMapping("/main/save")
    public String saveGrade(@ModelAttribute GradeScreForm gradeForm,
                            @RequestParam("estbllctreCode") String estbllctreCode,
                            RedirectAttributes redirectAttr) {

        try {
            gradeService.saveGrades(gradeForm.getGrades(), estbllctreCode);

            redirectAttr.addFlashAttribute("msg", "성적이 저장되었습니다.");

            return "redirect:/prof/grade/main/detail/" + estbllctreCode;

        } catch (Exception e) {
            redirectAttr.addFlashAttribute("msg", "오류가 발생했습니다.");
            return "redirect:/prof/grade/main/detail/" + estbllctreCode;
        }
    }

    /**
     * 학생 검색 (수정 없음)
     */
    @GetMapping("/main/searchStudent")
    @ResponseBody
    public List<GradeScreVO> searchStudent(@RequestParam("keyword") String keyword,
                                           @RequestParam("estbllctreCode") String estbllctreCode) {
        return gradeService.searchStudent(keyword, estbllctreCode);
    }
}
