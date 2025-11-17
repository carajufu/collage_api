package kr.ac.collage_api.learning.service.impl;

import kr.ac.collage_api.common.attach.service.UploadController;
import kr.ac.collage_api.learning.vo.*;
import kr.ac.collage_api.learning.mapper.LearningPageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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


//        todo: estbl_course의 profsr_no로 교수 정보 검색하기 null 체크 구현 필 estbl이 list에 어떻게 담기는지 확인 필요
//        weekInfoList.add(learningPageMapper.getProfInfo())

        // todo: list 반환 말고 map으로 list와 교수 정보 담아서 보내야할듯
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
}
