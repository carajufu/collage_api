package kr.ac.collage_api.competency.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.competency.vo.CompetencyVO;

@Service
public interface CompetencyService {

	void createAndSaveSelfIntro(CompetencyVO vo);

	CompetencyVO getSelfIntroDetail(int introNo);

	List<CompetencyVO> getSelfIntroList(String stdntNo);

}
