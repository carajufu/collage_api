package kr.ac.collage_api.certificates.vo;

import lombok.Data;

/*
역할 Role
- 성적증명서 한 행(과목 단위)을 표현하는 전용 DTO
- 학기, 이수구분, 교과목명, 학점, 성적 정보를 템플릿에 전달

의도 Intent
- 성적 조회 SQL 결과를 가공 없이 1:1 매핑
- yearNo, semNo를 별도 보유해 서버측 정렬 기준을 명확히 유지
- complSe(ESTBL_COURSE.COMPL_SE)를 그대로 노출해 "전필/전선/교필/교선/교양" 구분 표시

데이터 흐름 Data Flow
- 입력: MyBatis selectTranscriptRows 결과셋
  - YEAR_NO, SEM_NO, COMPL_SE, TERM_LABEL, SUBJECT_NAME, CREDITS, GRADE
- 처리: 서비스 레이어에서 컬렉션 단위로 전달(정렬은 주로 SQL에서 수행)
- 출력: HTML/PDF 템플릿 scoreRows 렌더링에 사용

계약 Contract
- yearNo     : 연도(정렬 전용), 예) 2025
- semNo      : 학기(정렬 전용), 예) 1, 2
- complSe    : 이수구분, 예) 전필, 전선, 교필, 교선, 교양
- termLabel  : 최종 표기용 학기 문자열, 예) 2025-1
- subjectName: 교과목명 (ALL_COURSE 등 기준)
- credits    : 학점, null 허용
- grade      : 성적 등급, 예) A+, B0
- 필드명/타입은 매퍼 XML resultMap과 1:1 대응, 임의 변경 금지

보안 Security
- 학번 등 직접 식별자 미포함
- 뷰/템플릿 렌더링 시 HTML 이스케이프 필수(XSS 방지)
- 로깅 시 전체 객체 덤프 지양(다른 VO와 조인될 수 있음)

유지보수 Maintenance
- 정렬은 SQL에서 yearNo, semNo 기준으로 수행하고 자바 재정렬 최소화
- 이수구분/교과목명 소스 테이블 변경 시 매퍼만 수정, VO는 가능하면 고정
- 필드 추가 시: SQL, resultMap, 템플릿(scoreRows) 동시 갱신
*/
@Data
public class TranscriptRowVO {
    private Integer yearNo;       // 연도 정렬용
    private Integer semNo;        // 학기 정렬용 (1, 2 등)
    private String  complSe;      // 이수구분 (전필, 전선, 교필, 교선, 교양 등)
    private String  termLabel;    // 학기 표기 (예: 2025-1)
    private String  subjectName;  // 과목명
    private Integer credits;      // 학점
    private String  grade;        // 성적 등급
}
