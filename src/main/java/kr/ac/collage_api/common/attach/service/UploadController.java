package kr.ac.collage_api.common.attach.service;

import kr.ac.collage_api.common.attach.mapper.UploadMapper;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.FileGroupVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Slf4j
@Controller
public class UploadController {

	@Autowired
	BeanController beanController;
	
	@Autowired
    UploadMapper uploadMapper;
	
	//다중파일업로드 사용 / 단일파일 업로드도 그룹 만들고 업로드 되게 함
    @Transactional
	public long fileUpload(MultipartFile[] multipartFiles) {

        long fileGroupNo = 0L;

        String fileUrl = "";
        int seq = 1;
        int result = 0;

        FileGroupVO fileGroupVO = new FileGroupVO();
        result += uploadMapper.insertFileGroup(fileGroupVO);
        fileGroupNo = fileGroupVO.getFileGroupNo();

        File uploadPath = null;
        FileDetailVO fileDetailVO = null;
        for (MultipartFile multipartFile : multipartFiles) {

            uploadPath = new File(this.beanController.getUploadFolder()
                    , this.beanController.getFolder());

            if (uploadPath.exists() == false) {
                uploadPath.mkdirs();
            }

            String uploadFileName = multipartFile.getOriginalFilename();

            UUID uuid = UUID.randomUUID();

            uploadFileName = uuid.toString() + "_" + uploadFileName;

            File saveFile = new File(uploadPath, uploadFileName);

            try {
                multipartFile.transferTo(saveFile);
            } catch (IllegalStateException | IOException e) {
                e.printStackTrace();
            }

            fileUrl =
                    "/" + this.beanController.getFolder().replace("\\", "/")
                            + "/" + uploadFileName;

            fileDetailVO = new FileDetailVO();

//            fileDetailVO.setFileNo(seq++);
            fileDetailVO.setFileGroupNo(fileGroupNo);
            fileDetailVO.setFileNm(multipartFile.getOriginalFilename());
            fileDetailVO.setFileStreNm(uploadFileName);
            fileDetailVO.setFileStreplace(fileUrl);
            fileDetailVO.setFileMg(multipartFile.getSize());
            fileDetailVO.setFileExtsn(
                    multipartFile.getOriginalFilename().substring(
                            multipartFile.getOriginalFilename().lastIndexOf(".") + 1
                    ));
            fileDetailVO.setFileTy(multipartFile.getContentType());
            fileDetailVO.setFileStreDe(null);
            fileDetailVO.setFileDwldCo(0);

            result += uploadMapper.insertFileDetail(fileDetailVO);
        }


        log.debug("chkng fileUpload (fileUrl > {} ) \n (fileGroupVO > {}) \n(result > {}) \n(uploadPath > {}) \n(fileDetailVO > {}) \n (fileGroupNo > {})", fileUrl, fileGroupVO, result, uploadPath, fileDetailVO, fileGroupNo);
        return fileGroupNo;
    }
    
    //파일그룹넘버가 있을때
    @Transactional
	public long fileUpload(Long fileGroupNo, int seq, MultipartFile[] multipartFiles) {

        String fileUrl = "";
//        int seq = 1;
        int result = 0;

        File uploadPath = null;
        FileDetailVO fileDetailVO = null;
        for (MultipartFile multipartFile : multipartFiles) {

            uploadPath = new File(this.beanController.getUploadFolder()
                    , this.beanController.getFolder());

            if (uploadPath.exists() == false) {
                uploadPath.mkdirs();
            }

            String uploadFileName = multipartFile.getOriginalFilename();

            UUID uuid = UUID.randomUUID();

            uploadFileName = uuid.toString() + "_" + uploadFileName;

            File saveFile = new File(uploadPath, uploadFileName);

            try {
                multipartFile.transferTo(saveFile);
            } catch (IllegalStateException | IOException e) {
                e.printStackTrace();
            }

            fileUrl =
                    "/" + this.beanController.getFolder().replace("\\", "/")
                            + "/" + uploadFileName;

            fileDetailVO = new FileDetailVO();

            fileDetailVO.setFileNo(seq++); 
            fileDetailVO.setFileGroupNo(fileGroupNo);
            fileDetailVO.setFileNm(multipartFile.getOriginalFilename());
            fileDetailVO.setFileStreNm(uploadFileName);
            fileDetailVO.setFileStreplace(fileUrl);
            fileDetailVO.setFileMg(multipartFile.getSize());
            fileDetailVO.setFileExtsn(
                    multipartFile.getOriginalFilename().substring(
                            multipartFile.getOriginalFilename().lastIndexOf(".") + 1
                    ));
            fileDetailVO.setFileTy(multipartFile.getContentType());
            fileDetailVO.setFileStreDe(null);
            fileDetailVO.setFileDwldCo(0);

            result += uploadMapper.insertFileDetail(fileDetailVO);
        }

        
        return fileGroupNo;
    }
    
    
    
    
    
    
    
    
    //서비스에서 이 컨트롤러 이 메서드를 실행하면 fileList를 가져올 수 있당!
    @Transactional
	public List<FileDetailVO> getFileDetailList(Long fileGroupNo) {
		return this.uploadMapper.getFileDetailList(fileGroupNo);
	}
	}
	
	
	

