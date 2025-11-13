<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="header.jsp" %>

    <div id="main-container" class="container-fluid">
        <div class="flex-grow-1 p-1 overflow-auto">
			<!-- body 시작 -->
	
		<div class="col-sm-12">
			<div id="example1_filter" class="dataTables_filter" style="float:right;">
				<form id="frm" name="frm" action="/bbs/list" method="get">
					<label>
						<!-- 검색 시 currentPage = 1로 초기화 -->
						<input type="hidden" name="currentPage" value="1" />
						<input type="search" name="keyword" 
							class="form-control form-control-sm"  
							placeholder="검색어를 입력해주세요" 
							value="${param.keyword}" 
							aria-controls="example1" />
					</label>
					<button type="submit" class="btn btn-primary btn-sm">검색</button>
				</form>
			</div>
		</div>
		<div>
			<table class="table table-hover">
			  <thead>
			    <tr>
			      <th scope="col">번호</th>
			      <th scope="col">제목</th>
			      <th scope="col">작성자</th>
			      <th scope="col">작성일</th>
			      <th scope="col">조회수</th>
			    </tr>
			  </thead>
			  <tbody>
			  <c:forEach var="bbsVO" items="${bbsVOList}" varStatus="stat" >
			    <tr>
			      <th scope="row">${bbsVO.rnum}</th>
			      <td><a href="/bbs/detail?bbscttNo=${bbsVO.bbscttNo}">${bbsVO.bbscttSj}</a></td>
			      <td>${bbsVO.acntId}</td>
			      <td>${bbsVO.bbscttWritngDe}</td>
			      <td>${bbsVO.bbscttRdcnt}</td>
			    </tr>
		   
			  </c:forEach>
			  </tbody>
			</table>
		</div>
		<div class="card-footer clearfix">
			<!--  justify-content-center : style="justify-content:center;" -->
			${articlePage.pagingArea}

		</div>


<!-- body 끝 -->
        </div>
    </div>
</main>


<%@ include file="footer.jsp" %>