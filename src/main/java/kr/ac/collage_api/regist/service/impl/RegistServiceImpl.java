package kr.ac.collage_api.regist.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.regist.mapper.RegistMapper;
import kr.ac.collage_api.regist.service.RegistService;
import kr.ac.collage_api.regist.vo.RegisterVO;

@Service
public class RegistServiceImpl implements RegistService{

	@Autowired
	RegistMapper registMapper;

	@Override
	public List<RegisterVO> selectRegisterList(Map<String, Object> param) {
		return registMapper.selectRegisterList(param);
	}
}
