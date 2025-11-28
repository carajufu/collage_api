package kr.ac.collage_api.learning.mapper;

import kr.ac.collage_api.learning.vo.AtendAbsncVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LearningPageProfMapper {

    List<AtendAbsncVO> getAttendByLecture(@Param("estbllctreCode") String estbllctreCode);
}
