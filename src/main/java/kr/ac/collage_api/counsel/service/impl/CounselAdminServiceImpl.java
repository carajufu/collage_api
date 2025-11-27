package kr.ac.collage_api.counsel.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.counsel.dto.CounselAdminChartDTO;
import kr.ac.collage_api.counsel.dto.CounselAdminChartDTO.ProfsrRankVO;
import kr.ac.collage_api.counsel.dto.CounselAdminChartDTO.StatusVO;
import kr.ac.collage_api.counsel.mapper.CounselAdminMapper;
import kr.ac.collage_api.counsel.service.CounselAdminService;
import kr.ac.collage_api.vo.CnsltVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CounselAdminServiceImpl implements CounselAdminService {

	@Autowired
	CounselAdminMapper counselAdminMapper;

	@Override
	public List<CnsltVO> selectCnsltList() {
		return this.counselAdminMapper.selectCnsltList();
	}

	@Override
	public CnsltVO selectCnsltDetail(int cnsltInnb) {
		return this.counselAdminMapper.selectCnsltDetail(cnsltInnb);
	}

	@Override
	public CounselAdminChartDTO selectCnlstChartValue() {

		CounselAdminChartDTO counselAdminChartDTO = new CounselAdminChartDTO();
		int todayRequestCount = this.counselAdminMapper.selectTodayRequestCount();
		int monthRequestCount = this.counselAdminMapper.selectMonthRequestCount();
		int currentWaitingCount = this.counselAdminMapper.selectCurrentWaitingCount();
		counselAdminChartDTO.setTodayRequestCount(todayRequestCount);
		counselAdminChartDTO.setMonthRequestCount(monthRequestCount);
		counselAdminChartDTO.setCurrentWaitingCount(currentWaitingCount);


		//도넛차트 시작//
		List<Map<String,Object>> dbResult = this.counselAdminMapper.selectStatusRatio();

		Map<String,Integer> countMap = new HashMap<String,Integer>();

		for(Map<String,Object> map : dbResult) {
			String sttus = (String) map.get("STTUS");

			int count = map.get("COUNT") == null ? 0 : ((Number) map.get("COUNT")).intValue();
			countMap.put(sttus, count);
		}

		List<StatusVO> chartData = new ArrayList<>();

		chartData.add(createStatusVO("신청대기",countMap.getOrDefault("1", 0),"#FFBB28"));
		chartData.add(createStatusVO("상담예정",countMap.getOrDefault("2", 0),"#0088FE"));
		chartData.add(createStatusVO("상담취소",countMap.getOrDefault("3", 0),"#FF8042"));
		chartData.add(createStatusVO("상담완료",countMap.getOrDefault("4", 0),"#00C49F"));
		log.info("selectCnlstChartValue() -> chartData : {}", chartData);
		counselAdminChartDTO.setStatusRatio(chartData);
		//도넛차트 끝//


		// 교수 상위 TOP 5 시작 //
		List<ProfsrRankVO> topFiveProfsr = new ArrayList<>();
		topFiveProfsr = this.counselAdminMapper.selectTopFiveProfsr();

		counselAdminChartDTO.setTopFiveProfsr(topFiveProfsr);


		return counselAdminChartDTO;
	}

	private StatusVO createStatusVO(String name, int value, String color) {
	    StatusVO vo = new StatusVO();
	    vo.setName(name);
	    vo.setValue(value);
	    vo.setColor(color);
	    return vo;
	}

}
