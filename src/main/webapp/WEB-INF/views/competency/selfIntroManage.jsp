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

                <form action="${pageContext.request.contextPath}/compe/manage/save" method="post">

                    <!-- 자격증 -->
                    <div class="mb-4">
                        <label class="fw-bold mb-1">자격증</label>
                        <textarea name="crqfc" rows="4" class="form-control form-control-sm"
                                  placeholder="예: 컴퓨터활용능력 2급 취득 / 운전면허 2종 보통 취득"
                        >${empty form.crqfc ? '' : fn:escapeXml(form.crqfc)}</textarea>
                        <div class="form-text">보유한 자격증이나 공인시험 합격 여부를 입력하세요.</div>
                    </div>

                    <!-- 교육/부트캠프 -->
                    <div class="mb-4">
                        <label class="fw-bold mb-1">교육 / 활동 경험</label>
                        <textarea name="edcHistory" rows="4" class="form-control form-control-sm"
                                  placeholder="예: 현장실습 참여 / 방학 중 직무 관련 교육 이수 / 온라인 강의 수강"
                        >${empty form.edcHistory ? '' : fn:escapeXml(form.edcHistory)}</textarea>
                        <div class="form-text">학교·기관 등에서 참여한 교육, 실습, 활동 등을 입력하세요.</div>
                    </div>

                    <!-- 주요 프로젝트 -->
                    <div class="mb-4">
                        <label class="fw-bold mb-1">주요 프로젝트</label>
                        <textarea name="mainProject" rows="5" class="form-control form-control-sm"
                                  placeholder="예: 졸업작품 제작 / 팀 프로젝트 참여 경험 / 동아리 프로젝트 수행"
                        >${empty form.mainProject ? '' : fn:escapeXml(form.mainProject)}</textarea>
                        <div class="form-text">수업·동아리·대회 등에서 진행한 프로젝트 경험을 입력하세요.</div>
                    </div>

                    <!-- 성격/강점 -->
                    <div class="mb-4">
                        <label class="fw-bold mb-1">성격 / 강점</label>
                        <textarea name="character" rows="4" class="form-control form-control-sm"
                                  placeholder="예: 맡은 일을 책임감 있게 수행함 / 사람들과 협력하는 데 강점이 있음"
                        >${empty form.character ? '' : fn:escapeXml(form.character)}</textarea>
                        <div class="form-text">나의 성격 중 직무에 도움이 될 것 같은 장점을 중심으로 작성하세요.</div>
                    </div>

                    <!-- 버튼 -->
                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <a href="${pageContext.request.contextPath}/compe/main"
                           class="btn btn-outline-primary btn-sm px-3">
                            AI자기소개서 생성기
                        </a>

                        <button type="submit" class="btn btn-primary btn-sm px-4">
                            저장하기
                        </button>
                    </div>
                </form>

            </div>
        </div>
    </div.
<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const params = new URLSearchParams(window.location.search);
    if (params.get("save") === "ok") {
        Swal.fire({
            icon: 'success',
            title: '저장되었습니다',
            text: '입력하신 내용이 성공적으로 저장되었습니다.',
            confirmButtonColor: '#222E83',
            confirmButtonText: '확인'
        });
    }
});
</script>

<%@ include file="../footer.jsp" %>
