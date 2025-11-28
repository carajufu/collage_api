package kr.ac.collage_api.learning.mapper;

import kr.ac.collage_api.learning.vo.AtendAbsncVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LearningPageProfMapper {
    List<TaskVO> selectTasks(@Param("estbllctreCode") String estbllctreCode);

    List<TaskPresentnVO> selectTaskPresentn(@Param("estbllctreCode") String estbllctreCode);

    List<AtendAbsncVO> getAttendList(@Param("estbllctreCode") String estbllctreCode);

    String getLctreNm(String estbllctreCode);

    List<TaskPresentnVO> selectTaskPresentnByTask(String estbllctreCode, String taskNo);
}
