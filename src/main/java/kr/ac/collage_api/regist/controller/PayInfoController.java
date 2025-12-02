package kr.ac.collage_api.regist.controller;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import kr.ac.collage_api.common.util.CurrentSemstr;
import kr.ac.collage_api.regist.service.PayInfoService;
import kr.ac.collage_api.regist.vo.PayHistoryVO;
import kr.ac.collage_api.vo.PayInfoVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/payinfo")
@RequiredArgsConstructor
public class PayInfoController {

    private final PayInfoService payInfoService;
    private final CurrentSemstr currentSemstr;


    /* ===================== 학생 등록금 대시보드 ===================== */
    @GetMapping("/studentView/{stdntNo}")
    public String studentView(@PathVariable String stdntNo, Model model) {

        Map<String, Object> resp = payInfoService.selectPayInfoList(stdntNo);

        model.addAttribute("payList", resp.get("payInfo"));
        model.addAttribute("year", resp.get("year"));
        model.addAttribute("semstr", resp.get("semstr"));

        return "regist/student_pay_dashboard";
    }


    /* ===================== 결제 시작 → 카카오 결제 URL 생성 ===================== */
    @PostMapping("/payment/start")
    @ResponseBody
    public Map<String, Object> paymentStart(@RequestBody Map<String, Object> req) {

        String method = String.valueOf(req.get("method"));
        String stdntNo = String.valueOf(req.get("stdntNo"));
        int registCtNo = Integer.parseInt(String.valueOf(req.get("registCtNo")));
        int amount = Integer.parseInt(String.valueOf(req.get("amount")));

        log.info("결제 시작 요청 → method={}, stdntNo={}, registCtNo={}, amount={}",
                method, stdntNo, registCtNo, amount);

        Map<String, Object> resp = new HashMap<>();

        if (method.equals("KAKAO")) {   // 팝업에서 Load할 url 반환
            resp.put("url", payInfoService.kakaoPayReady(stdntNo, registCtNo, amount));
        } else {
            resp.put("error", "UNSUPPORTED_METHOD");
        }
        return resp;
    }


    /* ===================== 카카오 결제 승인 콜백 ===================== */
    @GetMapping("/kakao/approve")
    @ResponseBody
    public String kakaoApprove(@RequestParam("pg_token") String pgToken,
                               @RequestParam("std") String stdntNo,
                               @RequestParam("ct") int registCtNo) {

        payInfoService.kakaoPayApprove(pgToken, stdntNo, registCtNo);

        return "<script>" +
                "alert('결제가 완료되었습니다.');" +
                "window.opener.location.href='/payinfo/studentView/" + stdntNo + "';" +
                "window.close();" +
                "</script>";
    }


    /* ===================== 취소 ===================== */
    @GetMapping("/kakao/cancel")
    public String kakaoCancel(@RequestParam("std") String stdntNo) {
        return "redirect:/payinfo/studentView/" + stdntNo;
    }

    /* ===================== 실패 ===================== */
    @GetMapping("/kakao/fail")
    public String kakaoFail(@RequestParam("std") String stdntNo) {
        return "redirect:/payinfo/studentView/" + stdntNo;
    }


    /* ===================== 납부 이력 ===================== */
    @GetMapping("/stdnt/history")
    public String history(@RequestParam Map<String, Object> param,
                          @RequestParam(required = false) String stdntNo,
                          Model model) {

        List<PayHistoryVO> list = payInfoService.getHistory(param, stdntNo);
        model.addAttribute("history", list);

        return "regist/student_pay_history";
    }
    
    @GetMapping("/receipt/{stdntNo}")
    public String showReceipt(@PathVariable String stdntNo, Model model){

        PayInfoVO data = payInfoService.getPayInfoOne(stdntNo);
        model.addAttribute("info", data);

        return "regist/receipt-popup";
    }

    @GetMapping("/admin/list")
    public ResponseEntity<List<PayInfoVO>> adminPayList(@RequestParam(required = false) String univCode,
                                                        @RequestParam(required = false) String subjctCode, @RequestParam(required = false) String grade,
                                                        @RequestParam(required = false) String paySttus) {

        Map<String, Object> params = new HashMap<>();
        params.put("univCode", univCode);
        params.put("subjctCode", subjctCode);
        params.put("grade", grade);
        params.put("paySttus", paySttus);

        List<PayInfoVO> list = payInfoService.selectAdminPayList(params);

        return ResponseEntity.ok(list);
    }
}
