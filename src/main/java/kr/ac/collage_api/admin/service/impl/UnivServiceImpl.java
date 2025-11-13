package kr.ac.collage_api.admin.service.impl;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.admin.mapper.UnivMapper;
import kr.ac.collage_api.admin.service.UnivService;
import kr.ac.collage_api.vo.ProfsrVO;
import kr.ac.collage_api.vo.SubjctVO;
import kr.ac.collage_api.vo.UnivVO;

@Service
public class UnivServiceImpl implements  UnivService{

	@Autowired
	private UnivMapper univMapper;
	
	//트리목록
	@Override
	public List<UnivVO> getUnivTreeList() {
		
		List<UnivVO> univList = univMapper.findAllUniv();
		List<SubjctVO> subjctList = univMapper.findAllSubjct();
		
		//그룹핑
		Map<String, List<SubjctVO>> subjctsByUnivCode = 
				subjctList.stream().collect(Collectors.groupingBy((subjct) -> subjct.getUnivCode()));
		//단과대에 학과 넣기
		univList.forEach(univ ->{
			List<SubjctVO> children = subjctsByUnivCode.get(univ.getUnivCode());
			
			if(children != null) {univ.setChildren(children);}
		});
				
		return univList;
	}

	//교수목록 포함 트리
	/*
	 * @Override public List<ProfsrVO> findProfsrList(String rank, String code) {
	 * 
	 * //학과, 단과대 목록 List<UnivVO> univList = univMapper.findAllUniv(); List<SubjctVO>
	 * subjctList = univMapper.findAllSubjct();
	 * 
	 * //학과별, 단과대별 교수목록 List<ProfsrVO> univProfsr =
	 * univMapper.findProfsrByRankAtLeast("정교수"); List<ProfsrVO> subjctProfsr =
	 * univMapper.findProfsrByRankAtLeast("부교수");
	 * 
	 * //그룹핑 //학과 코드별 Map<String, List<ProfsrVO>> profsrBySubjctCode = //분류 기준 함수
	 * subjctProfsr.stream().collect(Collectors.groupingBy((ProfsrVO)->
	 * ProfsrVO.getSubjctCode())); //단과대 코드별 Map<String, List<ProfsrVO>>
	 * profsrByUnivCode =
	 * univProfsr.stream().collect(Collectors.groupingBy((ProfsrVO)->
	 * ProfsrVO.getUnivCode()));
	 * 
	 * //학과 객체에 교수 리스트 넣기 subjctList.forEach(subjct -> { //key , defaultValue
	 * subjct.setProfsr(profsrBySubjctCode.getOrDefault(subjct.getSubjctCode(),
	 * Collections.emptyList())); //Collections 클래스의 정적 메서드 });
	 * univList.forEach(univ ->{ List<SubjctVO> children = subjctList.stream()
	 * .filter(s -> s.getUnivCode().equals(univ.getUnivCode()))
	 * .collect(Collectors.toList());
	 * 
	 * univ.setChildren(children);
	 * univ.setProfsr(profsrByUnivCode.getOrDefault(univ.getUnivCode(),
	 * Collections.emptyList())); }); return univMapper.findProfsrList(rank, code);
	 * }
	 */
	
	//학장후보
	@Override
    public List<ProfsrVO> findDeanCandidates(String univCode) {
        return univMapper.findProfsrByUniv(univCode, "정교수");
    }

	//학과장후보
    @Override
    public List<ProfsrVO> findDeptHeadCandidates(String subjctCode) {
        return univMapper.findProfsrBySubjct(subjctCode, "부교수");
    }

}
