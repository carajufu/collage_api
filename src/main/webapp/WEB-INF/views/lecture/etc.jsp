<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
 
<%@ include file="../header.jsp" %>

    <div id="main-container" class="container-fluid">
	    <div class="card card-custom p-4">
			<h5 class="card-title mb-3">나의 강의</h5>
			
			<div class="card">
	            <div class="card-body">
	                <ul class="nav nav-tabs nav-justified nav-border-top nav-border-top-primary mb-3" role="tablist">
	                    <li class="nav-item" role="presentation">
	                        <a class="nav-link active" data-bs-toggle="tab" href="#nav-border-justified-home" role="tab" aria-selected="true">
	                            <i class="ri-home-5-line align-middle me-1"></i> 교과목 관리
	                        </a>
	                    </li>
	                    <li class="nav-item" role="presentation">
	                        <a class="nav-link" data-bs-toggle="tab" href="#nav-border-justified-profile" role="tab" aria-selected="false" tabindex="-1">
	                            <i class="ri-user-line me-1 align-middle"></i> 강의 관리
	                        </a>
	                    </li>
	                </ul>
	                <div class="tab-content text-muted">
	                    <div class="tab-pane active" id="nav-border-justified-home" role="tabpanel">
	                        <h6>Give your text a good structure</h6>
	                        <p class="mb-0">
	                            Contrary to popular belief, you don’t have to work endless nights and hours to create a <a href="javascript:void(0);" class="text-decoration-underline"><b>Fantastic Design</b></a> by using complicated 3D elements. Flat design is your friend. Remember that. And the great thing about flat design is that it has become more and more popular over the years, which is excellent news to the beginner and advanced designer.
	                        </p>
	                    </div>
	                    <div class="tab-pane" id="nav-border-justified-profile" role="tabpanel">
	                        <h6>Use a color palette</h6>
	                        <p class="mb-0">
	                            Opposites attract, and that’s a fact. It’s in our nature to be interested in the unusual, and that’s why using contrasting colors in <a href="javascript:void(0);" class="text-decoration-underline"><b>Graphic Design</b></a> is a must. It’s eye-catching, it makes a statement, it’s impressive graphic design. Increase or decrease the letter spacing depending on the situation and try, try again until it looks right, and each letter has the perfect spot of its own.
	                        </p>
	                    </div>
	                </div>
	            </div>
	        </div>
			
			
			
			
			<div class="col-xl-3 col-md-6">
	            <!-- card -->
	            <div class="card card-animate border-0 border-start border-3 border-primary">
	                <div class="card-body">
	                    <div class="d-flex align-items-center">
	                        <div class="flex-grow-1">
	                            <p class="text-uppercase fw-medium text-muted mb-0">반려 강의</p>
	                        </div>
	                        <div class="flex-shrink-0">
	                            <h5 class="text-danger fs-14 mb-0">
	                                Pending
	                            </h5>
	                        </div>
	                    </div>
	                    <div class="d-flex align-items-end justify-content-between mt-4">
	                        <div>
	                            <h4 class="fs-22 fw-semibold ff-danger mb-4"><span class="counter-value" data-target="">2</span>개</h4>
	                        </div>
	                        <div class="avatar-sm flex-shrink-0">
	                            <span class="avatar-title bg-danger-subtle rounded fs-3">
	                                <i class="ri-file-edit-line text-danger"></i>
	                            </span>
	                        </div>
	                    </div>
	                </div><!-- end card body -->
	            </div><!-- end card -->
	        </div>
	        
	        
	        <div class="swiper-slide swiper-slide-active" role="group" aria-label="1 / 5" style="width: 390.5px; margin-right: 20px;">
	            <div class="card profile-project-card shadow-none profile-project-primary mb-0">
	                <div class="card-body p-4">
	                    <div class="d-flex">
	                        <div class="flex-grow-1 text-muted overflow-hidden">
	                            <h5 class="fs-14 text-truncate mb-1">
	                                <a href="#" class="text-body">ABC Project Customization</a>
	                            </h5>
	                            <p class="text-muted text-truncate mb-0"> Last Update : <span class="fw-semibold text-body">4 hr Ago</span></p>
	                        </div>
	                        <div class="flex-shrink-0 ms-2">
	                            <div class="badge bg-warning-subtle text-warning fs-10"> Inprogress</div>
	                        </div>
	                    </div>
	                    <div class="d-flex mt-4">
	                        <div class="flex-grow-1">
	                            <div class="d-flex align-items-center gap-2">
	                                <div>
	                                    <h5 class="fs-12 text-muted mb-0"> Members :</h5>
	                                </div>
	                                <div class="avatar-group">
	                                    <div class="avatar-group-item">
	                                        <div class="avatar-xs">
	                                            <img src="assets/images/users/avatar-4.jpg" alt="" class="rounded-circle img-fluid">
	                                        </div>
	                                    </div>
	                                    <div class="avatar-group-item">
	                                        <div class="avatar-xs">
	                                            <img src="assets/images/users/avatar-5.jpg" alt="" class="rounded-circle img-fluid">
	                                        </div>
	                                    </div>
	                                    <div class="avatar-group-item">
	                                        <div class="avatar-xs">
	                                            <div class="avatar-title rounded-circle bg-light text-primary">
	                                                A
	                                            </div>
	                                        </div>
	                                    </div>
	                                    <div class="avatar-group-item">
	                                        <div class="avatar-xs">
	                                            <img src="assets/images/users/avatar-2.jpg" alt="" class="rounded-circle img-fluid">
	                                        </div>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	                <!-- end card body -->
	            </div>
	            <!-- end card -->
	        </div>
                                                                
                                                                
                                                                
				
				<div class="card">
	                <div class="card-body">
	                    <!-- Nav tabs -->
	                    <ul class="nav nav-tabs nav-justified mb-3" role="tablist">
	                        <li class="nav-item" role="presentation">
	                            <a class="nav-link active" data-bs-toggle="tab" href="#nav-badge-home" data-filter="all" role="tab" aria-selected="true" tabindex="-1" >
	                                전체
	                            </a>
	                        </li>
	                        <li class="nav-item" role="presentation">
	                            <a class="nav-link align-middle" data-bs-toggle="tab" href="#nav-badge-home" data-filter="1" role="tab" aria-selected="false" tabindex="-1">
	                                현재 학기 <span class="badge rounded-pill text-bg-success">now</span>
	                            </a>
	                        </li>
	                        <li class="nav-item" role="presentation">
	                            <a class="nav-link align-middle" data-bs-toggle="tab" href="#nav-badge-home" data-filter="2"  role="tab" aria-selected="false" tabindex="-1">
	                                지난 학기
	                            </a>
	                        </li>
	                    </ul>
	                    <!-- Nav tabs -->
	                    <div class="tab-pane active show" id="nav-badge-home" role="tabpanel">
		                    <div class="tab-content text-muted">
		                        <div id="form">
					       			<form id="form">
					       				<input type="hidden" name="profsrNo" value="${profsrNo}">
					       				<div id="courseTable">
											<table class="table">
											  <thead class="table-light" id="tableHead">
											  </thead>   
												<c:if test="${empty estblCourseVOList}">
											  		<tbody>
												  		<tr><td colspan="11">개설된 강의가 없습니다.</td></tr>
													</tbody>
												</c:if>
												<c:if test="${!empty estblCourseVOList}">
													<tbody class="align-middle" id="tableBody"></tbody>
												</c:if>
											</table>
										</div>
									</form>
								</div>
		                    </div>
		            	</div>
	                </div><!-- end card-body -->
	            </div>
<%-- 	            <p>${estblCourseVO}</p> --%>
	            
	            
	            
	            
	            
	            <!-- ============================================================================ -->
	            
	            
	            
	            
	            
	            
	            
	            
	            
	            
	            
	            <div class="card">
	                <div class="card-body">
	                    <!-- Nav tabs -->
	                    <ul class="nav nav-pills nav-primary mb-3" role="tablist">
	                        <li class="nav-item waves-effect waves-light" role="presentation">
	                            <a class="nav-link active" data-bs-toggle="tab" href="#home-1" role="tab" aria-selected="true">강의 정보</a>
	                        </li>
	                        <li class="nav-item waves-effect waves-light" role="presentation">
	                            <a class="nav-link" data-bs-toggle="tab" href="#profile-1" role="tab" aria-selected="false" tabindex="-1">주차별 학습 목표</a>
	                        </li>
	                    </ul>
	                    <!-- Tab panes -->
	                    <div class="tab-content table-fixed-width">
	                        <div class="tab-pane active" id="home-1" role="tabpanel">
	                            
	                            <div class="d-flex">
	                                <div class="table-responsive">
                                        <table class="table table-bordered table-nowrap mb-0 table-fixed-layout">
	                                        <tr>
	                                            <td class="text-nowrap text-center">강의명</td>
	                                            <th colspan="4">데이터베이스 설계</th>
	                                            <td class="text-nowrap text-center" scope="row">강의코드</td>
	                                            <th>A105001</th>
	                                        </tr>
	                                        <tr>
	                                            <td class="text-nowrap text-center">이수구분</td>
	                                            <th colspan="3">전필</th>
	                                            <td class="text-nowrap text-center">수강인원</td>
	                                            <th colspan="2">40</th>
	                                        </tr>
	                                        <tr>
	                                            <td class="text-nowrap text-center">평가방식</td>
	                                            <th colspan="3">상대</th>
	                                            <td class="text-nowrap text-center">취득학점</td>
	                                            <th colspan="2">3 학점</th>
	                                        </tr>
	                                        <tr>
	                                            <td class="text-nowrap text-center">강의실</td>
	                                            <th colspan="3">인문관 101호</th>
	                                            <td class="text-nowrap text-center">강의시간</td>
	                                            <th colspan="2">월 1,2</th>
	                                        </tr>
	                                        <tr>
	                                            <td class="text-nowrap text-center">수업언어</td>
	                                            <th colspan="3">KOR</th>
	                                            <td class="text-nowrap text-center">강의계획서</td>
	                                            <th colspan="2">
	                                            	<a href="" id="fileDownload" data-filegroupno="\${fileGroupNo}">파일명 &nbsp;<i class="ri-folder-download-line"></i></a>
	                                            </th>
	                                        </tr>
	                                        <tr>
	                                            <td colspan="7"></td>
	                                        </tr>
	                                        <tr>
	                                            <td class="text-nowrap text-center">교수</td>
	                                            <th colspan="3">김진영</th>
	                                            <td class="text-nowrap text-center">연구실</td>
	                                            <th colspan="2">B101호</th>
	                                        </tr>
	                                        <tr>
	                                            <td class="text-nowrap text-center">e-mail</td>
	                                            <th colspan="3">asdf@asdf.com</th>
	                                            <td class="text-nowrap text-center">연락처</td>
	                                            <th colspan="2">010-1111-1111</th>
	                                        </tr>
	                                        <tr>
	                                            <td colspan="7"></td>
	                                        </tr>
                                        </table>
                                    </div>
                                    
	                            </div>
	                            
	                        </div>
	                        <div class="tab-pane" id="profile-1" role="tabpanel">
	                            <div class="d-flex">
									<div class="accordion custom-accordionwithicon-plus" id="accordionWithplusicon" style="width:500px;">
									    <div class="accordion-item">
									        <h2 class="accordion-header" id="week1">
									            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#week1Content" aria-expanded="true" aria-controls="week1Content">
									                <i class="ri-pencil-line"></i> &nbsp;&nbsp;1주차&nbsp;&nbsp;
									            </button>
									        </h2>
									        <div id="week1Content" class="accordion-collapse collapse show" aria-labelledby="week1" data-bs-parent="#weekInfo">
									            <div class="accordion-body">
									                <div class="d-flex mb-2 align-items-center">
									            		<label class="form-label me-2 mb-0" style="width:20%;">주제</label>
									            		<p class="form-label me-2 mb-0" style="width:80%;">주제 data</p>
										            </div>
										            <div class="d-flex mb-2 align-items-center">
										            	<label class="form-label me-2 mb-0" style="width:20%;">내용</label>
									            		<p class="form-label me-2 mb-0" style="width:80%;">내용 data</p>
										            </div>
									            </div>
									        </div>
									    </div>
									    <div class="accordion-item">
									        <h2 class="accordion-header" id="week2">
									            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#week2Content" aria-expanded="false" aria-controls="week2Content">
									                 <i class="ri-pencil-line"></i> &nbsp;&nbsp;2주차
									            </button>
									        </h2>
									        <div id="week2Content" class="accordion-collapse collapse" aria-labelledby="week2" data-bs-parent="#weekInfo">
									            <div class="accordion-body">
									                <div class="d-flex mb-2 align-items-center">
									            		<label class="form-label me-2 mb-0" style="width:20%;">주제</label>
									            		<p class="form-label me-2 mb-0" style="width:80%;">주제 data</p>
										            </div>
									                <div class="invalid-feedback">학습 주제를 입력해 주세요.</div>
										            <div class="d-flex mb-2 align-items-center">
										            	<label class="form-label me-2 mb-0" style="width:20%;">내용</label>
									            		<p class="form-label me-2 mb-0" style="width:80%;">내용 data</p>
										            </div>
									            </div>
									        </div>
									    </div>
									</div>
	                            </div>
	                        </div>
	                    </div>
	                </div><!-- end card-body -->
	            </div>
	            
	            
	            

	            
	            
	            
	            
	            
	            <!-- ============================================================================ -->
	            
	            
	            
	            
	            
	            
	            
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
	document.addEventListener("DOMContentLoaded", function() {
	
		// 강의데이터 필터링
		const courseList = JSON.parse(`${jsonStr}`);
		const head = document.getElementById("tableHead");
		const body = document.getElementById("tableBody");
		
		// 개설학기 정보 (형식: 개설년도 - 학기)
		const semstrInfo = "";
		courseList.forEach(item => {
			item.semstrInfo = `\${item.estblYear} - \${item.estblSemstr.substring(0,1)}`;
		});
		console.log(courseList);
		console.log(courseList.map(v => v.allCourse.operAt));
		
		const getValue = (obj, key) => {
			if (!key) { return ""; }
			return key.split('.').reduce((o,i) => (o ? o[i] : ''), obj);
		};
		
		const headers = {
				all: [
						{ label: "교과목ID", key: "estbllctreCode" }, 
						{ label: "이수구분", key: "complSe" }, 
						{ label: "강의명", key: "allCourse.lctreNm" }, 
						{ label: "개설학과", key: "subjctNm" }, 
						{ label: "취득학점", key: "acqsPnt" }, 
						{ label: "수강인원", key: "atnlcNmpr" }, 
						{ label: "개설학기", key: "semstrInfo" }, 
						{ label: "상태", key: "allCourse.operAt" }
					 ],
				0:   [
						{ label: "교과목ID", key: "estbllctreCode" }, 
						{ label: "이수구분", key: "complSe" }, 
						{ label: "강의명", key: "allCourse.lctreNm" }, 
						{ label: "개설학과", key: "subjctNm" }, 
						{ label: "취득학점", key: "acqsPnt" }, 
						{ label: "수강인원", key: "atnlcNmpr" }, 
						{ label: "입력", key: "" }, 
						{ label: "상태", key: "allCourse.operAt" }
					 ],
				1:   [
						{ label: "교과목ID", key: "estbllctreCode" }, 
						{ label: "이수구분", key: "complSe" }, 
						{ label: "강의명", key: "allCourse.lctreNm" }, 
						{ label: "개설학과", key: "subjctNm" }, 
						{ label: "평가방식", key: "evlMthd" }, 
						{ label: "취득학점", key: "acqsPnt" }, 
						{ label: "수강인원", key: "atnlcNmpr" }
					 ],
				2:   [
						{ label: "교과목ID", key: "estbllctreCode" },
						{ label: "이수구분", key: "complSe" }, 
						{ label: "강의명", key: "allCourse.lctreNm" }, 
						{ label: "개설학과", key: "subjctNm" }, 
						{ label: "취득학점", key: "acqsPnt" }, 
						{ label: "수강인원", key: "atnlcNmpr" }
					 ]
		};
		
		const renderStatusBadge = (operAt, estblSttus) => {

			switch (operAt.toString()) {
				case "0" : 
					return `<span class="badge bg-secondary-subtle text-secondary"><span> 미운영 </span></span>`;
					break;
				case "1" : 
					if (estblSttus == "1" || estblSttus == "3") {
						return `<span class="badge bg-warning-subtle text-warning"><span> 운영전 </span></span>`;
					} else {
						return `<span class="badge bg-success-subtle text-success"><span> 운영중 </span></span>`;
					}
				case "2" :
					return `<span class="badge bg-danger-subtle text-danger"><span> 폐강 </span></span>`;
				default :
					return "";
			}
		};
		
		const renderTable = (filterValue) => {
			
			// 데이터 필터링
			let filteredList = courseList;
			if(filterValue != "all") {
				filteredList = courseList.filter(item => {
					const operat = item.allCourse.operAt.toString();
					if (filterValue == "0") {
						return operat == "0";
					} else if (filterValue == "1") {
						return operat == "1";
					} else if (filterValue == "2") {
						return operat == "2";
					}
					return false;
				});
			}
			
			const currentHeader = headers[filterValue] || headers.all;
			
			// 헤더 생성
			let headHtml = "<tr>";
			currentHeader.forEach(h => {
				headHtml += `<th>\${h.label}</th>`;
			});
			headHtml += "</tr>";
			head.innerHTML = headHtml;
			
			// 바디 생성
			let bodyHtml = "";
			
			if (filteredList.length == 0) {
				// 데이터가 없는 경우
				bodyHtml = `<tr><td colspan="\${currentHeader.length}">개설된 강의가 없습니다.</td></tr>`;
			} else {
				filteredList.forEach(item => {
					bodyHtml += `<tr>`;
					
					currentHeader.forEach(h => {
						let cellValue = getValue(item, h.key);
						
						if (h.key == "allCourse.lctreNm") {
							cellValue = `
				                        <a type="button"
					                       data-bs-toggle="modal" data-bs-target="#modalPlan" 
					                       data-item-id="\${item.estbllctreCode}">\${cellValue}&nbsp;
					                       <i class="ri-search-line"></i>
					                    </a>
				                      `;
						} else if (h.key == "allCourse.operAt") {
							cellValue = renderStatusBadge(cellValue, item.estblSttus);
						} else if (!h.key) {
							cellValue = "";
						}
						
						bodyHtml += `<td>\${cellValue}</td>`;
					});
				
					bodyHtml += `</tr>`;
				});
			}
			
			body.innerHTML = bodyHtml;
		};
		
		
// 		const navTabsContainer = document.querySelector('.nav-tabs');
// 		console.log("체크: ", navTabsContainer != null);
		
		// 초기 렌더링
		renderTable("all");
		console.log("초기 렌더링 완료");
		
// 		if(navTabsContainer) {
// 			navTabsContainer.addEventListener("shown.bs.tab", function(event) {
				
// 				const clickedTab = event.target;
// 				console.log(clickedTab);
// 				const filterValue = clickedTab.getAttribute('data-filter');
// 				console.log("filterValue : ", filterValue);
				
// 					renderTable(filterValue);
				
// 			});
// 		} 
	
	document.querySelectorAll('.nav-tabs .nav-link').forEach(function(tab) {
		tab.addEventListener('shown.bs.tab', function(event) {
			console.log("이벤트 발생")
			const filterValue = event.target.getAttribute('data-filter');
			renderTable(filterValue);
		});
	});
		
	});
	
	
// 	renderTable("all");
	
	
	/*
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
				
				modalBody.innerHTML = modalHtml;
			})
			.catch(error => {
				console.error('fetch 에러 : ', error);
				modalBody.innerHTML = '<p class="text-danger">강의 정보를 불러오는 데 실패했습니다.</p>';
			});
	});
	*/
	
	
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
.bg-secondary-subtle {
  background-color: #e2e3e5 !important;  /* Bootstrap subtle secondary 회색 */
  color: #6c757d !important;
}

.table-fixed-layout {
	width: 50%;
	table-layout: fixed;
}

.table-fixed-height th,
.table-fixed-height td {
  /* ⭐️ 핵심: 모든 셀에 최소 높이를 강제 지정 */
  min-height: 50px; 
  height: 50px; /* 모든 셀 높이를 50px로 고정 */
  vertical-align: middle; /* (선택 사항) 셀 내용 세로 중앙 정렬 */
}

.table-fixed-layout td {
	background-color: #f3f6f9;
}
</style>

<%@ include file="../footer.jsp" %>
