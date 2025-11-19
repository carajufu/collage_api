<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%@ include file="/WEB-INF/views/header.jsp" %>

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
                    기본 이력 정보를 입력하면 Gemini AI가 초안 자기소개서를 자동 생성합니다.
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

                        <form action="${pageContext.request.contextPath}/stdnt/portfolio/generate" method="post" id="portfolioForm">

                            <table class="table table-bordered table-sm align-middle mb-3">
                                <tbody>

                                <tr>
                                    <th class="bg-light" style="width: 30%;">이름</th>
                                    <td>
                                        <input type="text" name="name" class="form-control form-control-sm"
                                               value="${fn:escapeXml(form.name)}"
                                               placeholder="예) 홍길동" required>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">생년</th>
                                    <td>
                                        <input type="number" name="birthYear" class="form-control form-control-sm"
                                               value="${fn:escapeXml(form.birthYear)}"
                                               placeholder="1998" required>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">학력</th>
                                    <td>
                                        <input type="text" name="educationLevel" class="form-control form-control-sm"
                                               value="${fn:escapeXml(form.educationLevel)}"
                                               placeholder="예) ○○대학교 ○○학과 졸업 예정" required>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">군필 여부</th>
                                    <td>
                                        <select name="military" class="form-select form-select-sm">
                                            <option value="해당 없음" ${form.military == '해당 없음' ? 'selected' : ''}>해당 없음</option>
                                            <option value="군필" ${form.military == '군필' ? 'selected' : ''}>군필</option>
                                            <option value="미필" ${form.military == '미필' ? 'selected' : ''}>미필</option>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">지원 직무</th>
                                    <td>
                                        <input type="text" name="targetJob" class="form-control form-control-sm"
                                               value="${fn:escapeXml(form.targetJob)}"
                                               placeholder="예) 백엔드 개발자" required>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">자격증</th>
                                    <td>
                                        <textarea name="certificates" rows="2" class="form-control form-control-sm"
                                                  placeholder="정보처리기사, SQLD 등">${fn:escapeXml(form.certificates)}</textarea>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">교육/부트캠프</th>
                                    <td>
                                        <textarea name="eduHistory" rows="2" class="form-control form-control-sm"
                                                  placeholder="○○부트캠프 자바/Spring 과정 등">${fn:escapeXml(form.eduHistory)}</textarea>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">주요 프로젝트</th>
                                    <td>
                                        <textarea name="projects" rows="3" class="form-control form-control-sm"
                                                  placeholder="핵심 프로젝트 중심으로 간단히">${fn:escapeXml(form.projects)}</textarea>
                                    </td>
                                </tr>

                                <tr>
                                    <th class="bg-light">성격/강점</th>
                                    <td>
                                        <textarea name="strengths" rows="2" class="form-control form-control-sm"
                                                  placeholder="문제 해결, 협업 능력 등">${fn:escapeXml(form.strengths)}</textarea>
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
