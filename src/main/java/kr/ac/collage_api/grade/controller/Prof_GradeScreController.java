package kr.ac.collage_api.grade.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.collage_api.grade.service.GradeScreService;
import kr.ac.collage_api.grade.vo.GradeScreForm;
import kr.ac.collage_api.grade.vo.GradeScreVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/prof/grade")
public class Prof_GradeScreController {

    @Autowired
    GradeScreService gradeService;

	//교수번호 임시 하드코딩
	String profsrNo = "P0001";
    
    @GetMapping("/main/All")
    public String profGradeMain(Model model) {
        List<GradeScreVO> allSbject = gradeService.getAllSbject(profsrNo);
        log.info("allSbject : {}", allSbject);
        model.addAttribute("allSbject",allSbject);
        return "grade/profGradeScreMain";
    }

    @GetMapping("/main/detail/{estbllctreCode}")
    public String profGradeDetail(@PathVariable String estbllctreCode,
						          Model model) {

    	List<GradeScreVO> selSbjectList = gradeService.getCourse(profsrNo);
    	log.info("selSbjectList : {}",selSbjectList);
    	
    	List<GradeScreVO> sbjectScr = gradeService.getSbjectScr(estbllctreCode);
    	log.info("sbjectScr : {}",sbjectScr);
    	
    	model.addAttribute("selSbject", selSbjectList.get(0));
    	model.addAttribute("sbjectScr", sbjectScr);
    	
    	return "grade/profGradeScreDetail";
    }
    
    @PostMapping("/main/detail/{estbllctreCode}/save")
    public String profGradeSubmint(@PathVariable String estbllctreCode,
    								@ModelAttribute GradeScreForm gradeForm, Model model) {
    	int result = this.gradeService.profGradeSubmit(gradeForm);
    	log.info("result : {}", result);
    	model.addAttribute("result",result);
    	return "redirect:/prof/grade/main/detail/" + estbllctreCode;
    }
    
    @PostMapping("/main/detail/{estbllctreCode}/edit")
    public String profGradeEdit(@PathVariable String estbllctreCode,
    							@ModelAttribute GradeScreForm gradeForm, Model model) {
    	int result = this.gradeService.profGradeEdit(gradeForm);
    	log.info("result : {}", result);
    	model.addAttribute("result",result);	
    	return "redirect:/prof/grade/main/detail/" + estbllctreCode;
    }
    
    /**
     * 학생 검색 (모달용)
     */
    @GetMapping("/main/searchStudent")
    @ResponseBody
    public List<GradeScreVO> searchStudent(@RequestParam("keyword") String keyword, String estbllctreCode) {
        return gradeService.searchStudent(keyword, estbllctreCode);
    }

    /**
     * 점수 수정 (기존 데이터만 UPDATE)
     */
    @PostMapping("/main/update")
    @ResponseBody
    public String updateGrade(@ModelAttribute GradeScreForm gradeForm) {
    	log.info("gradeForm : {}", gradeForm.getGrades());
        gradeService.updateGrades(gradeForm.getGrades());
        return "success";
    }

    /**
     * 점수 완료 (없는 학생은 INSERT → 전체 UPDATE)
     */
    @PostMapping("/main/save")
    @ResponseBody
    public String saveGrade(@ModelAttribute GradeScreForm gradeForm, @RequestParam("estbllctreCode") String estbllctreCode) {
    	log.info("gradeForm : {}", gradeForm.getGrades());
        gradeService.saveGrades(gradeForm.getGrades(), estbllctreCode);
        return "success";
    }

}
