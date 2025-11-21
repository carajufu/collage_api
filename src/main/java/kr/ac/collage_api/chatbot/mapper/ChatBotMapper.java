package kr.ac.collage_api.chatbot.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.collage_api.chatbot.vo.ChatBotVO;
import kr.ac.collage_api.vo.AcntVO;

@Mapper
public interface ChatBotMapper {

    /* ------------------------ 공통 ------------------------ */

    // 사용자 기본정보 (학생/교수 구분)
    AcntVO getUserDt(String acntId);



    /* ------------------------ 학생 ------------------------ */

    // 학생 성적 요약
    ChatBotVO getStudentSbjScore(String stdntNo);

    // 학생 수강신청 + 개설강의 + 강의명
    List<ChatBotVO> getStudentAtnlc(String stdntNo);

    // 누적 취득학점
    int getAllPnt( String stdntNo);

    // 전필/교필/전선/교선 이수 구분
    List<Map<String, Object>> getSubjectCompletions(String stdntNo);

    // 누적 GPA
    double getCumulativeGpa(String stdntNo);

    // 학생 기본정보
    ChatBotVO getStudentInfo(String stdntNo);

    // 상담 내역
    List<Map<String, Object>> getConsult(String stdntNo);



    /* ------------------------ 교수 ------------------------ */

    // 교수 담당 개설강의 목록
    List<ChatBotVO> getProfessorLectureList(String profsrNo);

    // 교수 상담 예약 내역
    List<ChatBotVO> getProfessorCounselList(String profsrNo);

    // 교수 - 주차별 학습/과제/제출 현황
    List<ChatBotVO> getProfWeekAcctoLrn(String profsrNo);

    // 교수 - 강의시간표
    List<ChatBotVO> getProfLctreTime(String profsrNo);

}
