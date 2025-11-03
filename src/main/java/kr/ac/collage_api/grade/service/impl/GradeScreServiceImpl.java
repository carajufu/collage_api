package kr.ac.collage_api.grade.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.collage_api.grade.mapper.GradeScreMapper;
import kr.ac.collage_api.grade.service.GradeScreService;
import kr.ac.collage_api.grade.vo.GradeScreVO;

/**
 * [수정 사항]
 * - GradeScreService 인터페이스 명세 변경에 따라,
 * 컨트롤러에서 사용하지 않는 getCourse()와 updateGrades() 메서드를 삭제했습니다.
 */
@Service
public class GradeScreServiceImpl implements GradeScreService {

    // Mapper Bean을 주입받습니다.
    @Autowired
    private GradeScreMapper gradeMapper;

    /**
     * 로그인 계정 ID → 교수번호 조회
     */
    @Override
    public String getProfsrNoByAcntId(String acntId) {
        return gradeMapper.getProfsrNoByAcntId(acntId);
    }

    /**
     * 교수 담당 전체 개설강의 목록
     */
    @Override
    public List<GradeScreVO> getAllSbject(String profsrNo) {
        return gradeMapper.getAllSbject(profsrNo);
    }

    /**
     * 교수 담당 강의 *상세* 정보 (1건)
     */
    @Override
    public GradeScreVO getCourseDetail(String estbllctreCode) {
        return gradeMapper.getCourseDetail(estbllctreCode);
    }

    /**
     * 해당 강의 수강 학생 성적 목록
     */
    @Override
    public List<GradeScreVO> getSbjectScr(String estbllctreCode) {
        return gradeMapper.getSbjectScr(estbllctreCode);
    }

    /**
     * 성적 저장 (INSERT + UPDATE)
     */
    @Override
    @Transactional
    public void saveGrades(List<GradeScreVO> grades, String estbllctreCode) {
        // 리스트가 비어있거나 null이면 쿼리를 실행하지 않음
        if (grades != null && !grades.isEmpty()) {
            gradeMapper.saveGrades(grades, estbllctreCode);
        }
    }

    /**
     * 학생 검색 (모달 검색)
     */
    @Override
    public List<GradeScreVO> searchStudent(String keyword, String estbllctreCode) {
        return gradeMapper.searchStudent(keyword, estbllctreCode);
    }

	@Override
	public List<GradeScreVO> getStudentSemstrList(String stdntNo) {
		 return gradeMapper.getStudentSemstrList(stdntNo);
	}

	@Override
	public List<GradeScreVO> getStudentSemstrDetail(String semstrScreInnb) {
		 return gradeMapper.getStudentSemstrDetail(semstrScreInnb);
	}
    
    /* * [삭제된 메서드]
     * - public List<GradeScreVO> getCourse(String profsrNo) { ... }
     * - public void updateGrades(List<GradeScreVO> grades) { ... }
     */
}