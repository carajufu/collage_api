package kr.ac.collage_api;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestController {
    @GetMapping("/")
    public String testMain(){
        return "login";
    }
    @GetMapping("/stdntRegist")
    public String testMain2(){
        return "regist/stdnt_regist";
    }
}
