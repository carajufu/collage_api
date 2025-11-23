
package kr.ac.collage_api.index.service.impl;

import java.util.List;

import kr.ac.collage_api.index.mapper.IndexBbsMapper;
import kr.ac.collage_api.index.service.IndexBbsService;
import kr.ac.collage_api.index.vo.IndexBbsVO;
import org.springframework.stereotype.Service;


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