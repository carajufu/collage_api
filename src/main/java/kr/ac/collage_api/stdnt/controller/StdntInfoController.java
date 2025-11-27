package kr.ac.collage_api.stdnt.controller;

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

    /* ------------------------------------------------------
       학생 정보 조회 + 프로필 이미지 조회
    ------------------------------------------------------- */
    @GetMapping("info")
    public String showStdntStatusPage(Model model) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId  = auth.getName();  // 로그인 아이디
        String stdntNo = auth.getName();  // 학생 번호 동일 가정

        /* 학생 기본정보 */
        StdntVO stdntInfo = stdntService.getStdntInfo(stdntNo);
        model.addAttribute("stdntInfo", stdntInfo);

        /* 계정 정보 */
        AcntVO acntInfo = stdntService.getAcntInfo(acntId);
        model.addAttribute("acntInfo", acntInfo);

        /* 프로필 이미지(완성된 경로) */
        String profileImagePath = stdntService.getProfileImage(acntId);

        /* FILE_DETAIL 상세 정보도 가져옴 */
        FileDetailVO profile = stdntService.getProfileImageDetail(acntId);
        model.addAttribute("profile", profile);

        /* 최종 이미지 URL 결정 */
        String profileImageUrl = null;

        if (profile != null && profile.getFileStreplace() != null) {
            // FILE_STREPLACE 안에 이미 "/yyyy/MM/dd/파일명.jpg" 전체 경로 포함됨
            profileImageUrl = profile.getFileStreplace();

            // 혹시 슬래시 누락 시 보정
            if (!profileImageUrl.startsWith("/")) {
                profileImageUrl = "/" + profileImageUrl;
            }
        }

        model.addAttribute("profileImageUrl", profileImageUrl);

        log.info("profile = {}", profile);
        log.info("profileImageUrl = {}", profileImageUrl);

        return "stdnt/stdntInfo";
    }

    /* ------------------------------------------------------
       프로필 이미지 업로드
    ------------------------------------------------------- */
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

    /* ------------------------------------------------------
       기본 정보 수정
    ------------------------------------------------------- */
    @PostMapping("info/update")
    @ResponseBody
    public String updateInfo(@RequestBody StdntVO vo) {
        int result = stdntService.updateInfo(vo);
        return result > 0 ? "success" : "fail";
    }

    /* ------------------------------------------------------
       비밀번호 확인
    ------------------------------------------------------- */
    @PostMapping("info/pwCheck")
    @ResponseBody
    public String pwCheck(@RequestParam("stdntNo") String stdntNo,
                          @RequestParam("password") String password) {

        boolean match = stdntService.checkPassword(stdntNo, password);
        return match ? "success" : "fail";
    }

    /* ------------------------------------------------------
       비밀번호 변경
    ------------------------------------------------------- */
    @PostMapping("info/updatePw")
    @ResponseBody
    public String updatePwInfo(@RequestParam("stdntNo") String stdntNo,
                               @RequestParam("password") String password) {

        int result = stdntService.updatePwInfo(stdntNo, password);
        return result > 0 ? "success" : "fail";
    }
}