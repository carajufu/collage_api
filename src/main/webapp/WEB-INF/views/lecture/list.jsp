<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

    <div id="main-container" class="container-fluid">
	    <div class="card card-custom p-4">
			<h5 class="card-title mb-3">개설 강의</h5>
	        <div class="flex-grow-1 p-1 overflow-visible">
	       		<div class="container-fluid"> 
	       			<nav class="navbar navbar-expand-lg bg-body-tertiary">
					  <div class="container-fluid">
					    <a class="navbar-brand">이수구분</a>
					    <div class="collapse navbar-collapse" id="navbarSupportedContent">
					      <form class="d-flex" role="search">
					        <select class="form-select" aria-label="Default select example" name="complSe" value="${param.complSe}">
							  <option value="" selected>---</option>
							  <option value="전필">전필</option>
							  <option value="전선">전선</option>
							  <option value="교필">교필</option>
							  <option value="교선">교선</option>
							  <option value="일선">일선</option>
							</select>
							<a class="navbar-brand" style="margin-left:50px">강의명</a>
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
					  		<th>교과목ID</th><th>이수구분</th><th>강의명</th><th>교수명</th><th>취득학점</th><th>강의실</th><th>강의시간</th><th>수강인원</th><th></th>
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
							  					data-bs-toggle="modal" data-bs-target="#modalDetail" data-item-id="${l.estbllctreCode}">
										강의 정보</button>
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
const modalDetail = document.getElementById("modalDetail");

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

$("#modalDetail").on("show.bs.modal",(event)=>{
	let modalDetailBtn = $(event.relatedTarget);
	let estbllctreCode = modalDetailBtn.data("item-id");
	
	var modalBody = modalDetail.querySelector(".modal-body");
	modalBody.innerHTML = `<p>강의 정보를 불러오는 중...</p>`;
	
	console.log("체크 : ", estbllctreCode);
	
	fetch("/lecture/detail/"+estbllctreCode)
		.then(response => {
			if(!response.ok) {
				throw new Error("오류 발생...");
			}
			return response.json();
		})
		.then(data => {
			const vo = data.estblCourseVO;
			
			let modalHTML = "";
			let planHTML = "";
			
			if(vo.file) {
				const fileName = vo.file.fileNm;
				const fileGroupNo = vo.file.fileGroupNo;
				
// 				const downloadUrl = "/lecture/downloadFile?fileGroupNo=" + fileGroupNo;
				planHTML += `
								<div class="col-sm-4"> 
									<label for="planFile" class="form-label"> 강의계획서 </label> 
									<button class="btn btn-outline-primary" id="fileDownload" data-filegroupno="\${fileGroupNo}">\${fileName}</button>
								</div>
							`;
			} else {
				planHTML += `
								<div class="col-sm-4"> 
									<label for="planFile" class="form-label"> 강의계획서 </label> 
									<a class="btn btn-outline-secondary"  id="fileDownload" data-filegroupno="0" readonly>파일 없음</a>
								</div>
							`;
			}
			
			modalHTML = `
					 <form class="needs-validation" novalidate="">
						<div class="row g-3"> 
							<div class="col-md-5"> 
							<label for="lctreNm" class="form-label">강의명</label>
								<input type="text" name="lctreNm" class="form-control" id="lctreNm" placeholder="" value="\${vo.allCourse.lctreNm}" required="" readonly> 
									<div class="invalid-feedback">
										Valid first name is required.
									</div> 
							</div> 
							<div class="col-md-4"> 
							<label for="lctreCode" class="form-label">강의 코드</label> 
								<input type="text" name="lctreCode" class="form-control" id="lctreCode" placeholder="" value="\${vo.lctreCode}" required="" readonly> 
									<div class="invalid-feedback">
										Valid first name is required.
									</div> 
							</div> 
							<div class="col-md-3"> 
							<label for="estblYear" class="form-label">개설년도</label> 
								<input type="number" name="estblYear" class="form-control" id="estblYear" value="\${vo.estblYear}" required="" readonly> 
									<div class="invalid-feedback">
										Valid first name is required.
									</div> 
							</div> 
							<div class="col-md-4"> 
								<label for="complSe" class="form-label">이수 구분</label> 
								<select class="form-select" name="complSe" id="complSe" required="" disabled> 
									<option value="---" \${!vo.complSe || vo.complSe == null ? 'selected' : ''}>---</option> 
									<option value="전필" \${vo.complSe == '전필' ? 'selected' : ''}>전필</option> 
									<option value="전선" \${vo.complSe == '전선' ? 'selected' : ''}>전선</option> 
									<option value="교필" \${vo.complSe == '교필' ? 'selected' : ''}>교필</option> 
									<option value="교선" \${vo.complSe == '교선' ? 'selected' : ''}>교선</option> 
									<option value="일선" \${vo.complSe == '일선' ? 'selected' : ''}>일선</option> 
								</select> 
								<div class="invalid-feedback">
									Please provide a valid state.
								</div> 
							</div>
							<div class="col-md-1"> </div>
							<div class="col-md-3"> 
								<label for="evlMthd" class="form-label">평가 방식</label> 
								<select class="form-select" name="evlMthd" id="evlMthd" required="" disabled>
									<option value="---" \${!vo.evlMthd || vo.evlMthd == null ? 'selected' : ''}>---</option>
									<option value="절대" \${vo.evlMthd == '절대' ? 'selected' : ''}>절대</option>
									<option value="상대" \${vo.evlMthd == '상대' ? 'selected' : ''}>상대</option>
									<option value="P/F" \${vo.evlMthd == 'PF' ? 'selected' : ''}>P/F</option>
								</select> 
								<div class="invalid-feedback">
									Please provide a valid state.
								</div> 
							</div>
							<div class="col-md-1"> </div>
							<div class="col-md-3"> 
								<label for="acqsPnt" class="form-label">취득 학점</label> 
								<input type="number" name="acqsPnt" class="form-control" id="acqsPnt" placeholder="" value="\${vo.acqsPnt}" required="" readonly> 
									<div class="invalid-feedback">
										Valid last name is required.
									</div> 
							</div>
							
							<div class="col-sm-5"> 
							<label for="lctreDfk" class="form-label">강의일</label>
								<div id="lctreDfk"><a>\${vo.timetable.lctreDfk} \${vo.timetable.beginTm}, \${vo.timetable.endTm}</a></div>
							</div>
							
							<div class="col-sm-4"> 
								<label for="address2" class="form-label">강의실 </label> 
								<input type="text" class="form-control" id="address2" value="\${vo.lctrum}" readonly> 
							</div> 
							<div class="col-sm-3"> 
							<label for="lctreNm" class="form-label">수강 인원</label> 
								<input type="number" class="form-control" id="firstName" placeholder="" value="\${vo.atnlcNmpr}" required="" readonly> 
									<div class="invalid-feedback">
										Valid first name is required.
									</div> 
							</div> 
							
							\${planHTML}
							
							<hr class="my-4">
							
							<div class="col-4"> 
								<label for="sklstfNm" class="form-label">교수</label> 
									<input type="text" class="form-control" id="sklstfNm" required="" value="\${vo.sklstf.sklstfNm}" readonly> 
									<div class="invalid-feedback">
										Please enter your shipping address.
									</div> 
							</div> 
							<div class="col-8"> </div>
							<div class="col-4"> 
								<label for="email" class="form-label">교수 이메일</label> 
								<div class="input-group has-validation"> 
									<span class="input-group-text">@</span> 
									<input type="email" class="form-control" id="email" placeholder="you@example.com" value="" readonly> 
										<div class="invalid-feedback">
											Please enter a valid email address for shipping updates.
										</div> 
								</div> 
							</div> 
							<div class="col-4"> 
								<label for="cttpc" class="form-label">교수 연락처</label> 
									<input type="text" class="form-control" id="cttpc" placeholder="010-XXXX-XXXX" required="" value="\${vo.sklstf.cttpc}" readonly> 
									<div class="invalid-feedback">
										Please enter your shipping address.
									</div> 
							</div> 
							<div class="col-4"> 
								<label for="labrumLc" class="form-label">교수 연구실</label> 
									<input type="text" class="form-control" id="labrumLc" required="" value="\${vo.profsr.labrumLc}" readonly> 
									<div class="invalid-feedback">
										Please enter your shipping address.
									</div> 
							</div> 
						</div>
					</form> 
			`
			modalBody.innerHTML = modalHTML;
		})
		.catch(error => {
			console.error('fetch 에러 : ', error);
			modalBody.innerHTML = '<p class="text-danger">강의 정보를 불러오는 데 실패했습니다.</p>';
		});
});
</script>
<style>
#form {
	max-height: 270px;
	overflow-y: auto;
}
</style>

<%@ include file="../footer.jsp" %>
