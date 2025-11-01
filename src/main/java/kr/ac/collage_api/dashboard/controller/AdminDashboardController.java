package kr.ac.collage_api.dashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/dashboard")
public class AdminDashboardController {

    @GetMapping("/admin")
    public String admin() {
        return "dashboard/admin/dashboard";
    }
}
