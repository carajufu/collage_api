package kr.ac.collage_api.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.BbsVO;

@Mapper
public interface BbsNoticeMapper {

	//list 총 페이지 가져오기
	public int getTotal(Map<String, Object> map);

	//현재 페이지 목록만 가져오기
	public List<BbsVO> list(Map<String, Object> map);

	//글 번호 하나로 게시글 상세페이지 가져오기
	public BbsVO detail(int bbscttNo);

	//게시글 삭제
	public int delete(int bbscttNo);

	//관리자 - 공지사항게시판 리스트 가져오기
	public List<BbsVO> adminList();

	//관리자 - 공지사항게시판 1행 수정
	public int adminPutDetail(BbsVO bbsVO);

	//관리자 - 공지사항 게시판 1행 삭제
	public int adminDeleteDetail(int bbscttNo);

	//관리자 - 공지사항 게시판 1행 등록
	public int adminPostDetail(BbsVO bbsVO);


	
}
