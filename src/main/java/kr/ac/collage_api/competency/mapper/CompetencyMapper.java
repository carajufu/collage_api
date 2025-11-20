package kr.ac.collage_api.competency.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import kr.ac.collage_api.competency.vo.CompetencyVO;

@Mapper
public interface CompetencyMapper {

	CompetencyVO getFormData(String stdntNo);

	int insertFormData(CompetencyVO vo);

	int updateFormData(CompetencyVO vo);

}
