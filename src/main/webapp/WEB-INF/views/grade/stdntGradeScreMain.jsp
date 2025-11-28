<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">학사 정보</a></li>
            <li class="breadcrumb-item active" aria-current="page">학기별 성적 조회</li>
        </ol>
    </nav>

    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">학기별 성적 조회</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">

        <c:if test="${empty semList}">
            <div class="alert alert-warning text-center">
                조회 가능한 학기 성적이 없습니다.
            </div>
        </c:if>

        <c:if test="${not empty semList}">
            <table class="table table-hover table-bordered align-middle text-center">
                <thead class="table-light">
                <tr>
                    <th style="width:12%;">년도</th>
                    <th style="width:12%;">학기</th>
                    <th>총점</th>
                    <th>평균</th>
                    <th>등급</th>
                    <th>취득 학점</th>
                    <th style="width:15%;">상세조회</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="sem" items="${semList}">
                    <tr>
                        <td>${sem.year}</td>

                        <td>
                            <span class="badge bg-primary-subtle text-primary px-3 py-2">
                                ${sem.semstr}
                            </span>
                        </td>

                        <td class="text-end">
                            <c:choose>
                                <c:when test="${sem.semstrTotpoint != null and sem.semstrTotpoint >= 400}">
                                    ${sem.semstrTotpoint}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td class="text-end">
                            <c:choose>
                                <c:when test="${sem.semstrTotpoint != null and sem.semstrTotpoint >= 400}">
                                    ${sem.pntAvrg}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${sem.semstrTotpoint != null and sem.semstrTotpoint >= 400}">
                                    <span class="badge bg-success px-3 py-2">${sem.pntGrad}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger px-3 py-2">-</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="text-end">
                            <c:choose>
                                <c:when test="${sem.semstrTotpoint != null and sem.semstrTotpoint >= 400}">
                                    ${sem.totAcqsPnt}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <a href="/stdnt/grade/semstr/detail?semstrScreInnb=${sem.semstrScreInnb}"
                               class="btn btn-outline-primary btn-sm px-3">
                                상세보기
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>

    </div>
</div>

<%@ include file="../footer.jsp" %>