package kr.ac.collage_api.regist.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.regist.vo.PayHistoryVO;
import kr.ac.collage_api.vo.PayInfoVO;

public interface PayInfoService {

	Map<String, Object> selectPayInfoList(String stdntNo);

	String kakaoPayReady(String stdntNo, int registCtNo, int amount);

	void kakaoPayApprove(String pgToken, String stdntNo, int registCtNo);

	List<PayHistoryVO> getHistory(Map<String, Object> param, String stdntNo);

	void updatePayStatus(int registCtNo, String stdntNo, String type);

	PayInfoVO getPayInfoOne(String stdntNo);
}
