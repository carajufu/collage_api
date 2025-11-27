<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

    <div id="main-container" class="container-fluid">
	    <div class="card card-custom p-4">
			<h5 class="card-title mb-3">장바구니 강의</h5>
	        <div class="overflow-visible" style="margin-bottom:10px">
		       		<div class="w-100 p-0" id="searchBox"> 
				      <form class="w-100 align-items-center py-2 d-flex p-3" role="search">
					      <div class="fw-bold me-3 flex-shrink-0" style="padding-right:200px">강의 검색</div>
					      <div class="me-4 d-flex align-items-center flex-shrink-0">
						    <span class="me-2">이수구분</span>
					        <select class="form-select" style="width:100px;" name="complSe" value="${param.complSe}">
							  <option value="" selected>---</option>
							  <option value="전필">전필</option>
							  <option value="전선">전선</option>
							  <option value="교필">교필</option>
							  <option value="교선">교선</option>
							  <option value="일선">일선</option>
							</select>
						  </div>
						  <div class="d-flex align-items-center flex-grow-1 me-3">
						  	<span class="me-2 flex-shrink-0">강의명</span>
					        <input type="search" placeholder="Search" class="form-control flex-grow-1" aria-label="Search" name="keyword" value="${param.keyword}"/>
					      </div>
					      <div class="flex-shrink-0">
					        <button class="btn btn-outline-primary" type="submit">검색</button>
					      </div>
				      </form>
	       			</div>
		       	</div>
	       		<div id="form">
	       			<form>
	       				<input type="hidden" name="stdntNo" value="${stdntNo}">
	       				<div id="courseTable">
							<table class="table">
								<thead class="table-light">
								  	<tr>
								  		<th>교과목ID</th><th>이수구분</th><th>강의명</th><th>교수명</th><th>취득학점</th><th>강의실</th><th>강의시간</th><th>담은 인원</th><th>담기</th>
								  	</tr>
						  		</thead>   
						  		<tbody id="courseTbody" class="align-middle">
						  			<tr><td colspan="11">강의 목록을 불러오는 중...</td></tr>
					  			</tbody>
							</table>
						</div>
					</form>
				</div>
	    <!-- 장바구니 리스트 파일 -->
	    <%@ include file="./mycartlist.jsp" %>



<div class="modal" tabindex="-1" id="modalPlan">
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
	const courseTbody = document.getElementById("courseTbody");
	
	// 강의실 정보 매핑
	
	
	function loadCourseList(keyword="", complSe="") {
		
		const url = `/atnlc/cart/load?keyword=\${keyword}&complSe=\${complSe}`;
// 		console.log("url : ", url);
		
		fetch(url, {
			method: "get",
			headers: {"Content-Type":"application/json;charset=UTF-8"}
		})
		.then(response => {
			if(!response.ok) {
				throw new Error("서버 오류 발생...");
			}
			return response.json();
		})
		.then(data => {
// 			console.log(data);
			loadCourseData(data.estblCourseVOList);
		})
		.catch(error => {
			console.error("강의 목록을 불러오지 못했습니다...", error);
			courseTbody.innerHTML = "<tr><td colspan='9'>강의 목록을 불러오지 못했습니다...</td></tr>";
		});
		
		
		// 강의 목록 로드 함수
		function loadCourseData(list) { 
			courseTbody.innerHTML = "";
			
			if(list == null) {
				courseTbody.innerHTML = "<tr><td colspan='9'>개설된 강의가 없습니다.</td></tr>";
				return;
			}
			
			let html = "";
			
			list.forEach(l=>{
				
				const timeInfo = `\${l.timetable.lctreDfk} \${l.timetable.beginTm},\${l.timetable.endTm}`;
				html += `
						<tr>
				  			<td>\${l.estbllctreCode}</td>
				  			<td>\${l.complSe}</td>
				  			<td>
				  				<a type="button"
			  					data-bs-toggle="modal" data-bs-target="#modalPlan" data-item-id="\${l.estbllctreCode}">\${l.allCourse.lctreNm}&nbsp;
			  					<i class="ri-search-line"></i></a>
				  			</td>
				  			<td>\${l.sklstf.sklstfNm}</td>
				  			<td>\${l.acqsPnt}</td>
				  			<td>\${l.lctrum}</td>
				  			<td>\${timeInfo}</td>
				  			<td>\${l.totalReqst}/\${l.atnlcNmpr}</td>
				  			<td><button type="button" class="btn btn-primary single-submit-btn" id="submitBtn" data-code="\${l.estbllctreCode}">담기</button></td>
				  		</tr>
				`; 
			});
			
			courseTbody.innerHTML = html;
		}

	}
	
	
	document.querySelector("form[role='search']").addEventListener("submit", function(event) {
		event.preventDefault();
		
		const form = event.target;
		const keyword = form.querySelector("input[name='keyword']").value;
		const complSe = form.querySelector("select[name='complSe']").value;
		
		console.log("keyword : ", keyword);
		console.log("complSe : ", complSe);
		loadCourseList(keyword, complSe);
	});
	

	// 장바구니 담기
	$("#form").on("click","#submitBtn",(event)=>{
		event.preventDefault();
		console.log("담기 버튼 click");
		
		const stdntNo = document.getElementsByName("stdntNo")[0].value;
		const estbllctreCode = $(event.currentTarget).data("code");
		
		console.log("선택 강의 코드 : " + estbllctreCode + " / 학생ID : " + stdntNo);
		
		const data = {
			stdntNo : stdntNo,
			estbllctreCode : estbllctreCode
		};
		
		if(confirm("선택한 강의를 장바구니에 담으시겠습니까?")) {
			
			fetch("/atnlc/cart/mycart/add", {
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
				
				if(!result.success) {
					let failMsg = "";
					let hasConflict = false;
					
					// 중복 강의
					const alreadyLecCode = result.alreadyLecCode; 
					if(alreadyLecCode && alreadyLecCode.length > 0) {
						failMsg += "이미 장바구니에 담은 강의입니다.\n";
						failMsg += " - " + alreadyLecCode.join('\n - ') + "\n\n";
						hasConflict = true;
					}
					
					// 중복 시간표
					// 중복 강의 필터링
					let perLecCode = result.perLecCode;
					
					if(alreadyLecCode && alreadyLecCode.length > 0) {
						const alreadySet = new Set(alreadyLecCode);
						perLecCode = perLecCode.filter(code => !alreadySet.has(code));
					}
					
					if(perLecCode && perLecCode.length > 0) {
						failMsg += "시간표가 겹치는 강의입니다.\n";
						failMsg += " - " + perLecCode.join('\n - ') + "\n\n";
						hasConflict = true;
					}
					
					// 실패 메세지 출력
					if(hasConflict) {
						alert(failMsg);
					} else {
						alert("알 수 없는 오류로 강의 담기에 실패했습니다.");
					}
					
				} else {
					
					// 장바구니 담기 성공
					alert(`총 \${result.insertCnt}개의 강의가 장바구니에 담겼습니다.`);
					
				}
				
				loadMyCart();
				loadCourseList();
				
			})
			.catch(error => {
				console.error("강의 담기 실패 : ", error);
				alert("강의 담기에 실패했습니다...");
			});
		}
		
	});
	
	
	loadCourseList();
	

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
									<button class="btn btn-outline-primary" id="fileDownload"  style="margin-left:10px" data-filegroupno="\${fileGroupNo}">\${fileName}</button>
									<input type="file" class="form-control" id="planFile" placeholder="Apartment or suite" style="display:none">
								</div>
					`;
				} else {
					fileHtml = `
								<div class="col-sm-4"> 
									<label for="planFile" class="form-label"> 강의계획서 </label> 
									<a class="btn btn-outline-secondary"  id="fileDownload" data-filegroupno="0" style="margin-left:10px" readonly>파일 없음</a>
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
					<h5>\${vo.estbllctreCode}</h5>
					</div> 

					<div class="col-sm-3"> 
					<label for="lctreNm" class="form-label">수강 인원</label> 
						<h5>\${vo.atnlcNmpr}</h5>
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
						<div id="lctreDfk"><h5>\${vo.timetable.lctreDfk} \${vo.timetable.beginTm}, \${vo.timetable.endTm}</h5></div>
					</div>
					
					<div class="col-sm-4"> 
						<label for="address2" class="form-label">강의실 </label> 
						<h5>\${vo.lctrum}</h5>
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
#searchBox {
  background-color: #F3F6F9;
}
</style>

<%@ include file="../footer.jsp" %>





