package kr.ac.collage_api.stdnt.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.stdnt.mapper.StdntMapper;
import kr.ac.collage_api.stdnt.service.StdntService;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class StdntServiceImpl implements StdntService {

	@Autowired
	private StdntMapper stdntMapper;
	
	@Override
	public StdntVO getStdntInfo(String stdntNo) {
		
		return stdntMapper.selectStdntInfo(stdntNo);
	}

	@Override
	public StdntVO getStdntInfoByName(String stdntNm) {
		return stdntMapper.selectStdntInfoByName(stdntNm);
	}

}
