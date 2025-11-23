package kr.ac.collage_api.certificates.vo;

import lombok.Data;

/**
 * ScoreRowVO
 *
 * 목적
 *  - 성적증명서 본문 테이블의 한 줄을 표현
 *  - Mapper selectScoreRows 결과 1 row 와 1:1 매핑
 *
 * 필드 의미
 *  - term         : 학기 문자열 (예 "2025 1학기")
 *  - subjectName  : 과목명
 *  - subjectCode  : 과목 코드
 *  - credit       : 학점 (취득 학점)
 *  - grade        : 등급 (A0 등)
 *
 * 보안
 *  - 개인정보 없음. 학생 인적사항은 포함 안 함
 *
 * 사용 흐름
 *  - StudentDocxService.getTranscriptRows(stdntNo) 가 List<ScoreRowVO> 리턴
 *  - JSP 또는 PDF 템플릿에서 반복 출력
 */
@Data
public class ScoreRowVO {

    // TERM_NM
    // "2025 1학기" 같이 학년도+학기
    private String term;

    // SUBJECT_NM
    // 과목 이름
    private String subjectName;

    // SUBJECT_CD
    // 과목 코드
    private String subjectCode;

    // CREDIT
    // 과목 학점
    private Integer credit;

    // GRADE
    // 등급 또는 평점 등급표시
    private String grade;
}
