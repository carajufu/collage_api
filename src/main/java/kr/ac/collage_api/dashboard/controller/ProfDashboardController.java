package kr.ac.collage_api.dashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/dashboard")
public class ProfDashboardController {

    @GetMapping("/prof")
    public String prof() {
        return "dashboard/prof/dashboard";
    }
}
