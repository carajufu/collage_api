package kr.ac.collage_api.security.service.impl;

import java.io.IOException;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomLoginFailureHandler implements AuthenticationFailureHandler{
	
	@Override
	public void onAuthenticationFailure (HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception)throws IOException, ServletException {
		log.debug("[CustomLoginFailureHandler], 인증 실패 : ",exception.getMessage());
		response.sendRedirect("/login");
	}

}