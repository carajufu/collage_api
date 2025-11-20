<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%@ include file="../header.jsp" %>

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>자기소개서 자동 생성</title>
</head>

<body>
<div class="page-content">
    <div class="container-fluid">

        <!-- 제목 -->
        <div class="row mb-4">
            <div class="col-12">
                <h4 class="mb-3">자기소개서 자동 생성</h4>
            </div>
        </div>

        <div class="row">

            <!-- 좌측 입력 폼 -->
            <div class="col-lg-5">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">기본 정보 입력</h5>
                    </div>

                    <div class="card-body">

                        <form action="${pageContext.request.contextPath}/compe/generate" method="post">

                            <table class="table table-bordered table-sm align-middle mb-3">
                                <tbody>

                                <!-- 이름 -->
                                <tr>
                                    <th class="bg-light" style="width: 30%;">이름</th>
                                    <td>
                                        <input type="text" name="stdntNm"
                                               class="form-control form-control-sm"
                                               value="${empty form.stdntNm ? '' : fn:escapeXml(form.stdntNm)}"
                                               placeholder="예) 홍길동">
                                    </td>
                                </tr>

                                <!-- 생년(VO 없음 → prompt용 입력) -->
                                <tr>
                                    <th class="bg-light">생년</th>
                                    <td>
                                        <input type="text" name="birthYear"
                                               class="form-control form-control-sm"
                                               value="${empty form.brthDy ? '' : fn:escapeXml(form.brthDy)}"
                                               placeholder="20251120">
                                    </td>
                                </tr>

                                <!-- 학력 -->
                                <tr>
                                    <th class="bg-light">학력</th>
                                    <td>
                                        <input type="text" name="lastAcdmcr"
                                               class="form-control form-control-sm"
                                               value="${empty form.lastAcdmcr ? '' : fn:escapeXml(form.lastAcdmcr)}"
                                               placeholder="예) ○○대학교 ○○학과 졸업 예정">
                                    </td>
                                </tr>

                                <!-- 군필 여부 -->
                                <tr>
                                    <th class="bg-light">군필 여부</th>
                                    <td>
                                        <select name="miltrAt" class="form-select form-select-sm">
                                            <option value="해당 없음" ${form.miltrAt=='해당 없음'?'selected':''}>해당 없음</option>
                                            <option value="군필" ${form.miltrAt=='군필'?'selected':''}>군필</option>
                                            <option value="미필" ${form.miltrAt=='미필'?'selected':''}>미필</option>
                                        </select>
                                    </td>
                                </tr>

                                <!-- 직무 -->
                                <tr>
                                    <th class="bg-light">지원 직무</th>
                                    <td>

                                        <!-- 대분류 -->
                                        <select id="jobCategory" class="form-select form-select-sm mb-2">
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

                                        <!-- 소분류 전체 (각각 숨김) -->

                                        <!-- 기획/전략 -->
                                        <select id="planJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="기획자" ${form.desireJob=='기획자'?'selected':''}>기획자</option>
                                            <option value="마케팅기획자" ${form.desireJob=='마케팅기획자'?'selected':''}>마케팅기획자</option>
                                            <option value="사업기획자" ${form.desireJob=='사업기획자'?'selected':''}>사업기획자</option>
                                            <option value="전략기획자" ${form.desireJob=='전략기획자'?'selected':''}>전략기획자</option>
                                            <option value="상품기획자" ${form.desireJob=='상품기획자'?'selected':''}>상품기획자</option>
                                            <option value="프로덕트매니저" ${form.desireJob=='프로덕트매니저'?'selected':''}>프로덕트매니저(PM)</option>
                                            <option value="경영기획자" ${form.desireJob=='경영기획자'?'selected':''}>경영기획자</option>
                                            <option value="서비스기획자" ${form.desireJob=='서비스기획자'?'selected':''}>서비스기획자</option>
                                            <option value="광고기획자" ${form.desireJob=='광고기획자'?'selected':''}>광고기획자</option>
                                            <option value="브랜드기획자" ${form.desireJob=='브랜드기획자'?'selected':''}>브랜드기획자</option>
                                            <option value="웹기획자" ${form.desireJob=='웹기획자'?'selected':''}>웹기획자</option>
                                            <option value="리서처" ${form.desireJob=='리서처'?'selected':''}>리서처</option>
                                            <option value="데이터분석가" ${form.desireJob=='데이터분석가'?'selected':''}>데이터분석가</option>
                                        </select>

                                        <!-- 마케팅/홍보/조사 -->
                                        <select id="marketingJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="마케터" ${form.desireJob=='마케터'?'selected':''}>마케터</option>
                                            <option value="온라인마케터" ${form.desireJob=='온라인마케터'?'selected':''}>온라인마케터</option>
                                            <option value="브랜드마케터" ${form.desireJob=='브랜드마케터'?'selected':''}>브랜드마케터</option>
                                            <option value="광고마케터" ${form.desireJob=='광고마케터'?'selected':''}>광고마케터</option>
                                            <option value="콘텐츠마케터" ${form.desireJob=='콘텐츠마케터'?'selected':''}>콘텐츠마케터</option>
                                            <option value="콘텐츠기획자" ${form.desireJob=='콘텐츠기획자'?'selected':''}>콘텐츠기획자</option>
                                            <option value="광고운영자" ${form.desireJob=='광고운영자'?'selected':''}>광고운영자</option>
                                            <option value="채널매니저" ${form.desireJob=='채널매니저'?'selected':''}>채널매니저</option>
                                            <option value="프로모션매니저" ${form.desireJob=='프로모션매니저'?'selected':''}>프로모션매니저</option>
                                        </select>

                                        <!-- 총무/법무/사무 -->
                                        <select id="officeJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="사무원" ${form.desireJob=='사무원'?'selected':''}>사무원</option>
                                            <option value="총무담당" ${form.desireJob=='총무담당'?'selected':''}>총무담당</option>
                                            <option value="비서" ${form.desireJob=='비서'?'selected':''}>비서</option>
                                            <option value="사무보조" ${form.desireJob=='사무보조'?'selected':''}>사무보조</option>
                                            <option value="행정담당" ${form.desireJob=='행정담당'?'selected':''}>행정담당</option>
                                            <option value="경영지원" ${form.desireJob=='경영지원'?'selected':''}>경영지원</option>
                                            <option value="자료입력원" ${form.desireJob=='자료입력원'?'selected':''}>자료입력원</option>
                                        </select>

                                        <!-- IT -->
                                        <select id="itJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="백엔드개발자" ${form.desireJob=='백엔드개발자'?'selected':''}>백엔드개발자</option>
                                            <option value="프론트엔드개발자" ${form.desireJob=='프론트엔드개발자'?'selected':''}>프론트엔드개발자</option>
                                            <option value="풀스택개발자" ${form.desireJob=='풀스택개발자'?'selected':''}>풀스택개발자</option>
                                            <option value="웹개발자" ${form.desireJob=='웹개발자'?'selected':''}>웹개발자</option>
                                            <option value="보안엔지니어" ${form.desireJob=='보안엔지니어'?'selected':''}>보안엔지니어</option>
                                            <option value="네트워크엔지니어" ${form.desireJob=='네트워크엔지니어'?'selected':''}>네트워크엔지니어</option>
                                            <option value="AI엔지니어" ${form.desireJob=='AI엔지니어'?'selected':''}>AI엔지니어</option>
                                            <option value="자바개발자" ${form.desireJob=='자바개발자'?'selected':''}>자바개발자</option>
                                            <option value="파이썬개발자" ${form.desireJob=='파이썬개발자'?'selected':''}>파이썬개발자</option>
                                            <option value="자바스크립트개발자" ${form.desireJob=='자바스크립트개발자'?'selected':''}>자바스크립트개발자</option>
                                        </select>

                                        <!-- 영업 -->
                                        <select id="salesJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="영업사원" ${form.desireJob=='영업사원'?'selected':''}>영업사원</option>
                                            <option value="영업지원담당" ${form.desireJob=='영업지원담당'?'selected':''}>영업지원담당</option>
                                            <option value="영업관리자" ${form.desireJob=='영업관리자'?'selected':''}>영업관리자</option>
                                            <option value="기술영업사원" ${form.desireJob=='기술영업사원'?'selected':''}>기술영업사원</option>
                                            <option value="상담영업원" ${form.desireJob=='상담영업원'?'selected':''}>상담영업원</option>
                                            <option value="해외영업사원" ${form.desireJob=='해외영업사원'?'selected':''}>해외영업사원</option>
                                        </select>

                                        <!-- 구매/자재/물류 -->
                                        <select id="logisticsJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="물류담당자" ${form.desireJob=='물류담당자'?'selected':''}>물류담당자</option>
                                            <option value="재고담당자" ${form.desireJob=='재고담당자'?'selected':''}>재고담당자</option>
                                            <option value="창고관리자" ${form.desireJob=='창고관리자'?'selected':''}>창고관리자</option>
                                            <option value="자재관리자" ${form.desireJob=='자재관리자'?'selected':''}>자재관리자</option>
                                            <option value="구매담당자" ${form.desireJob=='구매담당자'?'selected':''}>구매담당자</option>
                                        </select>

                                        <!-- 생산 -->
                                        <select id="productionJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="생산직사원" ${form.desireJob=='생산직사원'?'selected':''}>생산직사원</option>
                                            <option value="생산관리자" ${form.desireJob=='생산관리자'?'selected':''}>생산관리자</option>
                                            <option value="품질관리자" ${form.desireJob=='품질관리자'?'selected':''}>품질관리자</option>
                                            <option value="기계조작원" ${form.desireJob=='기계조작원'?'selected':''}>기계조작원</option>
                                        </select>

                                        <!-- 건설 -->
                                        <select id="constructionJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="전기기사" ${form.desireJob=='전기기사'?'selected':''}>전기기사</option>
                                            <option value="현장관리자" ${form.desireJob=='현장관리자'?'selected':''}>현장관리자</option>
                                            <option value="토목기사" ${form.desireJob=='토목기사'?'selected':''}>토목기사</option>
                                            <option value="건축설계사" ${form.desireJob=='건축설계사'?'selected':''}>건축설계사</option>
                                        </select>

                                        <!-- 의료 -->
                                        <select id="medicalJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="간호사" ${form.desireJob=='간호사'?'selected':''}>간호사</option>
                                            <option value="간호조무사" ${form.desireJob=='간호조무사'?'selected':''}>간호조무사</option>
                                            <option value="병원행정직원" ${form.desireJob=='병원행정직원'?'selected':''}>병원행정직원</option>
                                            <option value="환자안내직원" ${form.desireJob=='환자안내직원'?'selected':''}>환자안내직원</option>
                                        </select>

                                        <!-- 교육 -->
                                        <select id="educationJobs" name="desireJob" class="form-select form-select-sm job-detail" style="display:none;">
                                            <option value="">세부 직무 선택</option>
                                            <option value="학원강사" ${form.desireJob=='학원강사'?'selected':''}>학원강사</option>
                                            <option value="교육운영담당" ${form.desireJob=='교육운영담당'?'selected':''}>교육운영담당</option>
                                            <option value="학생지도교사" ${form.desireJob=='학생지도교사'?'selected':''}>학생지도교사</option>
                                            <option value="학습상담사" ${form.desireJob=='학습상담사'?'selected':''}>학습상담사</option>
                                            <option value="보육교사" ${form.desireJob=='보육교사'?'selected':''}>보육교사</option>
                                        </select>

                                    </td>
                                </tr>

                                <!-- 자격증 -->
                                <tr>
                                    <th class="bg-light">자격증</th>
                                    <td>
                                        <textarea name="crqfc" rows="2" class="form-control form-control-sm"
                                                  placeholder="">${empty form.crqfc ? '' : fn:escapeXml(form.crqfc)}</textarea>
                                    </td>
                                </tr>

                                <!-- 교육 이력 -->
                                <tr>
                                    <th class="bg-light">교육/부트캠프</th>
                                    <td>
                                        <textarea name="edcHistory" rows="2" class="form-control form-control-sm"
                                                  placeholder="">${empty form.edcHistory ? '' : fn:escapeXml(form.edcHistory)}</textarea>
                                    </td>
                                </tr>

                                <!-- 주요 프로젝트 -->
                                <tr>
                                    <th class="bg-light">주요 프로젝트</th>
                                    <td>
                                        <textarea name="mainProject" rows="3" class="form-control form-control-sm"
                                                  placeholder="핵심 프로젝트 중심으로">${empty form.mainProject ? '' : fn:escapeXml(form.mainProject)}</textarea>
                                    </td>
                                </tr>

                                <!-- 성격 -->
                                <tr>
                                    <th class="bg-light">성격/강점</th>
                                    <td>
                                        <textarea name="character" rows="2" class="form-control form-control-sm"
                                                  placeholder="문제 해결 능력 등">${empty form.character ? '' : fn:escapeXml(form.character)}</textarea>
                                    </td>
                                </tr>

                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between">
                                <button type="reset" class="btn btn-light btn-sm">초기화</button>
                                <button type="submit" class="btn btn-primary btn-sm">자기소개서 생성</button>
                            </div>

                        </form>

                    </div>
                </div>
            </div>

            <!-- 우측 결과 -->
            <div class="col-lg-7 mt-4 mt-lg-0">
                <div class="card h-100">

                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">생성된 자기소개서</h5>

                        <c:if test="${not empty generatedEssay}">
                            <form action="${pageContext.request.contextPath}/stdnt/portfolio/pdf"
                                  method="post" target="_blank" class="mb-0">
                                <textarea name="essay" class="d-none">${fn:escapeXml(generatedEssay)}</textarea>
                                <button type="submit" class="btn btn-outline-secondary btn-sm">PDF 다운로드</button>
                            </form>
                        </c:if>
                    </div>

                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty generatedEssay}">
                                <textarea class="form-control" rows="20">${fn:escapeXml(generatedEssay)}</textarea>
                                <small class="text-muted d-block mt-2">
                                    필요한 부분은 수정 후 PDF로 저장하십시오.
                                </small>
                            </c:when>
                            <c:otherwise>
                                <div class="text-muted">
                                    왼쪽에서 기본 정보를 입력하고
                                    <strong>[자기소개서 생성]</strong> 버튼을 누르면
                                    이곳에 AI가 생성한 내용이 표시됩니다.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

<!-- 직무 자동 선택 스크립트 -->
<script>
document.addEventListener("DOMContentLoaded", function () {

    const category = document.getElementById("jobCategory");
    const details = document.querySelectorAll(".job-detail");

    const selectedJob = "${form.desireJob}";

    const map = {
        plan: ["기획자","마케팅기획자","사업기획자","전략기획자","상품기획자","프로덕트매니저",
               "경영기획자","서비스기획자","광고기획자","브랜드기획자","웹기획자","리서처","데이터분석가"],
        marketing: ["마케터","온라인마케터","브랜드마케터","광고마케터","콘텐츠마케터","콘텐츠기획자",
                    "광고운영자","채널매니저","프로모션매니저"],
        office: ["사무원","총무담당","비서","사무보조","행정담당","경영지원","자료입력원"],
        it: ["백엔드개발자","프론트엔드개발자","풀스택개발자","웹개발자","보안엔지니어","네트워크엔지니어",
             "AI엔지니어","자바개발자","파이썬개발자","자바스크립트개발자"],
        sales: ["영업사원","영업지원담당","영업관리자","기술영업사원","상담영업원","해외영업사원"],
        logistics: ["물류담당자","재고담당자","창고관리자","자재관리자","구매담당자"],
        production: ["생산직사원","생산관리자","품질관리자","기계조작원"],
        construction: ["전기기사","현장관리자","토목기사","건축설계사"],
        medical: ["간호사","간호조무사","병원행정직원","환자안내직원"],
        education: ["학원강사","교육운영담당","학생지도교사","학습상담사","보육교사"]
    };

    for (let key in map) {
        if (map[key].includes(selectedJob)) {
            category.value = key;
        }
    }

    function showDetail() {
        details.forEach(el => el.style.display = "none");

        if (category.value) {
            const target = document.getElementById(category.value + "Jobs");
            if (target) target.style.display = "block";
        }
    }

    category.addEventListener("change", showDetail);

    // 첫 로드시 실행
    showDetail();

});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="../footer.jsp" %>
