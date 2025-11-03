package kr.ac.collage_api.lecture.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.ac.collage_api.lecture.service.LectureEvlService;
import kr.ac.collage_api.lecture.vo.LectureEvlVO;
import lombok.extern.slf4j.Slf4j;

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

        // 로그인 사용자
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId = auth != null ? auth.getName() : null;

        // ACNT_ID → PROFSR_NO
        String profsrNo = lectureService.getProfsrNoByAcntId(acntId);

        if (profsrNo == null || profsrNo.isBlank()) {
            model.addAttribute("allCourseList", List.of());
            model.addAttribute("currentPage", 1);
            model.addAttribute("totalPage", 0);
            return "lecture/profLctreEvlMain";
        }

        // 페이징
        int totalCount = lectureService.getTotalCourseCount(profsrNo);
        int totalPage = totalCount == 0 ? 0 : (int)Math.ceil((double)totalCount / size);
        if (page > totalPage && totalPage > 0) page = 1;
        int start = (page - 1) * size;

        List<LectureEvlVO> lectureList = lectureService.getPagedCourses(profsrNo, start, size);

        model.addAttribute("allCourseList", lectureList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", totalPage);

        return "lecture/profLctreEvlMain";
    }


    // ------------------------------------------------------------
    // 2) 강의평가 상세 페이지
    // ------------------------------------------------------------
    @GetMapping("/main/detail/{estbllctreCode}")
    public String detail(@PathVariable("estbllctreCode") String estbllctreCode,
                         Model model) {

        log.info("▶ 강의평가 상세조회 estbllctreCode={}", estbllctreCode);

        // A. 강의 기본정보 (강의명 + 교수명 포함)
        LectureEvlVO estblCourseInfo = lectureService.getEstblCourseById(estbllctreCode);

        // B. 평가 요약 리스트
        List<LectureEvlVO> evalSummaryList = lectureService.getLectureEvalSummary(estbllctreCode);

        // C. 점수 분포 (차트용)
        List<Integer> evalScoreCounts = lectureService.getLectureEvalScoreCounts(estbllctreCode);

        // D. 강의 시간표
        // ★ 참고: Service/Mapper/XML의 메소드명을 'getTimetableByEstblCode'로 통일했습니다.
        List<LectureEvlVO> timetableList = lectureService.getTimetableByEstblCode(estbllctreCode);

        // ✅ JSP 화면에서 사용될 표시용 별도 모델값
        String lectureName = (estblCourseInfo != null) ? estblCourseInfo.getLctreNm() : "N/A";
        String profsrNm = (estblCourseInfo != null) ? estblCourseInfo.getProfsrNm() : "N/A";

        // 모델 전달
        model.addAttribute("estblCourseInfo", estblCourseInfo);
        model.addAttribute("evalSummaryList", evalSummaryList);
        model.addAttribute("evalScoreCounts", evalScoreCounts);
        model.addAttribute("timetableList", timetableList);
        model.addAttribute("lectureName", lectureName);
        model.addAttribute("profsrNm", profsrNm);

        return "lecture/profLctreEvlDetail";
    }
}