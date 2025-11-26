package kr.ac.collage_api.learning.mapper;

import kr.ac.collage_api.learning.vo.*;
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

    List<QuizVO> quizList(String lecNo, String weekNo);

    List<QuizExVO> quizExList(String quizCode);

    QuizPresentnVO getSubmitQuiz(String quizCode, String name);

    void quizSubmit(String quizCode, String quizExCode, String stdntNo);

    String isCorrect(String quizCode, String quizExCode);

    LectureBbsVO getLectureBbs(String lecNo, String type);

    Map<String, Object> getBoard(Map<String, Object> paramMap);

    List<AtendAbsncVO> getAttend(@Param("estbllctreCode") String estbllctreCode,
                                 @Param("stdntNo") String stdntNo);
}
