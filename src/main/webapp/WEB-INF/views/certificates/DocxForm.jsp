<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="../header.jsp" %>
<!-- 전역 docx css -->
<link rel="stylesheet" href="<c:url value='${pageContext.request.contextPath}/css/docx.css'/>">

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">제증명 발급</a></li>
            <li class="breadcrumb-item active" aria-current="page">발급</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">발급</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row">
    <div class="col-xxl-12 col-12">
        <div class="docx-form-page">

            <div class="box">
                <h3>신청자 정보</h3>
                <div class="row-2col">
                    <div>
                        <label>학번</label>
                        <input type="text" value="<c:out value='${studentDocxVO.studentNo}'/>" readonly />
                    </div>
                    <div>
                        <label>이름</label>
                        <input type="text" value="<c:out value='${studentDocxVO.studentNameKor}'/>" readonly />
                    </div>
                </div>

                <div class="row-2col">
                    <div>
                        <label>전공</label>
                        <input type="text" value="<c:out value='${studentDocxVO.majorName}'/>" readonly />
                    </div>
                    <div>
                        <label>학위명</label>
                        <input type="text" value="<c:out value='${studentDocxVO.degreeName}'/>" readonly />
                    </div>
                </div>

                <div class="row-1col">
                    <label>학적 상태</label>
                    <input type="text" value="<c:out value='${studentDocxVO.status}'/>" readonly />
                    <div class="hint">&#160;&#160;정보가 사실과 다르면 학사행정실에 문의하여 정정 요청할 것</div>
                </div>
            </div>

            <div class="box">
                <h3>발급 요청</h3>

                <form id="certForm" onsubmit="return false;">
                    <label for="crtfKndNo">증명서 종류</label>
                    <select id="crtfKndNo" name="crtfKndNo">
                        <c:forEach var="crtf" items="${crtfList}">
                            <option value="${crtf.crtfKndNo}"
                                    data-name="${crtf.crtfNm}"
                                    data-desc="${crtf.crtfDc}">
                                ${crtf.crtfNm}
                                <c:if test="${crtf.issuFee != null}">
                                    (수수료 ${crtf.issuFee}원)
                                </c:if>
                            </option>
                        </c:forEach>
                    </select>

                    <div class="hint">
                        &#160;&#160;선택한 증명서 설명:
                        <span id="crtfDescArea">
                            <c:out value="${crtfList[0].crtfDc}" />
                        </span>
                    </div>

                    <label for="reasonSelect">발급 사유</label>
                    <select id="reasonSelect" name="reasonSelect"></select>
                    <input type="text" id="reasonCustom" name="reasonCustom"
                           placeholder="직접 입력"
                           style="display:none; margin-top:8px;" />

                    <div id="leaveRangeRow" class="row-2col" style="display:none;">
                        <div>
                            <label for="leaveStart">휴학 시작일</label>
                            <input type="date" id="leaveStart" name="leaveStart">
                        </div>
                        <div>
                            <label for="leaveEnd">휴학 종료일</label>
                            <input type="date" id="leaveEnd" name="leaveEnd">
                            <div class="hint">&#160;&#160;기간 미지정 시 서버 기본 정책 적용</div>
                        </div>
                    </div>

                    <button type="button" class="btn-issue" onclick="issueCert()">
                        <i class="bi bi-file-earmark-pdf-fill"></i>
                        PDF 발급 및 다운로드
                    </button>

                    <button type="button" class="btn-history" onclick="goToHistory()">
                        <i class="bi bi-clock-history"></i>
                        증명서 발급 이력
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>

<script>
    const REASON_PRESETS = {
        "재학증명서": ["병무 제출", "회사 제출", "장학금 신청", "공공기관 제출", "금융사 제출", "기타"],
        "휴학증명서": ["질병 치료", "가사 사유", "취업 준비", "해외 체류", "군입대 예정", "개인 사정 및 기타"],
        "졸업증명서": ["대학원 지원", "해외 비자", "자격증 응시", "취업 증빙", "기타"],
        "성적증명서": ["교환학생", "장학금 신청", "편입 지원", "대학원 지원", "취업 증빙", "기타"]
    };
    const OTHER_VALUE = "__OTHER__";
    const LEAVE_CERT_NAME = "휴학증명서";

    const selectCert   = document.getElementById('crtfKndNo');
    const descEl       = document.getElementById('crtfDescArea');
    const selectReason = document.getElementById('reasonSelect');
    const inputReason  = document.getElementById('reasonCustom');
    const leaveRow     = document.getElementById('leaveRangeRow');
    const leaveStart   = document.getElementById('leaveStart');
    const leaveEnd     = document.getElementById('leaveEnd');

    function populateReasonsByCert() {
        const opt = selectCert.options[selectCert.selectedIndex];
        const certName = opt.getAttribute('data-name') || '';
        const presets = REASON_PRESETS[certName] || ["기타"];

        selectReason.innerHTML = "";
        presets.forEach(r => {
            const o = document.createElement('option');
            o.value = (r === "기타") ? OTHER_VALUE : r;
            o.textContent = r;
            selectReason.appendChild(o);
        });

        inputReason.style.display = (selectReason.value === OTHER_VALUE) ? 'block' : 'none';
        if (inputReason.style.display === 'block') inputReason.focus();
    }

    function toggleLeaveRangeByCert() {
        const opt = selectCert.options[selectCert.selectedIndex];
        const certName = opt.getAttribute('data-name') || '';
        const isLeave = certName === LEAVE_CERT_NAME;
        leaveRow.style.display = isLeave ? 'grid' : 'none';
        if (!isLeave) {
            leaveStart.value = "";
            leaveEnd.value = "";
        }
    }

    selectCert.addEventListener('change', function () {
        const opt = selectCert.options[selectCert.selectedIndex];
        descEl.textContent = opt.getAttribute('data-desc') || '';
        populateReasonsByCert();
        toggleLeaveRangeByCert();
    });

    selectReason.addEventListener('change', function () {
        const isOther = selectReason.value === OTHER_VALUE;
        inputReason.style.display = isOther ? 'block' : 'none';
        if (isOther) inputReason.focus();
    });

    (function init() {
        populateReasonsByCert();
        toggleLeaveRangeByCert();
    })();

    function issueCert() {
        const crtfKndNo = selectCert.value;

        let reason = selectReason.value;
        if (reason === OTHER_VALUE) {
            reason = (inputReason.value || "").trim();
        }

        const params = new URLSearchParams();
        if (reason) params.set('reason', reason);

        if (leaveRow.style.display !== 'none') {
            const s = leaveStart.value;
            const e = leaveEnd.value;
            if (s && e && s > e) {
                alert('휴학 종료일이 시작일보다 빠를 수 없음');
                return;
            }
            if (s) params.set('leaveStart', s);
            if (e) params.set('leaveEnd', e);
        }

        const qs = params.toString() ? ('?' + params.toString()) : '';
        window.location.href = '/certificates/' + encodeURIComponent(crtfKndNo) + qs;
    }

    function goToHistory() {
        window.location.href = '<c:url value="/certificates/DocxHistory"/>';
    }
</script>
