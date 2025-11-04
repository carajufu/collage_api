package kr.ac.collage_api.common.attach.mapper;

import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.FileGroupVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UploadMapper {
    //파일 그룹 생성
    public int insertFileGroup(FileGroupVO fileGroupVO);

    //파일 디테일 생성
    public int insertFileDetail(FileDetailVO fileDetailVO);
}
