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
import lombok.extern.slf4j.Slf4j;

@Slf4j
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
            log.warn("강의평가 목록 조회: 사용자 인증 정보를 찾을 수 없습니다.");
            return "redirect:/login"; 
        }
        
        String stdntNo = lectureService.getStdntNoByAcntId(acntId);
        
        if (stdntNo == null) {
             log.warn("강의평가 목록 조회: ACNT_ID {} 에 해당하는 STDNT_NO가 없습니다.", acntId);
             model.addAttribute("atnlcList", List.of());
             return "lecture/stdntLctreEvlMain";
        }

        List<LectureEvlVO> atnlcList = lectureService.getAllLecturesByStdntNo(stdntNo);
        
        model.addAttribute("atnlcList", atnlcList);
        //로그 메시지 변경
        log.info("학생 {} (계정: {}) 의 '전체' 수강 강의 목록 {} 건 조회", stdntNo, acntId, atnlcList.size());
        
        return "lecture/stdntLctreEvlMain";
    }

    @GetMapping("/main/{estbllctreCode}")
    public String evalpage(@PathVariable String estbllctreCode, Model model) {

        LectureEvlVO lectureInfo = lectureService.getEstblCourseById(estbllctreCode);
        
        Integer evlNo = lectureService.getEvlNoByEstbllctreCode(estbllctreCode);
        
        if (evlNo == null) {
            log.warn("{} 에 해당하는 평가(EVL_NO)가 LCTRE_EVL에 없습니다. 기본 평가지를 생성합니다.", estbllctreCode);
            try {
                evlNo = lectureService.createDefaultEvaluation(estbllctreCode);
                log.info("새로운 평가(EVL_NO: {})가 생성되었습니다.", evlNo);
                
            } catch (Exception e) {
                log.error("기본 평가 생성 중 오류 발생", e);
                model.addAttribute("errorMessage", "평가지 생성 중 오류가 발생했습니다.");
                return "redirect:/stdnt/lecture/main/All"; 
            }
        }

        model.addAttribute("estbllctreCode", estbllctreCode); // hidden input 용
        model.addAttribute("lectureInfo", lectureInfo);     // 강의정보 표시용

        return "lecture/stdntLctreEvlDetail";
    }

    
    @PostMapping("/save")
    @ResponseBody
    public String evalSubmit(@RequestBody Map<String, Object> body) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String acntId = (auth != null) ? auth.getName() : null;

            if (acntId == null) {
                log.error("강의평가 제출: 인증되지 않은 사용자입니다.");
                return "fail_auth";
            }

            String stdntNo = lectureService.getStdntNoByAcntId(acntId);
            if (stdntNo == null) {
                log.error("강의평가 제출: ACNT_ID {} 에 해당하는 STDNT_NO가 없습니다.", acntId);
                return "fail_auth";
            }

            @SuppressWarnings("unchecked")
            List<Integer> evlScore = (List<Integer>) body.get("evlScore");
            @SuppressWarnings("unchecked")
            List<String> evlCn = (List<String>) body.get("evlCn");
            String estbllctreCode = (String) body.get("estbllctreCode");

            log.info("강의평가 제출 시도 → estbllctreCode: {}, stdntNo: {}, evlScore: {}, evlCn: {}",
                     estbllctreCode, stdntNo, evlScore, evlCn);

            lectureService.insertLectureEval(estbllctreCode, stdntNo, evlScore, evlCn);

            return "success";

        } catch (Exception e) {
            log.error("강의평가 등록 중 오류 발생", e);
            return "fail_server";
        }
    }

}