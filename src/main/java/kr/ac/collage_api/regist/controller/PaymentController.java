package kr.ac.collage_api.regist.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/regist")
public class PaymentController {
	// 등록금 납부 페이지 이동
	@GetMapping("/payment")
	public String payment(Model model) {
		log.info("payment() - 등록금 납부 페이지 요청");

		// 기본 학기 정보 전달
		model.addAttribute("semester", "2025년 2학기");
		model.addAttribute("dueDate", "2025-09-15");
		model.addAttribute("amount", 3230000);

		return "regist/payment";
	}
}
