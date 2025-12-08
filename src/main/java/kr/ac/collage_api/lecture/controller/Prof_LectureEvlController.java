package kr.ac.collage_api.lecture.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.ac.collage_api.lecture.service.LectureEvlService;
import kr.ac.collage_api.lecture.vo.LectureEvlVO;
import lombok.extern.slf4j.Slf4j;

/**
 * 교수용 강의평가 조회 컨트롤러
 */
@Slf4j
@Controller
@RequestMapping("/prof/lecture")
public class Prof_LectureEvlController {
	
    @Autowired
    private LectureEvlService lectureService;

    // ------------------------------------------------------------
    // 1) 교수 기준 강의 목록 (페이징)
    // ------------------------------------------------------------
    @GetMapping("/main/All")
    public String main(Model model,
                       @RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int size) {

        // 1. Spring Security를 통한 현재 로그인 교수 ID 획득
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId = auth != null ? auth.getName() : null;

        // 2. ACNT_ID -> PROFSR_NO 변환
        String profsrNo = lectureService.getProfsrNoByAcntId(acntId);

        // 3. 교수 정보가 없으면 빈 목록 리턴
        if (profsrNo == null || profsrNo.isBlank()) {
            model.addAttribute("allCourseList", List.of());
            model.addAttribute("currentPage", 1);
            model.addAttribute("totalPage", 0);
            return "lecture/profLctreEvlMain";
        }

        // 4. 페이징 처리 및 목록 조회
        int totalCount = lectureService.getTotalCourseCount(profsrNo);
        int totalPage = (totalCount == 0) ? 0 : (int) Math.ceil((double) totalCount / size);
        
        // 페이지 범위 보정
        if (page > totalPage && totalPage > 0) {
            page = 1;
        }
        int start = (page - 1) * size;

        List<LectureEvlVO> lectureList = lectureService.getPagedCourses(profsrNo, start, size);

        // 5. 모델 바인딩
        model.addAttribute("allCourseList", lectureList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", totalPage);

        return "lecture/profLctreEvlMain";
    }


    // ------------------------------------------------------------
    // 2) 강의평가 상세 페이지 (차트, 요약, 시간표, 코멘트)
    // ------------------------------------------------------------
    @GetMapping("/main/detail/{estbllctreCode}")
    public String detail(@PathVariable("estbllctreCode") String estbllctreCode,
                         Model model) {

        log.info("▶ 강의평가 상세조회 estbllctreCode={}", estbllctreCode);

        // 1. 강의 기본정보 조회 (강의명, 학점, 인원 등)
        LectureEvlVO estblCourseInfo = lectureService.getEstblCourseById(estbllctreCode);

        // 2. 객관식 문항별 평균 점수 및 참여 인원 리스트
        List<LectureEvlVO> evalSummaryList = lectureService.getLectureEvalSummary(estbllctreCode);

        // 3. 점수 분포 데이터 (1점~5점 각각 몇 명인지, Chart.js용 List<Integer>)
        List<Integer> evalScoreCounts = lectureService.getLectureEvalScoreCounts(estbllctreCode);

        // 4. 강의 시간표 조회
        List<LectureEvlVO> timetableList = lectureService.getTimetableByEstblCode(estbllctreCode);
        
        // 5. 주관식(서술형) 코멘트 조회 (학생들이 남긴 텍스트 의견)
        List<LectureEvlVO> narrativeList = lectureService.getLectureEvalNarratives(estbllctreCode);

        // 6. JSP 렌더링용 변수 설정
        String lectureName = (estblCourseInfo != null) ? estblCourseInfo.getLctreNm() : "N/A";
        String profsrNm = (estblCourseInfo != null) ? estblCourseInfo.getProfsrNm() : "N/A";

        // 추가 학생 강의평가 상세 내용
        List<LectureEvlVO> evalSubmitList = lectureService.getLectureEvalSummary(estbllctreCode);
        
        // 7. 모델 전달
        model.addAttribute("estblCourseInfo", estblCourseInfo); // 기본정보
        model.addAttribute("evalSummaryList", evalSummaryList); // 객관식 요약
        model.addAttribute("evalScoreCounts", evalScoreCounts); // 차트 데이터
        model.addAttribute("timetableList", timetableList);     // 시간표
        model.addAttribute("narrativeList", narrativeList);     // 주관식 의견
        
        model.addAttribute("lectureName", lectureName);
        model.addAttribute("profsrNm", profsrNm);

        return "lecture/profLctreEvlDetail";
    }
    
}