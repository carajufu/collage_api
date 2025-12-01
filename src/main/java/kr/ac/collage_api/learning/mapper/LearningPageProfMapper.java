package kr.ac.collage_api.learning.mapper;

import kr.ac.collage_api.learning.vo.*;
import kr.ac.collage_api.vo.FileDetailVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LearningPageProfMapper {
    List<TaskVO> selectTasks(@Param("estbllctreCode") String estbllctreCode);

    List<TaskPresentnVO> selectTaskPresentn(@Param("estbllctreCode") String estbllctreCode);

    String findWeekAcctoLrnNo(@Param("estbllctreCode") String estbllctreCode,
                              @Param("week") String week);

    String nextTaskNo();

    void insertTask(TaskVO vo);

    TaskVO getTaskByNo(String taskNo);

    int deleteTask(@Param("estbllctreCode") String estbllctreCode, @Param("taskNo") String taskNo);

    int deleteTaskPresentnByTask(@Param("taskNo") String taskNo);

    List<AtendAbsncVO> getAttendList(@Param("estbllctreCode") String estbllctreCode);

    String getLctreNm(String estbllctreCode);

    List<TaskPresentnVO> selectTaskPresentnByTask(String estbllctreCode, String taskNo);

    List<QuizVO> selectQuiz(@Param("estbllctreCode") String estbllctreCode);

    List<QuizPresentnVO> selectQuizPresentn(@Param("estbllctreCode") String estbllctreCode);

    List<QuizPresentnVO> selectQuizPresentnByQuiz(@Param("estbllctreCode") String estbllctreCode,
                                                  @Param("quizCode") String quizCode);

    String nextQuizCode();

    void insertQuiz(QuizVO vo);

    QuizVO getQuizByCode(String quizCode);

    int updateQuiz(QuizVO vo);

    int deleteQuiz(@Param("estbllctreCode") String estbllctreCode, @Param("quizCode") String quizCode);

    int deleteQuizPresentnByQuiz(@Param("quizCode") String quizCode);

    String nextQuizExCode();

    void insertQuizEx(QuizExVO vo);

    int deleteQuizExByQuiz(@Param("quizCode") String quizCode);

    List<QuizExVO> selectQuizExByQuiz(@Param("quizCode") String quizCode);

    FileDetailVO selectFileDetailByFileNo(@Param("fileGroupNo") long fileGroupNo, @Param("fileNo") long fileNo);
}
