package kr.ac.collage_api.chatbot.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpSession;

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
    public Map<String, String> Answer(
            @RequestBody Map<String, String> body,
            HttpSession session
    ) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String loginId = auth.getName(); // 학생번호 or 교수번호

        String msg = body.get("message");

        // 1) 세션에서 대화 히스토리 가져오기
        List<Map<String, String>> history =
                (List<Map<String, String>>) session.getAttribute("chatHistory");

        if (history == null) {
            history = new ArrayList<>();
        }

        // 2) 사용자 메시지만 먼저 히스토리에 입력
        Map<String, String> userMsg = new HashMap<>();
        userMsg.put("role", "user");
        userMsg.put("content", msg);
        history.add(userMsg);

        // 3) 챗봇은 이전 대화를 참고해서 응답 생성
        String reply = chatbotService.getAnswer(msg, loginId, history);

        // 4) 챗봇 응답도 히스토리에 저장
        Map<String, String> botMsg = new HashMap<>();
        botMsg.put("role", "assistant");
        botMsg.put("content", reply);
        history.add(botMsg);

        // 5) 다시 세션에 저장
        session.setAttribute("chatHistory", history);

        // 클라이언트에 응답 전달
        Map<String, String> answer = new HashMap<>();
        answer.put("answer", reply);
        return answer;
    }

}
