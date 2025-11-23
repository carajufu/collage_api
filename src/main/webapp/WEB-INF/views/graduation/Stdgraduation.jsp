<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

<script>
document.addEventListener("DOMContentLoaded", function() {
  const btnReqGradu = document.querySelector("#btnReqGradu");
  const modalEl = document.querySelector("#selectStudentModal");
  const chkAgree = document.querySelector("#chkAgree");
  const btnSubmitGrad = document.querySelector("#btnSubmitGrad");

  // 졸업 유형 선택(모달 밖)
  const gradTypeSelect = document.querySelector("#gradTypeSelect");
  const gradTypeOtherInput = document.querySelector("#gradTypeOtherInput");
  const gradTypeSummary = document.querySelector("#gradTypeSummary"); // 모달 내 요약 표시에 사용

  if (gradTypeSelect && gradTypeOtherInput) {
    const syncSummary = () => {
      const type = gradTypeSelect.value || "미선택";
      const other = gradTypeOtherInput.value?.trim();
      gradTypeSummary.textContent = (type === "기타" && other) ? `${type} (${other})` : type;
    };
    gradTypeSelect.addEventListener("change", () => {
      gradTypeOtherInput.style.display = (gradTypeSelect.value === '기타') ? 'block' : 'none';
      if (gradTypeSelect.value !== '기타') gradTypeOtherInput.value = "";
      syncSummary();
    });
    gradTypeOtherInput.addEventListener("input", syncSummary);
    syncSummary();
  }

  if (btnReqGradu && modalEl) {
    btnReqGradu.addEventListener("click", () => {
      // 신청 전 유효성: 유형 선택 필수
      const type = gradTypeSelect ? gradTypeSelect.value : "";
      const other = gradTypeOtherInput ? gradTypeOtherInput.value.trim() : "";
      if (!type) { alert("졸업 유형을 선택하세요."); gradTypeSelect.focus(); return; }
      if (type === "기타" && !other) { alert("기타 사유를 입력하세요."); gradTypeOtherInput.focus(); return; }
      new bootstrap.Modal(modalEl).show();
    });
  }

  if (chkAgree && btnSubmitGrad) {
    chkAgree.addEventListener("change", () => {
      btnSubmitGrad.disabled = !chkAgree.checked;
    });
  }

  if (btnSubmitGrad) {
    btnSubmitGrad.addEventListener("click", function() {
      // 모달 내 사유
      const reasonInput = document.querySelector("#reqstResnInput");
      const reason = reasonInput ? reasonInput.value.trim() : "";
      if (!reason) { alert("신청 사유를 입력하세요."); reasonInput.focus(); return; }

      // 모달 밖의 졸업 유형
      const gradType = gradTypeSelect ? gradTypeSelect.value : "";
      const gradTypeOther = gradTypeOtherInput ? gradTypeOtherInput.value.trim() : "";

      let fullReason = reason;
      if (gradType === '기타' && gradTypeOther) fullReason += ` (${gradTypeOther})`;
      else if (gradType) fullReason += ` (${gradType})`;

      const formData = new FormData();
      formData.append('reqstResn', fullReason);

      btnSubmitGrad.disabled = true;
      btnSubmitGrad.innerText = "처리 중...";

      fetch('/stdnt/gradu/main/request', { method: 'POST', body: formData })
        .then(resp => resp.text())
        .then(data => {
          if (data === 'success') {
            alert('졸업 신청이 완료되었습니다.');
            location.reload();
          } else {
            alert('졸업 신청 실패: ' + data);
            btnSubmitGrad.disabled = false;
            btnSubmitGrad.innerText = "졸업 신청";
          }
        })
        .catch(error => {
          alert("신청 중 오류: " + error.message);
          btnSubmitGrad.disabled = false;
          btnSubmitGrad.innerText = "졸업 신청";
        });
    });
  }
});
</script>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">학사 정보</a></li>
            <li class="breadcrumb-item active" aria-current="page">졸업 현황</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">졸업 현황</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>
<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">

    <table class="table table-bordered align-middle mb-4">
      <tbody>
        <tr><th class="table-light" style="width:20%;">학번</th><td>${stdntNo}</td></tr>
        <tr><th class="table-light">이름</th><td>${stdntInfo.stdntNm}</td></tr>
        <tr><th class="table-light">학과</th><td>${stdntInfo.subjctNm}</td></tr>
        <tr><th class="table-light">학적상태</th><td>${stdntInfo.sknrgsSttus}</td></tr>
      </tbody>
    </table>

    <div class="border rounded p-3 mb-4">
      <label class="form-label fw-bold mb-2">졸업 유형 선택</label>
      <div class="d-flex gap-3">
        <select id="gradTypeSelect" class="form-select" style="width:200px;">
          <option value="">선택하세요</option>
          <option value="졸업시험">졸업시험</option>
          <option value="졸업작품">졸업작품</option>
          <option value="졸업논문">졸업논문</option>
          <option value="기타">기타</option>
        </select>
        <input type="text" id="gradTypeOtherInput" class="form-control" style="display:none;" placeholder="예: 자격증 대체">
      </div>
      <div class="small text-muted mt-2">모달에서 선택 결과를 확인한 뒤 신청을 완료합니다.</div>
    </div>
    
    
    
    <c:choose>
      <c:when test="${empty graduinfo}"> 
      		
        <c:choose>
          <c:when test="${not ( (requirements.totalPnt >= requirements.MIN_TOTAL_PNT)
                              and (requirements.majorPnt >= requirements.MIN_MAJOR_PNT)
                              and (requirements.liberalPnt >= requirements.MIN_LIBERAL_PNT)
                              and (requirements.foreignLangCount >= requirements.MIN_FOREIGN_LANG) )}">
	          <div class="alert alert-success mb-3">모든 요건 충족 → 졸업 신청 가능</div>
	          <button id="btnReqGradu" class="btn btn-primary">졸업 신청하기</button>
          </c:when>
          <c:otherwise>
             <div class="alert alert-danger mb-3">졸업 요건 미충족 → 신청 불가</div>
             <button id="btnReqGradu" class="btn btn-warning" disabled>졸업 신청하기 (불가)</button>
          </c:otherwise>
        </c:choose>
      </c:when>

      <c:when test="${graduinfo.reqstSttus == '신청'}">
        <div class="alert alert-info mb-3">승인 대기중</div>
        <p><strong>신청일:</strong> <fmt:formatDate value="${graduinfo.changeReqstDt}" pattern="yyyy-MM-dd"/></p>
        <p><strong>사유:</strong> ${graduinfo.reqstResn}</p>
      </c:when>

      <c:when test="${graduinfo.reqstSttus == '승인'}">
        <div class="alert alert-success mb-3">졸업 최종 승인</div>
        <p><strong>승인일:</strong> <fmt:formatDate value="${graduinfo.confmComptDt}" pattern="yyyy-MM-dd"/></p>
      </c:when>

      <c:when test="${graduinfo.reqstSttus == '반려'}">
        <div class="alert alert-danger mb-3">반려됨 (재신청 가능)</div>
        <p><strong>반려사유:</strong> ${graduinfo.returnResn}</p>
        <c:if test="${ (requirements.totalPnt >= requirements.MIN_TOTAL_PNT)
                   and (requirements.majorPnt >= requirements.MIN_MAJOR_PNT)
                   and (requirements.liberalPnt >= requirements.MIN_LIBERAL_PNT)
                   and (requirements.foreignLangCount >= requirements.MIN_FOREIGN_LANG) }">
          <button id="btnReqGradu" class="btn btn-primary mt-2">졸업 다시 신청하기</button>
        </c:if>
      </c:when>
    </c:choose>

    <hr class="my-4">

    <h5 class="fw-bold mb-3">졸업 요건 충족 현황</h5>
    <table class="table table-bordered align-middle text-center">
      <thead class="table-light">
        <tr><th>항목</th><th>진행률</th><th>상태</th></tr>
      </thead>
      <tbody>
      
        <tr>
          <td>총 이수학점</td>
          <td>
            <div class="progress" style="height:22px;">
              <c:set var="pntPct" value="${(requirements.totalPnt >= requirements.MIN_TOTAL_PNT) ? 100 : (requirements.totalPnt * 100.0 / requirements.MIN_TOTAL_PNT)}"/>
              <div class="progress-bar ${(requirements.totalPnt >= requirements.MIN_TOTAL_PNT) ? 'bg-primary' : 'bg-danger'}"
                   style="width:${pntPct}%; min-width:24%;">
                ${requirements.totalPnt}/${requirements.MIN_TOTAL_PNT} 학점
              </div>
            </div>
          </td>
          <td>${(requirements.totalPnt >= requirements.MIN_TOTAL_PNT) ? '<span class="text-primary fw-semibold">충족</span>' : '<span class="text-danger fw-semibold">미충족</span>'}</td>
        </tr>

        <tr>
          <td>전공필수 이수학점</td>
          <td>
            <div class="progress" style="height:22px;">
              <c:set var="majorPct" value="${(requirements.majorPnt >= requirements.MIN_MAJOR_PNT) ? 100 : (requirements.majorPnt * 100.0 / requirements.MIN_MAJOR_PNT)}"/>
              <div class="progress-bar ${(requirements.majorPnt >= requirements.MIN_MAJOR_PNT) ? 'bg-primary' : 'bg-danger'}"
                   style="width:${majorPct}%; min-width:24%;">
                ${requirements.majorPnt}/${requirements.MIN_MAJOR_PNT} 학점
              </div>
            </div>
          </td>
          <td>${(requirements.majorPnt >= requirements.MIN_MAJOR_PNT) ? '<span class="text-primary fw-semibold">충족</span>' : '<span class="text-danger fw-semibold">미충족</span>'}</td>
        </tr>

        <tr>
          <td>교양필수 이수학점</td>
          <td>
            <div class="progress" style="height:22px;">
              <c:set var="libPct" value="${(requirements.liberalPnt >= requirements.MIN_LIBERAL_PNT) ? 100 : (requirements.liberalPnt * 100.0 / requirements.MIN_LIBERAL_PNT)}"/>
              <div class="progress-bar ${(requirements.liberalPnt >= requirements.MIN_LIBERAL_PNT) ? 'bg-primary' : 'bg-danger'}"
                   style="width:${libPct}%; min-width:24%;">
                ${requirements.liberalPnt}/${requirements.MIN_LIBERAL_PNT} 학점
              </div>
            </div>
          </td>
          <td>${(requirements.liberalPnt >= requirements.MIN_LIBERAL_PNT) ? '<span class="text-primary fw-semibold">충족</span>' : '<span class="text-danger fw-semibold">미충족</span>'}</td>
        </tr>

        <tr>
          <td>외국어 이수</td>
          <td>
            <div class="progress" style="height:22px;">
              <c:set var="flPct" value="${(requirements.foreignLangCount >= requirements.MIN_FOREIGN_LANG) ? 100 : (requirements.foreignLangCount * 100.0 / requirements.MIN_FOREIGN_LANG)}"/>
              <div class="progress-bar ${(requirements.foreignLangCount >= requirements.MIN_FOREIGN_LANG) ? 'bg-primary' : 'bg-danger'}"
                   style="width:${flPct}%; min-width:24%;">
                ${requirements.foreignLangCount}/${requirements.MIN_FOREIGN_LANG} 과목
              </div>
            </div>
          </td>
          <td>${(requirements.foreignLangCount >= requirements.MIN_FOREIGN_LANG) ? '<span class="text-primary fw-semibold">충족</span>' : '<span class="text-danger fw-semibold">미충족</span>'}</td>
        </tr>
      </tbody>
    </table>

    <div class="text-end mt-4">
      <button class="btn btn-secondary" onclick="history.back()">뒤로가기</button>
    </div>

    </div>
</div>

<div class="modal fade" id="selectStudentModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title">졸업 신청서 작성</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">

        <table class="table table-bordered align-middle mb-4">
          <tbody>
            <tr>
              <th class="table-light" style="width:20%;">선택한 졸업 유형</th>
              <td id="gradTypeSummary">미선택</td>
            </tr>
          </tbody>
        </table>

        <table class="table table-bordered text-center mb-4">
          <thead class="table-light">
            <tr><th>신청일</th><th>신청 사유</th></tr>
          </thead>
          <tbody>
            <tr>
              <td><fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd"/></td>
              <td><input type="text" id="reqstResnInput" class="form-control" value="졸업 요건 충족"></td>
            </tr>
          </tbody>
        </table>

        <div class="row mb-4">
          <div class="col">
            <label class="form-label fw-bold">지도교수 상담</label>
            <div>
              <c:choose>
                <c:when test="${not empty stdConsult}">
                  <span class="text-primary">[${stdConsult[0].profsrNm}] ${stdConsult[0].REQST_DE} 상담완료</span>
                </c:when>
                <c:otherwise>
                  <span class="text-danger">지도교수 상담 이력이 없습니다.</span>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="col">
            <label class="form-label fw-bold">연락처</label>
            <input type="text" class="form-control" value="${stdntInfo.cttpc}" readonly>
          </div>
          <div class="col">
            <label class="form-label fw-bold">이메일</label>
            <input type="text" class="form-control" value="${stdntInfo.acntId}@university.com" readonly>
          </div>
        </div>

        <div class="form-check mb-2">
          <input class="form-check-input" type="checkbox" id="chkAgree">
          <label class="form-check-label" for="chkAgree">졸업 신청 내용에 동의합니다.</label>
        </div>
      </div>

      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
        <button id="btnSubmitGrad" class="btn btn-primary" disabled>졸업 신청</button>
      </div>

    </div>
  </div>
</div>
<%@ include file="../footer.jsp" %>