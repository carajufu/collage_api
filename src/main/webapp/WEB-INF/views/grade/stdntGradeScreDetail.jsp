<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../header.jsp" %>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">학사 정보</a></li>
            <li class="breadcrumb-item"><a href="/stdnt/grade/main/All">성적</a></li>
            <li class="breadcrumb-item active" aria-current="page">과목별 성적 상세</li>
        </ol>
    </nav>

    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">과목별 성적 상세</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">

        <c:if test="${empty detail}">
            <div class="alert alert-warning">과목 성적 정보가 없습니다.</div>
        </c:if>

        <c:if test="${not empty detail}">
            <table class="table table-bordered table-hover align-middle text-center">
                <thead class="table-light">
                <tr>
                    <th class="text-start">과목명</th>
                    <th>출석</th>
                    <th>과제</th>
                    <th>중간</th>
                    <th>기말</th>
                    <th>총점</th>
                    <th>평균</th>
                    <th>등급</th>
                    <th>그래프</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="grade" items="${detail}">
                    <tr>
                        <td class="text-start">${grade.lctreNm}</td>
                        <td>${grade.atendScore}</td>
                        <td>${grade.taskScore}</td>
                        <td>${grade.middleScore}</td>
                        <td>${grade.trmendScore}</td>
                        <td>${grade.sbjectTotpoint}</td>
                        <td>${grade.pntAvrg}</td>
                        <td>${grade.pntGrad}</td>
                        <td>
                            <button type="button"
                                    class="btn btn-sm btn-outline-primary btn-chart"
                                    data-bs-toggle="modal"
                                    data-bs-target="#chartModal"
                                    data-att="${grade.atendScore}"
                                    data-task="${grade.taskScore}"
                                    data-mid="${grade.middleScore}"
                                    data-final="${grade.trmendScore}">
                                보기
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:if>

        <div class="mt-3 text-end">
            <a href="/stdnt/grade/main/All" class="btn btn-primary btn-sm">뒤로가기</a>
        </div>

        <!-- 그래프 모달 -->
        <div class="modal fade" id="chartModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">성적 그래프</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <canvas id="scoreChart" height="120"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
            let chartInstance;

            document.querySelectorAll(".btn-chart").forEach(btn => {
                btn.addEventListener("click", function () {
                    const data = [
                        this.dataset.att,
                        this.dataset.task,
                        this.dataset.mid,
                        this.dataset.final
                    ];

                    const ctx = document.getElementById("scoreChart").getContext("2d");
                    if (chartInstance) chartInstance.destroy();

                    chartInstance = new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: ['출석', '과제', '중간', '기말'],
                            datasets: [{
                                label: '점수',
                                data: data
                            }]
                        },
                        options: { responsive: true, scales: { y: { beginAtZero: true } } }
                    });
                });
            });
        </script>

<%@ include file="../footer.jsp" %>