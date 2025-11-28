package kr.ac.collage_api.chatbot.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.collage_api.chatbot.service.ChatBotService;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/chatbot")
public class ChatBotController {

    @Autowired
    private ChatBotService chatbotService;

    
    @PostMapping("/api")
    @ResponseBody
    public Map<String, String>Answer(@RequestBody Map<String, String> body){
    	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    	String loginId = auth.getName();  // 학번 or 교수번호
    	
    	String msg = body.get("message");
    	
    	String reply = chatbotService.getAnswer(msg, loginId);
    	
    	Map<String, String> answer = new HashMap();    	
    	answer.put("answer", reply);
    	return answer;
    }
    
}
