package kr.ac.collage_api.learning.controller;

import kr.ac.collage_api.learning.vo.*;
import kr.ac.collage_api.learning.service.impl.LearningPageServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/learning/student")
@Slf4j
public class LearningPageController {
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public class QuizBadRequestException extends RuntimeException {
        public QuizBadRequestException(String message) {
            super(message);
        }
    }

    @Autowired
    LearningPageServiceImpl learningPageService;

    /**
     *  요청받은 강의 페이지를 전송하는 메서드
     * @param model
     * @param principal
     * @param lecNo
     * @return
     */
    @GetMapping
    public String getLearningPage(Model model,
                                  Principal principal,
                                  @RequestParam String lecNo) {
        Map<String, Object> studentLearningWeek = learningPageService.getLearningPage(lecNo);

        model.addAttribute("learnInfo", studentLearningWeek);

        return "learning/student/studentMain";
    }

    /**
     * 과제 목록 응답하는 메서드
     * @param reqMap
     * @return
     */
    @PostMapping("/task")
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

    @GetMapping("/isSubmit")
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

    @GetMapping("/isQuizSubmit")
    @ResponseBody
    public Map<String, Object> getSubmitQuiz(String quizCode,
                                             Principal principal) {
        QuizPresentnVO quizPresentnVO = learningPageService.getSubmitQuiz(quizCode, principal.getName());
        Map<String, Object> respMap = new HashMap<>();

        respMap.put("status", "success");
        respMap.put("data", quizPresentnVO);

        return respMap;
    }

    @ResponseBody
    @PostMapping("/fileUpload")
    public Map<String, Object> taskFileUpload(MultipartHttpServletRequest req,
                                              @RequestParam String taskPresentnNo,
                                              @RequestParam(required = false) String[] retainedExisting,
                                              @RequestParam(required = false) String[] deletedExisting)
    {
        List<MultipartFile> files = new ArrayList<>();

        req.getMultiFileMap().forEach((key, list) -> {
            if("uploadFiles".equals(key) || "uploadFiles[]".equals(key) || key.startsWith("uploadFiles[")){
                files.addAll(list);
            }
        });

        MultipartFile[] uploadFiles = files.toArray(new MultipartFile[0]);

        log.debug("chkng taskFileUpload (uploadFiles > {}) (taskPresentnNo > {} )", uploadFiles, taskPresentnNo);

        int rslt = learningPageService.taskFileUpload(taskPresentnNo, uploadFiles);

        Map<String, Object> respMap = new HashMap<>();
        respMap.put("status", "success");

        return respMap;
    }

    @ResponseBody
    @PostMapping("/quiz")
    public Map<String, Object> quizList(@RequestBody Map<String, Object> reqMap) {
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

        List<QuizVO> quizByWeekList = learningPageService.quizList(lecNo, weekNo);

        for(QuizVO quiz : quizByWeekList) {
            List<QuizExVO> quizExByQuiz = learningPageService.quizExList(quiz.getQuizCode());
            quiz.setQuizeExVOList(quizExByQuiz);
        }

        respMap.put("status", "success");
        respMap.put("result", quizByWeekList);

        log.debug("chkng taskByWeekList > {}", quizByWeekList);

        return respMap;
    }

    @ResponseBody
    @GetMapping("/quizSubmit")
    public Map<String, Object> quizSubmit(@RequestParam String quizExCode,
                                          @RequestParam String quizCode,
                                          Principal principal) {
        Map<String, Object> respMap = new HashMap<>();

        // todo: 제출 데이터 db insert 후 정답인지 아닌지 알려주는 응답 바디 작성하기
        if(quizCode == null || quizExCode == null) {
            throw new QuizBadRequestException("Required field is missing");
        }

        respMap = learningPageService.quizSubmit(quizCode, quizExCode, principal.getName());

        return respMap;
    }
}
