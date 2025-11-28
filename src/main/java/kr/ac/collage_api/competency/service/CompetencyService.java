package kr.ac.collage_api.competency.service;

import java.util.List;

import kr.ac.collage_api.competency.vo.CompetencyVO;

public interface CompetencyService {

    CompetencyVO getFormData(String stdntNo);

    String generateIntro(CompetencyVO form);

    int insertFormData(CompetencyVO vo);
    
    int updateFormData(CompetencyVO vo);

	void saveForm(CompetencyVO form);
}
