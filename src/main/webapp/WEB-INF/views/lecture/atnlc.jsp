<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

	    <div class="card card-custom p-4">
			<h5 class="card-title mb-3">개설 강의</h5>
	        <div class="flex-grow-1 p-1 overflow-visible">
	       		<div class="container-fluid">
	       			<nav class="navbar navbar-expand-lg bg-body-tertiary">
					  <div class="container-fluid">
					    <a class="navbar-brand">구분</a>
					    <div class="collapse navbar-collapse" id="navbarSupportedContent">
					      <form class="d-flex" role="search">
					        <select class="form-select" aria-label="Default select example" name="complSe" value="${param.complSe}">
							  <option value="" selected>이수구분</option>
							  <option value="전필">전필</option>
							  <option value="전선">전선</option>
							  <option value="교필">교필</option>
							  <option value="교선">교선</option>
							  <option value="일선">일선</option>
							</select>
							<a class="navbar-brand" style="margin-left:50px">강의명</a>
					        <input type="search" placeholder="Search"  class="form-control"aria-label="Search" name="keyword" value="${param.keyword}"/>
					        <button class="btn btn-outline-primary flex-shrink-0" type="submit" style="margin-left:50px">검색</button>
					      </form>
					    </div>
					  </div>
					</nav>
       			</div>
	       		</div>
	       		<div id="form">
	       			<form>
	       				<input type="hidden" name="stdntNo" value="${stdntNo}">
	       				<div id="courseTable">
							<table class="table">
							  <thead class="table-light">
							  	<tr>
							  		<th>선택</th><th>교과목ID</th><th>이수구분</th><th>강의명</th><th>교수명</th><th>취득학점</th><th>강의실</th><th>강의시간</th><th>신청인원</th><th></th>
							  	</tr>
						  		</thead>   
						  		<tbody id="courseTbody" class="align-middle">
						  			<tr><td colspan="9">강의 목록을 불러오는 중...</td></tr>
					  			</tbody>
							</table>
						</div>
						<button type="submit" class="btn btn-primary" id="addCartBtn" style="margin-top: 20px">선택 담기</button>
					</form>
				</div>
	    <!-- 장바구니 리스트 파일 -->
	    <%@ include file="./mycartlist.jsp" %>
<!-- 	        </div> -->
<!-- 	    </div> -->
<!--     </div> -->
<!-- </main> -->

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
const courseTbody = document.getElementById("courseTbody");
	
	function loadCourseList(keyword="", complSe="") {
		
		const url = `/atnlc/load?keyword=\${keyword}&complSe=\${complSe}`;
		console.log("url : ", url);
		
		fetch(url, {
			method: "get",
			headers: {"Content-Type":"application/json;charset=UTF-8"}
		})
		.then(response => {
			if(!response.ok) {
				throw new Error("오류 발생...");
			}
			return response.json();
		})
		.then(data => {
			console.log(data);
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
							<td><input type="checkbox" name="listCheck" value="\${l.estbllctreCode}"></td>
				  			<td>\${l.estbllctreCode}</td>
				  			<td>\${l.complSe}</td>
				  			<td>\${l.allCourse.lctreNm}</td>
				  			<td>\${l.sklstf.sklstfNm}</td>
				  			<td>\${l.acqsPnt}</td>
				  			<td>\${l.lctrum}</td>
				  			<td>\${timeInfo}</td>
				  			<td>\${l.totalReqst}/\${l.atnlcNmpr}</td>
				  		</tr>
				`; 
			});
			
			courseTbody.innerHTML = html;
		}

	}
	
	
	document.querySelector("nav form").addEventListener("submit", function(event) {
		event.preventDefault();
		
		const form = event.target;
		const keyword = form.querySelector("input[name='keyword']").value;
		const complSe = form.querySelector("select[name='complSe']").value;
		
		console.log("keyword : ", keyword);
		console.log("complSe : ", complSe);
		loadCourseList(keyword, complSe);
	});
	
	

	// 장바구니 담기
	$("#addCartBtn").on("click",(event)=>{
		event.preventDefault();
		console.log("담기 버튼 click");
		
		const selectedCodes = getListCourseCodes();
		const stdntNo = document.getElementsByName("stdntNo")[0].value;
		
		
		if(selectedCodes.length==0) {
			alert("강의를 선택해 주세요.");
			return;
		} 

		const data = {
			stdntNo : stdntNo,
			estbllctreCodes : selectedCodes
		};
		
		
		if(confirm("선택한 강의를 장바구니에 담으시겠습니까?")) {
			
			fetch("/atnlc/mycart/add", {
				method: "post",
				headers: {"Content-Type":"application/json;charset-UTF-8"},
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
					const alreadyLecCodes = result.alreadyLecCodes; 
					if(alreadyLecCodes && alreadyLecCodes.length > 0) {
						failMsg += "이미 장바구니에 담은 강의입니다.\n";
						failMsg += " - " + alreadyLecCodes.join('\n - ') + "\n\n";
						hasConflict = true;
					}
					
					// 중복 시간표
					const perLecCodes = result.perLecCodes;
					if(perLecCodes && perLecCodes.length > 0) {
						failMsg += "시간표가 겹치는 강의입니다.\n";
						failMsg += " - " + perLecCodes.join('\n - ') + "\n\n";
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
		
	})
	

	function getListCourseCodes() {
		const checkboxs = document.querySelectorAll("input[name='listCheck']:checked");
		const listCourseCodes = Array.from(checkboxs).map(checkbox => checkbox.value);
		
		return listCourseCodes;
	}
	
	loadCourseList();
</script>

<%@ include file="../footer.jsp" %>





