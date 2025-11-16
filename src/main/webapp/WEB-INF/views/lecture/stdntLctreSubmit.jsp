<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

	    <div id="main-container" class="container-fluid p-0">
		    <div class="card card-custom p-4">
				<h5 class="card-title mb-3">수강신청</h5>
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
	       		<div id="course-section">
	       			<form>
	       				<input type="hidden" name="stdntNo" value="${stdntNo}">
	       				<div id="courseTable">
							<table class="table">
								<thead class="table-light">
									<tr>
								  		<th>교과목ID</th><th>이수구분</th><th>강의명</th><th>교수명</th><th>취득학점</th><th>강의실</th><th>강의시간</th><th>신청인원</th><th>신청</th>
								  	</tr>
								</thead>   
								<tbody id="courseTbody" class="align-middle">
						  			<tr><td colspan="10">강의 목록을 불러오는 중...</td></tr>
						  		</tbody>
							</table>
						</div>
					</form>
				</div>
	        </div>
	    </div>
	    
    </div>
</main>

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

	function loadCourseList(keyword="", complSe="") {
		
		const url = `/atnlc/submit/load?keyword=\${keyword}&complSe=\${complSe}`;
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
			loadCourseData(data.estblCourseVOList);
		})
		.catch(error => {
			console.error("강의 목록을 불러오지 못했습니다.", error);
			courseTbody.innerHTML = "<tr><td colspan='10'>강의 목록을 불러오지 못했습니다...</td></tr>";
		});
		
		
		// 강의 목록 로드 함수
		function loadCourseData(list) {
			courseTbody.innerHTML = "";
			
			if(list == null) {
				courseTbody.innerHTML = "<tr><td colspan='10'>개설된 강의가 없습니다.</td></tr>";
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
				  			<td>\${l.totalSubmit}/\${l.atnlcNmpr}</td>
				  			<td><button type="button" class="btn btn-primary single-submit-btn" id="submitBtn" data-code="\${l.estbllctreCode}">신청</button></td>
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
	
	loadCourseList();
	
	
	// 수강신청
	$("#course-section").on("click",".single-submit-btn",(event)=>{
		event.preventDefault();
		console.log("신청 버튼 click");
		
		const stdntNo = document.getElementsByName("stdntNo")[0].value;
		const estbllctreCode = $(event.currentTarget).data("code");
		
		console.log("선택 강의 코드 : " + estbllctreCode + " / 학생ID : " + stdntNo);
		
		const data = {
				stdntNo : stdntNo,
				estbllctreCode : estbllctreCode
		};
		
		if(confirm("선택한 강의를 신청하시겠습니까?")) {
			
			fetch("/atnlc/submit/add", {
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
				
				alert(`강의가 신청되었습니다.`);
				
				loadCourseList();
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
									<button class="btn btn-outline-primary" id="fileDownload" style="margin-left:10px" data-filegroupno="\${fileGroupNo}">\${fileName}</button>
									<input type="file" class="form-control" id="planFile" placeholder="Apartment or suite" style="display:none">
								</div>
					`;
				} else {
					fileHtml = `
								<div class="col-sm-4"> 
									<label for="planFile" class="form-label"> 강의계획서 </label> 
									<a class="btn btn-outline-secondary"  id="fileDownload" data-filegroupno="0"  style="margin-left:10px" readonly>파일 없음</a>
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
#form {
	max-height: 270px;
	overflow-y: auto;
}
#searchBox {
  background-color: #F3F6F9;
}
</style>

<%@ include file="../footer.jsp" %>
