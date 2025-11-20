package kr.ac.collage_api.account.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.ac.collage_api.account.dto.ProfSelectEditDetailDTO;
import kr.ac.collage_api.vo.ProfsrDgriVO;
import kr.ac.collage_api.vo.SklstfVO;
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

	public int insertProfAccount(Map<String, String> map);

	public int insertProfAccountBulk(MultipartFile uploadFile);

	public List<SklstfVO> selectProfInfo(String keyword);

	public ProfSelectEditDetailDTO selecteditdetail(String profsrNo);

	public List<SklstfVO> selectProfsrList();

	public int updateProfAccount(Map<String, String> map);

	public int deleteProfAccount(String profsrNo);

	public int deleteProfAccountList(List<String> idList);

	public List<ProfsrDgriVO> selectProfsrDgriList();

	public SklstfVO selectProfDgriInfo(String sklstfId);

	public int insertProfsrDgri(ProfsrDgriVO profsrDgriVO);

	public ProfsrDgriVO selectProfDgriInfoForUpdate(ProfsrDgriVO profsrDgriVO);

	public int updateProfDgri(ProfsrDgriVO profsrDgriVO);

	public int deleteProfDgri(String dgriNo);

	public int deleteProfsrDgriList(List<String> digriVOList);

	public int insertProfDgriBulk(MultipartFile uploadFile);


}
