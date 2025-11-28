package kr.ac.collage_api.security.service.impl;

import java.io.IOException;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler{

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
	                   AccessDeniedException ex) throws IOException, ServletException {
	    String uri = request.getRequestURI();
	    if (uri.startsWith("/api/")) {
	        // API((브라우저가 아닌 프로그램 호출) 경로) 
	    	//	-> JSON/상태코드 기대, 리다이렉트 금지
	        response.sendError(HttpServletResponse.SC_FORBIDDEN);
	        return;
	    }
	    // 웹 뷰((브라우저 화면)) 경로 → 접근 거부 페이지로 리다이렉트
	    response.sendRedirect("/accessError");
	}
}