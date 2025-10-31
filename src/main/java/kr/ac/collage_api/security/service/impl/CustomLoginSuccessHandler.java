package kr.ac.collage_api.security.service.impl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.collage_api.vo.AcntVO;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {
    private final HttpSessionRequestCache requestCache = new HttpSessionRequestCache();

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {
        CustomUser customUser = (CustomUser)authentication.getPrincipal();
        AcntVO acntVO = customUser.getAcntVO();

        SavedRequest savedRequest = requestCache.getRequest(request, response);

        if(savedRequest != null) {
            String targetUrl = savedRequest.getRedirectUrl();

            response.sendRedirect(targetUrl);

            return;
        } else {
            List<String> role = authentication.getAuthorities().stream()
                                    . map(GrantedAuthority::getAuthority)
                                    .toList();

            if (role.contains("ROLE_STUDENT")) {
                response.sendRedirect("/student/welcome");
                return;
            } else if (role.contains("ROLE_PROF")) {
                response.sendRedirect("/prof/welcome");
                return;
            } else if (role.contains("ROLE_ADMIN")) {
                response.sendRedirect("/admin/welcome");
                return;
            }
        }

    }
}