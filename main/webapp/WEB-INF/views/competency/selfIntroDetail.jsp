<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%@ include file="../header.jsp" %>

<div class="card-header">
    <h3 class="fw-bold fs-3">자기소개서 이어쓰기 & 버전관리</h3>
</div>

<div class="card-body">

    <!-- 저장된 자소서 목록 -->
    <div class="mb-3">

        <c:if test="${not empty manageList}">
            <ul class="list-group mb-3" style="max-height: 320px; overflow-y: auto;">

                <c:forEach var="item" items="${manageList}" varStatus="st">
                    <li class="list-group-item list-group-item-action manage-item py-2"
                        style="cursor:pointer;"
                        data-id="${item.formId}"
                        data-cn="${fn:escapeXml(item.manageCn)}">

                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="text-muted small">버전 ${st.count}</span>
                        </div>

                        <div class="small text-truncate" style="max-width: 100%;">
                            ${fn:substring(item.manageCn, 0, 40)}...
                        </div>
                    </li>
                </c:forEach>

            </ul>

            <div class="form-text">
                목록에서 항목을 클릭하면 아래에 내용이 표시됩니다.
            </div>
        </c:if>
    </div>


    <!-- 내용 표시 영역 -->
    <div class="col-md-12">

        <div class="mb-3">
            <label class="form-label fw-bold">자기소개서 내용</label>
            <textarea id="manageCnArea"
                      class="form-control"
                      rows="18"
                      placeholder="왼쪽 목록에서 버전을 선택하세요."></textarea>
        </div>

        <!-- 삭제 form -->
        <form id="delManageCnForm"
              action="${pageContext.request.contextPath}/compe/detail/delete"
              method="post"
              class="d-inline">

            <input type="hidden" name="formId" id="selectedFormId">

            <button type="submit" class="btn btn-danger btn-sm me-2">
                선택 버전 삭제
            </button>
        </form>

        <div class="card-header d-flex align-items-center">
            <a href="${pageContext.request.contextPath}/compe/main"
               class="btn btn-primary btn-sm ms-auto">자기소개서 생성으로 돌아가기</a>
        </div>

    </div>

</div>

<script>

// 선택 시 내용 + formId 저장
document.querySelectorAll(".manage-item").forEach(function(item) {

    item.addEventListener("click", function () {

        // 기존 선택 해제
        document.querySelectorAll(".manage-item").forEach(i => i.classList.remove("active"));

        // 선택된 항목 활성화
        this.classList.add("active");

        // 내용 출력
        const content = this.getAttribute("data-cn");
        document.getElementById("manageCnArea").value = content;

        // 삭제할 formId 저장
        const formId = this.getAttribute("data-id");
        document.getElementById("selectedFormId").value = formId;
    });
});


// 삭제 확인
document.getElementById("delManageCnForm").addEventListener("submit", function(e) {

    const formId = document.getElementById("selectedFormId").value;

    if (!formId) {
        alert("삭제할 버전을 선택하세요.");
        e.preventDefault();
        return;
    }

    if (!confirm("정말 삭제하시겠습니까?")) {
        e.preventDefault();
    }
});

</script>

<%@ include file="../footer.jsp" %>
