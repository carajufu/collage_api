package kr.ac.collage_api.dashboard.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.ac.collage_api.dashboard.service.ReactDashboardService;
import kr.ac.collage_api.dashboard.vo.ReactDashboardVO;

@RequestMapping("/admin")
@RestController
public class ReactDashboardController {

	@Autowired
	ReactDashboardService reactDashboardService;

	@GetMapping("/homestat")
	public ReactDashboardVO selectHomeChartValue() {
		return this.reactDashboardService.selectHomeChartValue();
	}
}
