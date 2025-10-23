package kr.ac.collage_api.account.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.account.vo.FileDetailVO;
import kr.ac.collage_api.account.vo.FileGroupVO;

@Mapper
public interface AccountMapper {

	//파일 그룹 생성
	public int insertFileGroup(FileGroupVO fileGroupVO);

	//파일 디테일 생성
	public int insertFileDetail(FileDetailVO fileDetailVO);

}
