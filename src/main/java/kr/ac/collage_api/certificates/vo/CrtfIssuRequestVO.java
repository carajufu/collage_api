package kr.ac.collage_api.certificates.vo;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Data;

/**
 * CrtfIssuRequestVO(증명서 발급 요청 이력)
 * 목적
 *  - 학생이 증명서 발급을 요청한 1건을 기록 (CRTF_ISSU_REQUEST)
 *
 * 데이터 흐름
 *  - 발급 시점에 INSERT
 *  - 상태(요청됨, 발급완료 등)와 시간 정보를 업데이트
 *  - PDF 생성 시 이 정보 + 학생 정보 + CrtfKndVO를 조합해 실제 PDF를 만든다
 *
 * 계약 / 보안
 *  - crtfIssuInnb는 PK (발급 요청 고유번호)
 *  - stdntNo는 학생 식별자라서 개인정보. 외부 노출은 권한 체크 필요
 *  - issuSttus는 행정 상태 코드. 감사 로그와 맞아야 함
 *
 * 유지 포인트
 *  - reqstDt / issuDt는 Oracle DATE → LocalDateTime으로 매핑
 *  - fileGroupNo는 첨부/산출물 묶음 번호. 
 *  	실제 파일 경로는 별도 테이블에서 접근 제어
 */

@Data
public class CrtfIssuRequestVO {

    // CRTF_ISSU_INNB
    // 발급 요청 고유번호 PK (예: CERT202510270001)
    private String crtfIssuInnb;

    // CRTF_KND_NO
    // 어떤 증명서인지 (CrtfKndVO.crtfKndNo FK)
    private String crtfKndNo;

    // FILE_GROUP_NO
    // 첨부/산출물 파일 묶음 번호
    private Long fileGroupNo;

    // STDNT_NO
    // 학번 (요청자 식별자)
    // 개인정보라 외부 응답 시 노출 주의 필요
    private String stdntNo;

    // REQST_DT
    // 요청 시각
    private LocalDateTime reqstDt;

    // ISSU_DT
    // 실제 발급 완료 시각
    private LocalDateTime issuDt;

    // ISSU_STTUS
    // 상태 코드 (REQUESTED, DONE, CANCELED 등)
    private String issuSttus;

    // 조인 메타
    // 증명서 종류 상세 (이름, 수수료 등)ㄴ
    private CrtfKndVO crtfKnd;
    
    //발급 사유
    private String issuResn;
    
    // ---- 파생 출력 전용 게터 ----
    private static final DateTimeFormatter DTF
    				= DateTimeFormatter.ofPattern("yyyy/MM/dd");

    public String getReqstDtKor() {
        return reqstDt == null ? "" : reqstDt.format(DTF);
    }
    public String getIssuDtKor() {
        return issuDt == null ? "" : issuDt.format(DTF);
    }
    public String getCrtfKndNm() {
        if (crtfKnd != null && crtfKnd.getCrtfNm() != null && !crtfKnd.getCrtfNm().isBlank()) {
            return crtfKnd.getCrtfNm();
        }
        return switch (String.valueOf(crtfKndNo)) {
            case "ENROLL" -> "재학증명서";
            case "GRADE"  -> "성적증명서";
            case "GRAD"   -> "졸업증명서";
            case "LEAVE"  -> "휴학증명서";
            default       -> crtfKndNo;
        };
    }
    
}