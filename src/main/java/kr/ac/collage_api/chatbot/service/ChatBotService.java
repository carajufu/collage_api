package kr.ac.collage_api.chatbot.service;

import org.springframework.stereotype.Service;

import kr.ac.collage_api.vo.AcntVO;

@Service
public interface ChatBotService {
    
    String getAnswer(String msg, String loginId);
    
}
