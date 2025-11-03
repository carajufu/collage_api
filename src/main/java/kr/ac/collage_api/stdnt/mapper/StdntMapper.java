package kr.ac.collage_api.stdnt.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.StdntVO;

@Mapper
public interface StdntMapper {
	
	public StdntVO selectStdntInfo(String stdntNo);
	
	public StdntVO selectStdntInfoByName(String stdntNm);

	public StdntVO findStdntByAcntId(String acntId);

}
