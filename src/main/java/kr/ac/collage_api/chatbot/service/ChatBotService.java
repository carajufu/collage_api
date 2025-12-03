package kr.ac.collage_api.chatbot.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.vo.AcntVO;

@Service
public interface ChatBotService {
    
    String getAnswer(String msg, String loginId);

	String getAnswer(String msg, String loginId, List<Map<String, String>> history);
    
}
