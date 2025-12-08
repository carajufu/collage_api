package kr.ac.collage_api.stdnt.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.stdnt.service.StdntInfoService;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/stdnt/main/")
public class StdntInfoController {

    @Autowired
    private StdntInfoService stdntService;


    /* ============================================================
       학생 정보 페이지 접근 시 → 비밀번호 인증 여부 체크
    ============================================================ */
    @GetMapping("info")
    public String showStdntStatusPage(Model model, HttpSession session) {

        Boolean passed = (Boolean) session.getAttribute("pwPass");
        if (passed == null || !passed) {
            return "redirect:/stdnt/main/chkPw";
        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId  = auth.getName();
        String stdntNo = auth.getName();

        StdntVO stdntInfo = stdntService.getStdntInfo(stdntNo);
        model.addAttribute("stdntInfo", stdntInfo);

        AcntVO acntInfo = stdntService.getAcntInfo(acntId);
        model.addAttribute("acntInfo", acntInfo);

        FileDetailVO profile = stdntService.getProfileImageDetail(acntId);
        model.addAttribute("profile", profile);

        String profileImageUrl = null;

        if (profile != null && profile.getFileStreplace() != null) {

            profileImageUrl = profile.getFileStreplace();

            if (!profileImageUrl.startsWith("/")) {
                profileImageUrl = "/" + profileImageUrl;
            }
        }

        model.addAttribute("profileImageUrl", profileImageUrl);

        return "stdnt/stdntInfo";
    }


    /* ============================================================
       비밀번호 확인 페이지
    ============================================================ */
    @GetMapping("chkPw")
    public String chkPwPage(Model model) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName();

        model.addAttribute("stdntNo", stdntNo);

        return "stdnt/chkPw";
    }


    /* ============================================================
       비밀번호 확인
    ============================================================ */
    @PostMapping("info/pwCheck")
    @ResponseBody
    public String pwCheck(@RequestParam("stdntNo") String stdntNo,
                          @RequestParam("password") String password,
                          HttpSession session) {

        boolean match = stdntService.checkPassword(stdntNo, password);

        if (match) {
            session.setAttribute("pwPass", true);
        }

        return match ? "success" : "fail";
    }


    /* ============================================================
       기본 정보 수정
    ============================================================ */
    @PostMapping("info/update")
    @ResponseBody
    public String updateInfo(@RequestBody StdntVO vo) {
        int result = stdntService.updateInfo(vo);
        return result > 0 ? "success" : "fail";
    }



    /* ============================================================
       프로필 이미지 업로드
    ============================================================ */
    @PostMapping("info/uploadFile")
    @ResponseBody
    public String uploadFile(@RequestParam("stdntNo") String stdntNo,
                             @RequestParam("uploadFile") MultipartFile uploadFile) {

        log.debug("uploadFile stdntNo={}, fileName={}", stdntNo, uploadFile.getOriginalFilename());

        if (uploadFile == null || uploadFile.isEmpty()) {
            return "fail";
        }

        long result = stdntService.updateProfileImage(stdntNo, uploadFile);
        return result > 0 ? "success" : "fail";
    }
}
