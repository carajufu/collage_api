package kr.ac.collage_api.regist.mapper;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.regist.vo.RegisterVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RegistMapper {

	public List<RegisterVO> selectRegisterList(Map<String, Object> param);
}
