package kr.ac.collage_api.learning.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;

@Controller
@RequestMapping("/learning")
@Slf4j
public class learningPageController {
    @GetMapping("/student")
    public String getLearningPage(Model model,
                                  Principal principal,
                                  @RequestParam String lcNo) {


        return "";
    }
}
