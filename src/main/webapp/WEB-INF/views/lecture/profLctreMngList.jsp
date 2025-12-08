<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/prof"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">강의</a></li>
            <li class="breadcrumb-item active" aria-current="page">개설 강의 관리</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">개설 강의 관리</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">
			<!-- 상태 카드 시작 -->
			<div class="row">
				<div class="col-xl-3 col-md-6">
	                <!-- card -->
	                <div class="card card-animate border-0 border-start border-3" style="border-color:#3577f1 !important;">
	                    <div class="card-body">
	                        <div class="d-flex align-items-center">
	                            <div class="flex-grow-1">
	                                <p class="text-uppercase fw-medium text-muted mb-0">전체 강의</p>
	                            </div>
	                            <div class="flex-shrink-0">
	                                <h5 class="text-primary fs-14 mb-0">
	                                    total
	                                </h5>
	                            </div>
	                        </div>
	                        <div class="d-flex align-items-end justify-content-between mt-4">
	                            <div>
	                                <h4 class="fs-22 fw-semibold ff-primary mb-4"><span id="totalInput">0</span>개</h4>
	                            </div>
	                            <div class="avatar-sm flex-shrink-0">
	                                <span class="avatar-title bg-primary-subtle rounded fs-3">
	                                    <i class="ri-list-check text-primary"></i>
	                                </span>
	                            </div>
	                        </div>
	                    </div><!-- end card body -->
	                </div><!-- end card -->
	            </div>
				<div class="col-xl-3 col-md-6">
	                <!-- card -->
	                <div class="card card-animate border-0 border-start border-3 border-success">
	                    <div class="card-body">
	                        <div class="d-flex align-items-center">
	                            <div class="flex-grow-1">
	                                <p class="text-uppercase fw-medium text-muted mb-0">승인 강의</p>
	                            </div>
	                            <div class="flex-shrink-0">
	                                <h5 class="text-success fs-14 mb-0">
	                                    Approved
	                                </h5>
	                            </div>
	                        </div>
	                        <div class="d-flex align-items-end justify-content-between mt-4">
	                            <div>
	                                <h4 class="fs-22 fw-semibold ff-success mb-4"><span id="approvedInput">0</span>개</h4>
	                            </div>
	                            <div class="avatar-sm flex-shrink-0">
	                                <span class="avatar-title bg-success-subtle rounded fs-3">
	                                    <i class=" ri-checkbox-circle-line text-success"></i>
	                                </span>
	                            </div>
	                        </div>
	                    </div><!-- end card body -->
	                </div><!-- end card -->
	            </div>
				<div class="col-xl-3 col-md-6">
	                <!-- card -->
	                <div class="card card-animate border-0 border-start border-3 border-danger">
	                    <div class="card-body">
	                        <div class="d-flex align-items-center">
	                            <div class="flex-grow-1">
	                                <p class="text-uppercase fw-medium text-muted mb-0">반려 강의</p>
	                            </div>
	                            <div class="flex-shrink-0">
	                                <h5 class="text-danger fs-14 mb-0">
	                                    Rejected
	                                </h5>
	                            </div>
	                        </div>
	                        <div class="d-flex align-items-end justify-content-between mt-4">
	                            <div>
	                                <h4 class="fs-22 fw-semibold ff-danger mb-4"><span id="rejectedInput">0</span>개</h4>
	                            </div>
	                            <div class="avatar-sm flex-shrink-0">
	                                <span class="avatar-title bg-danger-subtle rounded fs-3">
	                                    <i class="ri-forbid-line text-danger"></i>
	                                </span>
	                            </div>
	                        </div>
	                    </div><!-- end card body -->
	                </div><!-- end card -->
	            </div>
				<div class="col-xl-3 col-md-6">
	                <!-- card -->
	                <div class="card card-animate border-0 border-start border-3" style="border-color:#ced4da !important;">
	                    <div class="card-body">
	                        <div class="d-flex align-items-center">
	                            <div class="flex-grow-1">
	                                <p class="text-uppercase fw-medium text-muted mb-0">미입력 강의</p>
	                            </div>
	                            <div class="flex-shrink-0">
	                                <h5 class="text-dark fs-14 mb-0">
	                                    Pending
	                                </h5>
	                            </div>
	                        </div>
	                        <div class="d-flex align-items-end justify-content-between mt-4">
	                            <div>
	                                <h4 class="fs-22 fw-semibold ff-secondary mb-4"><span id="pendingInput">0</span>개</h4>
	                            </div>
	                            <div class="avatar-sm flex-shrink-0">
	                                <span class="avatar-title bg-dark-subtle rounded fs-3">
	                                    <i class="ri-file-edit-line text-dark"></i>
	                                </span>
	                            </div>
	                        </div>
	                    </div><!-- end card body -->
	                </div><!-- end card -->
	            </div>
	        </div>
			<!-- 상태 카드 끝 -->
			
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
                                처리중 <span class="badge rounded-pill text-bg-success" id="doneBadge"></span>
                            </a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link align-middle" data-bs-toggle="tab" href="#nav-badge-home" data-filter="0"  role="tab" aria-selected="false" tabindex="-1">
                                반려/미입력
                                <span class="badge rounded-pill text-bg-danger" id="errorBadge"></span>
                            </a>
                        </li>
                    </ul>
                    <!-- Nav tabs -->
                    <div class="tab-pane active show" id="nav-badge-home" role="tabpanel">
	                    <div class="tab-content text-muted">
	                        <div id="form">
				       			<form id="form">
				       				<input type="hidden" name="profsrNo" value="${profsrNo}">
				       				<div id="courseTable" style="border-radius: 8px;">
										<table class="table" style="border-radius: 8px; overflow: hidden;">
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
            
	    </div>
    </div>

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
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">닫기</button>
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
		
		// 상태 카드 렌더링
		const totalInput = document.querySelector("#totalInput");
		const approvedInput = document.querySelector("#approvedInput");
		const rejectedInput = document.querySelector("#rejectedInput");
		const pendingInput = document.querySelector("#pendingInput");
		
		const renderCardValue = () => {
			const total = courseList.length;
			const approved = courseList.filter(item => item.estblSttus == 2).length;
			const rejected = courseList.filter(item => item.estblSttus == 3).length;
			const pending = courseList.filter(item => item.estblSttus == 0).length;
			
			totalInput.textContent = total;
			approvedInput.textContent = approved;
			rejectedInput.textContent = rejected;
			pendingInput.textContent = pending;
		}
		
		
		// 탭 뱃지 렌더링
		let doneValue = 0;
		let errorValue = 0;
		const doneBadge = document.querySelector("#doneBadge");
		const errorBadge = document.querySelector("#errorBadge");
		
		courseList.forEach(item => {
			if (item.estblSttus == 1) {
				doneValue++;
			} else if (item.estblSttus == 0 || item.estblSttus == 3) {
				errorValue++;
			}
		})
		
		if (doneBadge) {
			doneBadge.textContent = doneValue;
			if (doneValue == 0) {
				doneBadge.style.display = "none";
			} else {
				doneBadge.style.display = "inline-block";
			}
		}
		
		if (errorBadge) {
			errorBadge.textContent = errorValue;
			if (errorValue == 0) {
				errorBadge.style.display = "none";
			} else {
				errorBadge.style.display = "inline-block";
			}
		}
		
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
						{ label: "상태", key: "estblSttus" }
					 ],
				0:   [
						{ label: "교과목ID", key: "estbllctreCode" }, 
						{ label: "이수구분", key: "complSe" }, 
						{ label: "강의명", key: "allCourse.lctreNm" }, 
						{ label: "개설학과", key: "subjctNm" }, 
						{ label: "취득학점", key: "acqsPnt" }, 
						{ label: "수강인원", key: "atnlcNmpr" }, 
						{ label: "상태", key: "estblSttus" }, 
						{ label: "-", key: "" }
					 ],
				1:   [
						{ label: "교과목ID", key: "estbllctreCode" }, 
						{ label: "이수구분", key: "complSe" }, 
						{ label: "강의명", key: "allCourse.lctreNm" }, 
						{ label: "개설학과", key: "subjctNm" }, 
						{ label: "취득학점", key: "acqsPnt" }, 
						{ label: "수강인원", key: "atnlcNmpr" }, 
						{ label: "상태", key: "estblSttus" },
						{ label: "-", key: "" }
					 ]
		};
		
		// 상태 뱃지 생성 함수
		const renderStatusBadge = (estblSttus) => {
			estblSttus = estblSttus.toString();
			switch (estblSttus) {
					case "0" : 
						return `<span class="badge bg-secondary-subtle text-secondary"><span> 미입력 </span></span>`;
					case "1" : 
						return `<span class="badge bg-success-subtle text-success"><span> 입력완료 </span></span>`;
					case "2" : 
						return `<span class="badge bg-primary-subtle text-primary"><span> 승인 </span></span>`;
					case "3" : 
						return `<span class="badge bg-danger-subtle text-danger"><span> 반려 </span></span>`;
					default :
						return "";
			} 
		};
		
		// 버튼 생성 함수
		const renderButton = (code, value) => {
			if (value == "0") {
				return `<a type="button" href="/prof/lecture/mng/edit?estbllctreCode=\${code}" class="btn btn-sm btn-primary" data-code="\${code}">입력하기</button>`;
			} else if (value == "1") {
				return `<a type="button" href="/prof/lecture/mng/edit?estbllctreCode=\${code}" class="btn btn-sm btn-primary" data-code="\${code}">내용보기</button>`;
			}
		}
		
		const renderTable = (filterValue) => {
			
			// 데이터 필터링
			let filteredList = courseList;
			if(filterValue != "all") {
				filteredList = courseList.filter(item => {
					const estblSttus = item.estblSttus.toString();
					if (filterValue == "0") {
						return estblSttus == "0" || estblSttus == "3";
					} else if (filterValue == "1") {
						return estblSttus == "1";
					} else if (filterValue == "2") {
						return estblSttus == "2";
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
				if(filterValue == "1") {
					bodyHtml = `<tr><td colspan="\${currentHeader.length}">처리 중인 강의가 없습니다.</td></tr>`;
				} else if (filterValue == "0") {
					bodyHtml = `<tr><td colspan="\${currentHeader.length}">미입력 강의가 없습니다.</td></tr>`;
				} else {
					bodyHtml = `<tr><td colspan="\${currentHeader.length}">개설 강의가 없습니다.</td></tr>`;
				}
			} else {
				filteredList.forEach(item => {
					bodyHtml += `<tr>`;
					
					const courseCode = getValue(item, "estbllctreCode");
					const courseSubmit = getValue(item, "totalSubmit");
					
					currentHeader.forEach(h => {
						let cellValue = getValue(item, h.key);
						
						if (h.key == "allCourse.lctreNm") {
							if (filterValue == "all") {
								cellValue = `
					                        <a type="button"
						                       data-bs-toggle="modal" data-bs-target="#modalDetail" 
						                       data-item-id="\${item.estbllctreCode}">\${cellValue}&nbsp;
						                       <i class="ri-search-line"></i>
						                    </a>
					            `;
							} else {
								cellValue = `
									\${cellValue}
								`;
							}
						} else if (h.key == "estblSttus") {
							cellValue = renderStatusBadge(cellValue);
						} else if (h.key == "") {
							cellValue = renderButton(courseCode, filterValue);
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
		


		// 초기 렌더링
		renderTable("all");
		renderCardValue();
		console.log("초기 렌더링 완료");
		
		
	
		document.querySelectorAll('.nav-tabs .nav-link').forEach(function(tab) {
			tab.addEventListener('shown.bs.tab', function(event) {
				console.log("이벤트 발생")
				const filterValue = event.target.getAttribute('data-filter');
				renderTable(filterValue);
			});
		});
			
		});
		
	
		// 강의 세부 정보 모달
		const modalDetail = document.getElementById("modalDetail");
	
		modalDetail.addEventListener("show.bs.modal",(event)=>{
			
			const modalPlanBtn = event.relatedTarget;
			const estbllctreCode = modalPlanBtn.getAttribute("data-item-id");
			const modalBody = modalDetail.querySelector(".modal-body");
			
			infoHtml = `
			        <div class="card-body">
			            <ul class="nav nav-pills nav-primary mb-3" role="tablist">
			                <li class="nav-item waves-effect waves-light" role="presentation">
			                    <a class="nav-link active" data-bs-toggle="tab" href="#home-1" role="tab" aria-selected="true">강의 정보</a>
			                </li>
			                <li class="nav-item waves-effect waves-light" role="presentation">
			                    <a class="nav-link" data-bs-toggle="tab" href="#profile-1" role="tab" aria-selected="false" tabindex="-1">주차별 학습 목표</a>
			                </li>
			            </ul>
			            <div class="tab-content table-fixed-width">
			`;
			
			console.log("체크 : ", estbllctreCode);
			
			event.preventDefault();
			
			fetch("/lecture/detail/"+estbllctreCode)
				.then(response => {
					if(!response.ok) {
						throw new Error("서버 오류 발생...");
					}
					return response.json();
				})
				.then(data => {
					const vo = data.estblCourseVO;
					
					if (vo.estblSttus != "2") {
						Swal.fire({
							icon: "warning",
							title: "미개설 강의",
							text: "개설된 강의만 열람할 수 있습니다."
						});
						return;
					}
					
					const bsModal = new bootstrap.Modal(modalDetail);
					bsModal.show();
					
					modalBody.innerHTML = `<p>강의 정보를 불러오는 중...</p>`;
					
					let fileHtml = "";
					
					// 강의 정보 탭 렌더링
					if(vo.file) {
						const fileName = vo.file.fileNm;
						const fileGroupNo = vo.file.fileGroupNo;
						const fileStreplace = vo.file.fileStreplace;
						
						fileHtml = `
									<td class="text-nowrap text-center">강의계획서</td>
				                    <th colspan="2">
				                    	<a href="" id="fileDownload"  
										   style="margin-left:10px" 
										   data-filegroupno="\${fileGroupNo}"
										>
											파일명 &nbsp;
											<i class="ri-folder-download-line"></i>
										</a>
				                    </th>
						`;
					} else {
						fileHtml = `
									<td class="text-nowrap text-center">강의계획서</td>
				                    <th colspan="2">
				                    	<a id="fileDownload"  
										   style="margin-left:10px" 
										   data-filegroupno="0"
										>
										    \${fileName} &nbsp;
											<i class="ri-folder-download-line"></i>
										</a>
				                    </th>
						`;
					}
					
					let modalHtml = "";
					
					modalHtml += infoHtml;
					modalHtml += `
	                    <div class="tab-pane active" id="home-1" role="tabpanel">
							<div class="d-flex">
								<div class="table-responsive">
				                    <table class="table table-bordered table-nowrap table-fixed-layout">
				                        <tr>
				                            <td class="text-nowrap text-center">강의명</td>
				                            <th colspan="4">\${vo.allCourse.lctreNm}</th>
				                            <td class="text-nowrap text-center" scope="row">강의코드</td>
				                            <th>\${vo.estbllctreCode}</th>
				                        </tr>
				                        <tr>
				                            <td class="text-nowrap text-center">이수구분</td>
				                            <th colspan="3">\${vo.complSe}</th>
				                            <td class="text-nowrap text-center">수강인원</td>
				                            <th colspan="2">\${vo.atnlcNmpr}</th>
				                        </tr>
				                        <tr>
				                            <td class="text-nowrap text-center">평가방식</td>
				                            <th colspan="3">\${vo.evlMthd}</th>
				                            <td class="text-nowrap text-center">취득학점</td>
				                            <th colspan="2">\${vo.acqsPnt}</th>
				                        </tr>
				                        <tr>
				                            <td class="text-nowrap text-center">강의실</td>
				                            <th colspan="3">\${vo.cmmn}&nbsp;\${vo.lctrum.substring(1,4)}호</th>
				                            <td class="text-nowrap text-center">강의시간</td>
				                            <th colspan="2">\${vo.timetable.lctreDfk} \${vo.timetable.beginTm}, \${vo.timetable.endTm}</th>
				                        </tr>
				                        <tr>
				                            <td class="text-nowrap text-center">수업언어</td>
				                            <th colspan="3">\${vo.lctreUseLang}</th>
		            `;
		            
					modalHtml += fileHtml;
					
					modalHtml += `		
										</tr>
						                <tr>
						                    <td colspan="7"></td>
						                </tr>
						                <tr>
						                    <td class="text-nowrap text-center">교수</td>
						                    <th colspan="3">\${vo.sklstf.sklstfNm}</th>
						                    <td class="text-nowrap text-center">연구실</td>
						                    <th colspan="2">\${vo.profsr.labrumLc}</th>
						                </tr>
						                <tr>
						                    <td class="text-nowrap text-center">e-mail</td>
						                    <th colspan="3">\${vo.profsr.emailAdres}</th>
						                    <td class="text-nowrap text-center">연락처</td>
						                    <th colspan="2">\${vo.sklstf.cttpc}</th>
						                </tr>
						                <tr>
						                    <td colspan="7"></td>
						                </tr>
						            </table>
						        </div>
					        </div>
				        </div>
					`;
					
					// 주차별 학습 목표 탭 렌더링
					
					if(vo.weekAcctoLrnVO.length == 0) {
							modalHtml += `
								<div class="tab-pane" id="profile-1" role="tabpanel">
				                    <div class="d-flex">
										<p>주차별 학습 목표가 입력되지 않았습니다.</p>
									</div>
		                        </div>	
							`;
					} else {
						
						modalHtml += `
							<div class="tab-pane" id="profile-1" role="tabpanel">
			                    <div class="d-flex">
									<div class="accordion custom-accordionwithicon-plus" id="accordionWithplusicon" style="width:100%;">
						`;
						
						vo.weekAcctoLrnVO.forEach(w=>{
							
							let weekNo = w.week;
							
							modalHtml += `
								<div class="accordion-item">
							        <h2 class="accordion-header" id="week\${weekNo}">
							            <button class="accordion-button \${weekNo=='1' ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#week\${weekNo}Content" aria-expanded="true" aria-controls="week\${weekNo}Content">
							                \${weekNo}주차&nbsp;&nbsp;\${w.lrnThema}
							            </button>
							        </h2>
							        <div id="week\${weekNo}Content" class="accordion-collapse collapse \${weekNo=='1' ? 'show' : ''}" aria-labelledby="week\${weekNo}" data-bs-parent="#weekInfo">
							            <div class="accordion-body">
								            <div class="d-flex mb-2 align-items-center">
							            		<label class="form-label me-2 mb-0" style="width:80%;">\${w.lrnCn}</label>
								            </div>
							            </div>
							        </div>
							    </div>
							`;
						});
						
						modalHtml += `
											</div>
					                    </div>
					                </div>
					            </div>
					        </div>
						`;
				}
					
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
.bg-secondary-subtle {
  background-color: #e2e3e5 !important;  /* Bootstrap subtle secondary 회색 */
  color: #6c757d !important;
}
.bg-primary-subtle {
  background-color: #c3deff !important;  /* Bootstrap subtle secondary 회색 */
  color: #0978ff !important;
}
.table-fixed-layout {
	width: 100%;
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
