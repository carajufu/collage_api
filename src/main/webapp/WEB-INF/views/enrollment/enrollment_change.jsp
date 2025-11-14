<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>

<div class="content-area" id="main-content">
<h2 class="section-title">휴학/복학 신청</h2>
    <div class="card card-custom p-4">
        
        <c:if test="${stdntStatus == '재학' || stdntStatus == '휴학'}">
            <form action="/enrollment/change" id="change-form" method="post" enctype="multipart/form-data">
            
             <div class="mb-3">
                <label class="form-label">신청 종류</label>
                <div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="changeTy" id="leave-radio" value="휴학"
                            <c:if test="${stdntStatus == '재학'}">checked</c:if>
                            <c:if test="${stdntStatus != '재학'}">disabled</c:if>>
                        <label class="form-check-label" for="leave-radio">휴학</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="changeTy" id="return-radio" value="복학"
                            <c:if test="${stdntStatus == '휴학'}">checked</c:if>
                            <c:if test="${stdntStatus != '휴학'}">disabled</c:if>>
                        <label class="form-check-label" for="return-radio">복학</label>
                    </div>
                </div>
            </div>
            
			<div class="mb-3" id="leave-semester-group" <c:if test="${stdntStatus != '재학'}">style="display: none;"</c:if>>
			    <label for="leave-semester-select" class="form-label">신청 학기</label>
			    <select class="form-select" name="efectOccrrncSemstr" id="leave-semester-select"> 
			        <option value="" selected>신청할 학기를 선택하세요...</option>
			        <c:forEach items="${leaveSemesters}" var="semester">
			            <option value="${semester}">
			                ${semester.split('-')[0]}년 ${semester.split('-')[1]}학기
			            </option>
			        </c:forEach>
			    </select>
			</div>
			
			<div class="mb-3" id="return-semester-group" <c:if test="${stdntStatus != '휴학'}">style="display: none;"</c:if>>
			    <label for="return-semester-select" class="form-label">신청 학기</label>
			    <select class="form-select" name="efectOccrrncSemstr" id="return-semester-select"> 
			        <option value="" selected>신청할 학기를 선택하세요...</option>
			        <c:forEach items="${returnSemesters}" var="semester">
			            <option value="${semester}">
			                ${semester.split('-')[0]}년 ${semester.split('-')[1]}학기
			            </option>
			        </c:forEach>
			    </select>
			</div>
            
            <div id="leaveFields" <c:if test="${stdntStatus != '재학'}">style="display: none;"</c:if>>
	            <div class="mb-3">
	                <label for="leave-reason" class="form-label">휴학 유형</label>
	                <select class="form-select" id="leave-reason" name="tmpabssklTy">
	                    <option value="" selected>유형을 선택하세요...</option>
	                    <option value="일반">개인 사유</option>
	                    <option value="질병">질병</option>
	                    <option value="군입대">군입대</option>
	                    <option value="기타">기타</option>
	                </select>
	            </div>
	            
	            <div class="mb-3">
	                <label for="leave-details" class="form-label">상세 사유</label>
	                <textarea class="form-control" id="leave-details" name="reqstResn" rows="3" placeholder="상세 사유를 입력하세요."></textarea>
	            </div>
	            
	            <div class="mb-3">
	                <label for="attachment-file" class="form-label">첨부 서류</label>
	                <input type="file" id="attachment-file" name="uploadFile" class="form-control">
	            </div>
            </div>
               
            <button type="submit" id="submit-btn" class="btn btn-primary">신청하기</button>
        </form>
        </c:if>
        
        <c:if test="${stdntStatus != '재학' && stdntStatus != '휴학'}">
            <div class="alert alert-warning" role="alert">
                현재 학적 상태(${stdntStatus})에서는 휴학 또는 복학 신청이 불가능합니다.
            </div>
        </c:if>
        
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {

	const leaveRadio = document.getElementById('leave-radio');
    const returnRadio = document.getElementById('return-radio');
    
    const leaveSemesterGroup = document.getElementById('leave-semester-group');
    const returnSemesterGroup = document.getElementById('return-semester-group');

    const leaveSelect = document.getElementById('leave-semester-select');
    const returnSelect = document.getElementById('return-semester-select');
    
    const leaveFields = document.getElementById('leaveFields');
    const changeForm = document.getElementById('change-form');

    //비활성화 설정
    if (leaveRadio && leaveRadio.checked) {
        if(returnSelect) returnSelect.disabled = true;
    } else if (returnRadio && returnRadio.checked) {
        if(leaveSelect) leaveSelect.disabled = true;
    }
    
    //휴학
    if(leaveRadio) {
        leaveRadio.addEventListener('change', function() {
            if (this.checked) {
                leaveSemesterGroup.style.display = 'block';
                leaveFields.style.display = 'block';
                leaveSelect.disabled = false;  
                
                returnSemesterGroup.style.display = 'none';
                returnSelect.disabled = true;
            }
        });
    }

    //복학
    if(returnRadio) {
        returnRadio.addEventListener('change', function() {
            if (this.checked) {
                returnSemesterGroup.style.display = 'block'; 
                returnSelect.disabled = false; 

                leaveSemesterGroup.style.display = 'none';   
                leaveFields.style.display = 'none';
                leaveSelect.disabled = true;   
            }
        });
    }

    if (!changeForm) {
        return; 
    }

    changeForm.addEventListener('submit', function(event) {
        event.preventDefault();
    	
        const reasonSelect = document.getElementById('leave-reason');
    	
        //유효성 검사
        if (leaveRadio.checked) {
            //휴학
            if (leaveSelect.value === "") {
                Swal.fire('신청 학기를 선택해주세요.');
                return;
            }
            if (reasonSelect.value === "") { 
                Swal.fire('휴학 유형을 선택해주세요.');
                return;
            }
        } else if (returnRadio.checked) {
            //복학
            if (returnSelect.value === "") {
                Swal.fire('신청 학기를 선택해주세요.');
                return;
            }
        }
    	
    	const formData = new FormData(this);
        
    	fetch('/enrollment/change', {
            method: 'POST',
            body: formData 
        })
        .then(response => {
            return response.text().then(message => ({
                ok: response.ok,
                message: message
            }));
        })
        .then(({ ok, message }) => {
            if (ok) {
                Swal.fire({
                    title: message,
                    icon: 'success',
                    confirmButtonText: "확인",
                }).then(() => {
                    window.location.href = '/enrollment/status';
                });
            } else {
                Swal.fire({
                    title: message,
                    icon: 'error',
                    confirmButtonText: "확인"
                });
            }
        })
        .catch(error => {
            console.error('Fetch Error:', error);
            Swal.fire('요청 중 문제가 발생했습니다. 네트워크 상태를 확인해주세요.');
        });
    });
});
</script>

<%@ include file="../footer.jsp" %>