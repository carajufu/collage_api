package kr.ac.collage_api.security.controller;

import kr.ac.collage_api.security.service.impl.CustomLoginSuccessHandler;
import kr.ac.collage_api.security.service.impl.CustomLogoutSuccessHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.security.Principal;

@Controller
@Slf4j
public class UserViewController {
    @Autowired
    BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    CustomLoginSuccessHandler customLoginSuccessHandler;

    @Autowired
    CustomLogoutSuccessHandler logoutSuccessHandler;

    @GetMapping("/login")
    public String login() {
        log.info(">>>>>>>>> {}", bCryptPasswordEncoder.encode("java"));
        return "login";
    }

    @RequestMapping(value="/login", method= RequestMethod.GET, params="logout")
    public String loginParams(Model model) {
        model.addAttribute("message", "로그아웃 되었습니다.");

        return "login";
    }

    @GetMapping("/student/welcome")
    public String studentWelcome(Principal principal) {
        log.info("chkng principal > {}", principal.getName());

        return "redirect:/dashboard/student";
    }

    @GetMapping("/prof/welcome")
    public String profWelcome(Principal principal) {
        log.info("chkng principal > {}", principal.getName());

        return "redirect:/dashboard/prof";
    }

    @GetMapping("/admin/welcome")
    public String adminWelcome(Principal principal) {
        log.info("chkng principal > {}", principal.getName());

        return "redirect:/dashboard/admin";
    }
}
