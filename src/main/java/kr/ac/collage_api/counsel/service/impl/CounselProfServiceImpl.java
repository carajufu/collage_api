package kr.ac.collage_api.counsel.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.counsel.mapper.CounselProfMapper;
import kr.ac.collage_api.counsel.service.CounselProfService;
import kr.ac.collage_api.ntcn.mapper.NtcnMapper;
import kr.ac.collage_api.vo.CnsltVO;
import kr.ac.collage_api.vo.NtcnVO;
import kr.ac.collage_api.websocket.ChatMessage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CounselProfServiceImpl implements CounselProfService {

	@Autowired
	NtcnMapper ntcnMapper;

	@Autowired
	SimpMessagingTemplate messagingTemplate;

	@Autowired
	CounselProfMapper counselProfMapper;

	@Override
	public String getProfsrNo(String acntId) {
		return this.counselProfMapper.getProfsrNo(acntId);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.counselProfMapper.getTotal(map);
	}

	@Override
	public List<CnsltVO> list(Map<String, Object> map) {
		return this.counselProfMapper.list(map);
	}

	@Override
	public List<CnsltVO> selectProfCnsltCount(String profsrNo) {
		return this.counselProfMapper.selectProfCnsltCount(profsrNo);
	}

	//상담예약 완료 1예약 대기중에서 -> 예약 완료로
	@Transactional
	@Override
	public int patchAccept(CnsltVO cnsltVO) {

		//메시지 보내기 위한 targetid 가져오기
		int cnsltInnb = cnsltVO.getCnsltInnb();
		String targetId = this.counselProfMapper.selectCnsltStdntNo(cnsltInnb);

		int result = this.counselProfMapper.patchAccept(cnsltVO);

		if (result>0) {
			sendNotification(targetId, "상담예약이 완료되었습니다.");
		}
		return result;
	}

	//상담 취소
	@Transactional
	@Override
	public int patchCancl(CnsltVO cnsltVO) {

		//메시지 보내기 위한 targetid 가져오기
		int cnsltInnb = cnsltVO.getCnsltInnb();
		String targetId = this.counselProfMapper.selectCnsltStdntNo(cnsltInnb);

		int result = this.counselProfMapper.patchCancl(cnsltVO);
		if (result > 0) {
			sendNotification(targetId, "상담이 취소되었습니다. 상담 취소사유를 확인하세요.");
		}
		return result;
	}

	@Transactional
	@Override
	public int patchResult(CnsltVO cnsltVO) {

		//메시지 보내기 위한 targetid 가져오기
		int cnsltInnb = cnsltVO.getCnsltInnb();
		String targetId = this.counselProfMapper.selectCnsltStdntNo(cnsltInnb);

		int result = this.counselProfMapper.patchResult(cnsltVO);
		if(result > 0) {
			sendNotification(targetId,"상담이 완료되었습니다. 상담결과를 확인하세요.");
		}
		return result;
	}


	public void sendNotification(String targetId, String ntcnCn) {
		String sender = "System 알림";
		String ntcnItnadr = "/counsel/std";


		NtcnVO ntcnVO = new NtcnVO();
		ntcnVO.setAcntId(targetId);
		ntcnVO.setNtcnCn(ntcnCn);
		ntcnVO.setSender(sender);
		ntcnVO.setNtcnItnadr(ntcnItnadr);

		this.ntcnMapper.insertNtcn(ntcnVO);

		ChatMessage notification = ChatMessage.builder()
				.type(ChatMessage.MessageType.CHAT)
				.sender(sender)
				.content(ntcnCn)
				.ntcnItnadr(ntcnItnadr)
				.ntcnNo(ntcnVO.getNtcnNo())
				.build();

		log.info("patchAccept() -> ntcnVO.getNtcnNo() : {}", ntcnVO.getNtcnNo());

		log.info("sendNotification() -> notification : {}", notification);

		messagingTemplate.convertAndSendToUser(
				targetId,
				"/queue/notifications",
				notification);

	}


}
