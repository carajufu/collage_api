<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

<div class="row pt-3 px-5">
    <div class="col-xxl-12 col-12">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
                <li class="breadcrumb-item active"><a href="#">졸업</a></li>
                <li class="breadcrumb-item active" aria-current="page">자기소개서 도우미</li>
            </ol>
        </nav>
    </div>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">자기소개서 도우미</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
    <div class="col-xxl-12 col-12">
        <div class="d-flex justify-content-end mb-2">
            <a href="${pageContext.request.contextPath}/compe/manage"
               class="btn btn-primary btn-md ms-auto">내 이력 관리</a>
        </div>
            <div class="d-flex justify-content-end mb-2">
                <button type="button" class="btn btn-outline-primary btn-sm" id="fillSampleBtn">
                    샘플 데이터 입력
                </button>
            </div>

            <form id="generateForm"
                  action="${pageContext.request.contextPath}/compe/generate"
                  method="post">

                <table class="table table-bordered table-sm align-middle mb-3">
                    <tbody>

                    <!-- 이름 + 생년 -->
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

                    <!-- 학력 + 군필 -->
                    <tr>
                        <th class="bg-light">학력</th>
                        <td>
                            <input type="text" name="lastAcdmcr"
                                   class="form-control form-control-sm"
                                   placeholder="대덕대학교 @@학과 졸업 예정(20@@년 @월)"
                                   value="${empty form.lastAcdmcr ? '' : fn:escapeXml(form.lastAcdmcr)}">
                        </td>

                        <th class="bg-light">군필 여부</th>
                        <td>
                            <select name="miltrAt" class="form-select form-select-sm">
                                <option value="해당 없음" ${form.miltrAt=='해당 없음' ? 'selected' : ''}>해당 없음</option>
                                <option value="군필"     ${form.miltrAt=='군필'     ? 'selected' : ''}>군필</option>
                                <option value="미필"     ${form.miltrAt=='미필'     ? 'selected' : ''}>미필</option>
                            </select>
                        </td>
                    </tr>

                    <!-- 지원 직무 -->
                    <tr>
                        <th class="bg-light">지원 직무</th>
                        <td colspan="3">
                            <div class="d-flex gap-2" style="max-width:80%;">

                                <!-- 대분류 -->
                                <select id="jobCategory" class="form-select form-select-sm" style="width:40%;">
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

                                <!-- 기획 -->
                                <select id="planJobs" name="desireJob"
                                        class="form-select form-select-sm job-detail"
                                        style="display:none; width:40%;">
                                    <option value="">세부 직무 선택</option>
                                    <option value="기획자"             ${form.desireJob=='기획자'             ? 'selected' : ''}>기획자</option>
                                    <option value="마케팅기획자"       ${form.desireJob=='마케팅기획자'       ? 'selected' : ''}>마케팅기획자</option>
                                    <option value="사업기획자"         ${form.desireJob=='사업기획자'         ? 'selected' : ''}>사업기획자</option>
                                    <option value="전략기획자"         ${form.desireJob=='전략기획자'         ? 'selected' : ''}>전략기획자</option>
                                    <option value="상품기획자"         ${form.desireJob=='상품기획자'         ? 'selected' : ''}>상품기획자</option>
                                    <option value="프로덕트매니저"     ${form.desireJob=='프로덕트매니저'     ? 'selected' : ''}>프로덕트매니저(PM)</option>
                                    <option value="경영기획자"         ${form.desireJob=='경영기획자'         ? 'selected' : ''}>경영기획자</option>
                                    <option value="서비스기획자"       ${form.desireJob=='서비스기획자'       ? 'selected' : ''}>서비스기획자</option>
                                    <option value="광고기획자"         ${form.desireJob=='광고기획자'         ? 'selected' : ''}>광고기획자</option>
                                    <option value="브랜드기획자"       ${form.desireJob=='브랜드기획자'       ? 'selected' : ''}>브랜드기획자</option>
                                    <option value="웹기획자"           ${form.desireJob=='웹기획자'           ? 'selected' : ''}>웹기획자</option>
                                    <option value="리서처"             ${form.desireJob=='리서처'             ? 'selected' : ''}>리서처</option>
                                    <option value="데이터분석가"       ${form.desireJob=='데이터분석가'       ? 'selected' : ''}>데이터분석가</option>
                                </select>

                                <!-- 마케팅 -->
                                <select id="marketingJobs" name="desireJob"
                                        class="form-select form-select-sm job-detail"
                                        style="display:none; width:40%;">
                                    <option value="">세부 직무 선택</option>
                                    <option value="마케터"           ${form.desireJob=='마케터'           ? 'selected' : ''}>마케터</option>
                                    <option value="온라인마케터"     ${form.desireJob=='온라인마케터'     ? 'selected' : ''}>온라인마케터</option>
                                    <option value="브랜드마케터"     ${form.desireJob=='브랜드마케터'     ? 'selected' : ''}>브랜드마케터</option>
                                    <option value="광고마케터"       ${form.desireJob=='광고마케터'       ? 'selected' : ''}>광고마케터</option>
                                    <option value="콘텐츠마케터"     ${form.desireJob=='콘텐츠마케터'     ? 'selected' : ''}>콘텐츠마케터</option>
                                    <option value="콘텐츠기획자"     ${form.desireJob=='콘텐츠기획자'     ? 'selected' : ''}>콘텐츠기획자</option>
                                    <option value="광고운영자"       ${form.desireJob=='광고운영자'       ? 'selected' : ''}>광고운영자</option>
                                    <option value="채널매니저"       ${form.desireJob=='채널매니저'       ? 'selected' : ''}>채널매니저</option>
                                    <option value="프로모션매니저"   ${form.desireJob=='프로모션매니저'   ? 'selected' : ''}>프로모션매니저</option>
                                </select>

                                <!-- 총무/법무 -->
                                <select id="officeJobs" name="desireJob"
                                        class="form-select form-select-sm job-detail"
                                        style="display:none; width:40%;">
                                    <option value="">세부 직무 선택</option>
                                    <option value="사무원"       ${form.desireJob=='사무원'       ? 'selected' : ''}>사무원</option>
                                    <option value="총무담당"     ${form.desireJob=='총무담당'     ? 'selected' : ''}>총무담당</option>
                                    <option value="비서"         ${form.desireJob=='비서'         ? 'selected' : ''}>비서</option>
                                    <option value="사무보조"     ${form.desireJob=='사무보조'     ? 'selected' : ''}>사무보조</option>
                                    <option value="행정담당"     ${form.desireJob=='행정담당'     ? 'selected' : ''}>행정담당</option>
                                    <option value="경영지원"     ${form.desireJob=='경영지원'     ? 'selected' : ''}>경영지원</option>
                                    <option value="자료입력원"   ${form.desireJob=='자료입력원'   ? 'selected' : ''}>자료입력원</option>
                                </select>

                                <!-- IT -->
                                <select id="itJobs" name="desireJob"
                                        class="form-select form-select-sm job-detail"
                                        style="display:none; width:40%;">
                                    <option value="">세부 직무 선택</option>
                                    <option value="백엔드개발자"       ${form.desireJob=='백엔드개발자'       ? 'selected' : ''}>백엔드개발자</option>
                                    <option value="프론트엔드개발자"   ${form.desireJob=='프론트엔드개발자'   ? 'selected' : ''}>프론트엔드개발자</option>
                                    <option value="웹개발자"           ${form.desireJob=='웹개발자'           ? 'selected' : ''}>웹개발자</option>
                                    <option value="보안엔지니어"       ${form.desireJob=='보안엔지니어'       ? 'selected' : ''}>보안엔지니어</option>
                                    <option value="네트워크엔지니어"   ${form.desireJob=='네트워크엔지니어'   ? 'selected' : ''}>네트워크엔지니어</option>
                                    <option value="AI엔지니어"         ${form.desireJob=='AI엔지니어'         ? 'selected' : ''}>AI엔지니어</option>
                                    <option value="자바개발자"         ${form.desireJob=='자바개발자'         ? 'selected' : ''}>자바개발자</option>
                                    <option value="파이썬개발자"       ${form.desireJob=='파이썬개발자'       ? 'selected' : ''}>파이썬개발자</option>
                                    <option value="자바스크립트개발자" ${form.desireJob=='자바스크립트개발자' ? 'selected' : ''}>자바스크립트개발자</option>
                                </select>

                                <!-- 영업 -->
                                <select id="salesJobs" name="desireJob"
                                        class="form-select form-select-sm job-detail"
                                        style="display:none; width:40%;">
                                    <option value="">세부 직무 선택</option>
                                    <option value="영업사원"       ${form.desireJob=='영업사원'       ? 'selected' : ''}>영업사원</option>
                                    <option value="영업지원담당"   ${form.desireJob=='영업지원담당'   ? 'selected' : ''}>영업지원담당</option>
                                    <option value="영업관리자"     ${form.desireJob=='영업관리자'     ? 'selected' : ''}>영업관리자</option>
                                    <option value="기술영업사원"   ${form.desireJob=='기술영업사원'   ? 'selected' : ''}>기술영업사원</option>
                                    <option value="상담영업원"     ${form.desireJob=='상담영업원'     ? 'selected' : ''}>상담영업원</option>
                                    <option value="해외영업사원"   ${form.desireJob=='해외영업사원'   ? 'selected' : ''}>해외영업사원</option>
                                </select>

                                <!-- 구매/자재 -->
                                <select id="logisticsJobs" name="desireJob"
                                        class="form-select form-select-sm job-detail"
                                        style="display:none; width:40%;">
                                    <option value="">세부 직무 선택</option>
                                    <option value="물류담당자"   ${form.desireJob=='물류담당자'   ? 'selected' : ''}>물류담당자</option>
                                    <option value="재고담당자"   ${form.desireJob=='재고담당자'   ? 'selected' : ''}>재고담당자</option>
                                    <option value="창고관리자"   ${form.desireJob=='창고관리자'   ? 'selected' : ''}>창고관리자</option>
                                    <option value="자재관리자"   ${form.desireJob=='자재관리자'   ? 'selected' : ''}>자재관리자</option>
                                    <option value="구매담당자"   ${form.desireJob=='구매담당자'   ? 'selected' : ''}>구매담당자</option>
                                </select>

                                <!-- 생산 -->
                                <select id="productionJobs" name="desireJob"
                                        class="form-select form-select-sm job-detail"
                                        style="display:none; width:40%;">
                                    <option value="">세부 직무 선택</option>
                                    <option value="생산직사원"   ${form.desireJob=='생산직사원'   ? 'selected' : ''}>생산직사원</option>
                                    <option value="생산관리자"   ${form.desireJob=='생산관리자'   ? 'selected' : ''}>생산관리자</option>
                                    <option value="품질관리자"   ${form.desireJob=='품질관리자'   ? 'selected' : ''}>품질관리자</option>
                                    <option value="기계조작원"   ${form.desireJob=='기계조작원'   ? 'selected' : ''}>기계조작원</option>
                                </select>

                                <!-- 건설 -->
                                <select id="constructionJobs" name="desireJob"
                                        class="form-select form-select-sm job-detail"
                                        style="display:none; width:40%;">
                                    <option value="">세부 직무 선택</option>
                                    <option value="전기기사"     ${form.desireJob=='전기기사'     ? 'selected' : ''}>전기기사</option>
                                    <option value="현장관리자"   ${form.desireJob=='현장관리자'   ? 'selected' : ''}>현장관리자</option>
                                    <option value="토목기사"     ${form.desireJob=='토목기사'     ? 'selected' : ''}>토목기사</option>
                                    <option value="건축설계사"   ${form.desireJob=='건축설계사'   ? 'selected' : ''}>건축설계사</option>
                                </select>

                                <!-- 의료 -->
                                <select id="medicalJobs" name="desireJob"
                                        class="form-select form-select-sm job-detail"
                                        style="display:none; width:40%;">
                                    <option value="">세부 직무 선택</option>
                                    <option value="간호사"         ${form.desireJob=='간호사'         ? 'selected' : ''}>간호사</option>
                                    <option value="간호조무사"     ${form.desireJob=='간호조무사'     ? 'selected' : ''}>간호조무사</option>
                                    <option value="병원행정직원"   ${form.desireJob=='병원행정직원'   ? 'selected' : ''}>병원행정직원</option>
                                    <option value="환자안내직원"   ${form.desireJob=='환자안내직원'   ? 'selected' : ''}>환자안내직원</option>
                                </select>

                                <!-- 교육 -->
                                <select id="educationJobs" name="desireJob"
                                        class="form-select form-select-sm job-detail"
                                        style="display:none; width:40%;">
                                    <option value="">세부 직무 선택</option>
                                    <option value="학원강사"       ${form.desireJob=='학원강사'       ? 'selected' : ''}>학원강사</option>
                                    <option value="교육운영담당"   ${form.desireJob=='교육운영담당'   ? 'selected' : ''}>교육운영담당</option>
                                    <option value="학생지도교사"   ${form.desireJob=='학생지도교사'   ? 'selected' : ''}>학생지도교사</option>
                                    <option value="학습상담사"     ${form.desireJob=='학습상담사'     ? 'selected' : ''}>학습상담사</option>
                                    <option value="보육교사"       ${form.desireJob=='보육교사'       ? 'selected' : ''}>보육교사</option>
                                </select>

                            </div>
                        </td>
                    </tr>

                    <!-- 자격증 + 교육/부트캠프 -->
                    <tr>
                        <th class="bg-light">자격증</th>
                        <td>
                            <textarea name="crqfc" rows="4" class="form-control form-control-sm"
                                      placeholder="정보처리산업기사 합격(20@@)..."
                            >${empty form.crqfc ? '' : fn:escapeXml(form.crqfc)}</textarea>
                        </td>

                        <th class="bg-light">교육/부트캠프</th>
                        <td>
                            <textarea name="edcHistory" rows="4" class="form-control form-control-sm"
                                      placeholder="Spring Boot, MyBatis 기반 웹 서비스 개발 프로젝트 경험..."
                            >${empty form.edcHistory ? '' : fn:escapeXml(form.edcHistory)}</textarea>
                        </td>
                    </tr>

                    <!-- 주요 프로젝트 -->
                    <tr>
                        <th class="bg-light">주요 프로젝트</th>
                        <td colspan="3">
                            <textarea name="mainProject" rows="5" class="form-control form-control-sm"
                                      placeholder="사용자 경험 개선 UI 리뉴얼 및 대시보드 그래프 구현..."
                            >${empty form.mainProject ? '' : fn:escapeXml(form.mainProject)}</textarea>
                        </td>
                    </tr>

                    <!-- 성격 -->
                    <tr>
                        <th class="bg-light">성격/강점</th>
                        <td colspan="3">
                            <textarea name="character" rows="4" class="form-control form-control-sm"
                                      placeholder="새로운 기술을 빠르게 학습하고 실제 프로젝트에 적용하는 능력이 강점입니다..."
                            >${empty form.character ? '' : fn:escapeXml(form.character)}</textarea>
                        </td>
                    </tr>

                    <!-- 추가 요청 사항 -->
                    <tr>
                        <th class="bg-light text">추가 요청 사항</th>
                        <td colspan="3">
                            <textarea id="aiGuide" rows="5" class="form-control form-control-sm"
                                      placeholder="예) 자기소개서는 간결하지만 핵심을 강조하는 스타일로 작성해주세요.&#10;예) 협업 경험을 중심으로 풀어주세요.&#10;예) 너무 형식적이지 않은 자연스러운 문체를 선호합니다.&#10;예) 성장 과정보다 실무 경험을 강조해주세요.&#10;이 내용은 저장되지 않습니다"></textarea>
                        </td>
                    </tr>

                    </tbody>
                </table>

                    <h6 style="color: LightSalmon;">AI가 작성하는 내용은 실수를 할 수 있습니다. 중요한 정보는 재차 확인하세요</h6>
                <div class="d-flex justify-content-end mb-5">
                    <a href="/compe/detail" class="btn btn-primary btn-sm me-2">생성된 자기소개서 확인하기</a>
                    <button type="submit" class="btn btn-primary btn-sm" id="generateBtn">자기소개서 생성</button>
                </div>

            </form>

        </div>
    </div>

<!-- 로딩 오버레이 -->
<div id="loadingOverlay"
     style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
            background:rgba(0,0,0,0.45); z-index:3000;">
    <div class="d-flex justify-content-center align-items-center" style="height:100%;">
        <div class="spinner-border text-light" role="status" style="width:4rem; height:4rem;"></div>
    </div>
</div>

<!-- 모달 -->
<div class="modal fade" id="essayModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">생성된 자기소개서</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <textarea id="modalEssayArea" class="form-control" rows="20"></textarea>
            </div>

            <div class="modal-footer">

                <form id="nextPageForm">
                    <textarea name="essay" id="nextEssayField" class="d-none"></textarea>
                    <a href="/compe/detail" class="btn btn-primary btn-sm">다음 단계로 이동</a>
                </form>

                <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">닫기</button>

            </div>

        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const category = document.getElementById("jobCategory");
    const details = document.querySelectorAll(".job-detail");
    const selectedJob = "${empty form.desireJob ? '' : fn:escapeXml(form.desireJob)}";
    const ctxPath = "${pageContext.request.contextPath}";

    const map = {
        plan: ["기획자","마케팅기획자","사업기획자","전략기획자","상품기획자","프로덕트매니저","경영기획자",
               "서비스기획자","광고기획자","브랜드기획자","웹기획자","리서처","데이터분석가"],
        marketing: ["마케터","온라인마케터","브랜드마케터","광고마케터","콘텐츠마케터","콘텐츠기획자",
                    "광고운영자","채널매니저","프로모션매니저"],
        office: ["사무원","총무담당","비서","사무보조","행정담당","경영지원","자료입력원"],
        it: ["백엔드개발자","프론트엔드개발자","웹개발자","보안엔지니어","네트워크엔지니어",
             "AI엔지니어","자바개발자","파이썬개발자","자바스크립트개발자"],
        sales: ["영업사원","영업지원담당","영업관리자","기술영업사원","상담영업원","해외영업사원"],
        logistics: ["물류담당자","재고담당자","창고관리자","자재관리자","구매담당자"],
        production: ["생산직사원","생산관리자","품질관리자","기계조작원"],
        construction: ["전기기사","현장관리자","토목기사","건축설계사"],
        medical: ["간호사","간호조무사","병원행정직원","환자안내직원"],
        education: ["학원강사","교육운영담당","학생지도교사","학습상담사","보육교사"]
    };

    // 기존 선택값으로 대분류/세부직무 세팅
    if (selectedJob !== "") {
        for (let key in map) {
            if (map[key].includes(selectedJob)) {
                category.value = key;
                const detailSelect = document.getElementById(key + "Jobs");
                if (detailSelect) {
                    detailSelect.style.display = "block";
                    detailSelect.disabled = false;
                    detailSelect.value = selectedJob;
                }
            }
        }
    }

    function showDetail() {
        details.forEach(el => {
            el.style.display = "none";
            el.disabled = true;
        });
        if (category.value) {
            const target = document.getElementById(category.value + "Jobs");
            if (target) {
                target.style.display = "block";
                target.disabled = false;
            }
        }
    }

    category.addEventListener("change", showDetail);
    showDetail();

    // AI 생성 요청
    const form = document.getElementById("generateForm");

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        document.getElementById("loadingOverlay").style.display = "block";

        const formData = new FormData(form);
        formData.append("extraGuide", document.getElementById("aiGuide").value.trim());

        fetch(ctxPath + "/compe/generateAjax", {
            method: "POST",
            body: formData
        })
            .then(res => {
                if (!res.ok) {
                    throw new Error("HTTP 상태코드: " + res.status);
                }
                return res.json();
            })
            .then(data => {
                document.getElementById("loadingOverlay").style.display = "none";

                document.getElementById("modalEssayArea").value = data.generatedEssay;
                document.getElementById("nextEssayField").value = data.generatedEssay;

                const modal = new bootstrap.Modal(document.getElementById("essayModal"));
                modal.show();
            })
            .catch(err => {
                console.error(err);
                alert("자기소개서 생성 중 오류가 발생했습니다.");
                document.getElementById("loadingOverlay").style.display = "none";
            });
    });

});

//샘플 데이터 자동 입력
document.getElementById("fillSampleBtn").addEventListener("click", function () {

    document.querySelector("input[name='stdntNm']").value = "정태민";
    document.querySelector("input[name='birthYear']").value = "19991231";

    document.querySelector("input[name='lastAcdmcr']").value =
        "대덕대학교 컴퓨터정보학과 졸업 예정(2025년 2월)";

    document.querySelector("select[name='miltrAt']").value = "군필";

    document.getElementById("jobCategory").value = "it";
    document.querySelectorAll(".job-detail").forEach(e => {
        e.style.display = "none";
        e.disabled = true;
    });
    const itSel = document.getElementById("itJobs");
    itSel.style.display = "block";
    itSel.disabled = false;
    itSel.value = "백엔드개발자";

    document.querySelector("textarea[name='crqfc']").value =
        "정보처리산업기사 합격(2024)\nSQLD 자격증 취득(2023)";

    document.querySelector("textarea[name='edcHistory']").value =
        "Spring Boot, MyBatis 기반 웹 개발 프로젝트 수행\nJava 백엔드 심화 과정 수료";

    document.querySelector("textarea[name='mainProject']").value =
        "대학 LMS 통합 시스템 개발\n- MYBATIS ORM 적용\n- 강의평가, 성적처리, 상담 모듈 개발\n- UI 리뉴얼 및 배포";

    document.querySelector("textarea[name='character']").value =
        "문제 해결 능력이 뛰어나며 협업 과정에서 의사소통이 원활합니다.\n새 기술 학습 속도가 빠르고 책임감이 강합니다.";

    document.getElementById("aiGuide").value =
        "실무 백엔드 개발자로 지원한다는 느낌을 강조하고, 협업 경험을 중심으로 자연스럽게 작성해주세요.";
});

</script>

<%@ include file="../footer.jsp" %>
