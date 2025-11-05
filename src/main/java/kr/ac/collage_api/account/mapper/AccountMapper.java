package kr.ac.collage_api.account.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.FileGroupVO;

@Mapper
public interface AccountMapper {
	
	//파일 그룹 생성
	public int insertFileGroup(FileGroupVO fileGroupVO);

	//파일 디테일 생성
	public int insertFileDetail(FileDetailVO fileDetailVO);
	
	//계정아이디로 교수 아이디 가져오기
	public String getProfsrNo(String acntId);

	//계정 아이디로 학생 아이디 가져오기
	public String selectStdntNo(String acntId);

	//파일 상세정보 조회
	public FileDetailVO getFileDetailByGroupNo(Long fileGroupNo);
}
