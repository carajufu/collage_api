package kr.ac.collage_api.learning.service.impl;

import kr.ac.collage_api.learning.mapper.LearningPageProfMapper;
import kr.ac.collage_api.learning.vo.AtendAbsncVO;
import kr.ac.collage_api.learning.vo.TaskPresentnVO;
import kr.ac.collage_api.learning.vo.TaskVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
