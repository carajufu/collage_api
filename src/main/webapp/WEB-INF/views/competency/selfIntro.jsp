<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%@ include file="/WEB-INF/views/header.jsp" %>

<script>
document.addEventListener("DOMContentLoaded", function() {

    const category = document.getElementById("jobCategory");
    const allDetailBoxes = document.querySelectorAll(".job-detail");

    category.addEventListener("change", function () {

        // 모든 세부 직무 숨기기
        allDetailBoxes.forEach(box => box.style.display = "none");

        // 선택한 카테고리만 보이기
        const selected = category.value + "Jobs";
        const target = document.getElementById(selected);

        if (target) {
            target.style.display = "block";
        }
    });

});
</script>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>자기소개서 자동 생성</title>
</head>
<body>

<div class="page-content">
    <div class="container-fluid">

        <!-- 제목 영역 -->
        <div class="row mb-4">
            <div class="col-12">
                <h4 class="mb-3">자기소개서 자동 생성</h4>
                <p class="text-muted mb-0">
                </p>
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

                        <!-- ★ 수정됨: action 경로 -->
                        <form action="${pageContext.request.contextPath}/compe/generate" method="post" id="portfolioForm">

                            <table class="table table-bordered table-sm align-middle mb-3">
                                <tbody>

                                <tr>
                                    <th class="bg-light" style="width: 30%;">이름</th>
                                    <td>
                                        <input type="text" name="name" class="form-control form-control-sm"
                                               value="${fn:escapeXml(data.name)}"
                                               placeholder="예) 홍길동" required>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">생년</th>
                                    <td>
                                        <input type="number" name="birthYear" class="form-control form-control-sm"
                                               value="${fn:escapeXml(data.birthYear)}"
                                               placeholder="1998" required>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">학력</th>
                                    <td>
                                        <input type="text" name="educationLevel" class="form-control form-control-sm"
                                               value="${fn:escapeXml(data.educationLevel)}"
                                               placeholder="예) ○○대학교 ○○학과 졸업 예정" required>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">군필 여부</th>
                                    <td>
                                        <select name="military" class="form-select form-select-sm">
                                            <option value="해당 없음" ${data.military == '해당 없음' ? 'selected' : ''}>해당 없음</option>
                                            <option value="군필" ${data.military == '군필' ? 'selected' : ''}>군필</option>
                                            <option value="미필" ${data.military == '미필' ? 'selected' : ''}>미필</option>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
								    <th class="bg-light">지원 직무</th>
								    <td>
								
								        <select id="jobCategory" name="jobCategory" class="form-select form-select-sm mb-2">
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
								
								        <!-- 기획/전략 -->
										<select id="planJobs" name="targetJob" class="form-select form-select-sm job-detail" style="display:none;">
										    <option value="">세부 직무 선택</option>
										    <option value="기획자">기획자</option>
										    <option value="기획자">마케팅기획자</option>
										    <option value="사업기획자">사업기획자</option>
										    <option value="전략기획자">전략기획자</option>
										    <option value="상품기획자">상품기획자</option>
										    <option value="프로덕트매니저">프로덕트매니저(PM)</option>
										    <option value="경영기획자">경영기획자</option>
										    <option value="서비스기획자">서비스기획자</option>
										    <option value="광고기획자">광고기획자</option>
										    <option value="브랜드기획자">브랜드기획자</option>
										    <option value="웹기획자">웹기획자</option>
										    <option value="리서처">리서처(시장조사)</option>
										    <option value="데이터분석가">데이터분석가</option>
										</select>
										
										<!-- 마케팅/홍보/조사 -->
										<select id="marketingJobs" name="targetJob" class="form-select form-select-sm job-detail" style="display:none;">
										    <option value="">세부 직무 선택</option>
										    <option value="마케터">마케터</option>
										    <option value="온마케터">온라인마케터</option>
										    <option value="브랜드마케터">브랜드마케터</option>
										    <option value="광고마케터">광고마케터</option>
										    <option value="콘텐츠마케터">콘텐츠마케터</option>
										    <option value="콘텐츠기획자">콘텐츠기획자</option>
										    <option value="광고운영자">광고운영자</option>
										    <option value="채널매니저">채널매니저</option>
										    <option value="프로모션매니저">프로모션매니저</option>
										</select>
										
										<!-- 총무/법무/사무 -->
										<select id="officeJobs" name="targetJob" class="form-select form-select-sm job-detail" style="display:none;">
										    <option value="">세부 직무 선택</option>
										    <option value="사무원">사무원</option>
										    <option value="총무담당">총무담당</option>
										    <option value="비서">비서</option>
										    <option value="사무보조">사무보조</option>
										    <option value="행정담당">행정담당</option>
										    <option value="경영지원">경영지원</option>
										    <option value="자료입력원">자료입력원</option>
										</select>
										
										<!-- IT 개발 / 데이터 -->
										<select id="itJobs" name="targetJob" class="form-select form-select-sm job-detail" style="display:none;">
										    <option value="">세부 직무 선택</option>
										    <option value="백엔드개발자">백엔드개발자</option>
										    <option value="프론트엔드개발자">프론트엔드개발자</option>
										    <option value="웹개발자">웹개발자</option>
										    <option value="보안엔지니어">보안엔지니어</option>
										    <option value="네트워크엔지니어">네트워크엔지니어</option>
										    <option value="AI엔지니어">AI엔지니어</option>
										    <option value="자바개발자">자바개발자</option>
										    <option value="파이썬개발자">파이썬개발자</option>
										    <option value="자바스크립트개발자">자바스크립트개발자</option>
										</select>
										
										<!-- 영업/판매/무역 -->
										<select id="salesJobs" name="targetJob" class="form-select form-select-sm job-detail" style="display:none;">
										    <option value="">세부 직무 선택</option>
										    <option value="영업사원">영업사원</option>
										    <option value="영업지원담당">영업지원담당</option>
										    <option value="영업관리자">영업관리자</option>
										    <option value="기술영업사원">기술영업사원</option>
										    <option value="상담영업원">상담영업원</option>
										    <option value="해외영업사원">해외영업사원</option>
										</select>
										
										<!-- 구매/자재/물류 -->
										<select id="logisticsJobs" name="targetJob" class="form-select form-select-sm job-detail" style="display:none;">
										    <option value="">세부 직무 선택</option>
										    <option value="물류담당자">물류담당자</option>
										    <option value="재고담당자">재고담당자</option>
										    <option value="창고관리자">창고관리자</option>
										    <option value="자재관리자">자재관리자</option>
										    <option value="구매담당자">구매담당자</option>
										</select>
										
										<!-- 생산 -->
										<select id="productionJobs" name="targetJob" class="form-select form-select-sm job-detail" style="display:none;">
										    <option value="">세부 직무 선택</option>
										    <option value="생산직사원">생산직사원</option>
										    <option value="생산관리자">생산관리자</option>
										    <option value="품질관리자">품질관리자</option>
										    <option value="기계조작원">기계조작원</option>
										</select>
										
										<!-- 건설/건축 -->
										<select id="constructionJobs" name="targetJob" class="form-select form-select-sm job-detail" style="display:none;">
										    <option value="">세부 직무 선택</option>
										    <option value="전기기사">전기기사</option>
										    <option value="현장관리자">현장관리자</option>
										    <option value="토목기사">토목기사</option>
										    <option value="건축설계사">건축설계사</option>
										</select>
										
										<!-- 의료 -->
										<select id="medicalJobs" name="targetJob" class="form-select form-select-sm job-detail" style="display:none;">
										    <option value="">세부 직무 선택</option>
										    <option value="간호사">간호사</option>
										    <option value="간호조무사">간호조무사</option>
										    <option value="병원행정직원">병원행정직원</option>
										    <option value="환자안내직원">환자안내직원</option>
										</select>
										
										<!-- 교육 -->
										<select id="educationJobs" name="targetJob" class="form-select form-select-sm job-detail" style="display:none;">
										    <option value="">세부 직무 선택</option>
										    <option value="학원강사">학원강사</option>
										    <option value="교육운영담당">교육운영담당</option>
										    <option value="학생지도교사">학생지도교사</option>
										    <option value="학습상담사">학습상담사</option>
										    <option value="보육교사">보육교사</option>
										</select>

								
								    </td>
								</tr>




                                <tr>
                                    <th class="bg-light">자격증</th>
                                    <td>
                                        <textarea name="certificates" rows="2" class="form-control form-control-sm"
                                                  placeholder="정보처리기사, SQLD 등">${fn:escapeXml(data.certificates)}</textarea>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">교육/부트캠프</th>
                                    <td>
                                        <textarea name="eduHistory" rows="2" class="form-control form-control-sm"
                                                  placeholder="○○부트캠프 자바/Spring 과정 등">${fn:escapeXml(data.eduHistory)}</textarea>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">주요 프로젝트</th>
                                    <td>
                                        <textarea name="projects" rows="3" class="form-control form-control-sm"
                                                  placeholder="핵심 프로젝트 중심으로 간단히">${fn:escapeXml(data.projects)}</textarea>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">성격/강점</th>
                                    <td>
                                        <textarea name="strengths" rows="2" class="form-control form-control-sm"
                                                  placeholder="문제 해결, 협업 능력 등">${fn:escapeXml(data.strengths)}</textarea>
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

            <!-- 우측 AI 생성 결과 -->
            <div class="col-lg-7 mt-4 mt-lg-0">
                <div class="card h-100">

                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="card-title mb-0">생성된 자기소개서</h5>

                        <c:if test="${not empty generatedEssay}">
                            <form action="${pageContext.request.contextPath}/stdnt/portfolio/pdf"
                                  method="post" target="_blank" class="mb-0">
                                <textarea name="essay" class="d-none">${fn:escapeXml(generatedEssay)}</textarea>
                                <button type="submit" class="btn btn-outline-secondary btn-sm">
                                    PDF 다운로드
                                </button>
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
                                    이곳에 내용이 표시됩니다.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </div>

        </div><!-- end row -->

    </div><!-- container-fluid -->
</div><!-- page-content -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
