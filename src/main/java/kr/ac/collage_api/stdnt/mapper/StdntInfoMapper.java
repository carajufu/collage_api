// StdntInfoMapper.java
package kr.ac.collage_api.stdnt.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.StdntVO;

@Mapper
public interface StdntInfoMapper {

    StdntVO selectStdntInfo(String stdntNo);

    StdntVO selectStdntInfoByName(String stdntNm);

    AcntVO getAcntInfo(String acntId);

    int updateInfo(StdntVO vo);

    int updateProfileImage(@Param("acntId") String acntId,
                           @Param("fileGroupNo") long fileGroupNo);

    int updatePwInfo(@Param("stdntNo") String stdntNo,
                     @Param("encodedPw") String encodedPw);

    /* -----------------------------
        추가: 비밀번호 검증용
    ------------------------------ */
    String getPassword(String stdntNo);

    /* -----------------------------
        추가: 프로필 이미지 조회
    ------------------------------ */
    String getProfileImage(String acntId);

	FileDetailVO getProfileImageDetail(String acntId);
}
