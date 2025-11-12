package kr.ac.collage_api.vo;

import lombok.Data;

/*
역할 Role
- 성적증명서 푸터 요약 컨테이너
- 총 취득학점과 총 평점을 한 번에 전달

의도 Intent
- DB 집계 결과를 가공 없이 그대로 매핑
- 템플릿 바인딩 단순화 및 일관성 유지

데이터 흐름 Data Flow
- 입력 MyBatis selectTranscriptSummary 결과셋 컬럼 TOTAL_CREDITS TOTAL_GPA
- 처리 없음 서비스 레이어에서 그대로 전달
- 출력 HTML PDF 템플릿의 합계 영역

계약 Contract
- totalCredits 정수 0 이상 학기 합계의 누계
- totalGpa 실수 0.00 이상 4.50 이하 DB에서 반올림 완료
- 컬럼명과 필드명 1대1 대응 변경 금지

보안 안전 Security
- 학번 등 식별자 미포함
- 뷰 출력 시 이스케이프 적용
- 로깅 시 전체 덤프 금지

유지보수 가이드 Maintenance
- 계산은 항상 SQL에서 수행 자바에서 재계산 금지
- GPA 정책 변경 시 쿼리 변경 VO 고정
- 필드 추가 시 매퍼와 템플릿 동시 갱신
*/
@Data
public class TranscriptSummaryVO {
  private Integer totalCredits; // 총 취득학점
  private Double  totalGpa;     // 총 평점
}
