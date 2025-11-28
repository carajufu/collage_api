<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>

<%@ include file="../header.jsp" %>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="/dashboard/student"><i class="las la-home"></i></a>
            </li>
            <li class="breadcrumb-item"><a href="#">학사 정보</a></li>
            <li class="breadcrumb-item active"><a href="#">성적</a></li>
            <li class="breadcrumb-item active">강의 평가</li>
        </ol>
    </nav>

    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">강의 평가</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height: 5px;"></div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">

        <div class="border rounded p-3 mb-4 bg-light">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <span class="fw-semibold">수강 강의 수:</span>
                    <span class="text-primary fw-bold">${fn:length(atnlcList)}</span> 개
                </div>
                <div class="text-muted small">
                    평가 완료 후 수정은 불가하니 신중히 제출하십시오.
                </div>
            </div>
        </div>

        <p class="text-muted mb-3">
            수강 중인 강의 목록입니다. 각 강의의 평가 버튼을 클릭하여 강의평가를 진행하십시오.
        </p>

        <c:if test="${empty atnlcList}">
            <div class="alert alert-secondary text-center py-4">
                현재 평가할 강의가 없습니다.
            </div>
        </c:if>

        <c:if test="${not empty atnlcList}">
            <div class="table-responsive">
                <table class="table table-hover align-middle text-center">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 6%;">No.</th>
                            <th style="width: 25%;">개설 강의명</th>
                            <th>강의코드</th>
                            <th>년도</th>
                            <th>학기</th>
                            <th>이수구분</th>
                            <th>학점</th>
                            <th>정원</th>
                            <th>수업언어</th>
                            <th style="width: 12%;">평가하기</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="lecture" items="${atnlcList}" varStatus="status">
                            <tr>
                                <td>${status.count}</td>
                                <td class="text-start fw-semibold">${lecture.lctreNm}</td>
                                <td>${lecture.lctreCode}</td>
                                <td>${lecture.estblYear}</td>
                                <td>${lecture.estblSemstr}</td>
                                <td>${lecture.complSe}</td>
                                <td>${lecture.acqsPnt}</td>
                                <td>${lecture.atnlcNmpr}</td>
                                <td>${lecture.lctreUseLang}</td>
                                <td>
                                    <c:set var="done"
                                           value="${evlDoneMap[lecture.estbllctreCode]}" />
                                    <c:choose>
                                        <c:when test="${done}">
                                            <button class="btn btn-outline btn-sm px-3" disabled>
                                                평가완료
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="/stdnt/lecture/main/${lecture.estbllctreCode}"
                                               class="btn btn-primary btn-sm px-3">
                                                평가하기
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>

                </table>
            </div>
        </c:if>

    </div>
</div>

<%@ include file="../footer.jsp" %>
