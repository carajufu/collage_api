package kr.ac.collage_api.certificates.vo;

import java.time.LocalDate;
import lombok.Value;
import lombok.Builder;
import lombok.Data;

/**
 * CertRenderVO : 증명서 발급 상세 옵션 VO
 * - 선택 파라미터 VO. LEAVE에서 기간만 의미.
 */
@Value
@Builder
@Data
public class CertRenderVO {
    String reason;        // 발급 사유(null 허용)
    LocalDate leaveStart; // 휴학 시작일(선택)
    LocalDate leaveEnd;   // 휴학 종료일(선택)
}
