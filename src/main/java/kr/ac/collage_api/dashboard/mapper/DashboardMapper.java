package kr.ac.collage_api.dashboard.mapper;

import kr.ac.collage_api.dashboard.vo.AcademicProgressRawVO;
import kr.ac.collage_api.dashboard.vo.DashLectureVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DashboardMapper {
    List<DashLectureVO> selectStudent(@Param("stdntNo") String studentNo,
                                      @Param("year") String year,
                                      @Param("period") String currentPeriod);

    List<DashLectureVO> selectProfessor(@Param("profsrNo") String profsrNo,
							            @Param("year") String year,
							            @Param("period") String currentPeriod);


    AcademicProgressRawVO selectAcademicProgress(@Param("stdntNo") String stdntNo);

}
