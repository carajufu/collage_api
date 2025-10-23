package kr.ac.collage_api.admin.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.admin.mapper.BbsNoticeMapper;
import kr.ac.collage_api.admin.service.BbsNoticeService;
import kr.ac.collage_api.admin.vo.BbsVO;

@Service
public class BbsNoticeServiceImpl implements BbsNoticeService {
	
	@Autowired
	BbsNoticeMapper adminMapper;

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.adminMapper.getTotal(map);
	}

	@Override
	public List<BbsVO> list(Map<String, Object> map) {
		return this.adminMapper.list(map);
	}

	@Override
	public BbsVO detail(int bbscttNo) {
		return this.adminMapper.detail(bbscttNo);
	}

	@Override
	public int delete(int bbscttNo) {
		return this.adminMapper.delete(bbscttNo);
	}
	
}
