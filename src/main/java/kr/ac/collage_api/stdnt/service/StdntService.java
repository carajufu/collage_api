package kr.ac.collage_api.stdnt.service;

import kr.ac.collage_api.vo.StdntVO;

public interface StdntService {

	/**
	 * 학번으로 학생 기본 정보 조회
	 * @param studentNo 학번
	 * @return 학생 정보 (StdntVO)
	 */
	public StdntVO getStdntInfo(String stdntNo);
	
	public StdntVO getStdntInfoByName(String stdntNm);

}
