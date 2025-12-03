package kr.ac.collage_api.security.service;

import kr.ac.collage_api.vo.AcntVO;

public interface DitAccountService {

	public AcntVO findById(String acntId);

	public int userSave(AcntVO acntVO);

	public int userSaveAuth(AcntVO acntVO);
	
	
	
}