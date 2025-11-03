package kr.ac.collage_api.learning.mapper;

import kr.ac.collage_api.learning.vo.TaskVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface LearningPageMapper {
    List<Map<String, Object>> getLearningPage(String lecNo);

    List<TaskVO> taskList(String lecNo, String weekNo);
}
