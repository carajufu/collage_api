package kr.ac.collage_api.dashboard.vo;

import lombok.Data;

/**
 * 학적 이행 집계 원본 데이터 VO
 *
 * 코드 의도
 * - 대시보드에서 보여줄 "학점/전공/교양/외국어 이행률"의 기초 숫자 집계용
 * - 퍼센트 계산, 충족/미충족 판정은 서비스/컨트롤러에서 2차 가공
 *
 * 비유
 * - 각 필드는 "주유 게이지에 들어갈 분자/분모 숫자"만 들고 있는 탱크 역할
 * - 실제 게이지(%) 그리기는 윗단에서 처리
 *
 * 설계 포인트
 * - Integer 사용: DB 집계 결과가 NULL일 수 있으므로 null 허용 (서비스에서 0으로 정규화)
 */
@Data
public class AcademicProgressRawVO {
    private Integer totalCompletedCredits;  // 총 이수 학점 (현재까지 채운 양)
    private Integer totalRequiredCredits;   // 졸업에 필요한 전체 학점
    private Integer majorCompletedCredits;  // 전공필수 이수 학점
    private Integer majorRequiredCredits;   // 전공필수 요구 학점
    private Integer liberalCompletedCredits; // 교양필수 이수 학점
    private Integer liberalRequiredCredits;  // 교양필수 요구 학점
    private Integer foreignCompletedSubjects; // 이수한 외국어 과목 수
    private Integer foreignRequiredSubjects;  // 요구 외국어 과목 수
}
