<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../header.jsp"%>

<style>
body {
	font-family: "Pretendard", "Noto Sans KR", sans-serif;
}

.btn-toggle {
	color: white;
	text-align: left;
	font-weight: 500;
	width: 100%;
}

.card-custom {
	border-radius: 12px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
	background-color: #fff;
	transition: 0.2s;
}


</style>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
                <li class="breadcrumb-item active"><a href="#">등록</a></li>
                <li class="breadcrumb-item active" aria-current="page">등록금 납부내역</li>
            </ol>
        </nav>
    </div>
    <div class="col-12 page-title mt-2">
	    <h2 class="section-title mb-4">등록금 납부내역</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
    <div class="col-xxl-12 col-12">
		<h5>등록 학기 정보</h5>
		<p class="text-muted">현재 학기: 2025년 2학기</p>
	</div>

	<!-- 조회 폼 -->
    <div class="col-xxl-12 col-12">
        <form action="/payinfo/stdnt/history"
            method="GET" class="row g-3 mb-3">
            <div class="col-md-3">
                <select id="mk_sel" class="form-select" name="year">
                    <option value="">-- 년도 선택 --</option>
                    <option value="2025">2025</option>
                    <option value="2024">2024</option>
                    <option value="2023">2023</option>
                </select>
            </div>
            <script>
              document.querySelector("#mk_sel").value="${mk_ys.year}";
            </script>
            <div class="col-md-3">
                <select id="mk_sel2" class="form-select" name="semester">
                    <option value="">-- 학기 선택 --</option>
                    <option value="1학기">1학기</option>
                    <option value="2학기">2학기</option>
                </select>
            </div>
            <script>
              document.querySelector("#mk_sel2").value="${mk_ys.semester}";
            </script>
            <div class="col-md-3">
                <button type="submit" class="btn btn-primary">조회</button>
            </div>
        </form>
    </div>
	<!-- ✅ DB 데이터 출력 -->
    <div class="col-xxl-12 col-12">
        <div class="accordion" id="registerList">
            <c:choose>
                <c:when test="${empty registerList}">
                    <p class="text-muted">등록 내역이 없습니다.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${registerList}" varStatus="st">
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button"
                                    data-bs-toggle="collapse" data-bs-target="#reg${st.index}">
                                    ${item.rqestYear}년 ${item.rqestSemstr} 등록 내역</button>
                            </h2>
                            <div id="reg${st.index}" class="accordion-collapse collapse"
                                data-bs-parent="#registerList">
                                <div class="accordion-body">
                                    <ul>
                                        <li>납부일: ${item.payDe}</li>
                                        <li>납부 금액: <fmt:formatNumber value="${item.payGld}"
                                                pattern="#,###" />원
                                        </li>
                                        <li>상태: <c:choose>
                                                <c:when test="${item.paySttus eq '완료'}">
                                                    <span class="badge bg-success">완료</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning text-dark">미납</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
	<!-- 등록 규정 안내 -->
    <div class="col-xxl-12 col-12">
        <div class="info-box mt-5">
            <h6 class="fw-semibold mb-2">등록 규정 안내</h6>
            <p class="mb-0 text-muted">
                등록은 매 학기 시작 전 지정된 기간 내에만 가능합니다. 등록금 미납 시 수강신청이 제한됩니다.
            </p>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp"%>
