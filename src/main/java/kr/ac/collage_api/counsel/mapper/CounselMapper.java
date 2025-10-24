package kr.ac.collage_api.counsel.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.CnsltAtVO;

@Mapper
public interface CounselMapper {

	//교수아이디가 포함된 상담_가능_여부 테이블 List 가져오기
	public List<CnsltAtVO> getCnsltAtVOList(String profsrNo);
						   
	// 상담_가능_여부 테이블에 입력
	public int insertCnsltAt(CnsltAtVO cnsltAtVO);

}
