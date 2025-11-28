package kr.ac.collage_api.common.attach.mapper;

import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.FileGroupVO;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UploadMapper {
    //파일 그룹 생성
    public int insertFileGroup(FileGroupVO fileGroupVO);

    //파일 디테일 생성
    public int insertFileDetail(FileDetailVO fileDetailVO);

    //그룹넘버로 파일 리스트를 셀렉하는 매퍼얌
	public List<FileDetailVO> getFileDetailList(Long fileGroupNo);
}
