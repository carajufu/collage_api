package kr.ac.collage_api.stdnt.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.SemstrScreVO;
import kr.ac.collage_api.vo.StdntVO;

@Mapper
public interface StdntMapper {
	
	public StdntVO selectStdntInfo(String stdntNo);
	
	public StdntVO selectStdntInfoByName(String stdntNm);

	public StdntVO findStdntByAcntId(String acntId);

	public List<EstblCourseVO> getCourseList(@Param("stdntNo") String stdntNo,
											@Param("year") String year,
											@Param("semstr") String semstr);

	public List<Map<String, Object>> getSbjScre(String stdntNo);

	public AcntVO getAcntInfo(String acntId);

	public List<SemstrScreVO> getSemstrList(String stdntNo);

	public Map<String, String> getYearSemBySemstrInnb(Integer semstrScreInnb);

	public Integer getTotalAcqsPnt(String stdntNo);

	public List<Map<String, Object>> getPntByComplSe(@Param("stdntNo") String stdntNo,
													@Param("year") String year,
													@Param("semstr") String semstr);

	public List<Map<String, Object>> getAttendanceSummary(String stdntNo);
}
