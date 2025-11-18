package kr.ac.collage_api.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import kr.ac.collage_api.service.impl.CustomUser;
import kr.ac.collage_api.vo.AcntVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@Slf4j
@ControllerAdvice(annotations = Controller.class)
public class GlobalUserInfoAdvice {

    /**
     * 모든 뷰 렌더링 전에 acntVO 를 모델에 주입.
     * - 우선 세션에서 찾고
     * - 없으면 Authentication.principal(CustomUser) 에서 가져와 세션에 캐싱
     */
    @ModelAttribute("acntVO")
    public AcntVO populateAcntVO(Authentication authentication,
                                 HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        // 1) 세션에 이미 있으면 그대로 사용
        if (session != null) {
            Object cached = session.getAttribute("acntVO");
            if (cached instanceof AcntVO) {
                return (AcntVO) cached;
            }
        }

        // 2) 세션에 없으면 SecurityContext 에서 꺼내서 세션에 저장
        if (authentication != null &&
            authentication.getPrincipal() instanceof CustomUser customUser) {

            AcntVO acntVO = customUser.getAcntVO();

            if (acntVO != null) {
                if (session == null) {
                    session = request.getSession(true);
                }
                session.setAttribute("acntVO", acntVO);
                log.debug("[GlobalUserInfoAdvice] acntVO cached in session: {}", acntVO.getAcntId());
            }

            return acntVO;
        }

        // 비로그인 / 익명
        return null;
    }
}
