package kr.ac.collage_api.competency.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.competency.vo.CompetencyVO;

@Service
public interface CompetencyService {

	CompetencyVO getFormData(String stdntNo);

	void saveForm(CompetencyVO form);

	String generateIntro(CompetencyVO form);

	void insertManageCn(String stdntNo, String resultIntro);

	List<CompetencyVO> getManageCnList(String stdntNo);

	List<CompetencyVO> getAllByStdntNo(String stdntNo);

	void deleteManageCn(String stdntNo);

	void saveManageCn(CompetencyVO vo);

	int updateFormData(CompetencyVO vo);

	int insertFormData(CompetencyVO vo);

	void deleteOneManageCn(String stdntNo, int formId);

}