package kr.ac.collage_api.vo;

import lombok.Data;

/**
 * CrtfKndVO(증명서 종류 마스터)
 * 목적
 *  - 증명서 종류 마스터 테이블 1행 표현 (CRTF_KND)
 *  - 재학 / 졸업 / 성적 등 어떤 증명서를 발급할 수 있는지 정의
 *
 * 데이터 흐름
 *  - 관리자가 미리 등록 (수수료, 양식ID 등)
 *  - 발급요청(CRTF_ISSU_REQUEST)이 이 정보를 FK로 참조
 *
 * 계약 / 보안
 *  - crtfKndNo는 PK. 무단 변경 금지
 *  - 개인정보 없음. 공개 가능 메타
 *
 * 유지 포인트
 *  - crtfIssuForm은 실제 PDF 템플릿/양식 ID만 가리킴
 *    실제 PDF 본문은 DB에 저장 안 함
 */
@Data
public class CrtfKndVO {

    // CRTF_KND_NO (PK)
    // 증명서 종류 식별 코드 (예: ENROLL, GRAD, SCORE)
    private String crtfKndNo;

    // CRTF_NM
    // 증명서 이름 (예: 재학증명서)
    private String crtfNm;

    // CRTF_DC
    // 증명서 설명 또는 비고
    private String crtfDc;

    // ISSU_FEE
    // 발급 수수료 금액(원). 없으면 null
    private Integer issuFee;

    // CRTF_ISSU_FORM
    // 발급 서식 ID. 어떤 PDF 양식/템플릿을 쓸지 가리키는 키
    private String crtfIssuForm;
}

