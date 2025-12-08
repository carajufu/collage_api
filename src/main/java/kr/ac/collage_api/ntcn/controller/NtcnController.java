package kr.ac.collage_api.ntcn.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.ac.collage_api.ntcn.mapper.NtcnMapper;
import kr.ac.collage_api.vo.NtcnVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/ntcn")
@RestController
public class NtcnController {

	@Autowired
	NtcnMapper ntcnMapper;

	// 읽지 않은 알림 리스트만 가져오기
	@GetMapping("/unread")
	public List<NtcnVO> selectUnreadNtcnList(Principal principal) {
		String acntId = principal.getName();
		return this.ntcnMapper.selectUnreadNtcnList(acntId);
	}

	//읽은 파일 상태값 변경
	@PostMapping("/read")
	public int updateNtcnCnfirmAt(@RequestBody NtcnVO ntcnVO) {
		int ntcnNo = ntcnVO.getNtcnNo();
		return this.ntcnMapper.updateNtcnCnfirmAt(ntcnNo);
	}

}
