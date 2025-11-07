package kr.ac.collage_api.lecture.controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.common.config.BeanController;
import kr.ac.collage_api.lecture.mapper.LectureMapper;
import kr.ac.collage_api.vo.FileDetailVO;
import kr.ac.collage_api.vo.FileGroupVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class PlanUploadController {

	@Autowired
	BeanController beanController;
	
	@Autowired
	LectureMapper lectureMapper;
	
	//다중파일업로드 사용 / 단일파일 업로드도 그룹 만들고 업로드 되게 함
	public long multiFileUpload(MultipartFile[] multipartFiles) {
		
		long fileGroupNo = 0L;
		
		String pictureUrl ="";
		int seq = 1;
		int result = 0;
		
		FileGroupVO fileGroupVO = new FileGroupVO();
		
		result += this.lectureMapper.insertFileGroup(fileGroupVO);
		log.info("multiFileUpload()->fileGroupNo : {}", fileGroupVO.getFileGroupNo());
		
		for(MultipartFile multipartFile : multipartFiles) {
			
			File uploadPath = new File(this.beanController.getUploadFolder()
									  , this.beanController.getFolder());
			
			if(uploadPath.exists()==false) {
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
			
			pictureUrl = 
					 "/" + this.beanController.getFolder().replace("\\","/")
					+"/" + uploadFileName;
			
			FileDetailVO fileDetailVO = new FileDetailVO();
			
			fileDetailVO.setFileNo(seq++);
			fileDetailVO.setFileGroupNo(fileGroupVO.getFileGroupNo());
			fileDetailVO.setFileNm(multipartFile.getOriginalFilename());
			fileDetailVO.setFileStreNm(uploadFileName);
			fileDetailVO.setFileStreplace(pictureUrl);
			fileDetailVO.setFileMg(multipartFile.getSize());
			fileDetailVO.setFileExtsn(
						multipartFile.getOriginalFilename().substring(
									multipartFile.getOriginalFilename().lastIndexOf(".")+1
								));
			fileDetailVO.setFileTy(multipartFile.getContentType());
			fileDetailVO.setFileStreDe(null);
			fileDetailVO.setFileDwldCo(0);

			result += this.lectureMapper.insertFileDetail(fileDetailVO);
			
			}
			
			
			return fileGroupVO.getFileGroupNo();
		}
		
	}
	
	
	

