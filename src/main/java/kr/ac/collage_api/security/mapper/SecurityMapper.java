package kr.ac.collage_api.security.mapper;

import kr.ac.collage_api.vo.AcntVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SecurityMapper {
    AcntVO findAcnt(String username);
}
