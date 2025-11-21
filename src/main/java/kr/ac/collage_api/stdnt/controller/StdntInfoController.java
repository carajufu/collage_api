package kr.ac.collage_api.stdnt.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import kr.ac.collage_api.stdnt.service.StdntInfoService;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/stdnt/main/")
public class StdntInfoController {

    @Autowired
    private StdntInfoService stdntService;

    @GetMapping("info")
    public String showStdntStatusPage(Model model) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String acntId = auth.getName();
        String stdntNo = auth.getName();

        StdntVO stdntInfo = stdntService.getStdntInfo(stdntNo);
        model.addAttribute("stdntInfo", stdntInfo);

        AcntVO acntInfo = stdntService.getAcntInfo(acntId);
        model.addAttribute("acntInfo", acntInfo);

        // 프로필 이미지 path 조회 추가
        String profileImagePath = stdntService.getProfileImage(acntId);
        model.addAttribute("profileImagePath", profileImagePath);

        return "stdnt/stdntInfo";
    }

    @PostMapping("info/uploadFile")
    @ResponseBody
    public String uploadFile(@RequestParam("stdntNo") String acntId,
                             @RequestParam("uploadFile") MultipartFile uploadFile,
                             HttpServletRequest request) {

        if (uploadFile != null && !uploadFile.isEmpty()) {
            long fileGroupNo = stdntService.updateProfileImage(acntId, uploadFile);
            if (fileGroupNo <= 0) return "fail";
        }
        return "success";
    }

    @PostMapping("info/update")
    @ResponseBody
    public String updateInfo(@RequestBody StdntVO vo) {
        int result = stdntService.updateInfo(vo);
        return result > 0 ? "success" : "fail";
    }

    @PostMapping("info/pwCheck")
    @ResponseBody
    public String pwCheck(@RequestParam("stdntNo") String stdntNo,
                          @RequestParam("password") String password) {

        boolean match = stdntService.checkPassword(stdntNo, password);
        return match ? "success" : "fail";
    }

    @PostMapping("info/updatePw")
    @ResponseBody
    public String updatePwInfo(@RequestParam("stdntNo") String stdntNo,
                               @RequestParam("password") String password) {

        int result = stdntService.updatePwInfo(stdntNo, password);
        return result > 0 ? "success" : "fail";
    }
}
