package kr.ac.collage_api.account.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.vo.StdntVO;
import kr.ac.collage_api.vo.SubjctVO;
import kr.ac.collage_api.vo.UnivVO;

public interface AccountService {

	public List<UnivVO> selectUnivCNinfo();

	public List<SubjctVO> selectSubjctCNinfo(String univCode);

	public int insertStdAccount(StdntVO stdntVO);

	public int insertStdAccountBulk(MultipartFile uploadFile);

	public List<StdntVO> selectStdntInfo(String keyword);

	public StdntVO selectOneStdntInfo(String stdntNo);

	public int updateStdAccount(StdntVO stdntVO);

}
