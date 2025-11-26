<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


			<h5 class="card-title py-4">나의 장바구니</h5>
	       		<div id="mycart-section">
	       			<form>
	       				<div class="card card-custom p-4" id="cartTable">
	       					<div style="border-radius: 8px;">
								<table class="table">
								  <thead class="table-light">
								  	<tr>
								  		<th>교과목ID</th><th>이수구분</th><th>강의명</th><th>교수명</th><th>취득학점</th><th>강의실</th><th>강의시간</th><th>수강인원</th><th>신청/취소</th>
								  	</tr>
								  </thead>
								  <tbody id="mycartTbody" class="align-middle">
								  	<tr><td colspan="9">장바구니 목록을 불러오는 중...</td></tr>
								  </tbody>
								</table>
							</div>
						</div>
					</form>
				</div>

<script>
const mycartTbody = document.getElementById("mycartTbody");

	function loadMyCart() {
		fetch("/atnlc/cart/mycart?stdntNo=${stdntNo}", {
			method: "get",
			headers: {"Content-Type":"application/json;charset=UTF-8"},
		})
		.then(response => {
			if(!response.ok) {
				throw new Error("오류 발생...");
			}
			return response.json();
		})
		.then(data => {
			console.log("장바구니 data : ", data);
			loadCartList(data.atnlcReqstVOList);
			
		})
		.catch(error => {
			console.error("장바구니 데이터를 불러오지 못했습니다... : ", error);
			mycartTbody.innerHTML = "<tr><td colspan='9'>장바구니 데이터를 불러오지 못했습니다...</td></tr>"
		});
	}	
	

	// 장바구니 목록 로드 함수
	function loadCartList(list) {
		mycartTbody.innerHTML = "";
		
		if(list.length == 0) {
			mycartTbody.innerHTML = "<tr><td colspan='9'>장바구니가 비었습니다.</td></tr>";
			return;
		}
		
		let html = "";
		
		list.forEach(l=>{
			
			const timeInfo = `\${l.estblCourse.timetable.lctreDfk} \${l.estblCourse.timetable.beginTm},\${l.estblCourse.timetable.endTm}`;
			
			html += `
					<tr>
			  			<td>\${l.estbllctreCode}</td>
			  			<td>\${l.estblCourse.complSe}</td>
			  			<td>\${l.allCourse.lctreNm}</td>
			  			<td>\${l.sklstf.sklstfNm}</td>
			  			<td>\${l.estblCourse.acqsPnt}</td>
			  			<td>\${l.estblCourse.cmmn} \${l.estblCourse.lctrum.substring(1,4)}호</td>
			  			<td>\${timeInfo}</td>
			  			<td>\${l.estblCourse.atnlcNmpr}</td>
						<td><button type="button" class="btn btn-primary single-submit-btn" id="submitBtn" data-code="\${l.estbllctreCode}">신청</button>
						<button type="button" class="btn btn-danger  single-submit-btn" id="editBtn" data-code="\${l.estbllctreCode}">취소</button></td>
			  		</tr>
			`;
		});
		
		mycartTbody.innerHTML = html;
	}
	

	// 장바구니 담기 취소
	$("#mycart-section").on("click","#editBtn",(event)=>{
		event.preventDefault();
		console.log("취소 버튼 click");

		const stdntNo = document.getElementsByName("stdntNo")[0].value;
		const estbllctreCode = $(event.currentTarget).data("code");

		console.log("선택 강의 코드 : " + estbllctreCode + " / 학생ID : " + stdntNo);

		const data = {
				stdntNo : stdntNo,
				estbllctreCode : estbllctreCode
		};

		Swal.fire({
			icon: "question",
			html: "선택한 강의를 장바구니에서 삭제하시겠습니까?",
			showCancelButton: true,
			confirmButtonText: "예",
			cancelButtonText: "아니오"
		})
		.then((result) => {
			if (result.isConfirmed) {
				
				fetch("/atnlc/cart/mycart/edit", {
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
					Swal.fire({
						icon: "success",
						title: "삭제 성공",
						text: "선택하신 강의를 장바구니에서 삭제했습니다."
					});
					loadMyCart();
				})
				.catch(error => {
					console.error("fetch 요청 오류 발생 : ", error);
				});
			}
			
		})
	});


	// 장바구니 강의 수강신청
	$("#mycart-section").on("click","#submitBtn",(event)=>{
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
				fetch("/atnlc/cart/mycart/submit", {
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
	
					Swal.fire({
						icon: "success",
						title: "신청 성공",
						text: "강의가 신청되었습니다."
					});
	
					loadMyCart();
					loadCourseList();
				})
				.catch(error => {
	
					console.error("fetch 요청 오류 발생 : ", error);
				});
			}
		})

	})

	function getCartCourseCodes() {
		const checkboxs = document.querySelectorAll("input[name='cartCheck']:checked");
		const cartCourseCodes = Array.from(checkboxs).map(checkbox => checkbox.value);

		return cartCourseCodes;
	}


	loadMyCart();

</script>
<style>
#courseTable, #cartTable {
	max-height: 270px;
	overflow-y: auto;
}
thead {
position: sticky;
top: 0;
}
</style>












