<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<!-- 전역 docx css -->
<link rel="stylesheet" href="<c:url value='${pageContext.request.contextPath}/css/docx.css'/>">

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="#"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item active" aria-current="page">증명서 발급 이력</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">증명서 발급 이력</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row">
    <div class="col-xxl-12 col-12">
        <div class="docx-history-page">
            <!-- 학생 기본 정보 -->
            <div class="box">
                <h3>학생 기본 정보</h3>
                <div class="row-2col">
                    <div>
                        <label>학번</label>
                        <input type="text" value="<c:out value='${studentDocxVO2.studentNo}'/>" readonly />
                    </div>
                    <div>
                        <label>성명(한글)</label>
                        <input type="text" value="<c:out value='${studentDocxVO2.studentNameKor}'/>" readonly />
                    </div>
                </div>
                <div class="row-2col">
                    <div>
                        <label>생년월일</label>
                        <input type="text" value="<c:out value='${studentDocxVO2.birthDeKor}'/>" readonly />
                    </div>
                    <div>
                        <label>전공 / 학과(부)</label>
                        <input type="text" value="<c:out value='${studentDocxVO2.majorName}'/>" readonly />
                    </div>
                </div>
                <div class="hint">
                    &#160;&#160;증명서 발급 내역과 문서번호는 본인 확인 및 진위 검증 용도로만 사용.
                </div>
            </div>

            <!-- 발급 이력 -->
            <div class="box">
                <h3>증명서 발급 이력</h3>

                <!-- 문서번호 검색 + 진위 확인 -->
                <div class="search-row">
                    <label for="searchDocNo">문서번호 조회</label>
                    <input type="text"
                           id="searchDocNo"
                           placeholder="예: REQ2025..."
                           maxlength="20"
                           oninput="handleDocNoInput()" />
                    <button type="button" class="btn-verify" onclick="verifyDocNo()">진위 확인</button>
                    <span id="docNoMsg"></span>
                </div>

                <div class="table-wrap">
                    <table class="issue-table">
                        <thead>
                        <tr>
                            <th>문서번호</th>
                            <th>증명서 종류</th>
                            <th>요청일</th>
                            <th>발급일</th>
                            <th>상태</th>
                        </tr>
                        </thead>
                        <tbody id="issueTableBody">
                        <c:if test="${empty CrtfIssuRequestVOlist}">
                            <tr>
                                <td colspan="5">발급 이력이 없습니다.</td>
                            </tr>
                        </c:if>

                        <c:forEach var="row" items="${CrtfIssuRequestVOlist}">
                            <tr>
                                <td data-col="docNo" class="doc-no">
                                    <c:out value="${row.crtfIssuInnb}"/>
                                </td>
                                <td><c:out value="${row.crtfKndNm}"/></td>
                                <td><c:out value="${row.reqstDtKor}"/></td>
                                <td><c:out value="${row.issuDtKor}"/></td>
                                <td><c:out value="${row.issuSttus}"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>

<script>
  /* 통합 스크립트: 문서번호 필터·검증 + 종류/파일명 매핑 후 테이블 보강 */

  /* 1) 상수 */
  const MAX_DOCNO = 20;
  const DOC_KIND = Object.freeze({
    D03: "재학증명서",
    D04: "졸업증명서",
    D02: "휴학증명서",
    D01: "성적증명서"
  });
  const DOC_PDF_NAME = Object.freeze({
    D03: "재학증명서.pdf",
    D04: "졸업증명서.pdf",
    D02: "휴학증명서.pdf",
    D01: "성적증명서.pdf"
  });

  /* 2) 매핑 유틸 */
  function docKindFromKey(key) {
    const k = (key ?? "").toString().trim().toUpperCase();
    for (const p of Object.keys(DOC_KIND)) {
      if (k.startsWith(p)) return DOC_KIND[p];
    }
    return "기타";
  }
  function docPdfNameFromKey(key) {
    const k = (key ?? "").toString().trim().toUpperCase();
    for (const p of Object.keys(DOC_PDF_NAME)) {
      if (k.startsWith(p)) return DOC_PDF_NAME[p];
    }
    return "문서.pdf";
  }

  /* 3) 테이블 보강: 종류 미기재 시 문서번호로 추론, 행에 pdfName 데이터 부여 */
  document.addEventListener('DOMContentLoaded', () => {
    const rows = document.querySelectorAll('#issueTableBody tr');
    rows.forEach(row => {
      const docCell = row.querySelector('td[data-col="docNo"]');
      if (!docCell) return;

      const key = (docCell.textContent || '').trim();
      const kindCell = row.cells[1]; // 2번째 컬럼: "증명서 종류"
      const curKind = (kindCell?.textContent || '').trim();

      if (kindCell && !curKind) {
        kindCell.textContent = docKindFromKey(key);
      }
      row.dataset.pdfName = docPdfNameFromKey(key);
    });
  });

  /* 4) 필터 */
  function filterByDocNo() {
    const kw = (document.getElementById('searchDocNo').value || '').trim().toUpperCase();
    const rows = document.querySelectorAll('#issueTableBody tr');

    rows.forEach(row => {
      const cell = row.querySelector('td[data-col="docNo"]');
      if (!cell) return;
      const txt = (cell.textContent || '').trim().toUpperCase();

      // "발급 이력이 없습니다." 행 유지
      if (!txt && row.cells.length === 1) {
        row.style.display = kw ? 'none' : '';
      }

      row.style.display = (!kw || txt.includes(kw)) ? '' : 'none';
    });
  }

  /* 5) 입력 핸들러 */
  function handleDocNoInput() {
    const el  = document.getElementById('searchDocNo');
    const msg = document.getElementById('docNoMsg');
    const len = el.value.length;

    if (len > MAX_DOCNO) {
      el.value = el.value.slice(0, MAX_DOCNO);
    }

    if (len === 0) {
      msg.textContent = '';
      msg.style.color = '#6c757d';
    } else if (len < MAX_DOCNO) {
      msg.textContent = len + ' / 20자';
      msg.style.color = '#6c757d';
    } else { // len == MAX_DOCNO
      msg.textContent = '20자 입력 완료';
      msg.style.color = '#0d6efd';
    }

    filterByDocNo();
  }

  /* 6) Enter 제출 → 진위 확인 */
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Enter' && document.activeElement.id === 'searchDocNo') {
      e.preventDefault();
      verifyDocNo();
    }
  });

  /* 7) 진위 확인 */
  async function verifyDocNo() {
    const input = document.getElementById('searchDocNo');
    const raw = (input.value || '').trim().toUpperCase();

    if (!/^[A-Z0-9]{20}$/.test(raw)) {
      alert('형식 오류: 20자 영문/숫자만 허용');
      return;
    }

    try {
      const url = '/certificates/verify?docNo=' + encodeURIComponent(raw);
      const res = await fetch(url, { method: 'GET' });

      if (!res.ok) {
        alert('검증 실패: 서버 응답 오류');
        return;
      }

      const data = await res.json();
      alert(data.valid ? '검증 결과: 유효 (등록 이력 확인)' : '검증 결과: 무효 (등록 이력 없음)');
    } catch (e) {
      console.error(e);
      alert('검증 실패: 네트워크 또는 시스템 오류');
    }
  }
</script>