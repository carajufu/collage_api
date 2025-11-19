package kr.ac.collage_api.competency.vo;

import lombok.Data;

@Data
public class CompetencyVO {
    // 시스템 관리용
    private int introNo;            // PK
    private String stdntNo;         // FK (로그인한 사용자 식별용)
    
    // 1. 사용자 직접 입력 정보 (DB 조회 X)
    private String name;            // 이름 (직접 입력)
    private int age;                // 나이 (직접 입력)
    private String targetJob;       // 희망 직무
    private String introTitle;      // 제목

    // 2. 자기소개서 구성 키워드
    private String motivation;      // 지원동기 키워드
    private String growthProcess;   // 성장과정 키워드
    private String strength;        // 장점 키워드
    
    // 3. 경력 및 자격증 (NULL 허용)
    private String career;          // 경력 사항 (예: 인턴 6개월, 카페 알바 등)
    private String certificate;     // 자격증 (예: 정보처리기사, 토익 850)

    // 4. 결과물
    private String finalResult;     // 자동 생성된 텍스트
    private String regDt;           // 작성일
}