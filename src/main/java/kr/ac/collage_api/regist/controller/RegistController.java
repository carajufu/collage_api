package kr.ac.collage_api.regist.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.ac.collage_api.regist.service.RegistService;
import kr.ac.collage_api.regist.vo.RegisterVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/regist")
public class RegistController {

    @Autowired
    private RegistService registService;

    @GetMapping("/list")
    public String list(@RequestParam(required = false) String year,
                       @RequestParam(required = false) String semester,
                       Model model) {
    	// 항상 저쪽에서 보낸 데이터가 왔는지 확인하는 습관
        log.debug("year {} semester {}",year,semester);    	
        String stuId = "1903653";

        Map<String, Object> param = new HashMap<>();
        param.put("stuId", stuId);
        param.put("year", year);
        param.put("semester", semester);

        List<RegisterVO> registerList = registService.selectRegisterList(param);
        log.debug("registerList: {}",registerList);
        model.addAttribute("registerList", registerList);
        model.addAttribute("mk_ys", param);
        return "regist/register";
    }
}
