package kr.ac.collage_api.graduation.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.collage_api.graduation.service.GraduationService;
import kr.ac.collage_api.graduation.vo.GraduationVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/stdnt/gradu")
public class GraduationController {

    @Autowired
    private GraduationService graduService;

    @GetMapping("/main")
    public String mainGradu(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String stdntNo = auth.getName(); // 학번(=username) 가정

        Map<String, Object> data = graduService.getGraduMainData(stdntNo);
        model.addAllAttributes(data);
        model.addAttribute("stdntNo", stdntNo);

        return "graduation/Stdgraduation";
    }

    @GetMapping("/main/All")
    public String mainGraduAll(Model model) {
        return mainGradu(model);
    }


    @PostMapping("/main/request")
    @ResponseBody
    public ResponseEntity<String> applyGradu(@RequestParam("reqstResn") String reqstResn) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String stdntNo = auth.getName();

            GraduationVO vo = new GraduationVO();
            vo.setStdntNo(stdntNo);
            vo.setReqstResn(reqstResn);

            graduService.applyForGraduation(vo);

            return ResponseEntity.ok("success");
        } catch (IllegalStateException ie) {
            log.warn("졸업 신청 거절: {}", ie.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ie.getMessage());
        } catch (Exception e) {
            log.error("졸업 신청 처리 중 시스템 오류", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("처리 중 오류가 발생했습니다");
        }
    }

}
