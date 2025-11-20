package kr.ac.collage_api.chatbot.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.ac.collage_api.vo.AcntVO;
import kr.ac.collage_api.vo.CnsltVO;
import kr.ac.collage_api.vo.EstblCourseVO;
import kr.ac.collage_api.vo.SbjectScreVO;

@Mapper
public interface ChatBotMapper {
	
	AcntVO getUserDt(String loginId);

	SbjectScreVO getStudentSbjScore(String stdntNo);

	List<String> getStudentCourses(String stdntNo);

	List<EstblCourseVO> getProfessorLectureList(String profsrNo);

	List<CnsltVO> getProfessorCounselList(String profsrNo);

}
