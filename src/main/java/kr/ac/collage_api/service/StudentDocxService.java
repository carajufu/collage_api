package kr.ac.collage_api.service;

import kr.ac.collage_api.vo.StudentDocxVO;
import kr.ac.collage_api.vo.ScoreRowVO;

import java.util.List;

/**
 * StudentDocxService
 *
 * 역할
 *  - 컨트롤러에서 직접 호출하는 Facade
 *  - mapper 결과를 가공(특히 degreeName) 후 돌려줌
 *
 * 주석
 *  - getEnrollmentDocx    재학증명서용 헤더블록
 *  - getLeaveDocx         휴학증명서 본문
 *  - getGraduationDocx    졸업증명서 본문
 *  - getTranscriptHeader  성적증명서 상단/요약(학번,이름,전공,총학점,GPA)
 *  - getTranscriptRows    성적증명서 본문 라인들
 */
public interface StudentDocxService {

    StudentDocxVO getEnrollmentDocx(String stdntNo);

    StudentDocxVO getLeaveDocx(String stdntNo);

    StudentDocxVO getGraduationDocx(String stdntNo);

    StudentDocxVO getTranscriptHeader(String stdntNo);

    List<ScoreRowVO> getTranscriptRows(String stdntNo);
}
