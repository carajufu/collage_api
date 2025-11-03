package kr.ac.collage_api.learning.controller;

import kr.ac.collage_api.learning.vo.TaskVO;
import kr.ac.collage_api.learning.service.impl.LearningPageServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/learning")
@Slf4j
public class LearningPageController {
    @Autowired
    LearningPageServiceImpl learningPageService;

    @GetMapping("/student")
    public String getLearningPage(Model model,
                                  Principal principal,
                                  @RequestParam String lecNo) {
        List<Map<String, Object>> studentLearningWeek;
        studentLearningWeek = learningPageService.getLearningPage(lecNo);

        model.addAttribute("weekList", studentLearningWeek);

        return "learning/student/studentMain";
    }

    /**
     * 과제 목록 응답하는 메서드
     * @param reqMap
     * @return
     */
    @PostMapping("student/task")
    @ResponseBody
    public Map<String, Object> taskList(@RequestBody Map<String, Object> reqMap) {
        log.debug("chkng taskList > {}", reqMap);

        Map<String, Object> respMap = new HashMap<>();

        // TODO: 인자가 둘 중 하나만 와도 통과 될 수 있으므로 개별 널 체크 필요
        if(reqMap.isEmpty()) {
            respMap.put("status", "error");
            respMap.put("message", "invalid request");

            return respMap;
        }

        String lecNo = reqMap.get("lecNo").toString();
        String weekNo = reqMap.get("weekNo").toString();

        List<TaskVO> taskByWeekList = learningPageService.taskList(lecNo, weekNo);

        respMap.put("status", "success");
        respMap.put("result", taskByWeekList);

        log.debug("chkng taskByWeekList > {}", taskByWeekList);

        return respMap;
    }
}
