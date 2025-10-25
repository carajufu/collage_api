package kr.ac.collage_api.dashboard.mapper;

import kr.ac.collage_api.dashboard.vo.LectureVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DashboardMapper {
    List<LectureVO> selectStudent(@Param("stdntNo") String studentNo,
                                    @Param("year") String year,
                                    @Param("period") String currentPeriod);
}
