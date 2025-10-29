package kr.ac.collage_api.counsel.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.account.mapper.AccountMapper;
import kr.ac.collage_api.common.util.CurrentSemstr;
import kr.ac.collage_api.counsel.mapper.CounselMapper;
import kr.ac.collage_api.counsel.service.CounselService;
import kr.ac.collage_api.vo.CnsltAtVO;
import kr.ac.collage_api.vo.CnsltVO;
import kr.ac.collage_api.vo.LctreTimetableVO;
import kr.ac.collage_api.vo.ProfsrVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CounselServiceImpl implements CounselService {

	@Autowired
	AccountMapper accountMapper;
	
	@Autowired
	CounselMapper counselMapper;

	@Autowired
	CurrentSemstr currentSemstr; 

	@Override
	public List<CnsltAtVO> getCnsltAtVOList(String acntId) {
		
		//계정 아이디로 교수 아이디 가져오기
		String profsrNo = this.accountMapper.getProfsrNo(acntId);
		log.info("getCnsltAtVOList() -> profsrNo : {}", profsrNo);
		return this.counselMapper.getCnsltAtVOList(profsrNo);
		
	}

	@Override
	public int insertCnsltAt(CnsltAtVO cnsltAtVO) {
		return this.counselMapper.insertCnsltAt(cnsltAtVO);
	}



	@Override
	public List<CnsltVO> selectCnsltStd(String acntId) {
		//계정 아이디로 학생No 가져오기
		String StdntNo = this.accountMapper.selectStdntNo(acntId);
		//학생 No 로 상담 VOList 가져오기
		return this.counselMapper.selectCnsltStd(StdntNo);
	}

	@Override
	public int createCnslt(CnsltVO cnsltVO) {
		
		return this.counselMapper.createCnslt(cnsltVO);
	}
	
	@Override
	public List<ProfsrVO> selectMyProf(String acntId) {
		//계정 아이디로 학생No 가져오기
		String stdntNo = this.accountMapper.selectStdntNo(acntId);
		log.info("selectMyProf() -> StdntNo : {}", stdntNo);

		String year = currentSemstr.getYear();
		String semstr = currentSemstr.getCurrentPeriod();
				
		return this.counselMapper.selectMyProf(stdntNo,year,semstr);
	}

	@Override
	public List<LctreTimetableVO> selectMyProfTimetable(String profsrNo) {
		log.info("selectMyProfTimetable() -> profsrNo : {}", profsrNo);
		return this.counselMapper.selectMyProfTimetable(profsrNo);
	}

	@Override
	public List<CnsltVO> profCnsltList(String profsrNo) {
		return this.counselMapper.profCnsltList(profsrNo);
	}

	@Override
	public CnsltVO seletCnsltDetail(int cnsltInnb) {
		return this.counselMapper.seletCnsltDetail(cnsltInnb);
	}


	@Override
	public List<CnsltVO> selectCnsltCount(String acntId) {
		//계정 아이디로 학생No 가져오기
		String stdntNo = this.accountMapper.selectStdntNo(acntId);
		
		return this.counselMapper.selectCnsltCount(stdntNo);
	}

	@Override
	public String selectStdntNo(String acntId) {
		return this.accountMapper.selectStdntNo(acntId);
	}





}
