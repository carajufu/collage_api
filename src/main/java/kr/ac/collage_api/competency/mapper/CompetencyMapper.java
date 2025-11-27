package kr.ac.collage_api.competency.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import kr.ac.collage_api.competency.vo.CompetencyVO;

@Mapper
public interface CompetencyMapper {

	int getNextFormNo();
	
	CompetencyVO getFormData(String stdntNo);

	int insertFormData(CompetencyVO vo);

	int updateFormData(CompetencyVO vo);
	
	void deleteManageCn(String stdntNo);

	List<CompetencyVO> selectManageCnList(String stdntNo);

	List<CompetencyVO> getManageCnList(String stdntNo);

	void deleteManageCnAll(String stdntNo);

	void insertManageCn(CompetencyVO vo);

	void deleteManageCnOne(String stdntNo, int formId);

}
