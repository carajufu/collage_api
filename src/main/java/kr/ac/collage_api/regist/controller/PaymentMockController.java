package kr.ac.collage_api.regist.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.ac.collage_api.regist.service.PayInfoService;
import kr.ac.collage_api.vo.PayInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/payment/mock")
public class PaymentMockController {

	@Autowired
	private PayInfoService payInfoService;

	// 은행별 "형식 유사" 계좌번호 생성 
	private String makeAccount(String bank, String stdntNo, int registCtNo) {
		Random r = new Random((stdntNo + "-" + registCtNo).hashCode());
		java.util.function.IntFunction<String> nd = (len) -> {
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < len; i++)
				sb.append(r.nextInt(10));
			return sb.toString();
		};
		return switch (bank) {
		case "001" -> "301-" + nd.apply(8) + "-" + nd.apply(2); // NH농협
		case "004" -> nd.apply(6) + "-" + nd.apply(2) + "-" + nd.apply(6); // KB국민
		case "088" -> "110-" + nd.apply(6) + "-" + nd.apply(4); // 신한
		default -> "999-" + nd.apply(8) + "-" + nd.apply(2);
		};
	}

	// 가상계좌 발급
	@PostMapping("/account")
	public Map<String, Object> issueVirtualAccount(@RequestBody Map<String, Object> req) {
		String stdntNo = req.get("stdntNo").toString();
		int registCtNo = Integer.parseInt(req.get("registCtNo").toString());
		String bank = req.getOrDefault("bank", "001").toString();

		PayInfoVO pay = payInfoService.selectPayInfo(stdntNo, registCtNo);
		if (pay != null && pay.getVrtlAcntno() != null && !pay.getVrtlAcntno().isEmpty()) {
			return Map.of("accountNo", pay.getVrtlAcntno(), "amount", pay.getPayGld());
		}

		String accountNo = makeAccount(bank, stdntNo, registCtNo);
		payInfoService.updateVirtualAccount(stdntNo, registCtNo, accountNo);

		int amount = payInfoService.selectPayAmount(stdntNo, registCtNo);
		Map<String, Object> res = new HashMap<>();
		res.put("accountNo", accountNo);
		res.put("amount", amount);
		return res;
	}

	// 카드 모의결제 → 완납(CARD)
	@PostMapping("card")
	public ResponseEntity<String> mockCard(@RequestBody Map<String, Object> body) {
		int registCtNo = Integer.parseInt(body.get("registCtNo").toString()); // ✅ 문자열을 int로 변환
		String stdntNo = body.get("stdntNo").toString();
		String payMthd = "CARD";

		payInfoService.updatePayStatus(registCtNo, stdntNo, payMthd);
		return ResponseEntity.ok("✅ 카드 결제 완료");
	}

	// 가상계좌 발급 + 즉시 완납(계좌이체로 표기) 한번에
	@PostMapping("/accountAndPay")
	public Map<String, Object> issueVAandPay(@RequestBody Map<String, Object> req) {
		String stdntNo = req.get("stdntNo").toString();
		int registCtNo = Integer.parseInt(req.get("registCtNo").toString());
		String bank = req.getOrDefault("bank", "001").toString();

		payInfoService.issueAccountAndConfirm(stdntNo, registCtNo, bank); // VRTL_ACNTNO 저장 + TRANSFER로 완료

		PayInfoVO pay = payInfoService.selectPayInfo(stdntNo, registCtNo);
		return Map.of("accountNo", pay.getVrtlAcntno(), "amount", pay.getPayGld());
	}
}
