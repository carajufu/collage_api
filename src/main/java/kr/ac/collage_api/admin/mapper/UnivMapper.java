package kr.ac.collage_api.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.admin.dto.SubjctUpdateRequestDto;
import kr.ac.collage_api.admin.dto.UnivUpdateRequestDto;
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

	//단과대 정보 업데이트
	public int updateUniv(UnivUpdateRequestDto univDto);

	//학과 정보 업데이트
	public int updateSubjct(SubjctUpdateRequestDto subjctDto);

	//학과 추가
	public int insertSubjct(SubjctUpdateRequestDto dto);

	//추가된 학과 조회
	public SubjctVO findSubjectByCode(String subjctCode);

	//단과대에 포함된 학과 수
	public int countSubjcts(String univCode);

	//학과에 포함된 교수 수
	public int countProfsrs(String subjctCode);

	//단과대 삭제
	public int deleteUniv(String univCode);

	//학과 삭제
	public int deleteSubjct(String subjctCode);


}
