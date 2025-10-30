package kr.ac.collage_api.counsel.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.vo.CnsltAtVO;
import kr.ac.collage_api.vo.CnsltVO;
import kr.ac.collage_api.vo.LctreTimetableVO;
import kr.ac.collage_api.vo.ProfsrVO;

@Mapper
public interface CounselMapper {

	//교수아이디가 포함된 상담_가능_여부 테이블 List 가져오기
	public List<CnsltAtVO> getCnsltAtVOList(String profsrNo);
						   
	// 상담_가능_여부 테이블에 입력
	public int insertCnsltAt(CnsltAtVO cnsltAtVO);

	//학생NO로 상담VOList 가져오기
	public List<CnsltVO> selectCnsltStd(String stdntNo);
	
	//상담신청 학생 => 교수
	public int createCnslt(CnsltVO cnsltVO);

	//학생 아이디로 같은 과 교수(and 현재 수업중인) 가져오기
	public List<ProfsrVO> selectMyProf(
		    @Param("stdntNo") String stdntNo, 
		    @Param("year") String year, 
		    @Param("semstr") String semstr
		);
	
	//내 상담교수의 강의 시간표 가져오기
	public List<LctreTimetableVO> selectMyProfTimetable(String profsrNo);

	//내 상담교수의 상담리스트 가져오기
	public List<CnsltVO> profCnsltList(String profsrNo);

	//상담 detail 보기
	public CnsltVO seletCnsltDetail(int cnsltInnb);

	//상담 상태 따른 카운트
	public List<CnsltVO> selectCnsltCount(String stdntNo);



}
