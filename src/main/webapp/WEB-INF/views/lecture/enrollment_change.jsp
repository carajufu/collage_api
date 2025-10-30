<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>

<div class="content-area" id="main-content">
<h2 class="section-title">휴학 신청</h2>
    <div class="card card-custom p-4">
        <h5 class="card-title mb-3">휴학 신청 안내</h5>
        <hr>
        <form action="/enrollment/change" method="post" enctype="multipart/form-data">
            
<%--             <input type="hidden" name="stdntId" value="${sessionScope.loginUser.studentId}"> --%>
            <input type="hidden" name="stdntId" value="S2025001">
            
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
<%@ include file="../footer.jsp" %>