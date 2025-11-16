package kr.ac.collage_api.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.vo.ProfsrVO;
import kr.ac.collage_api.vo.SubjctVO;
import kr.ac.collage_api.vo.UnivVO;

@Mapper
public interface UnivMapper {

	//단과대 정보 가져오기
	public List<UnivVO> findAllUniv();

	//학과 정보 가져오기
	public List<SubjctVO> findAllSubjct();

	//학장후보
	public List<ProfsrVO> findProfsrByUniv(@Param("univCode") String univCode, 
	                                       @Param("clsf") String clsf);

	//학과장후보
	public List<ProfsrVO> findProfsrBySubjct(@Param("subjctCode") String subjctCode, 
	                                         @Param("clsf") String clsf);

	

}
