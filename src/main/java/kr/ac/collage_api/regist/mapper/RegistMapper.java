package kr.ac.collage_api.regist.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.regist.vo.RegisterVO;

@Mapper
public interface RegistMapper {

	public List<RegisterVO> selectRegisterList(Map<String, Object> param);
}
