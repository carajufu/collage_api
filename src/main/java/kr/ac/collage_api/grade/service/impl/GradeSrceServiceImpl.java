package kr.ac.collage_api.grade.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.grade.mapper.GradeScreMapper;
import kr.ac.collage_api.grade.service.GradeScreService;
import kr.ac.collage_api.grade.vo.GradeScreForm;
import kr.ac.collage_api.grade.vo.GradeScreVO;

@Service
public class GradeSrceServiceImpl implements GradeScreService {

	@Autowired
	GradeScreMapper gradeMapper;

	@Override
	public List<GradeScreVO> getAllSbject(String profsrNo) {
		return this.gradeMapper.getAllSbject(profsrNo);
	}

	@Override
	public List<GradeScreVO> getCourse(String profsrNo) {
		return this.gradeMapper.getCourse(profsrNo);
	}
	
	@Override
	public List<GradeScreVO> getSbjectScr(String estbllctreCode) {
		return this.gradeMapper.getSbjectScr(estbllctreCode);
	}

	@Override
	public int profGradeSubmit(GradeScreForm gradeForm) {
		return this.gradeMapper.profGradeSubmit(gradeForm);
	}

	@Override
	public int profGradeEdit(GradeScreForm gradeForm) {
		return this.gradeMapper.profGradeEdit(gradeForm);
	}

	@Override
	public List<GradeScreVO> searchStudent(String keyword, String estbllctreCode) {
		return this.gradeMapper.searchStudent(keyword, estbllctreCode);
	}

	@Override
	@Transactional	
	public void updateGrades(List<GradeScreVO> grades) {	
		this.gradeMapper.updateGrades(grades);
	}

	@Override
	@Transactional
	public void saveGrades(List<GradeScreVO> grades, String estbllctreCode) {	
		this.gradeMapper.saveGrades(grades, estbllctreCode);
	}

//---------------------------- 학생용 ---------------------------- 
	
	@Override
	public List<GradeScreVO> getAllSemstr(String stdntNo) {
		return this.gradeMapper.getAllSemstr(stdntNo);
	}
	
//	@Override
//	public List<GradeVO> getAllScore(String stdntNo) {
//		return this.gradeMapper.getAllScore(stdntNo);
//	}
//	
//	@Override
//	public GradeVO getSbjectDetailScore(Map<String, Object> params) {
//		return this.gradeMapper.getSbjectDetailScore(params);
//	}
}
