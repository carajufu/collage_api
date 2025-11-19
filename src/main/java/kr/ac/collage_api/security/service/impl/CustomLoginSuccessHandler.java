package kr.ac.collage_api.security.service.impl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.collage_api.vo.AcntVO;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class CustomLoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
    private static final LinkedHashMap<String, String> ROLE_TO_URL = new LinkedHashMap<>();
    static {
        ROLE_TO_URL.put("ROLE_ADMIN", "/admin/welcome");
        ROLE_TO_URL.put("ROLE_PROF", "/prof/welcome");
        ROLE_TO_URL.put("ROLE_STUDENT", "/student/welcome");
    }

    private static final String FALLBACK_URL = "/";

    @Override
    protected String determineTargetUrl(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication) {
        Set<String> roles = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

        for(Map.Entry<String, String> e : ROLE_TO_URL.entrySet()) {
            if (roles.contains(e.getKey())) {
                return e.getValue();
            }
        }

        return FALLBACK_URL;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {
        super.onAuthenticationSuccess(request, response, authentication);
    }
}