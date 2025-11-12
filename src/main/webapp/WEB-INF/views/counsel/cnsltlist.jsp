<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>


<!-- 🌤 메인 콘텐츠 -->
        <div class="content-area" id="main-content">
            <h2 class="section-title">대시보드</h2>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="card card-custom p-3">
                        <h5>현재 학기</h5>
                        <p class="text-muted mb-0">2025년 2학기</p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card card-custom p-3">
                        <h5>학적 상태</h5>
                        <p class="text-muted mb-0">휴학</p>
                    </div>
                </div>

            <hr class="my-4">

        <h2 class="section-title">학적 변동 조회</h2>
        
        <table class="table table-bordered table-hover bg-white">
            <thead class="table-light">
                <tr>
                    <th>변동 구분</th>
                    <th>상태</th>
                    <th>변동 사유</th>
                    <th>변동 일자</th>
                </tr>
            </thead>
            <tbody>

                <tr>
                    <td>H2025001</td>
                    <td><span class="badge bg-warning text-dark">복학</span></td>
                    <td>휴학 기간 만료</td>
                    <td>2025-03-02</td>
                </tr>

                <tr>
                    <td>R2024002</td>
                    <td><span class="badge bg-success">휴학</span></td>
                    <td>개인 사유</td>
                    <td>2024-09-01</td>
                </tr>

                <tr>
                    <td>N2024001</td>
                    <td><span class="badge bg-primary">재학</span></td>
                    <td>신입학</td>
                    <td>2024-03-02</td>
                </tr>
            </tbody>
        </table>
        </div>
        
<%@ include file="../footer.jsp" %>