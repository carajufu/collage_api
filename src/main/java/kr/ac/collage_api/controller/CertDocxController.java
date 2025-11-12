package kr.ac.collage_api.controller;

import kr.ac.collage_api.mapper.CertDocxMapper;
import kr.ac.collage_api.mapper.DitAccountMapper;
import kr.ac.collage_api.mapper.StudentDocxMapper;
import kr.ac.collage_api.service.CertDocxService;
import kr.ac.collage_api.service.impl.StudentDocxServiceImpl;
import kr.ac.collage_api.vo.CertRenderVO;
import kr.ac.collage_api.vo.CrtfIssuRequestVO;
import kr.ac.collage_api.vo.CrtfKndVO;
import kr.ac.collage_api.vo.StudentDocxVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;

/**
 * 증명서 발급/조회 Controller.
 *
 * [접근 정책]
 * - /certificates/DocxForm         : 로그인 + ROLE_STUDENT 만 접근 가능
 * - /certificates/{crtfKndNo}     : 로그인 + ROLE_STUDENT 만 PDF 발급 가능
 * - /certificates/DocxHistory     : 로그인 사용자만 조회 가능
 * - /certificates/verify?docNo=   : DocxHistory의 호출로 사용, 제3자 진위 확인용, 별도 권한 제한 없음
 *
 * [응답 정책]
 * - View 메소드:
 *      인증/권한 실패 시 ResponseStatusException 으로 401/403 반환 (null 금지)
 * - PDF/JSON 메소드:
 *      유효하지 않은 요청에 대해 명시적인 400/401/403/500 ResponseEntity 반환
 */
@Slf4j
@Controller
@RequestMapping("/certificates")
@RequiredArgsConstructor
public class CertDocxController {

    private final CertDocxService certDocxService;
    private final CertDocxMapper certDocxMapper;
    private final StudentDocxMapper studentDocxMapper;
    private final StudentDocxServiceImpl studentDocxServiceImpl;
    private final DitAccountMapper ditAccountMapper;

    /**
     * 증명서 발급 신청 화면.
     * - 학생 본인 기본정보 + 발급 가능 증명서 목록 노출.
     * - 학생 외 접근 시 403.
     */
    @GetMapping("/DocxForm")
    public String certDocxPage(Model model, Principal principal) {

        // 1) 인증 검증
        if (principal == null || principal.getName() == null) {
            log.warn("[CertDocx] GET /DocxForm : unauthenticated access");
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }

        String acntId = principal.getName();
        String role = ditAccountMapper.findAuthoritiesByAcntId(acntId);

        // 2) 권한 검증: 학생만 허용
        if (!"ROLE_STUDENT".equals(role)) {
            log.warn("[CertDocx] GET /DocxForm : forbidden. acntId={}, role={}", acntId, role);
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "학생만 이용 가능한 서비스입니다.");
        }

        // 3) 학생 기본 정보 조회
        StudentDocxVO base = studentDocxMapper.selectStudentBasic(acntId);
        if (base == null) {
            log.warn("[CertDocx] GET /DocxForm : student not found. acntId={}", acntId);
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "학생 정보가 존재하지 않습니다.");
        }

        // 4) 학위명 등 2차 가공
        StudentDocxVO studentDocxVO = studentDocxServiceImpl.postProcessDegreeName(base);

        // 5) 발급 가능 증명서 목록
        List<CrtfKndVO> crtfList = certDocxMapper.selectAllCrtfKnd();

        model.addAttribute("studentDocxVO", studentDocxVO);
        model.addAttribute("crtfList", crtfList);

        return "certificates/DocxForm";
    }

    /**
     * 증명서 PDF 발급.
     *
     * [제한]
     * - ROLE_STUDENT 학생 본인만 호출 가능.
     * - 휴학 증명서(LEAVE)인 경우 leaveStart/leaveEnd 형식 및 기간 검증.
     *
     * [성공 시]
     * - Content-Type: application/pdf
     * - Content-Disposition: attachment; filename*=UTF-8''{파일명}.pdf
     *
     * [실패 시]
     * - 400: 파라미터 오류, 학생 정보 없음
     * - 401: 비로그인
     * - 403: 학생이 아님
     * - 500: 내부 오류
     */
    @ResponseBody
    @GetMapping(value = "/{crtfKndNo}", produces = MediaType.APPLICATION_PDF_VALUE)
    public ResponseEntity<?> downloadCertificatePdf(
            @PathVariable("crtfKndNo") String crtfKndNo,
            @RequestParam(value = "reason", required = false) String reason,
            @RequestParam(value = "leaveStart", required = false) String leaveStart,
            @RequestParam(value = "leaveEnd", required = false) String leaveEnd,
            Principal principal
    ) {
        log.info("[CertDocx] GET /certificates/{} requested. reason={}, leaveStart={}, leaveEnd={}",
                crtfKndNo, safe(reason), leaveStart, leaveEnd);

        try {
            // 1) 인증 검증
            if (principal == null || principal.getName() == null) {
                log.warn("[CertDocx] downloadCertificatePdf : unauthenticated access");
                return unauthorized("로그인이 필요합니다.");
            }

            String acntId = principal.getName();
            String role = ditAccountMapper.findAuthoritiesByAcntId(acntId);

            // 2) 권한 검증: 학생만 허용
            if (!"ROLE_STUDENT".equals(role)) {
                log.warn("[CertDocx] downloadCertificatePdf : forbidden. acntId={}, role={}", acntId, role);
                return forbidden("학생만 이용 가능한 서비스입니다.");
            }

            // 3) 학생 기본 정보 조회
            StudentDocxVO base = studentDocxMapper.selectStudentBasic(acntId);
            if (base == null) {
                log.warn("[CertDocx] downloadCertificatePdf : student not found. acntId={}", acntId);
                return badRequest("학생 정보가 존재하지 않습니다.");
            }

            StudentDocxVO student = studentDocxServiceImpl.postProcessDegreeName(base);

            // 4) 휴학 증명서인 경우에만 기간 파싱/검증
            LocalDate s = null;
            LocalDate e = null;
            if (isLeaveCert(crtfKndNo)) {
                try {
                    if (notBlank(leaveStart)) s = LocalDate.parse(leaveStart);
                    if (notBlank(leaveEnd))   e = LocalDate.parse(leaveEnd);
                } catch (DateTimeParseException ex) {
                    log.warn("[CertDocx] downloadCertificatePdf : invalid leave period format. start={}, end={}",
                            leaveStart, leaveEnd);
                    return badRequest("휴학 기간 형식 오류 (yyyy-MM-dd)");
                }

                if (s != null && e != null && s.isAfter(e)) {
                    log.warn("[CertDocx] downloadCertificatePdf : leaveEnd before leaveStart. start={}, end={}",
                            s, e);
                    return badRequest("휴학 종료일이 시작일보다 빠를 수 없습니다.");
                }
            }

            // 5) 렌더 옵션 구성
            CertRenderVO opts = CertRenderVO.builder()
                    .reason(blankToNull(reason))
                    .leaveStart(s)
                    .leaveEnd(e)
                    .build();

            // 6) PDF 생성 서비스 호출 (학생 본인 stdntNo 사용)
            byte[] pdfBytes = certDocxService.generateCertificatePdf(
                    acntId, student.getStudentNo(), crtfKndNo, opts);

            // 7) 다운로드 파일명 인코딩
            String downloadName = certDocxService.resolveDownloadFileName(crtfKndNo);
            String encodedName = URLEncoder.encode(downloadName, StandardCharsets.UTF_8)
                    .replace("+", "%20");

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.set(HttpHeaders.CONTENT_DISPOSITION,
                    "attachment; filename*=UTF-8''" + encodedName);

            return ResponseEntity.ok().headers(headers).body(pdfBytes);

        } catch (IllegalArgumentException iae) {
            // 비즈니스 로직에서 던진 검증 오류
            log.warn("[CertDocx] downloadCertificatePdf : validation failed. msg={}", iae.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .contentType(MediaType.TEXT_PLAIN)
                    .body(iae.getMessage());
        } catch (Exception ex) {
            // 예상치 못한 내부 오류
            log.error("[CertDocx] downloadCertificatePdf : internal error", ex);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.TEXT_PLAIN)
                    .body("PDF 생성 중 오류가 발생했습니다.");
        }
    }
    @GetMapping("/DocxHistory")
    public String certDocxHistory(Principal principal, Model model) {
        if (principal == null || principal.getName() == null) throw new IllegalStateException("인증 필요");
        final String acntId = principal.getName();

        StudentDocxVO base = studentDocxMapper.selectStudentBasic(acntId);
        if (base == null) throw new IllegalArgumentException("학생 정보 없음");
        StudentDocxVO student = studentDocxServiceImpl.postProcessDegreeName(base);

        List<CrtfIssuRequestVO> list = certDocxService.stdntNoSelectALL(student.getStudentNo());
        model.addAttribute("CrtfIssuRequestVOlist", list);
        model.addAttribute("studentDocxVO2", student);
        return "certificates/DocxHistory";
    }

    /**
     * 문서번호 진위 확인.
     * - QR/번호 조회용. 학생 전용이 아님.
     * - 단순히 존재 여부만 true/false 로 응답.
     */
    @ResponseBody
    @GetMapping(value = "/verify", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> verifyDocNo(@RequestParam("docNo") String docNo) {
        boolean valid = certDocxMapper.existsByDocNo(docNo) > 0;
        return Map.of("valid", valid, "docNo", docNo);
    }

    // ==== 내부 유틸 메소드 ====

    private static boolean isLeaveCert(String crtfKndNo) {
        return "LEAVE".equalsIgnoreCase(crtfKndNo);
    }

    private static boolean notBlank(String s) {
        return s != null && !s.isBlank();
    }

    private static String blankToNull(String v) {
        return (v == null || v.isBlank()) ? null : v;
    }

    private static String safe(String v) {
        return v == null ? "null" : v;
    }

    private static ResponseEntity<String> badRequest(String msg) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .contentType(MediaType.TEXT_PLAIN)
                .body(msg);
    }

    private static ResponseEntity<String> unauthorized(String msg) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .contentType(MediaType.TEXT_PLAIN)
                .body(msg);
    }

    private static ResponseEntity<String> forbidden(String msg) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .contentType(MediaType.TEXT_PLAIN)
                .body(msg);
    }
}