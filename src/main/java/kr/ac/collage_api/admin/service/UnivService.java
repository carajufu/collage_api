package kr.ac.collage_api.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.vo.ProfsrVO;
import kr.ac.collage_api.vo.UnivVO;

@Service
public interface UnivService {

	//트리목록
	List<UnivVO> getUnivTreeList();

	//교수목록 포함 트리
	//List<ProfsrVO> findProfsrList(String rank, String code);
	
	//학장후보
	List<ProfsrVO> findDeanCandidates(String univCode);   
	
	//학과장후보
    List<ProfsrVO> findDeptHeadCandidates(String subjctCode); 

}
