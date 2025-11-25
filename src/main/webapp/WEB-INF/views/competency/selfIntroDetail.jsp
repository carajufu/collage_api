<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
                            <span class="badge bg-primary-subtle text-primary">#${item.formId-1}</span>
                            <span class="text-muted small">버전 ${st.count}</span>
                        </div>

                        <div class="small text-truncate" style="max-width:100%;">
                            ${fn:substring(item.manageCn, 0, 40)}...
                        </div>
                    </li>
                </c:forEach>
            </ul>
            <div class="form-text">
                목록에서 항목을 클릭하면 오른쪽에 내용이 불러옵니다.
            </div>
        </c:if>
    </div>

    <!-- 오른쪽: 내용 수정 영역 -->
    <div class="col-md-12">
        <div class="mb-3">
            <label class="form-label fw-bold">자기소개서 내용</label>
            <textarea id="manageCnArea"
                      class="form-control"
                      rows="18"
                      placeholder="왼쪽 목록에서 버전을 선택하면 내용이 표시됩니다.">
					  ${fn:escapeXml(essay)}
            </textarea>
        </div>

        <!-- 삭제 폼 -->
        <div class="card-header d-flex align-items-center justify-content-end">
		    <form id="delManageCnForm"
		          action="${pageContext.request.contextPath}/compe/detail/delete"
		          method="post"
		          class="d-inline mb-0">
		
		        <input type="hidden" name="formId" id="selectedFormId">
		
		        <button type="submit" class="btn btn-outline-primary btn-sm me-2">
		            선택 버전 삭제
		        </button>
		    </form>
		
		    <a href="${pageContext.request.contextPath}/compe/main"
		       class="btn btn-primary btn-sm">
		        자기소개서 생성으로 돌아가기
		    </a>
		</div>
    </div>
</div>

<script>
document.querySelectorAll(".manage-item").forEach(function(item) {
    item.addEventListener("click", function () {

        const formId  = this.getAttribute("data-id");
        const content = this.getAttribute("data-cn") || "";

        document.getElementById("manageCnArea").value = content;
        document.getElementById("selectedFormId").value = formId;
    });
});

// 삭제 전 확인창 추가
document.getElementById("delManageCnForm").addEventListener("submit", function(e) {

    const fid = document.getElementById("selectedFormId").value;

    if (!fid || fid.trim() === "") {
        alert("삭제할 버전을 먼저 선택해 주세요.");
        e.preventDefault();
        return;
    }

    if (!confirm("정말 삭제하시겠습니까?")) {
        e.preventDefault();
    }
});
</script>

<%@ include file="../footer.jsp" %>
