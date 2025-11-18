package kr.ac.collage_api.admin.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.admin.mapper.BbsNoticeMapper;
import kr.ac.collage_api.admin.service.BbsNoticeService;
import kr.ac.collage_api.common.attach.service.UploadController;
import kr.ac.collage_api.vo.BbsVO;
import kr.ac.collage_api.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BbsNoticeServiceImpl implements BbsNoticeService {
	
	@Autowired
	BbsNoticeMapper bbsNoticeMapper;

	@Autowired
	UploadController uploadController;

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.bbsNoticeMapper.getTotal(map);
	}

	@Override
	public List<BbsVO> list(Map<String, Object> map) {
		return this.bbsNoticeMapper.list(map);
	}

	@Override
	public BbsVO detail(int bbscttNo) {
		return this.bbsNoticeMapper.detail(bbscttNo);
	}

	@Override
	public int delete(int bbscttNo) {
		return this.bbsNoticeMapper.delete(bbscttNo);
	}

	@Override
	public List<BbsVO> adminList() {
		return this.bbsNoticeMapper.adminList();
	}

	@Override
	public int adminPutDetail(BbsVO bbsVO) {
		return this.bbsNoticeMapper.adminPutDetail(bbsVO);
	}

	@Override
	public int adminDeleteDetail(int bbscttNo) {
		return this.bbsNoticeMapper.adminDeleteDetail(bbscttNo);
	}

	@Transactional
	@Override
	public int adminPostDetail(BbsVO bbsVO) {
		if(bbsVO.getAttachmentFiles() !=null &&  bbsVO.getAttachmentFiles().length>0) {
			Long fileGroupNo = uploadController.fileUpload(bbsVO.getAttachmentFiles());
			log.info("adminPostDetail() -> fileGroupNo : {}", fileGroupNo);
			bbsVO.setFileGroupNo(fileGroupNo);
		}

		return this.bbsNoticeMapper.adminPostDetail(bbsVO);
	}

	@Override
	public BbsVO adminDetail(int bbscttNo) {

		return this.bbsNoticeMapper.adminDetail(bbscttNo);
	}

	@Transactional
	@Override
	public List<FileDetailVO> getFileDetailList(Long fileGroupNo) {
		return this.uploadController.getFileDetailList(fileGroupNo);
	}


	@Transactional
	@Override
	public int adminPutDetail(BbsVO bbsVO, List<MultipartFile> files, List<Integer> deletedFileSns) {

		Long fileGroupNo = bbsVO.getFileGroupNo();

	    if (deletedFileSns != null && !deletedFileSns.isEmpty()) {
	    	int deleteResult = this.bbsNoticeMapper.deleteFileDetail(deletedFileSns,fileGroupNo);
	    	log.info("putdetail() -> deleteResult : {}", deleteResult);
	    }

	    if(files!=null && !files.isEmpty()) {

		    MultipartFile[] fileArray = files.toArray(new MultipartFile[0]);

		    if (fileGroupNo !=null) {
		    	int seq = this.bbsNoticeMapper.selectFileDetailMaxSeq(fileGroupNo);

		    	this.uploadController.fileUpload(fileGroupNo, seq, fileArray);
		    } else {
		    	fileGroupNo = uploadController.fileUpload(fileArray);
		        bbsVO.setFileGroupNo(fileGroupNo);
		    }
	    }


		return this.bbsNoticeMapper.adminPutDetail(bbsVO);
	}



}

