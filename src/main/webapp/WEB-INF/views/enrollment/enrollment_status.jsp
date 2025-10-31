<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>

<div class="content-area" id="main-content">
    <h2 class="section-title">대시보드</h2>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="card card-custom p-3">
                <h5>현재 학기</h5>
                <p class="text-muted mb-0">${currentSemester}</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card card-custom p-3">
                <h5>나의 학적 상태</h5>
                <p class="text-muted mb-0">${stdntInfo.sknrgsSttus}</p>
            </div>
        </div>
    </div>

    <hr class="my-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="section-title mb-0">학적 변동 신청 내역</h2>
        <a href="/enrollment/change" class="btn btn-primary">휴학/복학 신청하기</a>
    </div>
    
    <div class="card card-custom p-4">
        <table class="table table-hover text-center">
            <thead class="table-light">
                <tr>
                    <th>신청 종류</th>
                    <th>신청 학기</th>
                    <th>신청일</th>
                    <th>처리 상태</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${historyList}" var="history">
                    <tr>
                        <td>${history.changeTy} (${history.tmpabssklTy})</td>
                        <td>${history.efectOccrrncSemstr.split('-')[0]}년 ${history.efectOccrrncSemstr.split('-')[1]}학기</td>
                        <td><fmt:formatDate value="${history.changeReqstDt}" pattern="yyyy-MM-dd" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${history.reqstSttus == '승인'}">
                                    <span class="badge bg-success">승인</span>
                                </c:when>
                                <c:when test="${history.reqstSttus == '반려'}">
                                    <span class="badge bg-danger">반려</span>
                                </c:when>
<%--                                <c:when>--%>
<%--                                	<span class="badge bd-warning text-datk">처리중</span>--%>
<%--                                </c:when>--%>
                                <c:otherwise>
                                    <span class="badge bg-secondary">신청</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <button type="button" class="btn btn-sm btn-outline-secondary" 
                                    data-bs-toggle="modal" data-bs-target="#detailsModal"
                                    data-reqst-resn="${history.reqstResn}"
                                    data-return-resn="${history.returnResn}"
                                    data-status="${history.reqstSttus}">
                                자세히 보기
                            </button>
                            
                            <c:if test="${history.reqstSttus == '신청'}">
                                <a href="/enrollment/cancel?reqId=${history.sknrgsChangeInnb}" class="btn btn-sm btn-outline-danger">신청 취소</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                
                <c:if test="${empty historyList}">
                    <tr>
                        <td colspan="5" class="py-5">신청 내역이 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="detailsModal" tabindex="-1" aria-labelledby="detailsModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="detailsModalLabel">신청 상세 정보</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <h6>신청 사유</h6>
        <p id="modalReqstResn"></p>
        <hr>
        <div id="modalReturnSection">
            <h6>반려 사유</h6>
            <p id="modalReturnResn" class="text-danger"></p>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
</main>

<%@ include file="../footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var detailsModal = document.getElementById('detailsModal');
    detailsModal.addEventListener('show.bs.modal', function (event) {
        // 모달을 트리거한 버튼
        var button = event.relatedTarget;
        
        // data-* 속성에서 정보 추출
        var reqstResn = button.getAttribute('data-reqst-resn');
        var returnResn = button.getAttribute('data-return-resn');
        var status = button.getAttribute('data-status');

        // 모달 내용 업데이트
        var modalReqstResn = detailsModal.querySelector('#modalReqstResn');
        var modalReturnSection = detailsModal.querySelector('#modalReturnSection');
        var modalReturnResn = detailsModal.querySelector('#modalReturnResn');
        
        modalReqstResn.textContent = reqstResn || '작성된 사유가 없습니다.';
        
        // 반려 상태일 때만 반려 사유를 보여줌
        if (status === '반려' && returnResn) {
            modalReturnSection.style.display = 'block';
            modalReturnResn.textContent = returnResn;
        } else {
            modalReturnSection.style.display = 'none';
        }
    });
});
</script>