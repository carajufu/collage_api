package kr.ac.collage_api.certificates.service;

import java.util.List;

import kr.ac.collage_api.certificates.vo.CertRenderVO;
import kr.ac.collage_api.certificates.vo.CrtfIssuRequestVO;
import kr.ac.collage_api.certificates.vo.CrtfKndVO;

/**
 * CertDocxService
 *
 * [코드 의도]
 * - 증명서 발급 비즈니스 표준 인터페이스.
 * - 컨트롤러는 이 계약만 의존.
 *
 * [데이터 흐름]
 * - 입력: 증명서 코드, 학번, 선택 파라미터(사유, 휴학기간)
 * - 처리: 메타 조회 → 학생 데이터 조회 →(선택) 발급 로그 → 템플릿 렌더 → PDF 변환
 * - 출력: PDF 바이트 또는 메타 정보
 *
 * [계약]
 * - generateCertificatePdf는 null 반환 금지.
 */
public interface CertDocxService {

    // 증명서 메타 단건
    CrtfKndVO selectById(String crtfKndNo);

    // 증명서 메타 전체
    List<CrtfKndVO> selectAll();

    /**
     * PDF 생성(옵션 객체 시그니처, 컨트롤러와 정합).
     * @param acntId   로그인 계정
     * @param stdntNo  학번
     * @param crtfKndNo 증명서 코드
     * @param options  사유 및 휴학기간 등 선택 파라미터
     * @return PDF bytes
     */
    byte[] generateCertificatePdf(
            String acntId,
            String stdntNo,
            String crtfKndNo,
            CertRenderVO certRenderVO
    ) throws Exception;

    // 다운로드 파일명 결정
    String resolveDownloadFileName(String crtfKndNo);

    // 발급 이력 단건
    CrtfIssuRequestVO getIssueRequestInfo(String crtfIssuInnb);

    // 학번 기반 모든 발급 기록
    List<CrtfIssuRequestVO> stdntNoSelectALL(String stdntNo);
}
