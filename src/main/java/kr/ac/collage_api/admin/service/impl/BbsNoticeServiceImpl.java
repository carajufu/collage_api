package kr.ac.collage_api.admin.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.admin.mapper.BbsNoticeMapper;
import kr.ac.collage_api.admin.service.BbsNoticeService;
import kr.ac.collage_api.vo.BbsVO;

@Service
public class BbsNoticeServiceImpl implements BbsNoticeService {
	
	@Autowired
	BbsNoticeMapper bbsNoticeMapper;

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.bbsNoticeMapper.getTotal(map);
	}

	@Override
	public List<BbsVO> list(Map<String, Object> map) {
		return this.bbsNoticeMapper.list(map);
	}

	@Override
	public BbsVO detail(int bbscttNo) {
		return this.bbsNoticeMapper.detail(bbscttNo);
	}

	@Override
	public int delete(int bbscttNo) {
		return this.bbsNoticeMapper.delete(bbscttNo);
	}

	@Override
	public List<BbsVO> adminList() {
		return this.bbsNoticeMapper.adminList();
	}

	@Override
	public int adminPutDetail(BbsVO bbsVO) {
		return this.bbsNoticeMapper.adminPutDetail(bbsVO);
	}

	@Override
	public int adminDeleteDetail(int bbscttNo) {
		return this.bbsNoticeMapper.adminDeleteDetail(bbscttNo);
	}

	@Override
	public int adminPostDetail(BbsVO bbsVO) {
		return this.bbsNoticeMapper.adminPostDetail(bbsVO);
	}
	
}
