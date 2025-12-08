<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
let pageLangData = {};

async function loadPageLanguage() {
    const lang = localStorage.getItem("language") || "kr";
    const contextPath = "${pageContext.request.contextPath}";
    const url = contextPath + "/assets/lang/" + lang + ".json";

    try {
        const response = await fetch(url);
        if (response.ok) {
            pageLangData = await response.json();
        }
    } catch(e) {
        console.error("언어 JSON fetch 오류:", e);
    }
}

async function ensureLangLoaded() {
    if (!pageLangData || Object.keys(pageLangData).length === 0) {
        await loadPageLanguage();
    }
}

function getLangText(key){
    return pageLangData[key] || key;
}

function applyLang(){
    document.querySelectorAll("[data-key]").forEach(el => {
        el.textContent = getLangText(el.dataset.key);
    });

    document.querySelectorAll("[data-placeholder-key]").forEach(el => {
        el.placeholder = getLangText(el.dataset.placeholderKey);
    });
}

document.addEventListener("DOMContentLoaded", async () => {
    await loadPageLanguage();
    initPage();
    applyLang();
});
</script>

<script>
	
function initPage() {

    const editBtn     = document.getElementById("editBtn");
    const cancelBtn   = document.getElementById("cancelBtn");
    const saveBtn     = document.getElementById("saveBtn");
    const inputs      = document.querySelectorAll(".editable");
    const uploadFile  = document.querySelector("#uploadFile");
    const previewImg  = document.querySelector("#previewImg");
	
    editBtn?.addEventListener("click", () => {
        inputs.forEach(el => el.removeAttribute("readonly"));
        editBtn.style.display = "none";
        saveBtn.style.display = "inline-block";
        cancelBtn.style.display = "inline-block";
    });

    cancelBtn?.addEventListener("click", () => {
        inputs.forEach(el => el.setAttribute("readonly", "readonly"));
        editBtn.style.display   = "inline-block";
        saveBtn.style.display   = "none";
        cancelBtn.style.display = "none";
    });
	
    uploadFile?.addEventListener("change", () => {
        if (uploadFile.files && uploadFile.files[0]) {
            const reader = new FileReader();
            reader.onload = e => (previewImg.src = e.target.result);
            reader.readAsDataURL(uploadFile.files[0]);
        }
    });

    saveBtn?.addEventListener("click", () => {
        doSaveInfo();
    });

    async function doSaveInfo() {

        const data = {
            stdntNo     : document.querySelector("[name='stdntNo']").value,
            brthdy      : document.querySelector("[name='brthdy']").value,
            bassAdres   : document.querySelector("[name='bassAdres']").value,
            detailAdres : document.querySelector("[name='detailAdres']").value,
            zip         : document.querySelector("[name='zip']").value,
            cttpc       : document.querySelector("[name='cttpc']").value,
            emgncCttpc  : document.querySelector("[name='emgncCttpc']").value,
            bankNm      : document.querySelector("[name='bankNm']").value,
            acnutno     : document.querySelector("[name='acnutno']").value
        };

        const res = await fetch("/stdnt/main/info/update", {
            method : "POST",
            headers: { "Content-Type": "application/json" },
            body   : JSON.stringify(data)
        });

        const result = (await res.text()).trim();

        if (result !== "success") {
            await ensureLangLoaded();
            return Swal.fire({
                icon : "error",
                text : getLangText("t-msg-save-fail")
            });
        }
        if (uploadFile && uploadFile.files.length > 0) {
            const fd = new FormData();
            fd.append("uploadFile", uploadFile.files[0]);
            fd.append("stdntNo", data.stdntNo);
            await fetch("/stdnt/main/info/uploadFile", { method: "POST", body: fd });
        }

        await ensureLangLoaded();
        Swal.fire({
            icon : "success",
            title: getLangText("t-msg-save-success-title"),
            text : getLangText("t-msg-save-success")
        }).then(() => {
            location.href = "/stdnt/main/info";
        });
    }
}
</script>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="/dashboard/student" data-key="t-breadcrumb-home">
                    <i class="las la-home"></i>
                </a>
            </li>
            <li class="breadcrumb-item active" aria-current="page" data-key="t-breadcrumb-studentInfoModify"></li>
        </ol>
    </nav>

    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold" data-key="t-title-studentInfoModify"></h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>


<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">

        <form>

            <div class="row g-3 mb-4">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header" data-key="t-card-studentBasicInfo"></div>
                        <div class="card-body">

                            <div class="row g-3">

                                <div class="col-md-6">
                                    <label class="form-label" data-key="t-label-studentNo"></label>
                                    <input type="text" class="form-control" name="stdntNo" value="${stdntInfo.stdntNo}" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label" data-key="t-label-studentName"></label>
                                    <input type="text" class="form-control" name="stdntNm" value="${stdntInfo.stdntNm}" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label" data-key="t-label-birthDate"></label>
                                    <input type="text" class="form-control editable" name="brthdy" value="${stdntInfo.brthdy}" maxlength="8" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label" data-key="t-label-phone"></label>
                                    <input type="text" class="form-control editable" name="cttpc" value="${stdntInfo.cttpc}" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label" data-key="t-label-emergencyPhone"></label>
                                    <input type="text" class="form-control editable" name="emgncCttpc" value="${stdntInfo.emgncCttpc}" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label" data-key="t-label-bankName"></label>
                                    <input type="text" class="form-control editable" name="bankNm" value="${stdntInfo.bankNm}" readonly>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label" data-key="t-label-accountNo"></label>
                                    <input type="text" class="form-control editable" name="acnutno" value="${stdntInfo.acnutno}" readonly>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label" data-key="t-label-zipcode"></label>
                                    <div class="input-group">
                                        <input type="text" id="zipcode" name="zip" class="form-control editable" value="${stdntInfo.zip}" readonly>
                                        <button type="button" onclick="execDaumPostcode()" class="btn btn-outline-primary" data-key="t-btn-findAddress"></button>
                                    </div>
                                </div>

                                <div class="col-md-8">
                                    <label class="form-label" data-key="t-label-address"></label>
                                    <input type="text" id="bassAdres" name="bassAdres" class="form-control editable" value="${stdntInfo.bassAdres}" readonly>
                                </div>

                                <div class="col-md-12">
                                    <label class="form-label" data-key="t-label-detailAddress"></label>
                                    <input type="text" id="detailAdres" name="detailAdres" class="form-control editable" value="${stdntInfo.detailAdres}" readonly>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card">
                        <div class="card-header" data-key="t-card-profileImage"></div>
                        <div class="card-body text-center">

                            <c:choose>
                                <c:when test="${not empty profileImageUrl}">
                                    <img id="previewImg" src="${profileImageUrl}"
                                         style="width:150px;height:150px;object-fit:cover;border-radius:50%;border:1px solid #ddd;">
                                </c:when>
                                <c:otherwise>
                                    <img id="previewImg" src="/static/assets/images/users/user-dummy-img.jpg"
                                         style="width:150px;height:150px;object-fit:cover;border-radius:50%;border:1px solid #ddd;">
                                </c:otherwise>
                            </c:choose>

                            <input type="file" id="uploadFile" name="uploadFile" class="form-control mt-3">
                        </div>
                    </div>
                </div>

            </div>

            <div class="text-end">
                <button type="button" id="editBtn" class="btn btn-primary" data-key="t-btn-editInfo"></button>
                <button type="button" id="cancelBtn" class="btn btn-danger" style="display:none;" data-key="t-btn-cancelEdit"></button>
                <button type="button" id="saveBtn" class="btn btn-primary" style="display:none;" data-key="t-btn-saveInfo"></button>
            </div>

        </form>

    </div>
</div>

<%@ include file="../footer.jsp" %>
