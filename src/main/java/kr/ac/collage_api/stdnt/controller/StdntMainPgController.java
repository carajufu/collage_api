package kr.ac.collage_api.stdnt.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import kr.ac.collage_api.stdnt.service.StdntService;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.SemstrScreVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/stdnt/main/")
public class StdntMainPgController {

    @Autowired
    private StdntService stdntService;

    // 업로드 저장 경로 (FileConfig에서 "/files/**" → "C:/uploads/" 매핑되어 있다고 가정)
    private final String uploadFolder = "C:/uploads/profile";

    @GetMapping("status")
    public String showStdntStatusPage(
            @RequestParam(name = "semstr", required = false) Integer semstrScreInnb,
            Model model,
            HttpServletRequest request) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId = auth.getName();
        String stdntNo = auth.getName();

        // 학생/계정 기본정보
        StdntVO stdntInfo = stdntService.getStdntInfo(stdntNo);
        model.addAttribute("stdntInfo", stdntInfo);

        AcntVO acntInfo = stdntService.getAcntInfo(acntId);
        model.addAttribute("acntInfo", acntInfo);

        // 학기 리스트 및 선택값
        List<SemstrScreVO> semstrList = stdntService.getSemstrList(stdntNo);
        model.addAttribute("semstrList", semstrList);
        model.addAttribute("selectedSemstr", semstrScreInnb);

        // 선택 학기 → 연/학기 해석
        String year = null;
        String semstr = null;
        if (semstrScreInnb != null) {
            Map<String, String> ys = stdntService.getYearSemBySemstrInnb(semstrScreInnb);
            if (ys != null) {
                year = ys.get("YEAR");
                semstr = ys.get("SEMSTR");
                semstr = semstr + "학기"; 
            }
        }

        // 수강 목록 (연/학기 필터 반영)
        List<EstblCourseVO> historyList = stdntService.getCourseList(stdntNo, year, semstr);
        model.addAttribute("historyList", historyList);

        // 총 이수학점
        int totalPnt = stdntService.getTotalAcqsPnt(stdntNo);

        // 전공/교양 합계
        int majorPnt = 0;
        int culturePnt = 0;
        List<Map<String, Object>> pntByComplSe = stdntService.getPntByComplSe(stdntNo, year, semstr);
        for (Map<String, Object> row : pntByComplSe) {
            String complSe = (String) row.get("COMPL_SE");
            Number sumPnt = (Number) row.get("SUM_PNT");
            int v = sumPnt == null ? 0 : sumPnt.intValue();

            if (complSe != null) {
                if (complSe.startsWith("전")) majorPnt += v;
                else if (complSe.startsWith("교")) culturePnt += v;
            }
        }

        model.addAttribute("summary", totalPnt);
        model.addAttribute("majorPnt", majorPnt);
        model.addAttribute("culturePnt", culturePnt);

        // 출결 요약
        Map<String, Integer> attendance = new HashMap<>();
        attendance.put("attendCnt", 0);
        attendance.put("lateCnt", 0);
        attendance.put("absentCnt", 0);

        List<Map<String, Object>> attRows = stdntService.getAttendanceSummary(stdntNo);
        for (Map<String, Object> r : attRows) {
            String code = (String) r.get("ATEND_STTUS_CODE");
            int cnt = ((Number) r.get("CNT")).intValue();

            if ("ATTEND".equalsIgnoreCase(code) || "A".equalsIgnoreCase(code)) attendance.put("attendCnt", cnt);
            else if ("LATE".equalsIgnoreCase(code) || "L".equalsIgnoreCase(code)) attendance.put("lateCnt", cnt);
            else if ("ABSENT".equalsIgnoreCase(code) || "X".equalsIgnoreCase(code)) attendance.put("absentCnt", cnt);
        }
        model.addAttribute("attendance", attendance);

        // 세션에 저장된 프로필 이미지 경로 → 화면에 바인딩
        Object sessionImg = request.getSession().getAttribute("profileImagePath");
        if (sessionImg != null) {
            model.addAttribute("profileImagePath", sessionImg.toString());
        }

        return "stdnt/stdntMyPage";
    }

    // 프로필 업로드 (파일만 저장) + 세션에 경로 저장
    @PostMapping("uploadProfile")
    public String uploadProfile(@RequestParam("uploadFile") MultipartFile uploadFile,
                                HttpServletRequest request) {

        if (!uploadFile.isEmpty()) {
            File folder = new File(uploadFolder);
            if (!folder.exists()) folder.mkdirs();

            String originalName = uploadFile.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String saveName = uuid + "_" + originalName;

            File saveFile = new File(folder, saveName);
            try {
                uploadFile.transferTo(saveFile);

                // 정적 리소스 매핑이 "/files/**" → "C:/uploads/" 라면,
                // "/files/profile/저장파일명" 으로 접근 가능
                String publicPath = "/files/profile/" + saveName;

                // 리다이렉트 후에도 보이도록 세션에 저장
                request.getSession().setAttribute("profileImagePath", publicPath);

            } catch (IOException e) {
                log.error("프로필 업로드 실패", e);
            }
        }

        return "redirect:/stdnt/main/status";
    }

    @GetMapping("search")
    public String semstrSearch() {
        return "redirect:/stdnt/main/status";
    }
}
