package kr.ac.collage_api.dashboard.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.dashboard.vo.ReactDashboardVO.UnivRankVO;
import kr.ac.collage_api.dashboard.vo.ReactDashboardVO.keyValue;

@Mapper
public interface ReactDashboardMapper {

	//현재 재학생 수
	public int currentStdntCount();

	//현재 수업 수
	public int currentCourseCount(String strYear, String semstr);

	//현재 재직중인 교수
	public int currentProfsrCount();

	//학과별 학생수
	public List<UnivRankVO> stdntCountInUniv();

	//학적 상태별 학생수
	public List<keyValue> enrollmentRatio();

}
