package kr.ac.collage_api.counsel.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.counsel.mapper.CounselProfMapper;
import kr.ac.collage_api.counsel.service.CounselProfService;
import kr.ac.collage_api.vo.CnsltVO;

@Service
public class CounselProfServiceImpl implements CounselProfService {

	@Autowired
	CounselProfMapper counselProfMapper;
	
	@Override
	public String getProfsrNo(String acntId) {
		return this.counselProfMapper.getProfsrNo(acntId);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.counselProfMapper.getTotal(map);
	}

	@Override
	public List<CnsltVO> list(Map<String, Object> map) {
		return this.counselProfMapper.list(map);
	}

	@Override
	public List<CnsltVO> selectProfCnsltCount(String profsrNo) {
		return this.counselProfMapper.selectProfCnsltCount(profsrNo);
	}

	@Override
	public int patchAccept(CnsltVO cnsltVO) {
		return this.counselProfMapper.patchAccept(cnsltVO);
	}

	@Override
	public int patchCancl(CnsltVO cnsltVO) {
		return this.counselProfMapper.patchCancl(cnsltVO);
	}

	@Override
	public int patchResult(CnsltVO cnsltVO) {
		return this.counselProfMapper.patchResult(cnsltVO);
	}


}
