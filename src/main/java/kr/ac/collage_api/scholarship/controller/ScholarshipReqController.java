package kr.ac.collage_api.scholarship.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.ac.collage_api.scholarship.service.ScholarshipReqService;
import kr.ac.collage_api.vo.ScholarshipReqVO;

@RestController
@RequestMapping("/scholarship")
public class ScholarshipReqController {

	@Autowired
	private ScholarshipReqService service;

	// 신규 등록
	@PostMapping("/insert")
	public ResponseEntity<?> insert(@RequestBody ScholarshipReqVO vo) {
		service.insertScholarship(vo);
		return ResponseEntity.ok("ok");
	}

	@GetMapping("/list")
	public Map<String, Object> list(@RequestParam(required = false) String stdntNo,
			@RequestParam(required = false) String status, @RequestParam(required = false) String schlType,
			@RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "10") int size) {
		int offset = (page - 1) * size;

		Map<String, Object> param = new HashMap<>();
		param.put("stdntNo", stdntNo);
		param.put("status", status);
		param.put("schlType", schlType);
		param.put("offset", offset);
		param.put("size", size);

		List<ScholarshipReqVO> list = service.selectScholarshipList(param);
		int totalCount = service.selectScholarshipTotal(param);

		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		result.put("totalCount", totalCount);

		return result;
	}

	// 상태 변경 (승인 / 반려 등)
	@PostMapping("/update-status")
	public ResponseEntity<?> updateStatus(@RequestBody Map<String, Object> map) {
		service.updateStatus(map);
		return ResponseEntity.ok("ok");
	}

	// 지급 처리 (계좌 입금 + STATUS = '지급완료')
	@PostMapping("/pay")
	public ResponseEntity<?> pay(@RequestBody Map<String, Object> map) {

		// ① 요청으로부터 장학금 신청 번호 받기
		Integer schlReqNo = (Integer) map.get("schlReqNo");

		// ② 해당 신청 정보 조회
		ScholarshipReqVO info = service.selectOne(schlReqNo);

		if (info == null) {
			return ResponseEntity.badRequest().body("NOT_FOUND");
		}

		// 계좌 정보가 비어 있으면, 요청에서 기본 계좌 받아서 세팅
		if (info.getPayBank() == null) {
			info.setPayBank((String) map.getOrDefault("payBank", "국민은행"));
		}
		if (info.getPayAcnt() == null) {
			info.setPayAcnt((String) map.getOrDefault("payAcnt", "000-0000-00000"));
		}

		// ③ DB 업데이트 (PAY_BANK, PAY_ACNT, PAY_DE, STATUS='지급완료')
		Map<String, Object> payMap = new HashMap<>();
		payMap.put("schlReqNo", info.getSchlReqNo());
		payMap.put("payBank", info.getPayBank());
		payMap.put("payAcnt", info.getPayAcnt());

		service.updatePayInfo(payMap);

		// ④ (선택) 외부 은행 API 모의 호출 부분
		// 실제론 여기서 외부 API 연동 로직 들어감
		System.out.println("💸 Mock Bank Transfer => " + info.getPayBank() + " / " + info.getPayAcnt() + " / amount="
				+ info.getSchlAmount());

		return ResponseEntity.ok("ok");
	}

	// 장학금 상세 1건 조회 (수정 모달용)
	@GetMapping("/detail/{schlReqNo}")
	public ScholarshipReqVO detail(@PathVariable int schlReqNo) {
		return service.selectOne(schlReqNo);
	}

	// 신청 정보 수정 (종류/금액/메모)
	@PostMapping("/update")
	public ResponseEntity<?> update(@RequestBody ScholarshipReqVO vo) {
		service.updateScholarship(vo);
		return ResponseEntity.ok("ok");
	}

	// 신청 삭제 (DELETE)
	@PostMapping("/delete")
	public ResponseEntity<?> delete(@RequestBody Map<String, Object> map) {
		service.deleteScholarship((int) map.get("schlReqNo"));
		return ResponseEntity.ok("ok");
	}

	// 대시보드 통계 (React에서 차트용으로 사용)
	@GetMapping("/stats")
	public Map<String, Object> stats() {
		Map<String, Object> result = new HashMap<>();
		result.put("typeStats", service.getTypeStats()); // 장학금 종류별
		result.put("statusStats", service.getStatusStats()); // 상태별
		result.put("monthlyPayStats", service.getMonthlyPayStats()); // 최근 6개월 지급액
		return result;
	}
}
