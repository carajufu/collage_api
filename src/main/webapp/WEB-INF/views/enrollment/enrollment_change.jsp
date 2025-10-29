<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>

<div class="content-area" id="main-content">
<h2 class="section-title">휴학/복학 신청</h2>
    <div class="card card-custom p-4">
        <form action="/enrollment/change" id="change-form" method="post" enctype="multipart/form-data">
            
             <div class="mb-3">
                <label class="form-label">신청 종류</label>
                <div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="changeTy" id="leave-radio" value="휴학" checked>
                        <label class="form-check-label" for="leave-radio">휴학</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="changeTy" id="return-radio" value="복학">
                        <label class="form-check-label" for="return-radio">복학</label>
                    </div>
                </div>
            </div>
            
            <div class="mb-3">
			    <label for="leave-semester" class="form-label">신청 학기</label>
			    <select class="form-select" id="leave-semester" name="efectOccrrncSemstr"> 
			        <option selected disabled>신청할 학기를 선택하세요...</option>
			        
			        <c:forEach items="${semesters}" var="semester">
			            <option value="${semester}">
			                ${semester.split('-')[0]}년 ${semester.split('-')[1]}학기
			            </option>
			        </c:forEach>
			    </select>
			</div>
            
            <div class="mb-3">
                <label for="leave-reason" class="form-label">휴학 유형</label>
                <select class="form-select" id="leave-reason" name="tmpabssklTy">
                    <option selected disabled>유형을 선택하세요...</option>
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
                <input type="file" id="attachment-file" name="attachmentFile" class="form-control">
            </div>
               
            <button type="submit" id="submit-btn" class="btn btn-primary">신청하기</button>
        </form>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    //console.log("체킁: ",document.getElementById('change-form'))
    document.getElementById('change-form').addEventListener('submit', function(event) {
    	//alert("동작확인!")
        event.preventDefault(); 
    	
        const semesterSelect = document.getElementById('leave-semester');
        const reasonSelect = document.getElementById('leave-reason');
    	
        if (semesterSelect.value === '신청할 학기를 선택하세요...') {
    		Swal.fire('신청 학기를 선택해주세요.');
    		return;
    	}
    	
    	if (reasonSelect.value === '유형을 선택하세요...') { 
    		Swal.fire('휴학 유형을 선택해주세요.');
    		return;
    	}
    	
    	const formData = new FormData(this);
        
        fetch('/enrollment/change', {
            method: 'POST',
            body: new FormData(this)
        })
        .then(response => {
            if (response.ok) {
                Swal.fire({
                	  title: '신청이 성공적으로 완료되었습니다.',
                	  confirmButtonText: "OK",
                	}).then((result) => {
                          window.location.href = '/enrollment/status';
                	})
            } else {
                Swal.fire('신청 처리 중 오류가 발생했습니다.');
            }
        });
    });
</script>

<%@ include file="../footer.jsp" %>