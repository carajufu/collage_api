package kr.ac.collage_api.account.service;

import kr.ac.collage_api.vo.AcntVO;

public interface UserAccountService {

	public AcntVO findById(String acntId);

	public int userSave(AcntVO acntVO);

	public int userSaveAuth(AcntVO acntVO);
	
	
	
}