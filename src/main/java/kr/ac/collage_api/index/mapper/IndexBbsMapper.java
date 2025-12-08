package kr.ac.collage_api.index.mapper;

import java.util.List;

import kr.ac.collage_api.index.vo.IndexBbsVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface IndexBbsMapper {

    // INDEX 페이지: 공지/행사/논문 공통 조회
    List<IndexBbsVO> selectMainBbsList(@Param("bbsCode") int bbsCode);
}
