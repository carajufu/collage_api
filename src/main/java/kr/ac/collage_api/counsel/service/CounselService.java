package kr.ac.collage_api.counsel.service;

import java.util.List;

import kr.ac.collage_api.vo.CnsltAtVO;

public interface CounselService {

	
	public List<CnsltAtVO> getCnsltAtVOList(String acntId);

	// 상담 입력
	public int insertCnsltAt(CnsltAtVO cnsltAtVO);

}
