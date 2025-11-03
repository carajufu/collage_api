package kr.ac.collage_api.learning.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.dashboard.vo.TaskPresentnVO;
import kr.ac.collage_api.learning.service.impl.LearningPageServiceImpl;
import kr.ac.collage_api.learning.vo.LearningVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/learning")
@Slf4j
public class LearningPageController {
    @Autowired
    LearningPageServiceImpl learningPageService;

    /**
     *  요청받은 강의 페이지를 전송하는 메서드
     * @param model
     * @param principal
     * @param lecNo
     * @return
     */
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

        List<LearningVO> taskByWeekList = learningPageService.taskList(lecNo, weekNo);

        respMap.put("status", "success");
        respMap.put("result", taskByWeekList);

        log.debug("chkng taskByWeekList > {}", taskByWeekList);

        return respMap;
    }

    @GetMapping("/student/isSubmit")
    @ResponseBody
    public Map<String, Object> getSubmitTask(String taskNo,
                                             Principal principal) {
        TaskPresentnVO taskPresentnVO = learningPageService.getSubmitTask(taskNo, principal.getName());
        Map<String, Object> respMap = new HashMap<>();

        log.debug("chkng getSubmit Task (taskNo > {}) - (stdntNo > {})", taskNo, principal.getName());
        log.debug("chkng getSubmitTask (VO) > {}", taskPresentnVO);

        respMap.put("status", "success");
        respMap.put("data", taskPresentnVO);

        return respMap;
    }

    
    @ResponseBody
    @PostMapping("/student/fileUpload")
    public Map<String, Object> taskFileUpload(MultipartFile[] uploadFiles) {
        return null;
    }

}
