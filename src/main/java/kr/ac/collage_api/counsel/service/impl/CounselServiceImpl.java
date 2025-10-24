package kr.ac.collage_api.counsel.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.account.mapper.AccountMapper;
import kr.ac.collage_api.counsel.mapper.CounselMapper;
import kr.ac.collage_api.counsel.service.CounselService;
import kr.ac.collage_api.vo.CnsltAtVO;

@Service
public class CounselServiceImpl implements CounselService {

	@Autowired
	AccountMapper accountMapper;
	
	@Autowired
	CounselMapper counselMapper;

	@Override
	public List<CnsltAtVO> getCnsltAtVOList(String acntId) {
		
		//계정 아이디로 교수 아이디 가져오기
		String profsrNo = this.accountMapper.getProfsrNo(acntId);
								
		return this.counselMapper.getCnsltAtVOList(profsrNo);
	}

	@Override
	public int insertCnsltAt(CnsltAtVO cnsltAtVO) {
		return this.counselMapper.insertCnsltAt(cnsltAtVO);
	}
}
