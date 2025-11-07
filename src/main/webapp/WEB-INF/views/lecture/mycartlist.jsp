<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


			<hr/>
			<h5 class="card-title mb-3">나의 장바구니</h5>
	       		<div id="mycart-section">
	       			<form>
	       				<div id="cartTable">
							<table class="table">
							  <thead class="table-light">
							  	<tr>
							  		<th>선택</th><th>교과목ID</th><th>이수구분</th><th>강의명</th><th>교수명</th><th>취득학점</th><th>강의실</th><th>강의시간</th><th>수강인원</th><th></th>
							  	</tr>
							  </thead>   
							  <tbody id="mycartTbody" class="align-middle">
							  	<tr><td colspan="9">장바구니 목록을 불러오는 중...</td></tr>
							  </tbody>
							</table>
						</div>
						<button type="submit" class="btn btn-danger" id="editCartBtn">삭제</button>
					</form>
				</div>
      	  </div>
	    </div>
    </div>

<script>
const mycartTbody = document.getElementById("mycartTbody");

	function loadMyCart() {
		fetch("/atnlc/mycart?stdntNo=${stdntNo}", {
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
						<td><input type="checkbox" name="cartCheck" value="\${l.estbllctreCode}"></td>
			  			<td>\${l.estbllctreCode}</td>
			  			<td>\${l.estblCourse.complSe}</td>
			  			<td>\${l.allCourse.lctreNm}</td>
			  			<td>\${l.sklstf.sklstfNm}</td>
			  			<td>\${l.estblCourse.acqsPnt}</td>
			  			<td>\${l.estblCourse.lctrum}</td>
			  			<td>\${timeInfo}</td>
			  			<td>\${l.estblCourse.atnlcNmpr}</td>
			  		</tr>
			`;
		});
		
		mycartTbody.innerHTML = html;
	}
	
	// 장바구니 담기 취소
	$("#editCartBtn").on("click",(event)=>{
		event.preventDefault();
		console.log("삭제 버튼 click");
		
		const selectedCodes = getCartCourseCodes();
		const stdntNo = document.getElementsByName("stdntNo")[0].value;
		
		if(selectedCodes.length==0) {
			alert("삭제할 강의를 선택해 주세요.");
			return;
		} 

		const data = {
				stdntNo : stdntNo,
				estbllctreCodes : selectedCodes
			};
		
		if(confirm("선택한 강의를 장바구니에서 삭제하시겠습니까?")) {

			fetch("/atnlc/mycart/edit", {
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
				alert("강의가 삭제되었습니다.");
				loadMyCart();
			})
			.catch(error => {
				console.error("fetch 요청 오류 발생 : ", error);
			});
		}
	});
	
	
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












