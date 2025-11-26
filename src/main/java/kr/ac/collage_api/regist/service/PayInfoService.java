package kr.ac.collage_api.regist.service;

import java.util.List;
import java.util.Map;

import kr.ac.collage_api.regist.vo.PayHistoryVO;
import kr.ac.collage_api.vo.PayInfoVO;

public interface PayInfoService {

	int insertPayInfo(PayInfoVO payInfoVO);

    List<PayInfoVO> selectPayInfoListByStudent(String stdntNo);

    Map<String, Object> selectPayInfoList(String stdntNo);

	void updatePayStatus(int registCtNo, String stdntNo, String payMthd);

	PayInfoVO selectPayInfo(String stdntNo, int registCtNo);

	int updateVirtualAccount(String stdntNo, int registCtNo, String accountNo);

	int selectPayAmount(String stdntNo, int registCtNo);

	int existsPayInfo(String stdntNo, int registCtNo);

	/* 가상계좌 발급 + 계좌이체로 즉시 완납 처리 */
	void issueAccountAndConfirm(String stdntNo, int registCtNo, String bank);

	// 관리자용 납부내역 조회
	List<PayInfoVO> selectAdminPayList(Map<String, Object> params);

    List<PayHistoryVO> getHistory(Map<String, Object> paramMap, String name);
}
