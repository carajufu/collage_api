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

    /**
     * 1) 학생: 강의평가 목록 조회
     */
    @GetMapping("/main/All")
    public String evalForm(Model model) {
        
        // ★ 1. 세션에서 현재 로그인한 사용자의 ACNT_ID를 가져옵니다.
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId = (auth != null) ? auth.getName() : null;
        
        if (acntId == null) {
            log.warn("강의평가 목록 조회: 사용자 인증 정보를 찾을 수 없습니다.");
            return "redirect:/login"; // 예: 로그인 페이지로 리다이렉트
        }
        
        // ★ 2. ACNT_ID를 STDNT_NO (학번)로 변환합니다.
        String stdntNo = lectureService.getStdntNoByAcntId(acntId);
        
        if (stdntNo == null) {
             log.warn("강의평가 목록 조회: ACNT_ID {} 에 해당하는 STDNT_NO가 없습니다.", acntId);
             model.addAttribute("atnlcList", List.of());
             return "lecture/stdntLctreEvlMain";
        }

        // ★ 3. [수정] 변환된 stdntNo를 사용해 '모든' 수강 강의 목록을 조회합니다.
        List<LectureEvlVO> atnlcList = lectureService.getAllLecturesByStdntNo(stdntNo);
        
        model.addAttribute("atnlcList", atnlcList);
        // ★ [수정] 로그 메시지 변경
        log.info("학생 {} (계정: {}) 의 '전체' 수강 강의 목록 {} 건 조회", stdntNo, acntId, atnlcList.size());
        
        return "lecture/stdntLctreEvlMain";
    }

    /**
     * 2) 학생: 강의평가 작성 상세 페이지 (★ "평가지 자동 생성" 로직 포함)
     */
    @GetMapping("/main/{estbllctreCode}")
    public String evalpage(@PathVariable String estbllctreCode, Model model) {

        // A. 강의 기본정보 (강의명, 교수명, 학점 등)
        LectureEvlVO lectureInfo = lectureService.getEstblCourseById(estbllctreCode);
        
        // B. 강의평가 질문지 (평가 항목)
        // 1. 우선 EVL_NO를 조회합니다.
        Integer evlNo = lectureService.getEvlNoByEstbllctreCode(estbllctreCode);
        
        // 2. EVL_NO가 없으면(Total: 0), 기본 평가지를 생성합니다.
        if (evlNo == null) {
            log.warn("{} 에 해당하는 평가(EVL_NO)가 LCTRE_EVL에 없습니다. 기본 평가지를 생성합니다.", estbllctreCode);
            try {
                // 2-1. 서비스의 생성 메소드 호출
                evlNo = lectureService.createDefaultEvaluation(estbllctreCode);
                log.info("새로운 평가(EVL_NO: {})가 생성되었습니다.", evlNo);
                
            } catch (Exception e) {
                log.error("기본 평가 생성 중 오류 발생", e);
                model.addAttribute("errorMessage", "평가지 생성 중 오류가 발생했습니다.");
                return "redirect:/stdnt/lecture/main/All"; // 목록으로 돌려보냄
            }
        }

        // 3. (생성되었거나 원래 있던) EVL_NO로 질문지 목록을 조회합니다.
        List<LectureEvlVO> evalItemList = lectureService.getEvlIem(evlNo);

        // C. JSP에서 표기용
        model.addAttribute("estbllctreCode", estbllctreCode); // hidden input 용
        model.addAttribute("lectureInfo", lectureInfo);     // 강의정보 표시용
        model.addAttribute("evalItemList", evalItemList);   // 질문지 반복문용

        return "lecture/stdntLctreEvlDetail";
    }

    /**
     * 3) 학생: 강의평가 제출
     */
    @PostMapping("/main/detail/post/submit")
    @ResponseBody
    public String evalSubmit(@RequestBody Map<String, Object> body) {
        try {
            // ★ 1. 세션에서 ACNT_ID를 가져옵니다.
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String acntId = (auth != null) ? auth.getName() : null;
            
            if (acntId == null) {
                log.error("강의평가 제출: 세션이 만료되었거나 로그인되지 않은 사용자입니다.");
                return "fail_auth"; // 인증 실패
            }

            // ★ 2. ACNT_ID를 STDNT_NO (학번)로 변환합니다.
            String stdntNo = lectureService.getStdntNoByAcntId(acntId);
            if (stdntNo == null) {
                log.error("강의평가 제출: ACNT_ID {} 에 해당하는 STDNT_NO가 없습니다.", acntId);
                return "fail_auth";
            }

            // 3. 클라이언트에서 전송한 데이터 파싱
            @SuppressWarnings("unchecked")
            List<Integer> evlScore = (List<Integer>) body.get("evlScore");
            @SuppressWarnings("unchecked")
            List<String> evlCn = (List<String>) body.get("evlCn");
            String estbllctreCode = (String) body.get("estbllctreCode");

            log.info("강의평가 제출 시도 → estbllctreCode: {}, stdntNo: {}",
                     estbllctreCode, stdntNo);

            // ★ 4. 변환된 stdntNo를 사용하여 평가를 저장합니다.
            lectureService.insertLectureEval(estbllctreCode, stdntNo, evlScore, evlCn);
            
            return "success";

        } catch (Exception e) {
            log.error("강의평가 등록 중 오류 발생", e);
            return "fail_server";
        }
    }
}