package kr.ac.collage_api.learning.service.impl;

import kr.ac.collage_api.common.attach.service.UploadController;
import kr.ac.collage_api.learning.vo.*;
import kr.ac.collage_api.learning.mapper.LearningPageMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class LearningPageServiceImpl {
    @Autowired
    LearningPageMapper learningPageMapper;

    @Autowired
    UploadController uploadController;

    public Map<String, Object> getLearningPage(String lecNo) {
        List<Map<String, Object>> weekInfoList = learningPageMapper.getLearningPage(lecNo);
        Map<String, Object> lectureInfo = learningPageMapper.getLectureInfo(lecNo);

        for(Map<String, Object> week : weekInfoList){
            Object weekNoObj = week.get("WEEK");
            if(weekNoObj != null) {
                String weekNo = String.valueOf(weekNoObj);
                List<TaskVO> taskList = taskList(lecNo, weekNo);
                List<QuizVO> quizList = quizList(lecNo, weekNo);

                week.put("taskList", taskList);
                week.put("quizList", quizList);
            }
        }

        Map<String, Object> infoMap = new HashMap<>();
        infoMap.put("weekList", weekInfoList);
        infoMap.put("lecInfo", lectureInfo);

        Map<String, LectureBbsVO> bbsMap = getLectureBbs(lecNo);
        for(String key : bbsMap.keySet()) {
            infoMap.put(key, bbsMap.get(key));
        }

        return infoMap;
    }

    public List<TaskVO> taskList(String lecNo, String weekNo) {
        return learningPageMapper.taskList(lecNo, weekNo);
    }

    public TaskPresentnVO getSubmitTask(String taskNo, String studentNo) {
        return learningPageMapper.getSubmitTask(taskNo, studentNo);
    }

    @Transactional
    public int taskFileUpload(String taskpresentnNo, MultipartFile[] files) {
        Long fileGroupNo = uploadController.fileUpload(files);

        return learningPageMapper.taskFileUpload(taskpresentnNo, fileGroupNo);
    }

    public List<QuizVO> quizList(String lecNo, String weekNo) {
        List<QuizVO> quizVOList = learningPageMapper.quizList(lecNo, weekNo);

        for(QuizVO quiz : quizVOList) {
            String quizCode = quiz.getQuizCode();
            if(quizCode != null) {
                List<QuizExVO> quizExVOList = quizExList(quizCode);
                quiz.setQuizeExVOList(quizExVOList);
            }
        }

        return quizVOList;
    }

    public List<QuizExVO> quizExList(String quizCode) {
        return learningPageMapper.quizExList(quizCode);
    }

    public QuizPresentnVO getSubmitQuiz(String quizCode, String name) {
        return learningPageMapper.getSubmitQuiz(quizCode, name);
    }

    public Map<String, Object> quizSubmit(String quizCode, String quizExCode, String stdntNo) {
        Map<String, Object> result = new HashMap<>();

        learningPageMapper.quizSubmit(quizCode, quizExCode, stdntNo);

        // validate answer
        String correct = learningPageMapper.isCorrect(quizCode, quizExCode);

        if(correct.equals("1")) {
            result.put("isCorrect", "Correct");

            return result;
        } else {
            result.put("isCorrect", "inCorrect");
            return result;
        }
    }

    public Map<String, LectureBbsVO> getLectureBbs(String lecNo) {
        Map<String, LectureBbsVO> lectureBbsMap = new HashMap<>();

        lectureBbsMap.put("notice", learningPageMapper.getLectureBbs(lecNo, "공지사항"));
        lectureBbsMap.put("resource", learningPageMapper.getLectureBbs(lecNo, "자료실"));
        lectureBbsMap.put("question", learningPageMapper.getLectureBbs(lecNo, "질문"));

        lectureBbsMap.forEach((key, bbs) -> {
            for(LectureBbsCttVO ctt : bbs.getLectureBbsCttVOList()) {
                if(ctt.getSklstfNm() != null && ctt.getStdntNm() == null) {
                    ctt.setRole("교수");
                    ctt.setName(ctt.getSklstfNm());
                } else if(ctt.getStdntNm() != null && ctt.getSklstfNm() == null) {
                    ctt.setRole("학생");
                    ctt.setName(ctt.getStdntNm());
                } else {
                    log.warn("작성자 구분 불가: acntId = {}", ctt.getAcntId());
                }
            }
        });

        return lectureBbsMap;
    }
}
