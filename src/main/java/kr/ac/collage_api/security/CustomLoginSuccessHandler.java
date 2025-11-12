package kr.ac.collage_api.security;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import jakarta.servlet.ServletException; 

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
public class CustomLoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

	private final AdminHandoverCodeStore codeStore;

	@Override
	public void onAuthenticationSuccess(
	        HttpServletRequest req,
	        HttpServletResponse res,
	        Authentication auth
	) throws ServletException, IOException {
	    this.setDefaultTargetUrl("/debug/debuging");                // SavedRequest 없을 때 기본 경로
	    // 
	    boolean isAdmin = auth.getAuthorities().stream()
	            .anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority())); // 관리자 여부
	    if (!isAdmin) {
	        super.onAuthenticationSuccess(req, res, auth);        // 일반 사용자: 세션 유지 후 기본 이동
	        return;
	    }

	    String acntId = auth.getName();                           // 관리자 아이디
	    String code   = codeStore.issue(acntId);                  // 1회용 핸드오버 코드 발급

	    if (req.getSession(false) != null)                        // 관리자 전환: 세션 즉시 무효화
	        req.getSession(false).invalidate();

	    String target = isLocalhost(req) ? "http://localhost:5173/app" : req.getContextPath() + "/app";
	    String location = "/api/admin/exchange?ui=true&code="
	        + URLEncoder.encode(code, StandardCharsets.UTF_8)
	        + "&target=" + URLEncoder.encode(target, StandardCharsets.UTF_8);
	    res.setStatus(HttpServletResponse.SC_FOUND);
	    log.info("[CLS] redirecting to {}", location);
	    res.setHeader("Location", location);
	}

	private boolean isLocalhost(HttpServletRequest req) {
	    String h = req.getServerName();
	    return "localhost".equalsIgnoreCase(h) || "127.0.0.1".equals(h);
	}
}
