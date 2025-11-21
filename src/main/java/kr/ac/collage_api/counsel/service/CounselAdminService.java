package kr.ac.collage_api.counsel.service;

import java.util.List;

import kr.ac.collage_api.counsel.dto.CounselAdminChartDTO;
import kr.ac.collage_api.vo.CnsltVO;

public interface CounselAdminService {

	public List<CnsltVO> selectCnsltList();

	public CnsltVO selectCnsltDetail(int cnsltInnb);

	public CounselAdminChartDTO selectCnlstChartValue();

}
