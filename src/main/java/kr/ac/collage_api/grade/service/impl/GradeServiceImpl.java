package kr.ac.collage_api.grade.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.collage_api.grade.mapper.GradeMapper;
import kr.ac.collage_api.grade.service.GradeService;
import kr.ac.collage_api.grade.vo.GradeForm;
import kr.ac.collage_api.grade.vo.GradeVO;

@Service
public class GradeServiceImpl implements GradeService {

	@Autowired
	GradeMapper gradeMapper;

	@Override
	public List<GradeVO> getAllSbject(String profsrNo) {
		return this.gradeMapper.getAllSbject(profsrNo);
	}

	@Override
	public List<GradeVO> getCourse(String profsrNo) {
		return this.gradeMapper.getCourse(profsrNo);
	}
	
	@Override
	public List<GradeVO> getSbjectScr(String estbllctreCode) {
		return this.gradeMapper.getSbjectScr(estbllctreCode);
	}

	@Override
	public int profGradeSubmit(GradeForm gradeForm) {
		return this.gradeMapper.profGradeSubmit(gradeForm);
	}

	@Override
	public int profGradeEdit(GradeForm gradeForm) {
		return this.gradeMapper.profGradeEdit(gradeForm);
	}

	@Override
	public List<GradeVO> searchStudent(String keyword, String estbllctreCode) {
		return this.gradeMapper.searchStudent(keyword, estbllctreCode);
	}

	@Override
	public void updateGrades(List<GradeVO> grades) {	
		this.gradeMapper.updateGrades(grades);
	}

	@Override
	public void saveGrades(List<GradeVO> grades, String estbllctreCode) {	
		this.gradeMapper.saveGrades(grades, estbllctreCode);
	}

//---------------------------- 학생용 ---------------------------- 
	@Override
	public List<GradeVO> getAllScore(String stdntNo) {
		return this.gradeMapper.getAllScore(stdntNo);
	}

	@Override
	public GradeVO getSbjectDetailScore(Map<String, Object> params) {
		return this.gradeMapper.getSbjectDetailScore(params);
	}

}
