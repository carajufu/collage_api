package kr.ac.collage_api.graduation.service;

import java.util.Map;

import kr.ac.collage_api.graduation.vo.GraduationVO; // VO 경로는 실제 프로젝트에 맞게 수정

public interface GraduationService {

	public Map<String, Object> getGraduMainData(String stdntNo);
	
	public int applyForGraduation(GraduationVO graduVO);
	
}