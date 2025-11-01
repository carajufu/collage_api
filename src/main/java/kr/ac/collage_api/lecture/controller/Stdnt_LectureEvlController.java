package kr.ac.collage_api.lecture.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
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

    // 1) 목록 (그대로)
    @GetMapping("/main/All")
    public String evalForm(String estbllctreCode, Model model) {
        List<LectureEvlVO> atnlcList = lectureService.getEvlIemList(estbllctreCode);
        log.info("estbllctreCode 파라미터 확인 -> {}", estbllctreCode);
        model.addAttribute("atnlcList", atnlcList);
        log.info("atnlcList : {}", atnlcList);
        return "lecture/stdntLctreEvlMain";
    }

    // 2) 작성 페이지 (수정)
    @GetMapping("/main/{estbllctreCode}")
    public String evalpage(@PathVariable String estbllctreCode, Model model) {

        // 개설강의코드 -> 강의코드
        String lctreCode = lectureService.getLctreCodeByEstbllctreCode(estbllctreCode);

        // 강의 상세 (ALL_COURSE)
        LectureEvlVO lectureVO = lectureService.getLectureByLctreCode(lctreCode);

        // JSP에서 표기용
        model.addAttribute("estbllctreCode", estbllctreCode);
        model.addAttribute("lectureInfo", lectureVO);

//        // 평가 항목 세팅 (evlNo -> 항목)
//        Integer evlNo = lectureService.getEvlNoByEstbllctreCode(estbllctreCode);
//        List<LectureVO> evalItemList = lectureService.getEvalItemsByEvlNo(evlNo);
//        model.addAttribute("evalItemList", evalItemList);

        return "lecture/stdntLctreEvlDetail";
    }

    // 3) 저장 (stdntNo 받고, 서비스로 전달)
    @PostMapping("/main/detail/post/submit")
    @ResponseBody
    public String evalSubmit(@RequestBody Map<String, Object> body) {
        try {
            @SuppressWarnings("unchecked")
            List<Integer> evlScore = (List<Integer>) body.get("evlScore");
            @SuppressWarnings("unchecked")
            List<String> evlCn = (List<String>) body.get("evlCn");
            String stdntNo = (String) body.get("stdntNo");
            String estbllctreCode = (String) body.get("estbllctreCode");

            log.info("받은 데이터 → estbllctreCode: {}, stdntNo: {}, evlScore: {}, evlCn: {}",
                    estbllctreCode, stdntNo, evlScore, evlCn);

            lectureService.insertLectureEval(estbllctreCode, stdntNo, evlScore, evlCn);
            return "success";

        } catch (Exception e) {
            log.error("강의평가 등록 중 오류 발생", e);
            return "fail";
        }
    }
}