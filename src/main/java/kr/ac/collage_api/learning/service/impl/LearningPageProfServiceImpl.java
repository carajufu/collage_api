package kr.ac.collage_api.learning.service.impl;

import kr.ac.collage_api.learning.mapper.LearningPageProfMapper;
import kr.ac.collage_api.learning.vo.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LearningPageProfServiceImpl {
    @Autowired
    private final LearningPageProfMapper learningPageProfMapper;

    public String getLctreNm(String estbllctreCode) {
        return learningPageProfMapper.getLctreNm(estbllctreCode);
    }

    public List<TaskVO> getTasks(String estbllctreCode) {
        return learningPageProfMapper.selectTasks(estbllctreCode);
    }

    public List<TaskPresentnVO> getTaskPresentn(String estbllctreCode) {
        return learningPageProfMapper.selectTaskPresentn(estbllctreCode);
    }

    public List<AtendAbsncVO> getAttendList(String estbllctreCode) {
        return learningPageProfMapper.getAttendList(estbllctreCode);
    }

    public List<TaskPresentnVO> getTaskPresentnByTask(String estbllctreCode, String taskNo) {
        return learningPageProfMapper.selectTaskPresentnByTask(estbllctreCode, taskNo);
    }

    public TaskVO createTask(String estbllctreCode,
                             String week,
                             String title,
                             String content,
                             String beginDe,
                             String closDe) {

        String weekAcctoLrnNo = learningPageProfMapper.findWeekAcctoLrnNo(estbllctreCode, week);
        if (weekAcctoLrnNo == null) {
            throw new IllegalArgumentException("해당 주차 정보를 찾을 수 없습니다.");
        }

        String nextTaskNo = learningPageProfMapper.nextTaskNo();

        TaskVO vo = new TaskVO();
        vo.setTaskNo(nextTaskNo);
        vo.setWeekAcctoLrnNo(weekAcctoLrnNo);
        vo.setTaskSj(title);
        vo.setTaskCn(content);
        vo.setTaskBeginDe(beginDe);
        vo.setTaskClosDe(closDe);

        learningPageProfMapper.insertTask(vo);
        return learningPageProfMapper.getTaskByNo(nextTaskNo);
    }

    @Transactional
    public int deleteTask(String estbllctreCode, String taskNo) {
        // 제출물이 있으면 함께 삭제
        learningPageProfMapper.deleteTaskPresentnByTask(taskNo);
        return learningPageProfMapper.deleteTask(estbllctreCode, taskNo);
    }

    public List<QuizVO> getQuizzes(String estbllctreCode) {
        return learningPageProfMapper.selectQuiz(estbllctreCode);
    }

    public List<QuizPresentnVO> getQuizPresentn(String estbllctreCode) {
        return learningPageProfMapper.selectQuizPresentn(estbllctreCode);
    }

    public List<QuizPresentnVO> getQuizPresentnByQuiz(String estbllctreCode, String quizCode) {
        return learningPageProfMapper.selectQuizPresentnByQuiz(estbllctreCode, quizCode);
    }
}
