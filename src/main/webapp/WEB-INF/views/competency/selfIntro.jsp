<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

<style>
    #loadingOverlay {
        display:none;
        position:fixed;
        top:0; left:0;
        width:100%; height:100%;
        background:rgba(0,0,0,0.45);
        z-index:3000;
    }
</style>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">학사 정보</a></li>
            <li class="breadcrumb-item active" aria-current="page">성적 관리</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">성적 관리</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>
<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">

        <div class="row mb-4">
            <div class="col-12">
                <h4 class="mb-3">자기소개서 자동 생성</h4>
            </div>
        </div>

        <div class="row">
            <div class="col-xl">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">기본 정보 입력</h5>
                    </div>

                    <div class="card-body">

                        <form action="${pageContext.request.contextPath}/compe/generate" method="post" id="generateForm">

                            <table class="table table-bordered table-sm align-middle mb-3">
                                <tbody>

                                <!-- 이름 -->
                                <tr>
                                    <th class="bg-light" style="width:10%;">이름</th>
                                    <td style="width:40%;">
                                        <input type="text" name="stdntNm"
                                               class="form-control form-control-sm"
                                               value="${empty form.stdntNm ? '' : fn:escapeXml(form.stdntNm)}">
                                    </td>
                                    <th class="bg-light" style="width:10%;">생년</th>
                                    <td style="width:40%;">
                                        <input type="text" name="birthYear"
                                               class="form-control form-control-sm"
                                               value="${empty form.brthDy ? '' : fn:escapeXml(form.brthDy)}">
                                    </td>
                                </tr>

                                <!-- 학력 + 군필 여부 -->
                                <tr>
                                    <th class="bg-light">학력</th>
                                    <td>
                                        <input type="text" name="lastAcdmcr"
                                               class="form-control form-control-sm"
                                               value="${empty form.lastAcdmcr ? '' : fn:escapeXml(form.lastAcdmcr)}">
                                    </td>
                                    <th class="bg-light">군필 여부</th>
                                    <td>
                                        <select name="miltrAt" class="form-select form-select-sm">
                                            <option value="해당 없음" ${form.miltrAt=='해당 없음'?'selected':''}>해당 없음</option>
                                            <option value="군필" ${form.miltrAt=='군필'?'selected':''}>군필</option>
                                            <option value="미필" ${form.miltrAt=='미필'?'selected':''}>미필</option>
                                        </select>
                                    </td>
                                </tr>

                                <!-- 지원 직무 (40% 공간으로 축소) -->
                                <tr>
                                    <th class="bg-light" style="width:10%;">지원 직무</th>
                                    <td colspan="3" style="width:40%;">

                                        <!-- 대분류 -->
                                        <select id="jobCategory" class="form-select form-select-sm mb-2" style="width:40%;">
                                            <option value="">직무 대분류 선택</option>
                                            <option value="plan">기획/전략</option>
                                            <option value="marketing">마케팅/홍보/조사</option>
                                            <option value="office">총무/법무/사무</option>
                                            <option value="it">IT개발/데이터</option>
                                            <option value="sales">영업/판매/무역</option>
                                            <option value="logistics">구매/자재/물류</option>
                                            <option value="production">생산</option>
                                            <option value="construction">건설/건축</option>
                                            <option value="medical">의료</option>
                                            <option value="education">교육</option>
                                        </select>

                                        <!-- 세부 직무 전체 -->
                                        <select id="planJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;width:40%;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="기획자">기획자</option>
                                            <option value="마케팅기획자">마케팅기획자</option>
                                            <option value="사업기획자">사업기획자</option>
                                            <option value="전략기획자">전략기획자</option>
                                            <option value="상품기획자">상품기획자</option>
                                            <option value="프로덕트매니저">프로덕트매니저(PM)</option>
                                            <option value="경영기획자">경영기획자</option>
                                            <option value="서비스기획자">서비스기획자</option>
                                            <option value="광고기획자">광고기획자</option>
                                            <option value="브랜드기획자">브랜드기획자</option>
                                            <option value="웹기획자">웹기획자</option>
                                            <option value="리서처">리서처</option>
                                            <option value="데이터분석가">데이터분석가</option>
                                        </select>

                                        <select id="marketingJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;width:40%;">...</select>
                                        <select id="officeJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;width:40%;">...</select>
                                        <select id="itJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;width:40%;">...</select>
                                        <select id="salesJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;width:40%;">...</select>
                                        <select id="logisticsJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;width:40%;">...</select>
                                        <select id="productionJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;width:40%;">...</select>
                                        <select id="constructionJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;width:40%;">...</select>
                                        <select id="medicalJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;width:40%;">...</select>
                                        <select id="educationJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;width:40%;">...</select>
                                    </td>
                                </tr>

                                <!-- 자격증 -->
                                <tr>
                                    <th class="bg-light">자격증</th>
                                    <td colspan="3">
                                        <textarea name="crqfc" rows="4" class="form-control form-control-sm"
                                        >${empty form.crqfc ? '' : fn:escapeXml(form.crqfc)}</textarea>
                                    </td>
                                </tr>

                                <!-- 교육 -->
                                <tr>
                                    <th class="bg-light">교육/부트캠프</th>
                                    <td colspan="3">
                                        <textarea name="edcHistory" rows="4" class="form-control form-control-sm"
                                        >${empty form.edcHistory ? '' : fn:escapeXml(form.edcHistory)}</textarea>
                                    </td>
                                </tr>

                                <!-- 프로젝트 -->
                                <tr>
                                    <th class="bg-light">주요 프로젝트</th>
                                    <td colspan="3">
                                        <textarea name="mainProject" rows="5" class="form-control form-control-sm"
                                        >${empty form.mainProject ? '' : fn:escapeXml(form.mainProject)}</textarea>
                                    </td>
                                </tr>

                                <!-- 성격 -->
                                <tr>
                                    <th class="bg-light">성격/강점</th>
                                    <td colspan="3">
                                        <textarea name="character" rows="4" class="form-control form-control-sm"
                                        >${empty form.character ? '' : fn:escapeXml(form.character)}</textarea>
                                    </td>
                                </tr>

                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between">
                                <button type="reset" class="btn btn-light btn-sm">초기화</button>
                                <button type="submit" class="btn btn-primary btn-sm" id="generateBtn">자기소개서 생성</button>
                            </div>

                        </form>

                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- 로딩 오버레이 -->
<div id="loadingOverlay">
    <div class="d-flex justify-content-center align-items-center" style="height:100%;">
        <div class="spinner-border text-light" role="status" style="width:4rem; height:4rem;"></div>
    </div>
</div>

<!-- 모달 유지 (생략) -->

<script>
// 기존 JS 동일
</script>

<%@ include file="../footer.jsp" %>
