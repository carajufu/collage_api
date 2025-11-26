<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script type="text/javascript">
document.addEventListener("DOMContentLoaded", function () {

  /* -------------------------
     주소 검색
  ------------------------- */
  window.execDaumPostcode = function () {
    new daum.Postcode({
      oncomplete: function (data) {
        let addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
        let extraAddr = '';

        if (data.userSelectedType === 'R') {
          if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) extraAddr += data.bname;
          if (data.buildingName !== '' && data.apartment === 'Y')
            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
          if (extraAddr !== '') extraAddr = ' (' + extraAddr + ')';
        }

        document.getElementById("zipcode").value = data.zonecode;
        document.getElementById("bassAdres").value = addr + extraAddr;
        document.getElementById("detailAdres").focus();
      }
    }).open();
  };

  /* -------------------------
     수정 버튼 처리
  ------------------------- */
  const editBtn   = document.getElementById("editBtn");
  const cancelBtn = document.getElementById("cancelBtn");
  const saveBtn   = document.getElementById("saveBtn");
  const inputs    = document.querySelectorAll(".editable");

  editBtn.addEventListener("click", function () {
    inputs.forEach(el => el.removeAttribute("readonly"));
    editBtn.style.display = "none";
    saveBtn.style.display = "inline-block";
    cancelBtn.style.display = "inline-block";
  });

  cancelBtn.addEventListener("click", function () {
    inputs.forEach(el => el.setAttribute("readonly", "readonly"));
    editBtn.style.display = "inline-block";
    saveBtn.style.display = "none";
    cancelBtn.style.display = "none";
  });

  /* -------------------------
      이미지 미리보기
  ------------------------- */
  const uploadFile = document.querySelector("#uploadFile");
  const previewImg = document.querySelector("#previewImg");

  uploadFile.addEventListener("change", function () {
    if (this.files && this.files[0]) {
      const reader = new FileReader();
      reader.onload = function (e) {
        previewImg.src = e.target.result;
      };
      reader.readAsDataURL(this.files[0]);
    }
  });

  /* -------------------------
      비밀번호 확인 모달 관련
  ------------------------- */
  let pwFailCount = 0;

  const pwCheckModal = new bootstrap.Modal(document.getElementById("pwCheckModal"));
  const pwCheckInput = document.getElementById("pwCheckInput");
  const pwCheckBtn   = document.getElementById("pwCheckBtn");

  saveBtn.addEventListener("click", function () {
    pwCheckModal.show();
  });

  pwCheckBtn.addEventListener("click", async function () {

    const stdntNo = document.querySelector("[name='stdntNo']").value;
    const pwd     = pwCheckInput.value.trim();

    if (!pwd) {
      alert("비밀번호를 입력해 주십시오.");
      return;
    }

    const formData = new FormData();
    formData.append("stdntNo", stdntNo);
    formData.append("password", pwd);

    const res = await fetch("/stdnt/main/info/pwCheck", {
      method: "POST",
      body: formData
    });

    const result = (await res.text()).trim();

    if (result !== "success") {
      pwFailCount++;
      if (pwFailCount >= 3) {
          Swal.fire({
              icon: 'error',
              text: "비밀번호 3회 오류. 정보 수정이 제한됩니다.",
              confirmButtonColor: '#222E83',
              confirmButtonText: '확인'
          });
        pwCheckModal.hide();
        pwCheckInput.value = "";
        return;
      }
        Swal.fire({
            icon: 'error',
            text: "비밀번호가 일치하지 않습니다.",
            confirmButtonColor: '#222E83',
            confirmButtonText: '확인'
        });
      pwCheckInput.value = "";
      return;
    }

    // 비밀번호 확인 성공 → 저장 실행
    pwCheckModal.hide();
    doSaveInfo();
  });

  /* -------------------------
      정보 저장 실행 함수
  ------------------------- */
  async function doSaveInfo() {

    const data = {
      stdntNo: document.querySelector("[name='stdntNo']").value,
      brthdy: document.querySelector("[name='brthdy']").value,
      bassAdres: document.querySelector("[name='bassAdres']").value,
      detailAdres: document.querySelector("[name='detailAdres']").value,
      zip: document.querySelector("[name='zip']").value,
      cttpc: document.querySelector("[name='cttpc']").value,
      emgncCttpc: document.querySelector("[name='emgncCttpc']").value,
      bankNm: document.querySelector("[name='bankNm']").value,
      acnutno: document.querySelector("[name='acnutno']").value
    };

    /* 기본 정보 저장 */
    const res = await fetch("/stdnt/main/info/update", {
      method: "POST",
      headers: { "Content-Type": "application/json;charset=utf-8" },
      body: JSON.stringify(data)
    });

    const result = await res.text();
    if (result.trim() !== "success") {
        Swal.fire({
            icon: 'error',
            text: "정보 수정 중 오류가 발생했습니다.",
            confirmButtonColor: '#222E83',
            confirmButtonText: '확인'
        });
      return;
    }

    /* 이미지 업로드 */
    if (uploadFile.files.length > 0) {
      const formData = new FormData();
      formData.append("uploadFile", uploadFile.files[0]);
      formData.append("stdntNo", data.stdntNo);

      await fetch("/stdnt/main/info/uploadFile", {
        method: "POST",
        body: formData
      });
    }

      Swal.fire({
          icon: 'success',
          title: '저장되었습니다',
          text: '입력하신 내용이 성공적으로 저장되었습니다.',
          confirmButtonColor: '#222E83',
          confirmButtonText: '확인'
      })
          .then(() => location.href = "/stdnt/main/info");
  }
});
</script>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item active" aria-current="page">개인 정보 수정</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">개인 정보 수정</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">

    <form>

      <div class="row g-3 mb-4">

        <!-- 왼쪽 정보 카드 -->
        <div class="col-md-8">
          <div class="card">
            <div class="card-header">학생 기본 정보</div>
            <div class="card-body">

              <div class="row g-3">

                <div class="col-md-6">
                  <label class="form-label">학번</label>
                  <input type="text" class="form-control" name="stdntNo" value="${stdntInfo.stdntNo}" readonly>
                </div>

                <div class="col-md-6">
                  <label class="form-label">이름</label>
                  <input type="text" class="form-control" name="stdntNm" value="${stdntInfo.stdntNm}" readonly>
                </div>

                <div class="col-md-6">
                  <label class="form-label">생년월일</label>
                  <input type="text" class="form-control editable" name="brthdy" value="${stdntInfo.brthdy}" maxlength="8" readonly>
                </div>

                <div class="col-md-6">
                  <label class="form-label">연락처</label>
                  <input type="text" class="form-control editable" name="cttpc" value="${stdntInfo.cttpc}" readonly>
                </div>

                <div class="col-md-6">
                  <label class="form-label">비상연락처</label>
                  <input type="text" class="form-control editable" name="emgncCttpc" value="${stdntInfo.emgncCttpc}" readonly>
                </div>

                <div class="col-md-6">
                  <label class="form-label">은행명</label>
                  <input type="text" class="form-control editable" name="bankNm" value="${stdntInfo.bankNm}" readonly>
                </div>

                <div class="col-md-6">
                  <label class="form-label">계좌번호</label>
                  <input type="text" class="form-control editable" name="acnutno" value="${stdntInfo.acnutno}" readonly>
                </div>

                <div class="col-md-4">
                  <label class="form-label">우편번호</label>
                  <div class="input-group">
                    <input type="text" id="zipcode" name="zip" class="form-control editable" value="${stdntInfo.zip}" readonly>
                    <button type="button" onclick="execDaumPostcode()" class="btn btn-outline-primary">찾기</button>
                  </div>
                </div>

                <div class="col-md-8">
                  <label class="form-label">주소</label>
                  <input type="text" id="bassAdres" name="bassAdres" class="form-control editable" value="${stdntInfo.bassAdres}" readonly>
                </div>

                <div class="col-md-12">
                  <label class="form-label">상세주소</label>
                  <input type="text" id="detailAdres" name="detailAdres" class="form-control editable" value="${stdntInfo.detailAdres}" readonly>
                </div>

              </div>
            </div>
          </div>
        </div>

        <!-- 오른쪽 프로필 이미지 카드 -->
        <div class="col-md-4">
          <div class="card">
            <div class="card-header">프로필 이미지</div>
            <div class="card-body text-center">
              <c:choose>
				  <c:when test="${not empty profileImageUrl}">
				    <img id="previewImg"
				         src="${profileImageUrl}"
				         style="width:150px;height:150px;object-fit:cover;border-radius:50%;border:1px solid #ddd;">
				  </c:when>
				
				  <c:otherwise>
				    <img id="previewImg"
				         src="/static/assets/images/users/user-dummy-img.jpg"
				         style="width:150px;height:150px;object-fit:cover;border-radius:50%;border:1px solid #ddd;">
				  </c:otherwise>
				</c:choose>
              <input type="file" id="uploadFile" name="uploadFile" class="form-control mt-3">
            </div>
          </div>
        </div>

      </div>

      <div class="text-end">
        <button type="button" id="editBtn" class="btn btn-primary">정보 수정</button>
        <button type="button" id="cancelBtn" class="btn btn-danger" style="display:none;">수정 취소</button>
        <button type="button" id="saveBtn" class="btn btn-primary" style="display:none;">정보 저장</button>
      </div>

    </form>

    </div>
</div>

<!-- 비밀번호 확인 모달 -->
<div class="modal fade" id="pwCheckModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title">비밀번호 확인</h5>
      </div>

      <div class="modal-body">
        <input type="password" id="pwCheckInput" class="form-control" placeholder="비밀번호 입력">
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">취소</button>
        <button type="button" id="pwCheckBtn" class="btn btn-primary">확인</button>
      </div>

    </div>
  </div>
</div>

<%@ include file="../footer.jsp" %>
