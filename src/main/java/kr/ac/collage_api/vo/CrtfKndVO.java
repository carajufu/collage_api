package kr.ac.collage_api.vo;

import lombok.Data;

//
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



