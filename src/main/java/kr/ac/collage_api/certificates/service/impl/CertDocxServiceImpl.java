package kr.ac.collage_api.certificates.service.impl;

import kr.ac.collage_api.certificates.mapper.CertDocxMapper;
import kr.ac.collage_api.certificates.mapper.StudentDocxMapper;
import kr.ac.collage_api.certificates.service.CertDocxService;
import kr.ac.collage_api.certificates.vo.CertRenderVO;
import kr.ac.collage_api.certificates.vo.CrtfIssuRequestVO;
import kr.ac.collage_api.certificates.vo.StudentDocxVO;
import kr.ac.collage_api.certificates.vo.TranscriptRowVO;
import kr.ac.collage_api.common.util.KorNameTranUtil;
import kr.ac.collage_api.vo.CrtfKndVO;
import lombok.extern.slf4j.Slf4j;

import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Slf4j
@Service
public class CertDocxServiceImpl implements CertDocxService {

    @Autowired
    CertDocxMapper certDocxMapper;

    @Autowired
    StudentDocxMapper studentDocxMapper;

    @Autowired
    StudentDocxServiceImpl studentDocxServiceImpl;

    // 고정 문구
    private static final String UNIV_NAME           = "대한민국대학교";
    private static final String CHANCELLOR_TITLE    = "총장";
    private static final String CHANCELLOR_NAME     = "고길동";
    private static final String DEFAULT_ISSUER_DEPT = "교무처장";

    private static final String UNIV_VERIFY_URL   = "https://example.university";
    private static final String VALID_PERIOD_DESC = "90일간 유효";
    private static final String DEFAULT_DEGREE_NAME = "공학사";

    private static final String TEMPLATE_BASE_CLASSPATH = "/static/cert-templates/";
    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");
    private static final String FONT_CLASSPATH = "/static/fonts/NanumGothic.ttf";
    private static final String FONT_FAMILY    = "NanumGothic";
    private static final ClassPathResource KR_FONT = new ClassPathResource(FONT_CLASSPATH);

    public CertDocxServiceImpl(CertDocxMapper certDocxMapper) {
        this.certDocxMapper = certDocxMapper;
    }

    // ===== 인터페이스 구현 (VO 전용) =====
    @Transactional
    @Override
    public byte[] generateCertificatePdf(
            String acntId,
            String studentNo,
            String crtfKndNo,
            CertRenderVO options
    ) throws Exception {

        // 1. 학생 정보
        StudentDocxVO base = studentDocxMapper.selectStudentBasic(acntId);
        StudentDocxVO st = studentDocxServiceImpl.postProcessDegreeName(base);
        normalizeStudentDefaults(st);

        // 2. 발급요청 INSERT
        final String issuInnb = "REQ" + ZonedDateTime.now().format(FMT);
        final String reasonNorm = nz(options == null ? null : options.getReason(), null);

        CrtfIssuRequestVO req = new CrtfIssuRequestVO();
        req.setCrtfIssuInnb(issuInnb);
        req.setCrtfKndNo(crtfKndNo);
        req.setStdntNo(studentNo);
        req.setReqstDt(LocalDateTime.now());
        req.setIssuSttus("Request");
        req.setIssuResn(reasonNorm);
        certDocxMapper.insertCrtfIssuRequest(req);

        // 3. 템플릿 렌더 HTML 생성
        String html = buildHtmlForCertificate(crtfKndNo, st, options, issuInnb);

        // 4. HTML -> PDF
        byte[] pdfBytes = renderHtmlToPdf(html);

        // 5. 완료 업데이트
        req.setIssuDt(LocalDateTime.now());
        req.setIssuSttus("DONE");
        certDocxMapper.updateCrtfIssuStatus(req);

        return pdfBytes;
    }

    @Override
    public CrtfKndVO selectById(String crtfKndNo) { return certDocxMapper.selectCrtfKndById(crtfKndNo); }

    @Override
    public List<CrtfKndVO> selectAll() { return certDocxMapper.selectAllCrtfKnd(); }

    @Override
    public String resolveDownloadFileName(String crtfKndNo) {
        String key = (crtfKndNo == null ? "" : crtfKndNo.trim().toUpperCase());
        if (key.startsWith("D03")) return "재학증명서.pdf";
        if (key.startsWith("D04"))   return "졸업증명서.pdf";
        if (key.startsWith("D02"))  return "휴학증명서.pdf";
        if (key.startsWith("D01"))  return "성적증명서.pdf";
        throw new IllegalArgumentException("Unknown crtfKndNo: " + crtfKndNo);
    }

    @Override
    public CrtfIssuRequestVO getIssueRequestInfo(String crtfIssuInnb) {
        return certDocxMapper.selectIssueRequestInfo(crtfIssuInnb);
    }

    @Override
    public List<CrtfIssuRequestVO> stdntNoSelectALL(String stdntNo) {
        return certDocxMapper.stdntNoSelectALL(stdntNo);
    }

    // ===== HTML 빌드 =====
    private String buildHtmlForCertificate(
            String crtfKndNo,
            StudentDocxVO st,
            CertRenderVO options,
            String verifyNo
    ) throws IOException {
        String templateFile = resolveTemplateFile(crtfKndNo);
        String rawTemplate = loadTemplateFromClasspath("static/cert-templates/" + templateFile);
        String html = applyCommonPlaceholders(rawTemplate, st, verifyNo);
        html = applyTypeSpecificPlaceholders(html, crtfKndNo, st, options);
        return html;
    }

    private String resolveTemplateFile(String crtfKndNo) {
        String key = (crtfKndNo == null ? "" : crtfKndNo.trim().toUpperCase());
        if (key.startsWith("D03")) return "ENROLL_V1.html";
        if (key.startsWith("D04"))   return "GRAD_V1.html";
        if (key.startsWith("D02"))  return "LEAVE_V1.html";
        if (key.startsWith("D01"))  return "SCORE_V2.html";
        throw new IllegalArgumentException("Unknown crtfKndNo: " + crtfKndNo);
    }

    private String loadTemplateFromClasspath(String path) throws IOException {
        ClassPathResource resource = new ClassPathResource(path);
        try (InputStream is = resource.getInputStream()) {
            return new String(is.readAllBytes(), StandardCharsets.UTF_8);
        }
    }

    // 공통 치환. 휴학 기간은 여기서 치환하지 않음(타입별에서 VO 기반 주입).
    private String applyCommonPlaceholders(String tpl, StudentDocxVO st, String verifyNo) {
        // 졸업일 하드코드 산출
        DateTimeFormatter inFmt = DateTimeFormatter.ofPattern("yyyy.MM.dd[.]");
        LocalDate entrance = LocalDate.parse(st.getEntranceDeKor(), inFmt);
        LocalDate graduation = LocalDate.of(entrance.getYear() + 4, 2, 21); // 02-21 고정
        String graduationDeKor = graduation.format(DateTimeFormatter.ofPattern("yyyy.MM.dd."));

        // 기관·검증
        tpl = rpl(tpl, "{{univName}}", UNIV_NAME);
        tpl = rpl(tpl, "${univName}",  UNIV_NAME);
        tpl = rpl(tpl, "{{chancellorTitle}}", CHANCELLOR_TITLE);
        tpl = rpl(tpl, "${chancellorTitle}",  CHANCELLOR_TITLE);
        tpl = rpl(tpl, "{{chancellorName}}", CHANCELLOR_NAME);
        tpl = rpl(tpl, "${chancellorName}",  CHANCELLOR_NAME);
        tpl = rpl(tpl, "{{univVerifyUrl}}", UNIV_VERIFY_URL);
        tpl = rpl(tpl, "${univVerifyUrl}",  UNIV_VERIFY_URL);
        tpl = rpl(tpl, "{{validPeriodDesc}}", VALID_PERIOD_DESC);
        tpl = rpl(tpl, "${validPeriodDesc}",  VALID_PERIOD_DESC);
        tpl = rpl(tpl, "{{verifyNo}}", verifyNo);
        tpl = rpl(tpl, "${verifyNo}",  verifyNo);

        // 학생 기본
        tpl = rpl(tpl, "{{studentNo}}", st.getStudentNo());
        tpl = rpl(tpl, "${studentNo}",  st.getStudentNo());
        tpl = rpl(tpl, "{{studentNameKor}}", st.getStudentNameKor());
        tpl = rpl(tpl, "${studentNameKor}",  st.getStudentNameKor());

        String engName = nz(st.getStudentNameEng(),
                KorNameTranUtil.resolveDisplayEngName(st.getStudentNameKor(), null));
        tpl = rpl(tpl, "{{studentNameEng}}", engName);
        tpl = rpl(tpl, "${studentNameEng}",  engName);

        tpl = rpl(tpl, "{{birthDeKor}}", st.getBirthDeKor());
        tpl = rpl(tpl, "${birthDeKor}",  st.getBirthDeKor());
        tpl = rpl(tpl, "{{entranceDeKor}}", st.getEntranceDeKor());
        tpl = rpl(tpl, "${entranceDeKor}",  st.getEntranceDeKor());
        tpl = rpl(tpl, "{{majorName}}", st.getMajorName());
        tpl = rpl(tpl, "${majorName}",  st.getMajorName());
        tpl = rpl(tpl, "{{status}}", st.getStatus());
        tpl = rpl(tpl, "${status}",  st.getStatus());
        tpl = rpl(tpl, "{{collegeName}}", nz(st.getCollegeName(), ""));
        String degreeName = nz(st.getDegreeName(), DEFAULT_DEGREE_NAME);
        tpl = rpl(tpl, "{{degreeName}}", degreeName);
        tpl = rpl(tpl, "${degreeName}",  degreeName);
        tpl = rpl(tpl, "{{graduationDate}}", graduationDeKor);
        tpl = rpl(tpl, "${graduationDate}",  graduationDeKor);

        // 발급일
        String issueDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy.MM.dd."));
        tpl = rpl(tpl, "{{issueDate}}", issueDate);
        tpl = rpl(tpl, "${issueDate}",  issueDate);

        log.info("[applyCommonPlaceholders] StudentDocxVO={}", st);
        return tpl;
    }

    // 타입별 치환. 사유(=reason), 휴학기간, 학점 증명 등.
    private String applyTypeSpecificPlaceholders(String tpl, String crtfKndNo, StudentDocxVO st, CertRenderVO options) {
        String key = (crtfKndNo == null ? "" : crtfKndNo.trim().toUpperCase());

        // 공통 reason
        String reason = options == null ? null : options.getReason();
        tpl = rpl(tpl, "{{reason}}", nz(reason, ""));
        tpl = rpl(tpl, "${reason}",  nz(reason, ""));

        // 휴학증명서: 부서/직책 + 기간(VO 우선 주입)
        if (key.startsWith("LEAVE")) {
            tpl = rpl(tpl, "{{issuerDeptOrRole}}", DEFAULT_ISSUER_DEPT);
            tpl = rpl(tpl, "${issuerDeptOrRole}",  DEFAULT_ISSUER_DEPT);

            LocalDate s = options == null ? null : options.getLeaveStart();
            LocalDate e = options == null ? null : options.getLeaveEnd();

            String sKor = fmtKor(s);
            String eKor = fmtKor(e);

            tpl = rpl(tpl, "{{leaveStartDate}}", nz(sKor, ""));
            tpl = rpl(tpl, "${leaveStartDate}",  nz(sKor, ""));
            tpl = rpl(tpl, "{{leaveEndDate}}",   nz(eKor, ""));
            tpl = rpl(tpl, "${leaveEndDate}",    nz(eKor, ""));

            // leaveReason도 동일 값 주입 필요 시
            tpl = rpl(tpl, "{{leaveReason}}", nz(reason, ""));
            tpl = rpl(tpl, "${leaveReason}",  nz(reason, ""));
        } else {
            // 비-휴학생: 빈값 주입
            tpl = rpl(tpl, "{{leaveStartDate}}", "");
            tpl = rpl(tpl, "${leaveStartDate}",  "");
            tpl = rpl(tpl, "{{leaveEndDate}}",   "");
            tpl = rpl(tpl, "${leaveEndDate}",    "");
            tpl = rpl(tpl, "{{leaveReason}}",    "");
            tpl = rpl(tpl, "${leaveReason}",     "");
        }

        // 성적증명서: 표 + 합계
        if (key.startsWith("SCORE")) {
            final String stdntNo = nz(st.getStudentNo(), null);
            final List<kr.ac.collage_api.certificates.vo.TranscriptRowVO> rows =
                    (stdntNo != null) ? certDocxMapper.selectTranscriptRows(stdntNo)
                                      : java.util.Collections.emptyList();

            final String rowsHtml = buildScoreRowsWithCredits(rows);
            tpl = rpl(tpl, "{{scoreRows}}", rowsHtml);
            tpl = rpl(tpl, "${scoreRows}",  rowsHtml);

            final kr.ac.collage_api.certificates.vo.TranscriptSummaryVO summary =
                    (stdntNo != null) ? certDocxMapper.selectTranscriptSummary(stdntNo) : null;

            final String totalCredits = (summary != null && summary.getTotalCredits() != null)
                    ? summary.getTotalCredits().toString() : "";
            final String totalGpa = (summary != null && summary.getTotalGpa() != null)
                    ? summary.getTotalGpa().toString() : "";

            tpl = rpl(tpl, "{{totalCredits}}", totalCredits);
            tpl = rpl(tpl, "${totalCredits}",  totalCredits);
            tpl = rpl(tpl, "{{totalGpa}}",     totalGpa);
            tpl = rpl(tpl, "${totalGpa}",      totalGpa);

            log.info("totalCredits={}, totalGpa={}", totalCredits, totalGpa);
        } else {
            tpl = rpl(tpl, "{{scoreRows}}", "");
            tpl = rpl(tpl, "${scoreRows}",  "");
        }

        return tpl;
    }

    private byte[] renderHtmlToPdf(String html) throws Exception {
        String baseUrl = Objects.requireNonNull(
                this.getClass().getResource(TEMPLATE_BASE_CLASSPATH),
                "cert-template base path not found on classpath").toString();

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfRendererBuilder builder = new PdfRendererBuilder();

        // 폰트(File 경로). fat-jar 배포 시 InputStream 방식 전환 검토.
        File fontFile = new File("src/main/resources/static/fonts/NanumGothic.ttf");
        builder.useFont(fontFile, FONT_FAMILY);

        builder.useFastMode();
        builder.withHtmlContent(html, baseUrl);
        builder.toStream(baos);
        builder.run();
        return baos.toByteArray();
    }
    /**
     * 성적증명서 성적 영역 HTML 생성기.
     *
     * 입력:
     *  - rows: TranscriptRowVO 목록
     *      yearNo    / semNo     : 정렬용 (SQL에서 사용)
     *      termLabel : "2024-2" 형태 학기 라벨
     *      complSe   : 전필/전선/교필/교선/교양 등 이수구분
     *      subjectName, credits, grade
     *
     * 출력:
     *  - SCORE_V2.html 내 {{scoreRows}} 위치에 삽입할 <tr><td>...</td> 구조의 HTML 문자열.
     *
     * 레이아웃 규칙:
     *  1) score-table 는 3열 (thead에 3개 th).
     *  2) 각 열(td) 안에 "학기 블록" 최대 4개까지 쌓는다.
     *  3) 학기 블록:
     *      - 상단: <div class="term-label">[2024-2학기]</div>  (가운데 정렬용)
     *      - 하단: 과목별 <div class="course-line">구분 | 과목명 | 학점 | 성적</div> (좌측 정렬용)
     *  4) 4개 학기 블록을 채우면 다음 열로 넘어감.
     *  5) 3열이 모두 찼으면 </tr> 로 행 닫고 새 행 시작.
     *  6) 마지막 행은 남는 열을 빈 <td>로 채워 그리드 유지.
     *
     * 주의:
     *  - rows 정렬은 SQL에서 yearNo, semNo, subjectName 기준으로 끝내고 여기서는 재정렬하지 않는다.
     *  - escapeHtml / nz 는 상위 유틸 사용 (XSS 및 null 방어).
     */
 // ===== 학점 증명 표 행 렌더러 (3열 / 학기 블록 / 구분|과목명|학점|성적 + 학기요약) =====
    private String buildScoreRowsWithCredits(List<TranscriptRowVO> rows) {
        if (rows == null || rows.isEmpty()) {
            return "<tr><td colspan=\"3\">성적 데이터 없음</td></tr>";
        }

        // 1) 학기별 그룹핑: termLabel 기준 (정렬은 SQL에서 보장)
        Map<String, List<TranscriptRowVO>> byTerm = new LinkedHashMap<>();
        for (TranscriptRowVO r : rows) {
            String term = nz(r.getTermLabel(), "");
            byTerm.computeIfAbsent(term, k -> new ArrayList<>()).add(r);
        }

        StringBuilder sb = new StringBuilder(rows.size() * 64);

        int col = 0;            // 0~2 (3열)
        int termCountInCol = 0; // 현재 열에 들어간 학기 블록 수
        boolean openTr = false; // <tr> 오픈 여부

        // 2) 학기별 블록 렌더링
        for (Map.Entry<String, List<TranscriptRowVO>> e : byTerm.entrySet()) {

            // 열/행 제어
            if (!openTr) {
                sb.append("<tr>");
                openTr = true;
            }
            if (termCountInCol == 0) {
                sb.append("<td>");
            }

            // 2-1) 학기 라벨 [2024-2학기]
            String termLabel = escapeHtml(nz(e.getKey(), ""));
            sb.append("<div class=\"term-label\">[ ")
              .append(termLabel)
              .append("학기 ]</div>");

            // 2-2) 과목 라인 + 학기 누적 계산
            int termEarnedCredits = 0;     // 학기 취득 학점
            double termPointSum = 0.0;     // Σ(gradePoint * 학점)
            int termPointCredits = 0;      // GPA 분모(포인트 계산 대상 학점)

            for (TranscriptRowVO r : e.getValue()) {
                String complSe = escapeHtml(nz(r.getComplSe(), ""));       // 전필/전선/교양...
                String subj    = escapeHtml(nz(r.getSubjectName(), ""));   // 과목명
                Integer c      = r.getCredits();
                String gradeRaw= nz(r.getGrade(), "");
                String grade   = escapeHtml(gradeRaw);

                // 2-2-1) 화면 출력
                sb.append("<div class=\"course-line\">");
                if (!complSe.isEmpty()) {
                    sb.append(complSe).append(" | ");
                }
                sb.append(subj)
                  .append(" | ")
                  .append(c == null ? "" : c.toString())
                  .append(" | ")
                  .append(grade);
                sb.append("</div>");

                // 2-2-2) 학기 합계 / 평점 계산용
                if (c != null && c > 0) {
                    Double gp = mapGradePoint(gradeRaw);
                    if (gp != null) {
                        // GPA 계산용 분자/분모
                        termPointSum     += gp * c;
                        termPointCredits += c;
                        // 취득 학점: F, NP, W 등은 미취득 처리
                        if (isPassGrade(gradeRaw)) {
                            termEarnedCredits += c;
                        }
                    }
                }
            }

            // 2-3) 학기 요약 라인: 학기 취득학점 / 학기 평점평균
            if (termPointCredits > 0) {
                double gpa = termPointSum / termPointCredits;
                sb.append("<div class=\"term-label\">")
                  .append("&#160;취득학점: ")
                  .append(termEarnedCredits)
                  .append("&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;평점평균: ")
                  .append(String.format(java.util.Locale.US, "%.2f", gpa))
                  .append("</div>");
            } else {
                // 유효한 성적 없는 학기: 취득/평점 표기 생략 또는 0 처리 선택 가능
                sb.append("<div class=\"course-line term-summary\">")
                  .append("학기 취득학점: 0 | 학기 평점평균: -")
                  .append("</div>");
            }

            sb.append("<br/>"); // 학기 블록 간 간격
            termCountInCol++;

            // 한 열에 학기 4개 → 열 닫고 다음 열
            if (termCountInCol >= 4) {
                sb.append("</td>");
                col++;
                termCountInCol = 0;
            }

            // 3열 모두 사용 → 행 닫고 초기화
            if (col >= 3) {
                sb.append("</tr>");
                openTr = false;
                col = 0;
                termCountInCol = 0;
            }
        }

        // 3) 마지막 행 정리
        if (openTr) {
            if (termCountInCol > 0) {
                sb.append("</td>");
                col++;
            }
            while (col < 3) {
                sb.append("<td></td>");
                col++;
            }
            sb.append("</tr>");
        }

        return sb.toString();
    }


    //=========학점 관련 보조 유틸=========
	/**
	 * 학점등급 → 평점 변환
	 * - 기본 4.5 만점 체계 가정
	 * - P: GPA 계산 제외
	 * - F/NP/W/I: 0.0 처리 (Pass 실패/포기 과목)
	 * - 필요 시 학교 규정에 따라 수정
	 */
	private Double mapGradePoint(String gradeRaw) {
	    if (gradeRaw == null) return null;
	    String g = gradeRaw.trim().toUpperCase();
	
	    switch (g) {
	        case "A+": return 4.5;
	        case "A0": return 4.0;
	        case "B+": return 3.5;
	        case "B0": return 3.0;
	        case "C+": return 2.5;
	        case "C0": return 2.0;
	        case "D+": return 1.5;
	        case "D0": return 1.0;
	        case "F":
	        case "NP":
	        case "W":
	        case "I":
	            return 0.0;
	        case "P":
	            // Pass 과목: 취득학점은 인정할 수 있으나 GPA에는 미반영
	            return null;
	        default:
	            // 정의되지 않은 등급: GPA 미반영
	            return null;
	    }
	}
	
	/**
	 * 취득학점으로 인정할 등급 여부
	 * - F/NP/W/I는 미취득
	 * - P는 취득으로 볼지 여부는 제도에 따라 갈리므로 여기서는 취득 인정(true)로 처리.
	 *   (학교 규정 다르면 여기만 수정)
	 */
	private boolean isPassGrade(String gradeRaw) {
	    if (gradeRaw == null) return false;
	    String g = gradeRaw.trim().toUpperCase();
	    switch (g) {
	        case "F":
	        case "NP":
	        case "W":
	        case "I":
	            return false;
	        default:
	            return true;
	    }
	}
    // ===== HTML 이스케이프 유틸 =====
    private static String escapeHtml(String s) {
        if (s == null) return "";
        String out = s;
        out = out.replace("&", "&amp;");
        out = out.replace("<", "&lt;");
        out = out.replace(">", "&gt;");
        out = out.replace("\"", "&quot;");
        out = out.replace("'", "&#39;");
        return out;
    }

    // ===== 보조 유틸 =====
    private static String fmtKor(LocalDate d) {
        return d == null ? null : d.format(DateTimeFormatter.ofPattern("yyyy.MM.dd."));
    }

    private void normalizeStudentDefaults(StudentDocxVO st) {
        if (st.getDegreeName() == null || st.getDegreeName().isBlank()) {
            st.setDegreeName(DEFAULT_DEGREE_NAME);
        }
    }

    private String rpl(String tpl, String key, String value) {
        if (value == null) value = "";
        return tpl.replace(key, value);
    }

    private String nz(String v, String def) {
        if (v == null || v.isBlank()) return def;
        return v;
    }

    private String nz(Object v, String def) {
        if (v == null) return def;
        String s = v.toString();
        if (s == null || s.isBlank()) return def;
        return s;
    }
}
