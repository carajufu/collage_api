
package kr.ac.collage_api.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.mapper.IndexBbsMapper;
import kr.ac.collage_api.service.IndexBbsService;
import kr.ac.collage_api.vo.IndexBbsVO;

@Service
public class IndexBbsServiceImpl implements IndexBbsService {

    private final IndexBbsMapper indexBbsMapper;

    public IndexBbsServiceImpl(IndexBbsMapper indexBbsMapper) {
        this.indexBbsMapper = indexBbsMapper;
    }

    @Override
    public List<IndexBbsVO> selectMainBbsList(int bbsCode) {
        // 메인 인덱스에서 게시판별(공지/행사/논문 등) 상단 N개 목록 조회
        return indexBbsMapper.selectMainBbsList(bbsCode);
    }
}