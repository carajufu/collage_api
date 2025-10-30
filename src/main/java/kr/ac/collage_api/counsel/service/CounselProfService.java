package kr.ac.collage_api.counsel.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.vo.CnsltVO;

public interface CounselProfService {

	
	//계정아이디로 교수번호 가져오기
	public String getProfsrNo(String acntId);
		
	//키워드 고려해서 가져옴
	public int getTotal(Map<String, Object> map);

	//현재 페이지 목록만 가져오기
	public List<CnsltVO> list(Map<String, Object> map);

	//상담페이지 상단에 통계
	public List<CnsltVO> selectProfCnsltCount(String profsrNo);

	//1.예약 대기중 -> 2.예약 완료 patch
	public int patchAccept(CnsltVO cnsltVO);

	//상태 1, 2 => 3. 취소 patch
	public int patchCancl(CnsltVO cnsltVO);

	//상태 2 => 4. 완료 PATCH
	public int patchResult(CnsltVO cnsltVO);


}
