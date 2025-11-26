package kr.ac.collage_api.regist.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.ac.collage_api.regist.vo.PayHistoryVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import jakarta.servlet.http.HttpServletResponse;
import kr.ac.collage_api.regist.service.PayInfoService;
import kr.ac.collage_api.vo.PayInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/payinfo")
public class PayInfoController {

	@Autowired
	private PayInfoService payInfoService;

	private String convertPayMethod(String payMthd) {
		switch (payMthd) {
		case "CARD":
			return "카드결제";
		case "VA":
			return "무통장 / 가상계좌 입금";
		default:
			return "기타";
		}
	}

	/* 학생별 납부내역 조회 */
	@GetMapping("/studentView/{stdntNo}")
	public String studentView(@PathVariable String stdntNo, Model model) {
        Map<String, Object> resp = payInfoService.selectPayInfoList(stdntNo);

        List<PayInfoVO> payList = (List<PayInfoVO>) resp.get("payInfo");
		model.addAttribute("payList", payList);
        model.addAttribute("year", resp.get("year").toString());
        model.addAttribute("semstr", resp.get("semstr").toString());

        return "regist/student_pay_dashboard";
	}

    @GetMapping("/stdnt/list")
    public String getList() {
        return "regist/register";
    }

    @GetMapping("/stdnt/history")
    public String getHistory(@RequestParam Map<String, Object> paramMap,
                                Principal principal,
                                Model model) {
        List<PayHistoryVO> payHistoryVOList = payInfoService.getHistory(paramMap, principal.getName());
        model.addAttribute("registerList", payHistoryVOList);
        return "regist/register";
    }

	/* 영수증 다운로드: 완납만 허용 */
	@GetMapping("/receipt/{stdntNo}")
	public void downloadReceipt(@PathVariable String stdntNo, HttpServletResponse response)
			throws IOException, DocumentException {

		List<PayInfoVO> list = payInfoService.selectPayInfoListByStudent(stdntNo);
		if (list.isEmpty()) {
			response.setStatus(404);
			return;
		}

		PayInfoVO pay = list.get(0); // 최신건 가정
		if (!"완납".equals(pay.getPaySttus())) { // 미납이면 403
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "미납 상태에서는 영수증을 발급할 수 없습니다.");
			return;
		}

		String displayPayMthd = switch (pay.getPayMthd()) {
		case "CARD" -> "카드결제";
		case "TRANSFER" -> "계좌이체";
		case "VA" -> "가상계좌";
		default -> "기타";
		};

		response.setContentType("application/pdf");
		response.setHeader("Content-Disposition", "attachment; filename=tuition_receipt_" + stdntNo + ".pdf");

		Document document = new Document(PageSize.A4, 50, 50, 60, 50);
		PdfWriter.getInstance(document, response.getOutputStream());
		document.open();

		String fontPath = "C:/Windows/Fonts/H2GTRE.TTF";
		BaseFont baseFont = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
		Font fontTitle = new Font(baseFont, 18, Font.BOLD);
		Font fontLabel = new Font(baseFont, 11, Font.BOLD);
		Font fontNormal = new Font(baseFont, 11);

		Paragraph title = new Paragraph("대덕인재대학교 등록금 납부 증명서", fontTitle);
		title.setAlignment(Element.ALIGN_CENTER);
		title.setSpacingAfter(20);
		document.add(title);

		PdfPTable info = new PdfPTable(2);
		info.setWidthPercentage(80);
		info.setSpacingBefore(10f);
		info.getDefaultCell().setBorder(com.itextpdf.text.Rectangle.NO_BORDER);

		info.addCell(new Phrase("학과", fontLabel));
		info.addCell(new Phrase(pay.getRqestUniv(), fontNormal));
		info.addCell(new Phrase("학번", fontLabel));
		info.addCell(new Phrase(pay.getStdntNo(), fontNormal));
		info.addCell(new Phrase("성명", fontLabel));
		info.addCell(new Phrase(pay.getStdntNm(), fontNormal));
		info.addCell(new Phrase("학기", fontLabel));
		info.addCell(new Phrase(pay.getRqestYear() + "년 " + pay.getRqestSemstr(), fontNormal));
		info.addCell(new Phrase("납부금액", fontLabel));
		info.addCell(new Phrase(String.format("%,d 원", pay.getPayGld()), fontNormal));
		info.addCell(new Phrase("납부방식", fontLabel));
		info.addCell(new Phrase(convertPayMethod(pay.getPayMthd()), fontNormal));
		info.addCell(new Phrase("납부일자", fontLabel));
		info.addCell(new Phrase(pay.getPayDe(), fontNormal));
		document.add(info);

		document.close();
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
