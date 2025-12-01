package kr.ac.collage_api.learning.controller;

import kr.ac.collage_api.learning.service.impl.LearningPageProfServiceImpl;
import kr.ac.collage_api.learning.vo.AtendAbsncVO;
import kr.ac.collage_api.learning.vo.QuizPresentnVO;
import kr.ac.collage_api.learning.vo.TaskPresentnVO;
import kr.ac.collage_api.learning.vo.TaskVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

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

    @PostMapping("/task")
    @ResponseBody
    public ResponseEntity<?> createTask(@RequestBody Map<String, String> body) {
        String estbllctreCode = body.getOrDefault("estbllctreCode", "").trim();
        String week = body.getOrDefault("week", "").trim();
        String title = body.getOrDefault("taskSj", "").trim();
        String content = body.getOrDefault("taskCn", "").trim();
        String beginDe = body.getOrDefault("taskBeginDe", "").trim();
        String closDe = body.getOrDefault("taskClosDe", "").trim();

        if (estbllctreCode.isEmpty() || week.isEmpty() || title.isEmpty() || beginDe.isEmpty() || closDe.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("status", "error", "message", "필수 값 누락(estbllctreCode, week, taskSj, taskBeginDe, taskClosDe)"));
        }

        TaskVO created = learningPageProfService.createTask(estbllctreCode, week, title, content, beginDe, closDe);
        return ResponseEntity.ok(Map.of("status", "success", "data", created));
    }

    @DeleteMapping("/task")
    @ResponseBody
    public ResponseEntity<?> deleteTask(@RequestParam String estbllctreCode,
                                        @RequestParam String taskNo) {
        if (!StringUtils.hasText(estbllctreCode) || !StringUtils.hasText(taskNo)) {
            return ResponseEntity.badRequest()
                    .body(Map.of("status", "error", "message", "estbllctreCode, taskNo \ud544\uc218 \uac12 \ub204\ub77d"));
        }

        int deleted = learningPageProfService.deleteTask(estbllctreCode, taskNo);
        if (deleted <= 0) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("status", "error", "message", "\uc0ad\uc81c\ud560 \uacfc\uc81c\uac00 \uc5c6\uc2b5\ub2c8\ub2e4."));
        }
        return ResponseEntity.ok(Map.of("status", "success", "deleted", deleted));
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

    @GetMapping("/quiz")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getQuiz(@RequestParam String estbllctreCode) {
        return ResponseEntity.ok(Map.of(
                "quizzes", learningPageProfService.getQuizzes(estbllctreCode),
                "submissions", learningPageProfService.getQuizPresentn(estbllctreCode)
        ));
    }

    @GetMapping("/quiz-presentn")
    @ResponseBody
    public ResponseEntity<List<QuizPresentnVO>> getQuizPresentnByQuiz(
            @RequestParam String estbllctreCode,
            @RequestParam String quizCode) {
        return ResponseEntity.ok(
                learningPageProfService.getQuizPresentnByQuiz(estbllctreCode, quizCode));
    }
}
