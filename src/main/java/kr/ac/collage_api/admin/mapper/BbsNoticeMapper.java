package kr.ac.collage_api.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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

	
	//관리자 - 공지사항 게시판 1행 삭제
	public int adminDeleteDetail(int bbscttNo);

	//관리자 - 공지사항 게시판 1행 등록
	public int adminPostDetail(BbsVO bbsVO);

	//관리자 - 공지사항 상세화면 bbs1행 가져오기
	public BbsVO adminDetail(int bbscttNo);

	//파일 디테일에서 deletedFileSns 삭제하기
	public int deleteFileDetail(@Param("fileNo")List<Integer> deletedFileSns, @Param("fileGroupNo") Long fileGroupNo);

	//파일 디테일 테이블에서 파일 그룹에 맞는 seq 최대값 찾기
	public int selectFileDetailMaxSeq(Long fileGroupNo);

	//관리자 - 공지사항게시판 1행 수정
	public int adminPutDetail(BbsVO bbsVO);



	
}
