<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


			<hr/>
			<h5 class="card-title mb-3">나의 장바구니</h5>
	       		<div id="mycart-section">
	       			<form>
						<table class="table">
						  <thead class="table-light">
						  	<tr>
						  		<th>교과목ID</th><th>이수구분</th><th>강의명</th><th>교수명</th><th>취득학점</th><th>강의실</th><th>강의시간</th><th>수강인원</th><th></th>
						  	</tr>
						  </thead>   
						  <c:if test="${empty atnlcReqstVOList}">
						  	<tbody>
						  		<tr><td colspan="9">장바구니가 비었습니다.</td></tr>
						  	</tbody>
						  </c:if>
						  <c:if test="${!empty atnlcReqstVOList}">
							  <tbody>
							  	<c:forEach var="l" items="${atnlcReqstVOList}" varStatus="stat">
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
						<button type="submit" class="btn btn-danger id="delBtn">삭제</button>
					</form>
				</div>
      	  </div>
	    </div>
    </div>

<script>



</script>
