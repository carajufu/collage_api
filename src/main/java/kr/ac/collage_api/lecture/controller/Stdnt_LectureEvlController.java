package kr.ac.collage_api.lecture.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.collage_api.lecture.service.LectureEvlService;
import kr.ac.collage_api.lecture.vo.LectureEvlVO;

@Controller
@RequestMapping("/stdnt/lecture")
public class Stdnt_LectureEvlController {

    @Autowired
    private LectureEvlService lectureService;

    @GetMapping("/main/All")
    public String evalForm(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId = (auth != null) ? auth.getName() : null;
        if (acntId == null) {
            return "redirect:/login";
        }
        String stdntNo = lectureService.getStdntNoByAcntId(acntId);
        if (stdntNo == null) {
            model.addAttribute("atnlcList", List.of());
            return "lecture/stdntLctreEvlMain";
        }
        List<LectureEvlVO> atnlcList = lectureService.getAllLecturesByStdntNo(stdntNo);
        model.addAttribute("atnlcList", atnlcList);
        return "lecture/stdntLctreEvlMain";
    }

    @GetMapping("/main/{estbllctreCode}")
    public String evalpage(@PathVariable String estbllctreCode, Model model) {
        LectureEvlVO lectureInfo = lectureService.getEstblCourseById(estbllctreCode);
        Integer evlNo = lectureService.getEvlNoByEstbllctreCode(estbllctreCode);
        if (evlNo == null) {
            evlNo = lectureService.createDefaultEvaluation(estbllctreCode);
        }
        List<LectureEvlVO> evalItemList = lectureService.getEvlIem(evlNo);
        model.addAttribute("estbllctreCode", estbllctreCode);
        model.addAttribute("lectureInfo", lectureInfo);
        model.addAttribute("evalItemList", evalItemList);
        return "lecture/stdntLctreEvlDetail";
    }

    @PostMapping("/save")
    @ResponseBody
    public String evalSubmit(@RequestBody Map<String, Object> body) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId = (auth != null) ? auth.getName() : null;
        if (acntId == null) {
            return "fail_auth";
        }
        String stdntNo = lectureService.getStdntNoByAcntId(acntId);
        if (stdntNo == null) {
            return "fail_auth";
        }
        @SuppressWarnings("unchecked")
        List<Integer> evlScore = (List<Integer>) body.get("evlScore");
        @SuppressWarnings("unchecked")
        List<String> evlCn = (List<String>) body.get("evlCn");
        String estbllctreCode = (String) body.get("estbllctreCode");
        lectureService.insertLectureEval(estbllctreCode, stdntNo, evlScore, evlCn);
        return "success";
    }
}
