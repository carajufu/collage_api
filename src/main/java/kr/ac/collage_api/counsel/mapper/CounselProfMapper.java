package kr.ac.collage_api.counsel.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.CnsltVO;

@Mapper
public interface CounselProfMapper {

	//계정아이디로 교수번호 가져오기
	public String getProfsrNo(String acntId);

	//총개수(키워드 있을때는 키워드에 해당되는 글의 총 개수
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

	//알림 보낼 학생 번호가져오기
	public String selectCnsltStdntNo(int cnsltInnb);


}
