// StdntInfoServiceImpl.java
package kr.ac.collage_api.stdnt.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.common.attach.service.UploadController;
import kr.ac.collage_api.stdnt.mapper.StdntInfoMapper;
import kr.ac.collage_api.stdnt.service.StdntInfoService;
import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.StdntVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class StdntInfoServiceImpl implements StdntInfoService {

    @Autowired
    private StdntInfoMapper stdntMapper;

    @Autowired
    private UploadController uploadService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public StdntVO getStdntInfo(String stdntNo) {
        return stdntMapper.selectStdntInfo(stdntNo);
    }

    @Override
    public StdntVO getStdntInfoByName(String stdntNm) {
        return stdntMapper.selectStdntInfoByName(stdntNm);
    }

    @Override
    public AcntVO getAcntInfo(String acntId) {
        return stdntMapper.getAcntInfo(acntId);
    }

    @Override
    public int updateInfo(StdntVO vo) {
        return stdntMapper.updateInfo(vo);
    }
    
    @Override
    public FileDetailVO getProfileImageDetail(String acntId) {
        return stdntMapper.getProfileImageDetail(acntId);
    }

    /* ------------------------------------------
       프로필 이미지 업로드 (UploadController 활용)
       → fileGroupNo 생성 후 DB 저장
    ------------------------------------------- */
    @Override
    public long updateProfileImage(String acntId, MultipartFile uploadFile) {

        if (uploadFile == null || uploadFile.isEmpty()) {
            return 0;
        }

        // 파일 업로드 처리 (파일 1개)
        long fileGroupNo = uploadService.fileUpload(new MultipartFile[]{uploadFile});

        // 학생 테이블에 fileGroupNo 저장
        stdntMapper.updateProfileImage(acntId, fileGroupNo);

        return fileGroupNo;
    }

    /* ------------------------------------------
       비밀번호 변경
    ------------------------------------------- */
    @Override
    public int updatePwInfo(String stdntNo, String password) {
        String encodedPw = passwordEncoder.encode(password);
        return stdntMapper.updatePwInfo(stdntNo, encodedPw);
    }

    /* ------------------------------------------
       비밀번호 확인
    ------------------------------------------- */
    @Override
    public boolean checkPassword(String stdntNo, String rawPassword) {

        String encodedPw = stdntMapper.getPassword(stdntNo);

        if (encodedPw == null || encodedPw.isEmpty()) {
            return false;
        }

        return passwordEncoder.matches(rawPassword, encodedPw);
    }
    /* ------------------------------------------
       프로필 이미지 경로 조회
       (fileGroupNo → FILE_DETAIL 경로 조회)
    ------------------------------------------- */
    @Override
    public String getProfileImage(String acntId) {
        return stdntMapper.getProfileImage(acntId);
    }

}
