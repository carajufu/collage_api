package kr.ac.collage_api.competency.service;

import java.util.List;

import kr.ac.collage_api.competency.vo.CompetencyVO;

public interface CompetencyService {

    CompetencyVO getFormData(String stdntNo);

    String generateIntro(CompetencyVO form);

    // 옵션: 사용자가 폼을 저장하고 싶으면 아래 사용
    int insertFormData(CompetencyVO vo);
    int updateFormData(CompetencyVO vo);

	void saveForm(CompetencyVO form);
}
