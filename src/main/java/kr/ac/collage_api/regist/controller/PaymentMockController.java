package kr.ac.collage_api.regist.controller;//package kr.ac.collage_api.regist.controller;
//
//import java.util.Map;
//
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//import kr.ac.collage_api.regist.service.PayInfoService;
//import kr.ac.collage_api.vo.PayInfoVO;
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//
//@RestController
//@RequestMapping("/payment/mock")
//@RequiredArgsConstructor
//@Slf4j
//public class PaymentMockController {
//
//    private final PayInfoService payInfoService;
//
//    private String generateAccount(String bank,int r){
//        return switch(bank){
//            case "001"->"301-"+r+"-"+(r/3);
//            case "004"->"110-"+(r/2)+"-"+r;
//            default->"999-"+r+"-"+(r*7);
//        };
//    }
//
//    // 가상계좌 발급
//    @PostMapping("/account")
//    public Map<String,Object> issue(@RequestBody Map<String,Object> req){
//
//        String stdntNo=req.get("stdntNo").toString();
//        int registCtNo=Integer.parseInt(req.get("registCtNo").toString());
//        String bank=req.getOrDefault("bank","001").toString();
//
//        PayInfoVO exist=payInfoService.selectPayInfo(stdntNo,registCtNo);
//
//        if(exist!=null && exist.getVrtlAcntno()!=null){
//            return Map.of("accountNo",exist.getVrtlAcntno(),"amount",exist.getPayGld());
//        }
//
//        int r=Math.abs((stdntNo+registCtNo).hashCode());
//        String acc=generateAccount(bank,r);
//
//        payInfoService.updateVirtualAccount(stdntNo,registCtNo,acc);
//        return Map.of("accountNo",acc,"amount",payInfoService.selectPayAmount(stdntNo,registCtNo));
//    }
//
//    // 카드결제 → 자동 완납
//    @PostMapping("/card")
//    public ResponseEntity<?> card(@RequestBody Map<String,Object> b){
//        payInfoService.updatePayStatus(
//                Integer.parseInt(b.get("registCtNo").toString()),
//                b.get("stdntNo").toString(),
//                "CARD"
//        );
//        return ResponseEntity.ok("카드결제 완료");
//    }
//
//    // 발급 + 즉시완납 패키지
//    @PostMapping("/accountAndPay")
//    public Map<String,Object> doBoth(@RequestBody Map<String,Object> r){
//
//        String stdntNo=r.get("stdntNo").toString();
//        int registCtNo=Integer.parseInt(r.get("registCtNo").toString());
//
//        payInfoService.issueAccountAndConfirm(stdntNo,registCtNo,"TRANSFER");
//        PayInfoVO p=payInfoService.selectPayInfo(stdntNo,registCtNo);
//
//        return Map.of("accountNo",p.getVrtlAcntno(),"amount",p.getPayGld(),"status",p.getPaySttus());
//    }
//}
