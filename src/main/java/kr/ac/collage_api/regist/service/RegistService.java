package kr.ac.collage_api.regist.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.regist.vo.RegisterVO;

public interface RegistService {
	List<RegisterVO> selectRegisterList(Map<String, Object> param);
}
