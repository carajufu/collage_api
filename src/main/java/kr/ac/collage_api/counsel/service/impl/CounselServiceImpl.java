package kr.ac.collage_api.counsel.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.account.mapper.AccountMapper;
import kr.ac.collage_api.common.util.CurrentSemstr;
import kr.ac.collage_api.counsel.mapper.CounselMapper;
import kr.ac.collage_api.counsel.service.CounselService;
import kr.ac.collage_api.ntcn.mapper.NtcnMapper;
import kr.ac.collage_api.vo.CnsltAtVO;
import kr.ac.collage_api.vo.CnsltVO;
import kr.ac.collage_api.vo.LctreTimetableVO;
import kr.ac.collage_api.vo.NtcnVO;
import kr.ac.collage_api.vo.ProfsrVO;
import kr.ac.collage_api.websocket.ChatMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class CounselServiceImpl implements CounselService {

	@Autowired
	SimpMessagingTemplate messagingTemplate;

	@Autowired
	NtcnMapper ntcnMapper;

	@Autowired
	AccountMapper accountMapper;

	@Autowired
	CounselMapper counselMapper;

	@Autowired
	CurrentSemstr currentSemstr;

	@Override
	public List<CnsltAtVO> getCnsltAtVOList(String acntId) {

		//계정 아이디로 교수 아이디 가져오기
		String profsrNo = this.accountMapper.getProfsrNo(acntId);
		log.info("getCnsltAtVOList() -> profsrNo : {}", profsrNo);
		return this.counselMapper.getCnsltAtVOList(profsrNo);

	}

	@Override
	public int insertCnsltAt(CnsltAtVO cnsltAtVO) {
		return this.counselMapper.insertCnsltAt(cnsltAtVO);
	}



	@Override
	public List<CnsltVO> selectCnsltStd(String acntId) {
		//계정 아이디로 학생No 가져오기
		String StdntNo = this.accountMapper.selectStdntNo(acntId);
		//학생 No 로 상담 VOList 가져오기
		return this.counselMapper.selectCnsltStd(StdntNo);
	}

	@Transactional
	@Override
	public int createCnslt(CnsltVO cnsltVO) {

		int result = this.counselMapper.createCnslt(cnsltVO);

		if (result > 0) {
			String targetId = cnsltVO.getProfsrNo();		//받을사람Id
			String ntcnCn = "새로운 학생이 상담신청을 했습니다.";	//내용
			String sender = "System 알림";					//보낸이
			String ntcnItnadr = "/counselprof/prof"; 		//이동주소

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

			log.info("sendNotification() -> notification : {}", notification);

			messagingTemplate.convertAndSendToUser(
					targetId,
					"/queue/notifications",
					notification);

		}
		return result;
	}

	@Override
	public List<ProfsrVO> selectMyProf(String acntId) {
		//계정 아이디로 학생No 가져오기
		String stdntNo = this.accountMapper.selectStdntNo(acntId);
		log.info("selectMyProf() -> StdntNo : {}", stdntNo);

		String year = currentSemstr.getYear();
		String semstr = currentSemstr.getCurrentPeriod();

		return this.counselMapper.selectMyProf(stdntNo,year,semstr);
	}

	@Override
	public List<LctreTimetableVO> selectMyProfTimetable(String profsrNo) {
		log.info("selectMyProfTimetable() -> profsrNo : {}", profsrNo);
		return this.counselMapper.selectMyProfTimetable(profsrNo);
	}

	@Override
	public List<CnsltVO> profCnsltList(String profsrNo) {
		return this.counselMapper.profCnsltList(profsrNo);
	}

	@Override
	public CnsltVO seletCnsltDetail(int cnsltInnb) {
		return this.counselMapper.seletCnsltDetail(cnsltInnb);
	}


	@Override
	public List<CnsltVO> selectCnsltCount(String acntId) {
		//계정 아이디로 학생No 가져오기
		String stdntNo = this.accountMapper.selectStdntNo(acntId);

		return this.counselMapper.selectCnsltCount(stdntNo);
	}

	@Override
	public String selectStdntNo(String acntId) {
		return this.accountMapper.selectStdntNo(acntId);
	}





}
