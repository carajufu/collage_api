package kr.ac.collage_api.admin.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.ac.collage_api.admin.dto.SubjctUpdateRequestDto;
import kr.ac.collage_api.admin.dto.UnivUpdateRequestDto;
import kr.ac.collage_api.admin.service.UnivService;
import kr.ac.collage_api.vo.ProfsrVO;
import kr.ac.collage_api.vo.SubjctVO;
import kr.ac.collage_api.vo.UnivVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/admin/univ")
public class UnivController {
	
	@Autowired
	private UnivService univService;
	
	//트리목록
	@GetMapping("/tree")
	public List<UnivVO> getUnivTree(){
		return univService.getUnivTreeList();
	}
	
	//교수목록 포함 트리
	/*
	 * @GetMapping("/prof/list") public ResponseEntity<List<ProfsrVO>>
	 * getProfsrList(
	 * 
	 * @RequestParam String rank,
	 * 
	 * @RequestParam String code){ List<ProfsrVO> profsr =
	 * univService.findProfsrList(rank,code); return ResponseEntity.ok(profsr); }
	 */
	
	// 단과대 학장 후보(정교수 이상) 조회
    @GetMapping("/dean-candidates")
    public ResponseEntity<List<ProfsrVO>> getDeanCandidates(@RequestParam String univCode) {
        List<ProfsrVO> candidates = univService.findDeanCandidates(univCode);
        return ResponseEntity.ok(candidates);
    }

    // 학과 학과장 후보(부교수 이상) 조회
    @GetMapping("/depthead-candidates")
    public ResponseEntity<List<ProfsrVO>> getDeptHeadCandidates(@RequestParam String subjctCode) {
        List<ProfsrVO> candidates = univService.findDeptHeadCandidates(subjctCode);
        return ResponseEntity.ok(candidates);
    }

    //단과대 정보 업데이트
    @PutMapping("/update/{univCode}")
    public ResponseEntity<UnivUpdateRequestDto> updateUniversity(
            @PathVariable String univCode,
            @RequestBody UnivUpdateRequestDto univDto) {

        univDto.setUnivCode(univCode);

        UnivUpdateRequestDto updatedUniv = univService.updateUniv(univDto);

        return ResponseEntity.ok(updatedUniv);
    }

    // 학과 정보 업데이트
    @PutMapping("/update/subjcts/{subjctCode}")
    public ResponseEntity<SubjctUpdateRequestDto> updateSubjct(
            @PathVariable String subjctCode,
            @RequestBody SubjctUpdateRequestDto subjctDto) {

        subjctDto.setSubjctCode(subjctCode);

        SubjctUpdateRequestDto updatedSubjct = univService.updateSubjct(subjctDto);

        return ResponseEntity.ok(updatedSubjct);
    }

    //학과 추가
    @PostMapping("/create/subjcts")
    public ResponseEntity<?> createSubject(@RequestBody SubjctUpdateRequestDto dto) {


        if (dto.getUnivCode() == null || dto.getUnivCode().isEmpty()) {
             return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(Map.of("message", "부모 단과대학 코드가 없습니다."));
        }
        if (dto.getSubjctCode() == null || dto.getSubjctCode().isEmpty()) {
            return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(Map.of("message", "학과 코드와 학과명을 입력하세요."));
        }

        try {
            SubjctVO savedSubject = univService.createSubject(dto);

            //성공
            return new ResponseEntity<>(savedSubject, HttpStatus.CREATED);

        } catch (DataIntegrityViolationException e) {
            //실패
            return ResponseEntity
                .status(HttpStatus.CONFLICT)
                .body(Map.of("message", "이미 존재하는 학과 코드입니다."));

        } catch (IllegalArgumentException e) {
            return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(Map.of("message", e.getMessage()));

        } catch (Exception e) {
            return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("message", "학과 추가 중 서버 오류가 발생했습니다."));
        }

    }

    //단과대 삭제
    @DeleteMapping("/delete/{univCode}")
    public ResponseEntity<?> deleteUniversity(@PathVariable String univCode) {
        try {
            univService.deleteUniv(univCode);
            //성공
            return ResponseEntity.noContent().build();

        } catch (Exception e) {
            return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("message", e.getMessage()));
        }
    }

    //학과 삭제
    @DeleteMapping("/delete/subjcts/{subjctCode}")
    public ResponseEntity<?> deleteSubject(@PathVariable String subjctCode) {
        try {
            univService.deleteSubjct(subjctCode);
            return ResponseEntity.noContent().build();

        } catch (Exception e) {
            return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("message", e.getMessage()));
        }
    }
}
