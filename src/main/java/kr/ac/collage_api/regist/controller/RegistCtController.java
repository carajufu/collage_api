package kr.ac.collage_api.regist.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import kr.ac.collage_api.regist.service.RegistCtService;
import kr.ac.collage_api.vo.RegistCtVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/regist")
@CrossOrigin(origins = "http://localhost:*")
public class RegistCtController {

	@Autowired
	private RegistCtService registCtService;

	// 등록금 고지 등록 (학과·학년 단위)
	@PostMapping("/insert")
	public ResponseEntity<String> insertRegist(@RequestBody RegistCtVO registCtVO) {
		log.info("확인: {}", registCtVO);

		int result = registCtService.insertRegist(registCtVO);
		if (result == 0) {
			return ResponseEntity.badRequest().body("⚠️ 이미 동일한 학과/학년/학기의 등록금 고지가 존재합니다.");
		}

		return ResponseEntity.ok("✅ 등록금 고지가 정상적으로 등록되었습니다.");
	}

	// 등록금 고지 목록 조회 (관리자용)
	@GetMapping("/list")
	public ResponseEntity<List<RegistCtVO>> selectRegistList() {
		List<RegistCtVO> list = registCtService.selectRegistList();
		return ResponseEntity.ok(list);
	}

	// 등록금 중복 확인
	@PostMapping("/check-duplicate")
	public ResponseEntity<Boolean> checkDuplicate(@RequestBody RegistCtVO registCtVO) {
		int count = registCtService.checkDuplicateRegist(registCtVO);
		return ResponseEntity.ok(count > 0);
	}

	// 등록금 자동 생성
	@PostMapping("/autoGenerate")
	public ResponseEntity<String> autoGenerate(@RequestParam String rqestYear, @RequestParam String rqestSemstr) {

		int count = registCtService.autoGenerate(rqestYear, rqestSemstr);
		String message = count + "건의 등록금 고지가 자동 생성되었습니다.";
		return ResponseEntity.ok(message);
	}

	// 테스트용임! 지워도 됨!
	@GetMapping("/ping")
	public String ping() {
		return "등록금 API 정상 동작 중 ✅";
	}

	// 단과대 목록
	@GetMapping("/univ-list")
	@ResponseBody
	public List<Map<String, Object>> selectUnivList() {
		return registCtService.selectUnivList();
	}

	// 단과대별 학과 목록
	@GetMapping("/subjects/{univCode}")
	public List<Map<String, Object>> selectSubjectsByUniv(@PathVariable String univCode) {
		return registCtService.selectSubjectsByUniv(univCode);
	}

	// 등록금 미고지 단과대/학과 조회
	@GetMapping("/unissued")
	public List<Map<String, Object>> selectUnissued(@RequestParam(required = false) String rqestUniv,
			@RequestParam(required = false) String subjctCode, @RequestParam(required = false) String rqestGrade,
                                                    @RequestParam(required = false) String rqestYear,
                                                    @RequestParam(required = false) String rqestSemstr) {
		Map<String, Object> params = new HashMap<>();
		params.put("rqestUniv", rqestUniv);
		params.put("subjctCode", subjctCode);
		params.put("rqestGrade", rqestGrade);
        params.put("rqestYear", rqestYear);
        params.put("rqestSemstr", rqestSemstr);
		return registCtService.selectUnissuedSubjects(params);
	}

	@PutMapping("/update")
	public ResponseEntity<?> updateRegist(@RequestBody RegistCtVO vo) {

		registCtService.updateRegistCt(vo);

		return ResponseEntity.ok().body("등록금 수정 완료");
	}

	@DeleteMapping("/delete/{registCtNo}")
	public ResponseEntity<?> deleteRegist(@PathVariable int registCtNo) {
		registCtService.deleteRegistCt(registCtNo);
		return ResponseEntity.ok().build();
	}

}