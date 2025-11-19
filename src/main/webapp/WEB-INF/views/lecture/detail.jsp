<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../header.jsp" %>

	<div>
		<div class="col-md-7 col-lg-8">
			<h4 class="mb-3">강의 정보</h4> 
			<form class="needs-validation" novalidate="">
				<div class="row g-3"> 
					<div class="col-md-5"> 
					<label for="lctreNm" class="form-label">강의명</label>
						<input type="text" class="form-control" id="lctreNm" placeholder="" value="${estblCourseVO.lctreNm}" required="" readonly> 
							<div class="invalid-feedback">
								Valid first name is required.
							</div> 
					</div> 
					<div class="col-md-4"> 
					<label for="lctreCode" class="form-label">강의 코드</label> 
						<input type="text" class="form-control" id="lctreCode" placeholder="" value="${estblCourseVO.lctreCode}" required="" readonly> 
							<div class="invalid-feedback">
								Valid first name is required.
							</div> 
					</div> 
					<div class="col-md-3"> 
					<label for="estblYear" class="form-label">개설년도</label> 
						<input type="number" class="form-control" id="estblYear" value="${estblCourseVO.estblYear}" required="" readonly> 
							<div class="invalid-feedback">
								Valid first name is required.
							</div> 
					</div> 
					<div class="col-md-4"> 
						<label for="complSe" class="form-label">이수 구분</label> 
						<select class="form-select" id="complSe" required="" readonly> 
							<c:if test="${estblCourseVO.complSe==null || estblCourseVO.complSe==''}">
								<option value="---">---</option> 
							</c:if>
							<c:if test="${estblCourseVO.complSe=='전필'}">
								<option value="전필">전필</option> 
							</c:if>
							<c:if test="${estblCourseVO.complSe=='전선'}">
								<option value="전선">전선</option> 
							</c:if>
							<c:if test="${estblCourseVO.complSe=='교필'}">
								<option value="교필">교필</option> 
							</c:if>
							<c:if test="${estblCourseVO.complSe=='교선'}">
								<option value="교선">교선</option> 
							</c:if>
							<c:if test="${estblCourseVO.complSe=='일선'}">
								<option value="일선">일선</option> 
							</c:if>
						</select> 
						<div class="invalid-feedback">
							Please provide a valid state.
						</div> 
					</div>
					<div class="col-md-1"> </div>
					<div class="col-md-3"> 
						<label for="evlMthd" class="form-label">평가 방식</label> 
						<select class="form-select" id="evlMthd" required="" readonly>
							<c:if test="${estblCourseVO.evlMthd==null || estblCourseVO.evlMthd==''}">
								<option value="---">---</option> 
							</c:if>
							<c:if test="${estblCourseVO.evlMthd=='절대'}">
								<option value="절대">절대</option> 
							</c:if>
							<c:if test="${estblCourseVO.evlMthd=='상대'}">
								<option value="상대">상대</option> 
							</c:if>
							<c:if test="${estblCourseVO.evlMthd=='PF'}">
								<option value="PF">P/F</option> 
							</c:if>
						</select> 
						<div class="invalid-feedback">
							Please provide a valid state.
						</div> 
					</div>
					<div class="col-md-1"> </div>
					<div class="col-md-3"> 
						<label for="acqsPnt" class="form-label">취득 학점</label> 
						<input type="number" class="form-control" id="acqsPnt" placeholder="" value="${estblCourseVO.acqsPnt}" required="" readonly> 
							<div class="invalid-feedback">
								Valid last name is required.
							</div> 
					</div>
					<div class="col-sm-5"> 
					<label for="lctreDfk" class="form-label">강의일</label> 
						<div class="form-check"> 
							<label class="form-check-label" for="mon">
								<input type="checkbox" class="form-check-input" id="mon"
									<c:if test="${estblCourseVO.lctreDfk=='월'}">checked</c:if>
									>월
							</label>
							<label class="form-check-label" for="tue" style="margin-left:30px">
								<input type="checkbox" class="form-check-input" id="mon"
									<c:if test="${estblCourseVO.lctreDfk=='화'}">checked</c:if>
									>화
							</label>
							<label class="form-check-label" for="wed" style="margin-left:30px">
								<input type="checkbox" class="form-check-input" id="mon"
									<c:if test="${estblCourseVO.lctreDfk=='수'}">checked</c:if>
									>수
							</label>
							<label class="form-check-label" for="thu" style="margin-left:30px">
								<input type="checkbox" class="form-check-input" id="mon"
									<c:if test="${estblCourseVO.lctreDfk=='목'}">checked</c:if>
									>목
							</label>
							<label class="form-check-label" for="fri" style="margin-left:30px">
								<input type="checkbox" class="form-check-input" id="mon"
									<c:if test="${estblCourseVO.lctreDfk=='금'}">checked</c:if>
									>금
							</label>
						</div>
					</div>
					<div class="col-sm-4"> 
						<label for="address2" class="form-label">강의실 </label> 
						<input type="text" class="form-control" id="address2" value="${estblCourseVO.lctrum}" readonly> 
					</div> 
					<div class="col-sm-3"> 
					<label for="lctreNm" class="form-label">수강 인원</label> 
						<input type="number" class="form-control" id="firstName" placeholder="" value="${estblCourseVO.atnlcNmpr}" required="" readonly> 
							<div class="invalid-feedback">
								Valid first name is required.
							</div> 
					</div> 
					<div class="col-sm-4"> 
						<label for="address2" class="form-label">강의계획서 </label> 
						<input type="file" class="form-control" id="address2" placeholder="Apartment or suite"> 
					</div> 
					
					<hr class="my-4">
					
					<div class="col-4"> 
						<label for="sklstfNm" class="form-label">교수</label> 
							<input type="text" class="form-control" id="sklstfNm" required="" value="${estblCourseVO.sklstfNm}" readonly> 
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
							<input type="text" class="form-control" id="cttpc" placeholder="010-XXXX-XXXX" required="" value="${estblCourseVO.cttpc}" readonly> 
							<div class="invalid-feedback">
								Please enter your shipping address.
							</div> 
					</div> 
					<div class="col-4"> 
						<label for="labrumLc" class="form-label">교수 연구실</label> 
							<input type="text" class="form-control" id="labrumLc" required="" value="${estblCourseVO.labrumLc}" readonly> 
							<div class="invalid-feedback">
								Please enter your shipping address.
							</div> 
					</div> 
					<hr class="my-4"> 
					<button class="w-100 btn btn-primary btn-lg" type="submit" id="editBtn">수정</button> 
				</div>
			</form> 
		</div>
	</div>
</div>


<script type="text/javascript">
$("editBtn").on("click",()=>{
	
});
</script>

<%@ include file="../footer.jsp" %>