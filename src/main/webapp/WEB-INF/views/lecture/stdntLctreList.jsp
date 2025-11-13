<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

    <div id="main-container" class="container-fluid">
	    <div class="card card-custom p-4">
			<h5 class="card-title mb-3">수강신청 내역</h5>
	       		<div id="form">
	       			<form id="form">
	       				<input type="hidden" name="stdntNo" value="${stdntNo}">
	       				<div id="courseTable">
							<table class="table">
							  <thead class="table-light">
							  	<tr>
							  		<th>교과목ID</th><th>이수구분</th><th>강의명</th><th>교수명</th><th>취득학점</th><th>강의실</th><th>강의시간</th><th>신청인원</th><th>취소</th>
							  	</tr>
							  </thead>   
							  <c:if test="${empty atnlcReqstVOList}">
							  	<tbody>
							  		<tr><td colspan="11">신청한 강의가 없습니다.</td></tr>
							  	</tbody>
							  </c:if>
							  <c:if test="${!empty atnlcReqstVOList}">
								  <tbody class="align-middle">
								  	<c:forEach var="l" items="${atnlcReqstVOList}" varStatus="stat">
								  		<tr>
								  			<td>${l.estbllctreCode}</td><td>${l.estblCourse.complSe}</td>
								  			<td>
								  				<a type="button"
							  					data-bs-toggle="modal" data-bs-target="#modalPlan" data-item-id="${l.estbllctreCode}">${l.allCourse.lctreNm}&nbsp;
							  					<i class="ri-search-line"></i></a>
								  			</td>
								  			
											
								  			<td>${l.sklstf.sklstfNm}</td><td>${l.estblCourse.acqsPnt}</td>
								  			<td>${l.estblCourse.lctrum}</td><td>${l.timetable.lctreDfk} ${l.timetable.beginTm},${l.timetable.endTm}</td><td>${l.estblCourse.atnlcNmpr}</td>
								  			<td><button type="button" class="btn btn-danger editBtn" data-code="${l.estbllctreCode}">취소</button>
											</td>
								  		</tr>
								  	</c:forEach>
								  </tbody>
								</c:if>
							</table>
						</div>
					</form>
				</div>
	        </div>
	    </div>
    </div>
</main>

<div class="modal" tabindex="-1" id="modalDetail">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">강의 정보</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">

	$("#form").on("click",".editBtn",(event)=>{
		event.preventDefault();
		console.log("취소 버튼 click");
		
		const estbllctreCode = $(event.currentTarget).data("code");
		const stdntNo = document.getElementsByName("stdntNo")[0].value;
		
		console.log("선택 강의 코드 : " + estbllctreCode + " / 학생ID : " + stdntNo);
		
		const data = {
				stdntNo : stdntNo,
				estbllctreCode : estbllctreCode
		};
		
		if(confirm("수강신청을 취소하시겠습니까?")) {
			
			fetch("/atnlc/stdntLctreList/edit", {
				method: "post",
				headers: {"Content-Type":"application/json;charset=UTF-8"},
				body: JSON.stringify(data)
			})
			.then(response => {
				if(!response.ok) {
					throw new Error("서버 오류 발생");
				}
				return response.json();
			})
			.then(data => {
				
				const result = data.result;
				
				if(result < 0) {
					alert("취소 실패 : 알 수 없는 오류");
				}
				
				alert("취소되었습니다.");
				
				location.reload();
				
			})
			.catch(error => {
				console.error("fetch 요청 오류 발생 : ", error);
			});
		}
		
	});
	
	
	// 강의계획서 모달
	const modalPlan = document.getElementById("modalPlan");

	modalPlan.addEventListener("show.bs.modal",(event)=>{
		const modalPlanBtn = event.relatedTarget;
		const estbllctreCode = modalPlanBtn.getAttribute("data-item-id");
		
		const modalBody = modalPlan.querySelector(".modal-body");
		modalBody.innerHTML = `<p>강의 정보를 불러오는 중...</p>`;
		
		console.log("체크 : ", estbllctreCode);
		
		fetch("/lecture/detail/"+estbllctreCode)
			.then(response => {
				if(!response.ok) {
					throw new Error("서버 오류 발생...");
				}
				return response.json();
			})
			.then(data => {
				const vo = data.estblCourseVO;
				
				let fileHtml = "";
				
				if(vo.file) {
					const fileName = vo.file.fileNm;
					const fileGroupNo = vo.file.fileGroupNo;
					const fileStreplace = vo.file.fileStreplace;
					
					fileHtml = `
								<div class="col-sm-4"> 
									<label for="planFile" class="form-label"> 강의계획서 </label> 
									<button class="btn btn-outline-primary" id="fileDownload"  data-filegroupno="\${fileGroupNo}">\${fileName}</button>
									<input type="file" class="form-control" id="planFile" placeholder="Apartment or suite" style="display:none">
								</div>
					`;
				} else {
					fileHtml = `
								<div class="col-sm-4"> 
									<label for="planFile" class="form-label"> 강의계획서 </label> 
									<a class="btn btn-outline-secondary"  id="fileDownload"  data-filegroupno="0" readonly>파일 없음</a>
									<input type="file" class="form-control" id="planFile" placeholder="Apartment or suite" style="display:none">
								</div>
					`;
				}
				
				let modalHtml = "";
				
				modalHtml = `
						<div class="row g-3"> 
							<div class="col-md-5"> 
							<label for="lctreNm" class="form-label">강의명</label>
								<h5>\${vo.allCourse.lctreNm}</h5>
							</div> 
							
							<div class="col-md-4"> 
							<label for="lctreCode" class="form-label">강의 코드</label> 
							<h5>\${vo.lctreCode}</h5>
							</div> 
							
							<div class="col-md-3"> 
							<label for="estblYear" class="form-label">개설년도</label> 
							<h5>\${vo.estblYear}</h5>
							</div> 
							
							<div class="col-md-4"> 
								<label for="complSe" class="form-label">이수 구분</label> 
								<h5>\${vo.complSe}</h5>
							</div>
							
							<div class="col-md-1"> </div>
							<div class="col-md-3"> 
								<label for="evlMthd" class="form-label">평가 방식</label> 
								<h5>\${vo.evlMthd}</h5>
								</select> 
							</div>
							
							<div class="col-md-1"> </div>
							<div class="col-md-3"> 
								<label for="acqsPnt" class="form-label">취득 학점</label> 
								<h5>\${vo.acqsPnt}</h5>
							</div>
							
							<div class="col-sm-5"> 
							<label for="lctreDfk" class="form-label">강의일</label>
								<div id="lctreDfk"><a>\${vo.timetable.lctreDfk} \${vo.timetable.beginTm}, \${vo.timetable.endTm}</a></div>
							</div>
							
							<div class="col-sm-4"> 
								<label for="address2" class="form-label">강의실 </label> 
								<h5>\${vo.lctrum}</h5>
							</div> 
							<div class="col-sm-3"> 
							<label for="lctreNm" class="form-label">수강 인원</label> 
								<h5>\${vo.atnlcNmpr}</h5>
							</div>
				`;
				
				modalHtml += fileHtml;
				
				modalHtml += `			
							
							<hr class="my-4">
							
							<div class="col-4"> 
								<label for="sklstfNm" class="form-label">교수</label> 
								<h5>\${vo.sklstf.sklstfNm}</h5>
							</div>
							
							<div class="col-8"> </div>
							<div class="col-4"> 
								<label for="email" class="form-label">교수 이메일</label> 
								<div class="input-group has-validation"> 
									<h5>\${vo.profsr.emailAdres}</h5> 
								</div> 
							</div> 
							
							<div class="col-4"> 
								<label for="cttpc" class="form-label">교수 연락처</label> 
								<h5>\${vo.sklstf.cttpc}</h5>
							</div> 
							
							<div class="col-4"> 
								<label for="labrumLc" class="form-label">교수 연구실</label> 
									<h5>\${vo.profsr.labrumLc}</h5>
							</div> 
							
						</div>
				`;
				
				modalBody.innerHTML = modalHtml;
			})
			.catch(error => {
				console.error('fetch 에러 : ', error);
				modalBody.innerHTML = '<p class="text-danger">강의 정보를 불러오는 데 실패했습니다.</p>';
			});
	});
	
	
	// 강의계획서 파일 다운로드
	document.addEventListener("click", (e)=>{
		
		const downloadBtn = e.target.closest("#fileDownload");
		
		
		if(downloadBtn) {
			const fileGroupNo = downloadBtn.dataset.filegroupno;
			
			if(fileGroupNo && fileGroupNo!=0) {
				e.preventDefault();
				console.log("fileGroupNo 체크 : ", fileGroupNo);
				
				window.location.href = "/lecture/downloadFile?fileGroupNo=" + fileGroupNo;
			} else {
				e.preventDefault();
			}
		}
	});
	
	
</script>
<style>
#form {
	max-height: 270px;
	overflow-y: auto;
}
</style>

<%@ include file="../footer.jsp" %>
