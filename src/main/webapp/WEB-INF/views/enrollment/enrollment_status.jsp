<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>

<div class="content-area" id="main-content">
    <h2 class="section-title">대시보드</h2>

    <div class="row g-4 mb-4">
	    <div class="col-md-3">
	        <div class="card card-custom p-3">
	            <h5>정보</h5>
	            <p class="text-muted mb-0">${stdntInfo.stdntNm} (${stdntInfo.stdntNo})</p>
	        </div>
	    </div>
	    <div class="col-md-3">
	        <div class="card card-custom p-3">
	            <h5>소속</h5>
	            <p class="text-muted mb-0">${stdntInfo.subjctVO.subjctNm}</p>
	        </div>
	    </div>
	    <div class="col-md-3">
	        <div class="card card-custom p-3">
	            <h5>학년 / 학기</h5>
	            <p class="text-muted mb-0">${stdntInfo.grade}학년 / ${currentSemester}</p>
	        </div>
	    </div>
	    <div class="col-md-3">
	        <div class="card card-custom p-3">
	            <h5>학적 상태</h5>
	            <p class="text-muted mb-0">
	               ${stdntInfo.sknrgsSttus}
	            </p>
	        </div>
	    </div>
	</div>

    <hr class="my-4">
    
    <%-- 학적 변동 내역 --%>
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="section-title mb-0">공식 학적 변동 내역</h2>
        <div>
            <button type="button" class="btn btn-outline-secondary me-2" 
                    data-bs-toggle="modal" data-bs-target="#applicationHistoryModal">
                신청 내역 조회
            </button>
            <a href="/enrollment/change" class="btn btn-primary">휴학/복학 신청하기</a>
        </div>
    </div>
    
    <div class="card card-custom p-4">
        <table class="table text-center">
            <thead class="table-light">
                <tr>
                    <th>변동 구분</th>
                    <th>적용 학기</th>
                    <th>처리 일자</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${officialList}" var="item">
                    <tr>
                        <td>${item.changeTy}</td>
                        <td>${item.efectOccrrncSemstr.split('-')[0]}년 ${item.efectOccrrncSemstr.split('-')[1]}학기</td>
                        <td><fmt:formatDate value="${item.changeReqstDt}" pattern="yyyy-MM-dd" /></td>
                    </tr>
                </c:forEach>
                
                <fmt:parseDate value="${stdntInfo.entschDe}" pattern="yyyyMMdd" var="admissionDate" />
                <fmt:formatDate value="${admissionDate}" pattern="MM" var="admissionMonth" />
                
                <tr>
				    <td>입학</td>
				    <td>
		            <fmt:formatDate value="${admissionDate}" pattern="yyyy" />년 
		            <c:choose>
		                <c:when test="${admissionMonth >= 3 && admissionMonth <= 8}">
		                    1학기
		                </c:when>
		                <c:otherwise>
		                    2학기
		                </c:otherwise>
		            </c:choose>
		        </td>
		        <td>
		            <fmt:formatDate value="${admissionDate}" pattern="yyyy-MM-dd" />
		        </td>
		    </tr>                
                <c:if test="${empty officialList}">
                    <tr>
                        <td colspan="3" class="py-5">공식 학적 변동 내역이 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div> 


<%-- 신청 내역 조회--%>
<div class="modal fade" id="applicationHistoryModal" tabindex="-1" aria-labelledby="applicationHistoryModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="applicationHistoryModalLabel">학적 변동 신청 내역</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      
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
							    <c:when test="${history.reqstSttus == '처리중'}"> 
							        <span class="badge bg-warning text-dark">처리중</span>
							    </c:when>
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
                                    data-status="${history.reqstSttus}"
                                    data-change-ty="${history.changeTy} (${history.tmpabssklTy})"
                                    data-semester="${history.efectOccrrncSemstr.split('-')[0]}년 ${history.efectOccrrncSemstr.split('-')[1]}학기">
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
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>


<%-- 상세보기 --%>
<div class="modal fade" id="detailsModal" tabindex="-1" aria-labelledby="detailsModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="detailsModalLabel">신청 상세 정보</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
	    <div class="mb-3">
	        <span class="badge bg-primary me-2" id="modalChangeTy"></span>
	        <span class="text-muted" id="modalSemester"></span>
	    </div>	
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

<%@ include file="../footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', function () {
    var detailsModal = document.getElementById('detailsModal');
    detailsModal.addEventListener('show.bs.modal', function (event) {

    	var button = event.relatedTarget;
        
        // data-* 속성에서 정보 추출
        var reqstResn = button.getAttribute('data-reqst-resn');
        var returnResn = button.getAttribute('data-return-resn');
        var status = button.getAttribute('data-status');
        
        var changeTy = button.getAttribute('data-change-ty'); 
        var semester = button.getAttribute('data-semester');

        var modalReqstResn = detailsModal.querySelector('#modalReqstResn');
        var modalReturnSection = detailsModal.querySelector('#modalReturnSection');
        var modalReturnResn = detailsModal.querySelector('#modalReturnResn');
        
        detailsModal.querySelector('#modalChangeTy').textContent = changeTy;
        detailsModal.querySelector('#modalSemester').textContent = semester;
        
        modalReqstResn.textContent = reqstResn || '작성된 사유가 없습니다.';
        
        if (status === '반려' && returnResn) {
            modalReturnSection.style.display = 'block';
            modalReturnResn.textContent = returnResn;
        } else {
            modalReturnSection.style.display = 'none';
        }
    });
});
</script>