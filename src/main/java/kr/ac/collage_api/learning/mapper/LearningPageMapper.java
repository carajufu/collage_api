package kr.ac.collage_api.learning.mapper;

import kr.ac.collage_api.learning.vo.TaskPresentnVO;
import kr.ac.collage_api.learning.vo.TaskVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface LearningPageMapper {
    List<Map<String, Object>> getLearningPage(String lecNo);

    Map<String, Object> getLectureInfo(String lecNo);

    List<TaskVO> taskList(String lecNo, String weekNo);

    TaskPresentnVO getSubmitTask(String taskNo, String studentNo);

    int taskFileUpload(@Param("taskpresentnNo") String taskpresentnNo,
                          @Param("fileGroupNo") Long fileGroupNo);
}
