package kr.ac.collage_api.learning.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.dashboard.vo.TaskPresentnVO;
import kr.ac.collage_api.learning.vo.LearningVO;

@Mapper
public interface LearningPageMapper {
    List<Map<String, Object>> getLearningPage(String lecNo);

    List<LearningVO> taskList(String lecNo, String weekNo);

    TaskPresentnVO getSubmitTask(String taskNo, String studentNo);
}
