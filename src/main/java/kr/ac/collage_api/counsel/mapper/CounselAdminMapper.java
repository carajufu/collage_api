package kr.ac.collage_api.counsel.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.counsel.dto.CounselAdminChartDTO.ProfsrRankVO;
import kr.ac.collage_api.vo.CnsltVO;

@Mapper
public interface CounselAdminMapper {

	//관리자 상담 리스트 불러오기
	public List<CnsltVO> selectCnsltList();

	//관리자 상담 디테일 가져오기
	public CnsltVO selectCnsltDetail(int cnsltInnb);

	//오늘 상담 신청 건수
	public int selectTodayRequestCount();

	//이번 달 상담 신청 건수
	public int selectMonthRequestCount();

	//현재시점 처리안된 상담건수
	public int selectCurrentWaitingCount();

	//상태통계 자료 가져오기
	public List<Map<String, Object>> selectStatusRatio();

	//교수 상위 top5 불러오기
	public List<ProfsrRankVO> selectTopFiveProfsr();

}
