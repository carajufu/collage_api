package kr.ac.collage_api.learning.controller;

import kr.ac.collage_api.learning.service.impl.LearningPageProfServiceImpl;
import kr.ac.collage_api.learning.vo.AtendAbsncVO;
import kr.ac.collage_api.learning.vo.TaskPresentnVO;
import kr.ac.collage_api.learning.vo.TaskVO;
import lombok.RequiredArgsConstructor;
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

@RequestMapping("/learning/prof")
@Controller
@RequiredArgsConstructor
public class LearningPageProfController {
    @Autowired
    private final LearningPageProfServiceImpl learningPageProfService;

    @GetMapping
    public String getTasks(@RequestParam("estbllctreCode") String estbllctreCode,
                           Model model) {
        List<TaskVO> tasks = learningPageProfService.getTasks(estbllctreCode);
        List<TaskPresentnVO> submissions = learningPageProfService.getTaskPresentn(estbllctreCode);
        String lctreNm = learningPageProfService.getLctreNm(estbllctreCode);

        Map<String, Object> body = new HashMap<>();
        body.put("lctreNm", lctreNm);
        body.put("tasks", tasks);
        body.put("taskPresentn", submissions);

        model.addAttribute("body", body);
        return "learning/prof/profMain";
    }

    @GetMapping("/task-presentn")
    @ResponseBody
    public ResponseEntity<List<TaskPresentnVO>> getTaskPresentnByTask(
            @RequestParam String estbllctreCode,
            @RequestParam String taskNo) {
        return ResponseEntity.ok(
                learningPageProfService.getTaskPresentnByTask(estbllctreCode, taskNo));
    }

    @GetMapping("/attend")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAttend(@RequestParam("estbllctreCode") String estbllctreCode) {
        if (!StringUtils.hasText(estbllctreCode)) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("status", "error", "message", "estbllctreCode is required"));
        }

        List<AtendAbsncVO> attendList = learningPageProfService.getAttendList(estbllctreCode);

        Map<String, Object> resp = new HashMap<>();
        resp.put("status", "success");
        resp.put("data", attendList);
        resp.put("count", attendList.size());

        return ResponseEntity.ok(resp);
    }
}
