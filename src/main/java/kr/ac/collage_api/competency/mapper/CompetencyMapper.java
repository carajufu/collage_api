package kr.ac.collage_api.competency.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.competency.vo.CompetencyVO;

@Mapper
public interface CompetencyMapper {
    public int insertSelfIntro(CompetencyVO vo);
    
    public CompetencyVO selectSelfIntro(int introNo);
    
    public List<CompetencyVO> selectSelfIntroList(String stdntNo);
}