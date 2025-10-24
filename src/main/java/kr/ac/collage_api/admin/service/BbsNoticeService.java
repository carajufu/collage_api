package kr.ac.collage_api.admin.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.vo.BbsVO;

public interface BbsNoticeService {

	//list 총 페이지 가져오기
	public int getTotal(Map<String, Object> map);

	//현재 페이지에서 보여지는 목록만 가지고오기 ex) 한페이지에 10개만 보여진다면 10개만 가지고 옴
	public List<BbsVO> list(Map<String, Object> map);

	//게시글 상세페이지
	public BbsVO detail(int bbscttNo);

	//게시글 삭제
	public int delete(int bbscttNo);

}
