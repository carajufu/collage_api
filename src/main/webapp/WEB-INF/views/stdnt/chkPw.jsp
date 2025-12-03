<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const pwInput = document.getElementById("password");
    if (pwInput) pwInput.focus();
});

async function doPwCheck() {

    const pwd = document.getElementById("password").value.trim();
    const stdntNo = "${stdntNo}"; 

    if (!pwd) {
        return Swal.fire({
            icon: "error",
            text: "비밀번호를 입력하세요."
        });
    }

    const fd = new FormData();
    fd.append("stdntNo", stdntNo);
    fd.append("password", pwd);

    const res = await fetch("/stdnt/main/info/pwCheck", {
        method: "POST",
        body: fd
    });

    const result = (await res.text()).trim();

    if (result !== "success") {
        return Swal.fire({
            icon: "error",
            text: "비밀번호가 올바르지 않습니다."
        });
    }
    location.href = "/stdnt/main/info";
}
</script>

<div class="d-flex justify-content-center align-items-center" style="min-height: 70vh;">
    <div class="card shadow-sm border-0" style="max-width: 360px; width:100%;">
        
        <div class="card-header bg-white text-center border-0">
            <h5 class="mt-2 mb-2">비밀번호 확인</h5>
        </div>

        <div class="card-body">

            <label class="form-label">비밀번호를 입력하세요</label>
            <input type="password"
                   id="password"
                   class="form-control mb-3"
                   placeholder="비밀번호">

            <button type="button"
                    onclick="doPwCheck()"
                    class="btn btn-primary w-100">
                확인
            </button>

        </div>

    </div>
</div>

<%@ include file="../footer.jsp" %>
