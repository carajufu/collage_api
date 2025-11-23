package kr.ac.collage_api.index.service;

import java.util.List;

import kr.ac.collage_api.index.vo.IndexBbsVO;

/**
 * INDEX 메인용 게시판 목록 조회 서비스
 * - 코드 의도: 메인 페이지에서 공지/행사/학술 등 게시글 요약 리스트를 조회하는 진입점.
 * - 데이터 흐름: Controller → IndexBbsService.selectMainBbsList(bbsCode)
 * 						   → Mapper
 * 						   → VO 리스트 반환.
 * 
 * - 계약: 유효한 bbsCode(1=공지, 2=행사, 3=학술/논문 등)를 입력받아 최신 N개 게시글 목록을 반환한다.
 */
public interface IndexBbsService {
    List<IndexBbsVO> selectMainBbsList(int bbsCode);
}
