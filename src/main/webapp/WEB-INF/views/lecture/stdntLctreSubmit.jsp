<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">강의</a></li>
            <li class="breadcrumb-item active" aria-current="page">수강신청</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">수강신청</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">
        <div class="card card-custom p-4">
            <div class="overflow-visible" style="margin-bottom:10px">
                <div class="w-100 p-0" id="searchBox" style="border-radius: 8px;">
                  <form class="w-100 align-items-center py-2 d-flex p-3" role="search">
                      <div class="fw-bold me-3 flex-shrink-0" style="padding-right:500px">강의 검색</div>
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
                    <div id="courseTable" style="border-radius: 8px;">
                        <table class="table" style="border-radius: 8px; overflow: hidden;">
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
			
			if(list.length == 0) {
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
		
		Swal.fire({
			icon: "question",
			html: "선택한 강의를 신청하시겠습니까?",
			showCancelButton: true,
			confirmButtonText: "예",
			cancelButtonText: "아니오"
		})
		.then((result) => {
			if (result.isConfirmed) {
				
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
				
				if(!result.success) {
					let failMsg = "";
					let hasConflict = false;
					
					const perLec = result.perLec;
					const alreadyLec = result.alreadyLec; 
					const checkNmpr = result.checkNmpr;
					
					if(alreadyLec != null) {
						// 중복 강의 검사
						failMsg = "이미 신청한 강의입니다.";
						hasConflict = true;
						
					} else if (perLec != null) {
						// 중복 시간표 검사
						failMsg = "시간표가 겹치는 강의입니다.";
						hasConflict = true;
						
					} else if (checkNmpr == false) {
						// 수강 정원 초과 검사
						failMsg = "수강 가능 정원을 초과했습니다.";
						hasConflict = true;
					}
					
					// 실패 메세지 출력
					if(hasConflict) {
						Swal.fire({
							icon: "error",
							title: "신청 실패",
							text: failMsg
						});
					} else {
						Swal.fire({
							icon: "error",
							title: "신청 실패",
							text: "알 수 없는 오류로 강의 담기에 실패했습니다."
						});
					}
					
				} else {
					
					// 장바구니 담기 성공
					Swal.fire({
								icon: "success",
								title: "신청 성공",
								text: "선택하신 강의를 성공적으로 신청했습니다."
							})
				}
				
				loadCourseList();
				
			})
			.catch(error => {
				
				console.error("fetch 요청 오류 발생 : ", error);
			});
			}
		})
	});
	
	
	// 강의 세부 정보 모달
	const modalPlan = document.getElementById("modalPlan");

	modalPlan.addEventListener("show.bs.modal",(event)=>{
		const modalPlanBtn = event.relatedTarget;
		const estbllctreCode = modalPlanBtn.getAttribute("data-item-id");
		
		const modalBody = modalPlan.querySelector(".modal-body");
		modalBody.innerHTML = `<p>강의 정보를 불러오는 중...</p>`;
		
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
#form {
	max-height: 270px;
	overflow-y: auto;
}
#searchBox {
  background-color: #F3F6F9;
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
