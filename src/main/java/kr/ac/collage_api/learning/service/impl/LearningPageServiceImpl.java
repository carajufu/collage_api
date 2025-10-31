package kr.ac.collage_api.learning.service.impl;

import kr.ac.collage_api.dashboard.vo.TaskPresentnVO;
import kr.ac.collage_api.learning.vo.TaskVO;
import kr.ac.collage_api.learning.mapper.LearningPageMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class LearningPageServiceImpl {
    @Autowired
    LearningPageMapper learningPageMapper;

    public List<Map<String, Object>> getLearningPage(String lecNo) {
        return learningPageMapper.getLearningPage(lecNo);
    }

    public List<TaskVO> taskList(String lecNo, String weekNo) {
        return learningPageMapper.taskList(lecNo, weekNo);
    }

    public TaskPresentnVO getSubmitTask(String taskNo, String studentNo) {
        return learningPageMapper.getSubmitTask(taskNo, studentNo);
    }
}
