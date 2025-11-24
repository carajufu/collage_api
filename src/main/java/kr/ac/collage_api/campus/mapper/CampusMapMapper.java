package kr.ac.collage_api.campus.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CampusMapMapper {

	// 학과 조회
    public List<String> selectDeptListByUnivCode(String univCode);
}
