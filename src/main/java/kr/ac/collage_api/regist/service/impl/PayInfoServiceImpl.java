package kr.ac.collage_api.regist.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpHeaders;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import kr.ac.collage_api.common.util.CurrentSemstr;
import kr.ac.collage_api.regist.mapper.PayInfoMapper;
import kr.ac.collage_api.regist.service.PayInfoService;
import kr.ac.collage_api.regist.vo.PayHistoryVO;
import kr.ac.collage_api.vo.PayInfoVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class PayInfoServiceImpl implements PayInfoService {

    private final PayInfoMapper payInfoMapper;
    private final CurrentSemstr currentSemstr;

    @Value("${kakao.admin-key}") private String adminKey;
    @Value("${kakao.cid}")       private String cid;
    @Value("${kakao.ready-url}") private String readyUrl;
    @Value("${kakao.approve-url}") private String approveUrl;
    @Value("${kakao.redirect.success}") private String successUrl;
    @Value("${kakao.redirect.cancel}")  private String cancelUrl;
    @Value("${kakao.redirect.fail}")    private String failUrl;

    private final Map<String,String> tidStore = new HashMap<>();

    /* 결제 준비 */
    @Override
    public String kakaoPayReady(String stdntNo, int registCtNo, int amount) {

        RestTemplate rt = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();

        headers.add("Authorization", "KakaoAK " + adminKey);
        headers.add("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");

        MultiValueMap<String,String> params = new LinkedMultiValueMap<>();
        params.add("cid", cid);
        params.add("partner_order_id", "PAY-"+registCtNo);
        params.add("partner_user_id", stdntNo);
        params.add("item_name", "등록금");
        params.add("quantity", "1");
        params.add("total_amount", String.valueOf(amount));
        params.add("tax_free_amount", "0");

        params.add("approval_url", successUrl + "?std="+stdntNo+"&ct="+registCtNo);
        params.add("cancel_url", cancelUrl  + "?std="+stdntNo);
        params.add("fail_url",   failUrl    + "?std="+stdntNo);

        Map res = rt.postForObject(readyUrl,new HttpEntity<>(params,headers),Map.class);

        String tid = (String)res.get("tid");
        String redirectUrl = (String)res.get("next_redirect_pc_url");

        tidStore.put(stdntNo+"-"+registCtNo, tid);

        log.info("결제 준비 → TID={}, URL={}",tid,redirectUrl);

        return redirectUrl;
    }


    /* 결제 승인 */
    @Override
    @Transactional
    public void kakaoPayApprove(String pgToken, String stdntNo, int registCtNo) {

        Map<String, Object> param = new HashMap<>();
        param.put("stdntNo", stdntNo);
        param.put("registCtNo", registCtNo);
        param.put("payMthd", "KAKAO");         
        param.put("schlship", null);            
        param.put("vrtlAcntno", null);

        payInfoMapper.updatePayStatus(param);
    }

    /* DB 조회 */
    @Override
    public Map<String,Object> selectPayInfoList(String stdntNo){
        Map<String,Object> r=new HashMap<>();
        r.put("payInfo",payInfoMapper.selectPayInfoList(stdntNo));
        r.put("year",currentSemstr.getYear());
        r.put("semstr",currentSemstr.getCurrentPeriod());
        return r;
    }

    @Override
    public List<PayHistoryVO> getHistory(Map<String,Object> p,String stdntNo){
        p.put("stdntNo",stdntNo);
        return payInfoMapper.getHistory(p);
    }

    @Override
    @Transactional
    public void updatePayStatus(int registCtNo, String stdntNo, String payMthd) {
        Map<String, Object> param = new HashMap<>();
        param.put("registCtNo", registCtNo);
        param.put("stdntNo", stdntNo);
        param.put("payMthd", payMthd);

        int updated = payInfoMapper.updatePayStatus(param);
        log.info("결제 상태 업데이트: stdntNo={}, registCtNo={}, payMthd={}, rows={}",
                stdntNo, registCtNo, payMthd, updated);
    }

    @Override
    public PayInfoVO getPayInfoOne(String stdntNo){
        return payInfoMapper.getPayInfoOne(stdntNo);
    }

    @Override
    public List<PayInfoVO> selectAdminPayList(Map<String, Object> params) {

        log.info("📄 관리자 납부내역 조회 요청 필터: {}", params);

        return payInfoMapper.selectAdminPayList(params);
    }

}
