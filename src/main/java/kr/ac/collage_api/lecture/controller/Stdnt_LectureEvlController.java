package kr.ac.collage_api.lecture.controller;

import java.util.HashMap;
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
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/stdnt/lecture")
public class Stdnt_LectureEvlController {

    @Autowired
    private LectureEvlService lectureService;

    // 학생 강의 평가 메인
    @GetMapping("/main/All")
    public String evalForm(Model model) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId = (auth != null) ? auth.getName() : null;

        if (acntId == null) {
            return "redirect:/login";
        }

        String stdntNo = lectureService.getStdntNoByAcntId(acntId);
        List<LectureEvlVO> atnlcList = lectureService.getAllLecturesByStdntNo(stdntNo);

        Map<String, Boolean> evlDoneMap = new HashMap<>();
        for (LectureEvlVO lecture : atnlcList) {
            String estbllctreCode = lecture.getEstbllctreCode();
            boolean done = lectureService.isLectureEvaluatedByStdnt(estbllctreCode, stdntNo);
            evlDoneMap.put(estbllctreCode, done);
        }

        model.addAttribute("atnlcList", atnlcList);
        model.addAttribute("evlDoneMap", evlDoneMap); // JSP에서 사용

        return "lecture/stdntLctreEvlMain";
    }

    // 학생 강의 평가 상세
    @GetMapping("/main/{estbllctreCode}")
    public String evalPage(@PathVariable String estbllctreCode, Model model) {

        LectureEvlVO lectureInfo = lectureService.getEstblCourseById(estbllctreCode);
        Integer evlNo = lectureService.getEvlNoByEstbllctreCode(estbllctreCode);

        // 평가 마스터 & 항목 자동 생성
        if (evlNo == null || lectureService.countEvlItems(evlNo) == 0) {
            evlNo = lectureService.createDefaultEvaluation(estbllctreCode);
        }

        // 방금 생성된 EVL_NO 기준으로 항목 목록 조회
        List<LectureEvlVO> evalItemList = lectureService.getEvalItemsByEstbllctreCode(estbllctreCode);

        model.addAttribute("lectureInfo", lectureInfo);
        model.addAttribute("estbllctreCode", estbllctreCode);
        model.addAttribute("evalItemList", evalItemList);

        return "lecture/stdntLctreEvlDetail";
    }

    // 학생 강의 평가 제출
    @PostMapping("/save")
    @ResponseBody
    public String evalSubmit(@RequestBody Map<String, Object> body) {

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String acntId = (auth != null) ? auth.getName() : null;

            if (acntId == null) {
                return "fail_auth";
            }

            String stdntNo = lectureService.getStdntNoByAcntId(acntId);

            @SuppressWarnings("unchecked")
            List<Integer> lctreEvlInnb = (List<Integer>) body.get("lctreEvlInnb");
            @SuppressWarnings("unchecked")
            List<Integer> evlScore = (List<Integer>) body.get("evlScore");
            @SuppressWarnings("unchecked")
            List<String> evlCn = (List<String>) body.get("evlCn");
            String estbllctreCode = (String) body.get("estbllctreCode");

            lectureService.insertLectureEval(estbllctreCode, stdntNo, lctreEvlInnb, evlScore, evlCn);

            return "success";

        } catch (Exception e) {
            log.error("강의평가 등록 오류", e);
            return "fail_server";
        }
    }
}
