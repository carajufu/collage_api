package kr.ac.collage_api.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.ac.collage_api.vo.IndexBbsVO;

@Mapper
public interface IndexBbsMapper {

    // INDEX 페이지: 공지/행사/논문 공통 조회
    List<IndexBbsVO> selectMainBbsList(@Param("bbsCode") int bbsCode);
}
