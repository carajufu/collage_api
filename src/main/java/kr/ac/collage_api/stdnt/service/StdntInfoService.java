package kr.ac.collage_api.stdnt.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.StdntVO;

@Service
public interface StdntInfoService {

    StdntVO getStdntInfo(String stdntNo);
    StdntVO getStdntInfoByName(String stdntNm);

    AcntVO getAcntInfo(String acntId);

    int updateInfo(StdntVO vo);

    long updateProfileImage(String acntId, MultipartFile uploadFile);

    int updatePwInfo(String stdntNo, String password);

    String getProfileImage(String acntId);
    
    boolean checkPassword(String stdntNo, String rawPassword);
    
	FileDetailVO getProfileImageDetail(String acntId);
}
