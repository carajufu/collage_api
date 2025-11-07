<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

    <div id="main-container" class="container-fluid">
	    <div class="card card-custom p-4">
			<h5 class="card-title mb-3">개설 강의</h5>
	        <div class="flex-grow-1 p-1 overflow-visible">
	       		<div class="container-fluid"> 
	       			<nav class="navbar navbar-expand-lg bg-body-tertiary">
					  <div class="container-fluid">
					    <a class="navbar-brand">구분</a>
	<!-- 				    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"> -->
	<!-- 				      <span class="navbar-toggler-icon"></span> -->
	<!-- 				    </button> -->
					    <div class="collapse navbar-collapse" id="navbarSupportedContent">
					      <form class="d-flex" role="search">
					        <select class="form-select" aria-label="Default select example" name="complSe" value="${param.complSe}">
							  <option selected>이수구분</option>
							  <option value="전필">전필</option>
							  <option value="전선">전선</option>
							  <option value="교필">교필</option>
							  <option value="교선">교선</option>
							  <option value="일선">일선</option>
							</select>
					        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" name="keyword" value="${param.keyword}"/>
					        <button class="btn btn-outline-primary" type="submit">search</button>
					      </form>
					    </div>
					  </div>
					</nav>
	       				
	       			</div>
	       		</div>
	       		<div id="form">
					<table class="table">
					  <thead class="table-light">
					  	<tr>
					  		<th>교과목ID</th><th>이수구분</th><th>강의명</th><th>교수명</th><th>취득학점</th><th>강의실</th><th>강의시간</th><th>수강인원</th><th>비고</th>
					  	</tr>
					  </thead>
					  <c:if test="${empty estblCourseVOList}">
					  	<tbody>
					  		<tr><td colspan="9">개설된 강의가 없습니다.</td></tr>
					  	</tbody>
					  </c:if>
					  <c:if test="${!empty estblCourseVOList}">
						  <tbody>
						  	<c:forEach var="l" items="${estblCourseVOList}" varStatus="stat">
						  		<tr>
						  			<td>${l.estbllctreCode}</td><td>${l.complSe}</td>
						  			<td>${l.allCourse.lctreNm}</td>
						  			<td>${l.sklstf.sklstfNm}</td><td>${l.acqsPnt}</td>
						  			<td>${l.lctrum}</td><td>${l.timetable.lctreDfk} ${l.timetable.beginTm},${l.timetable.endTm}</td><td>${l.atnlcNmpr}</td>
						  			<td>
							  			<button class="btn btn-outline-secondary d-inline-flex align-items-center" type="button"
							  					data-bs-toggle="modal" data-bs-target="#modalPlan" data-item-id="${l.estbllctreCode}">
										강의계획서</button>
	<!-- 									<svg class="bi ms-1" width="10" height="5" aria-hidden="true"><use xlink:href="#arrow-right-short"></use></svg>  -->
									</td>
						  		</tr>
						  	</c:forEach>
						  </tbody>
						</c:if>
					</table>
				</div>
	        </div>
	    </div>
    </div>
<<<<<<< HEAD
=======
</main>
>>>>>>> 26a4290 (please)

<div class="modal" tabindex="-1" id="modalPlan">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalHeader"></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" id="clsBtn">닫기</button>
        <button type="button" class="btn btn-primary" id="editBtn">수정</button>
        <button type="button" class="btn btn-primary" id="editConfirmBtn" style="display:none;">수정 완료</button>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript">
const modalPlan = document.getElementById("modalPlan");
const modalHeader = document.getElementById("modalHeader");

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

let estbllctreCode = null;


$("#editBtn").on("click",(event)=>{
// 	const elements = document.querySelector("#fileDownload");
	
	$("#fileDownload").hide();
	$("#planFile").show();
	
	console.log("수정 버튼 click");
	
	$("#editBtn").hide();
	$("#editConfirmBtn").show();
	
	$("#editConfirmBtn").on("click",(event)=>{
		console.log("수정 확인 버튼 click");
		const file = document.querySelector("#planFile").files[0];
		
		let formData = new FormData();
		if(!file) {
			alert("파일을 첨부해 주세요.");
			return;
		}
		
		formData.append("estbllctreCode", estbllctreCode);
		formData.append("uploadFile", file);
		
		fetch("/lecture/uploadPlan", {
				method: "post",
				body: formData
			})
			.then(response => {
				if(!response.ok) {
					throw new Error(`Error! Status: ${response.status}`);
				}
				return response.json();
			})
			.then(result => {
				if(result.result=="1") {
					alert("강의계획서가 등록되었습니다.");
					document.querySelector("#clsBtn").click();
				}
			})
			.catch(error=>{
				console.error("fetch 요청 오류 : ", error);
			});
	});
});


$("#modalPlan").on("show.bs.modal",(event)=>{
	let modalPlanBtn = $(event.relatedTarget);
	estbllctreCode = modalPlanBtn.data("item-id");
	
	var modalBody = modalPlan.querySelector(".modal-body");
	modalBody.innerHTML = `<p>강의 계획서 파일을 불러오는 중...</p>`;
	
	console.log("체크 modalPlanBtn : ", estbllctreCode);

	fetch("/lecture/detailPlan/"+estbllctreCode)
		.then(response => {
			if(!response.ok) {
				throw new Error("오류 발생...");
			}
			return response.json();
		})
		.then(data => {
			const vo = data.estblCourseVO;
			modalHeader.textContent = vo.allCourse.lctreNm;
			
			const result = data.result;
			const fileGroupNo = vo.file.fileGroupNo;
			
			if(vo.file){
				const fileName = vo.file.fileNm;
				const fileStreplace = vo.file.fileStreplace;
				modalBody.innerHTML = `
										<div class="col-sm-4"> 
											<label for="address2" class="form-label"> 강의계획서 </label> 
											<button class="btn btn-outline-primary" id="fileDownload"  data-filegroupno="\${fileGroupNo}">\${fileName}</button>
											<input type="file" class="form-control" id="planFile" placeholder="Apartment or suite" style="display:none">
										</div>
				`
			} else {
				modalBody.innerHTML = `
											<div class="col-sm-4"> 
												<label for="planFile" class="form-label"> 강의계획서 </label> 
												<a class="btn btn-outline-secondary"  id="fileDownload"  data-filegroupno="0" readonly>파일 없음</a>
												<input type="file" class="form-control" id="planFile" placeholder="Apartment or suite" style="display:none">
											</div>
				`
			} 
		})
		.catch(error => {
			console.error('fetch 에러 : ', error);
			modalBody.innerHTML = '<p class="text-danger">강의계획서 파일을 불러오는 데 실패했습니다.</p>';
		});
});

</script>

<%@ include file="../footer.jsp" %>
