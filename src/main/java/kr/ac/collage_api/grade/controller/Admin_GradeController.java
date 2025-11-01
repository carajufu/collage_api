//package kr.ac.collage_api.grade.controller;
//
//import java.util.List;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//
//import kr.ac.collage_api.grade.service.GradeService;
//import kr.ac.collage_api.grade.vo.GradeVO;
//import kr.ac.collage_api.vo.LctreEvlVO;
//import lombok.extern.slf4j.Slf4j;
//
//@Slf4j
//@Controller
//@RequestMapping("/admin/grade")
//public class Admin_GradeController {
//
//    @Autowired
//    private GradeService gradeService;
//
//    /**
//     * 전체 성적 관리(관리자)
//     * - Model에 담는 구조:
//     *   1) allGrades: List<GradeVO> → 전체 성적 테이블
//     *   2) stats: List<GradeStatsDTO> → 집계용(평균/최대/최소/인원 등)
//     */
//    @GetMapping("/main/All")
//    public String adminGradeMain(Model model) {
//
//        List<GradeVO> result = gradeService.getAllGrades();
//
//        model.addAttribute("result", result);
//
//        log.info("result : ", result);
//        return "grade/adminGradeMain";
//    }
//
//    /**
//     * 전체 강의평가 통계(관리자)
//     * - Model에 담는 구조:
//     *   1) evalStats: List<LctreEvlVO> → 강의별 평가 요약(평균/참여자수 등)
//     */
//    @GetMapping("/eval")
//    public String evalStats(Model model) {
//        List<LctreEvlVO> result = gradeService.getAllEvalStats();
//        log.info("result : ", result);
//        
//        model.addAttribute("result", result);
//        log.info("model : {}", model);
//        return "grade/adminEvalStats";
//    }
//}
package kr.ac.collage_api.grade.controller;


