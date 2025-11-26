package kr.ac.collage_api.regist.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.ac.collage_api.common.util.CurrentSemstr;
import kr.ac.collage_api.regist.vo.PayHistoryVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.regist.mapper.PayInfoMapper;
import kr.ac.collage_api.regist.service.PayInfoService;
import kr.ac.collage_api.vo.PayInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PayInfoServiceImpl implements PayInfoService {

	@Autowired
	private PayInfoMapper payInfoMapper;

    @Autowired
    CurrentSemstr currentSemstr;

	@Override
	public int insertPayInfo(PayInfoVO payInfoVO) {
		return payInfoMapper.insertPayInfo(payInfoVO);
	}

	@Override
	public List<PayInfoVO> selectPayInfoListByStudent(String stdntNo) {
        return payInfoMapper.selectPayInfoListByStudent(stdntNo);
	}

	@Override
	public Map<String, Object> selectPayInfoList(String stdntNo) {
        Map<String, Object> resp = new HashMap<>();

        resp.put("payInfo", payInfoMapper.selectPayInfoList(stdntNo));
        resp.put("year", currentSemstr.getYear());
        resp.put("semstr", currentSemstr.getCurrentPeriod());

		return resp;
	}

    @Override
    public List<PayHistoryVO> getHistory(Map<String, Object> paramMap, String name) {
        return payInfoMapper.getHistory(paramMap, name);
    }

    @Override
	@Transactional
	public void updatePayStatus(int registCtNo, String stdntNo, String payMthd) {
		Map<String, Object> param = new HashMap<>();
		param.put("registCtNo", registCtNo);
		param.put("stdntNo", stdntNo);
		param.put("payMthd", payMthd);
		payInfoMapper.updatePayStatus(param);
	}

	@Override
	public PayInfoVO selectPayInfo(String stdntNo, int registCtNo) {
		return payInfoMapper.selectPayInfo(stdntNo, registCtNo);
	}

	@Override
	public int updateVirtualAccount(String stdntNo, int registCtNo, String accountNo) {
		return payInfoMapper.updateVirtualAccount(stdntNo, registCtNo, accountNo);
	}

	@Override
	public int selectPayAmount(String stdntNo, int registCtNo) {
		return payInfoMapper.selectPayAmount(stdntNo, registCtNo);
	}

	@Override
	public int existsPayInfo(String stdntNo, int registCtNo) {
		return payInfoMapper.existsPayInfo(stdntNo, registCtNo);
	}

	@Override
	public void issueAccountAndConfirm(String stdntNo, int registCtNo, String bank) {
		Map<String, Object> param = new HashMap<>();
		param.put("registCtNo", registCtNo);
		param.put("stdntNo", stdntNo);
		param.put("payMthd", "TRANSFER");

		payInfoMapper.updatePayStatus(param);
		log.info("✅ 계좌이체 완료 처리: stdntNo={}, registCtNo={}", stdntNo, registCtNo);
	}
	
	@Override
    public List<PayInfoVO> selectAdminPayList(Map<String, Object> params) {

        log.info("📄 관리자 납부내역 조회 요청 필터: {}", params);

        return payInfoMapper.selectAdminPayList(params);
    }

}
