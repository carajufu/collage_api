package kr.ac.collage_api.grade.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import kr.ac.collage_api.grade.service.GradeScreService;
import kr.ac.collage_api.grade.vo.GradeScreForm;
import kr.ac.collage_api.grade.vo.GradeScreVO;

/**
 * [수정 사항]
 * 1. (추가) @PostMapping("/main/save")
 * - detail.jsp의 AJAX 저장(/main/save) 요청을 처리할 엔드포인트를 추가했습니다.
 * - 폼 데이터를 GradeScreForm VO로 바인딩합니다.
 * - gradeService.saveGrades (INSERT+UPDATE)를 호출합니다.
 * - AJAX 응답으로 "success" 또는 "error" 문자열을 반환합니다.
 *
 * 2. (유지) profGradeDetail
 * - detail.jsp가 사용하는 ${selSbject}와 ${sbjectScr}를 모델에
 * 정상적으로 추가하고 있으므로, 기존 코드를 유지합니다.
 */
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

    /**
     * [신규 추가] 성적 저장 (INSERT + UPDATE)
     * detail.jsp의 '/main/save' AJAX 호출을 처리합니다.
     */
    @PostMapping("/main/save")
    @ResponseBody
    public String saveGrade(@ModelAttribute GradeScreForm gradeForm,
                            @RequestParam("estbllctreCode") String estbllctreCode) {
        try {
            // Service 호출: 폼에서 바인딩된 grades 리스트와 estbllctreCode를 전달
            gradeService.saveGrades(gradeForm.getGrades(), estbllctreCode);
            
            // JSP의 success: function()으로 "success" 문자열 반환
            return "success"; 
        } catch (Exception e) {
            e.printStackTrace();
            // JSP의 error: function() 또는 success:의 else 분기 처리용 "error" 반환
            return "error"; 
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