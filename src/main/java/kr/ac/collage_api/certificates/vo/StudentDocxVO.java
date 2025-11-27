package kr.ac.collage_api.certificates.vo;

import lombok.Data;

/**
 * StudentDocxVO
 *
 * 목적
 *  - 증명서 출력용
 *  - 재학증명서 / 휴학증명서 / 졸업증명서 / 성적증명서 공통 기반
 *
 * 주의
 *  - 이 VO는 "화면 또는 PDF로 나가는 값"만 포함함
 *  - DB 내부 관리용 민감필드 (주소, 전화, 계좌 등) 배제
 *  - 값이 null일 수 있음 (증명서별로 안 쓰는 필드 존재)
 *
 * 필드별 사용처
 *  - 재학증명서 : studentNo, studentNameKor, majorName, collegeName, status
 *  - 휴학증명서 : studentNo, studentNameKor, majorName, collegeName, status,
 *               leaveStartDate, returnDueDate, leaveReason
 *  - 졸업증명서 : studentNo, studentNameKor, majorName, collegeName,
 *               graduationDate, degreeName
 *  - 성적증명서 : studentNo, studentNameKor, majorName, collegeName,
 *               totalCredits, totalGpa (+ 별도 과목행 리스트 ScoreRowVO)
 */
@Data
public class StudentDocxVO {

    // 공통 기본 영역 -----------------------------

    // 학번 (STDNT.STDNT_NO)
    // 개인정보. 호출자는 본인 또는 허가된 직원이어야 함
    private String studentNo;

    // 한글 이름 (STDNT.STDNT_NM)
    private String studentNameKor;

    // 영문 이름
    // 현재 DB에 컬럼 없으면 매퍼에서 NULL AS STDNT_NM_ENG 로 채움
    private String studentNameEng;

    // 전공명 (SUBJCT.SUBJCT_NM)
    private String majorName;

    // 학적 상태 (STDNT.SKNRGS_STTUS)
    // 예: 재학, 휴학, 졸업 등
    // 재학/휴학증명서에서 바로 노출
    private String status;

    // 단과대 명칭 (COLLEGE.COLLEGE_NM 등)
    // 예: 소프트웨어융합대학
    // 졸업증명서/재학증명서/휴학증명서/성적증명서 공통으로 찍어도 무방
    private String collegeName;

    // 학위명 (공학사, 문학사 등)
    // DB에 없음. 서비스 계층에서 전처리 collegeName 기반으로 주입
    // 졸업증명서에서 사용
    private String degreeName;
    
    // 생년월일(추가)
    private String birthDeKor;

    // 입학일(추가)
    private String entranceDeKor;
    
    // 졸업 관련 -----------------------------

    // 졸업일자 (STDNT.GRDTN_DE)
    // 졸업증명서에서 사용
    private String graduationDate;

    // 성적 요약 영역 -------------------------

    // 누적 취득 학점 합계
    // 성적증명서 하단에 출력
    private Integer totalCredits;

    // 누적 평점 (가중 평균 GPA, 소수 둘째자리)
    // 성적증명서 하단에 출력
    private Double totalGpa;

    // 휴학 관련 ------------------------------

    // 휴학 시작일
    // 휴학증명서 전용
    private String leaveStartDate;

    // 복학 예정일 (또는 복학 승인일 등 정책에 맞는 값)
    // 휴학증명서 전용
    private String returnDueDate;

    // 휴학 사유 구분
    // 예: 일반휴학, 군휴학 등
    // 화면에는 그대로 노출할 문자열 형태로 세팅
    private String leaveReason;
}
