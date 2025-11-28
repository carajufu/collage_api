package kr.ac.collage_api.learning.controller;

import kr.ac.collage_api.learning.service.impl.LearningPageProfServiceImpl;
import kr.ac.collage_api.learning.service.impl.LearningPageServiceImpl;
import kr.ac.collage_api.learning.vo.AtendAbsncVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/learning/prof")
@Slf4j
public class LearningPageProfController {
    @Autowired
    private LearningPageProfServiceImpl learningPageProfService;

    @GetMapping
    public String getLearningPage(@RequestParam(required = false) String lecNo, Model model) {
        model.addAttribute("lecNo", lecNo);
        return "learning/prof/profMain";
    }

    @GetMapping("/attendance")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAttendByLecture(@RequestParam(required = false) String estbllctreCode) {
        if (!StringUtils.hasText(estbllctreCode)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("status", "error", "message", "estbllctreCode is required"));
        }

        List<AtendAbsncVO> attendList = learningPageProfService.getAttendByLecture(estbllctreCode);

        Map<String, Object> resp = new HashMap<>();
        resp.put("status", "success");
        resp.put("data", attendList);
        resp.put("count", attendList.size());

        log.debug("prof attendance loaded for {} -> {} rows", estbllctreCode, attendList.size());

        return ResponseEntity.ok(resp);
    }
}
