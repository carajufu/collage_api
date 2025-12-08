<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../../header.jsp" %>

<div class="row pt-3 px-5">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="/dashboard/student"><i class="las la-home"></i></a></li>
            <li class="breadcrumb-item"><a href="#">${result.LCTRE_NM}</a></li>
            <li class="breadcrumb-item active" aria-current="page">${result.BBS_NM}</li>
        </ol>
    </nav>
    <div class="col-12 page-title mt-2">
        <h2 class="fw-semibold">${result.BBS_NM}</h2>
        <div class="my-4 p-0 bg-primary" style="width: 100px; height:5px;"></div>
    </div>
</div>

<div class="row pt-2 px-5">
    <div class="col-xxl-12 col-12">
        <div class="card shadow-sm">
            <div class="card-body pb-2">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                    <div>
                        <div class="text-muted small">글번호 ${param.no}</div>
                        <h3 class="mb-1">${result.BBSCTT_SJ }</h3>
                    </div>
                    <div class="text-end text-muted small">
                        <div>
                            <strong>
                                <c:choose>
                                    <c:when test="${not empty result.SKLSTF_NM}">${result.SKLSTF_NM}</c:when>
                                    <c:when test="${not empty result.STDNT_NM}">${result.STDNT_NM}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                        <div class="mt-1">
                            <i class="bi bi-clock-history"></i>
                            <fmt:formatDate value="${result.BBSCTT_WRITNG_DE}" pattern="yyyy.MM.dd HH:mm" />
                            · 조회 ${result.BBSCTT_RDCNT}
                        </div>
                    </div>
                </div>
            </div>

            <div class="card-body border-top">
                <div class="post-body" style="min-height:200px; line-height:1.65;">
                    <c:out value="${result.BBSCTT_CN}" escapeXml="false" />
                </div>
            </div>

            <div class="card-body border-top">
                <h6 class="mb-2"><i class="bi bi-paperclip"></i> 첨부파일</h6>
                <c:choose>
                    <c:when test="${not empty attachmentList}">
                        <ul class="list-group list-group-flush">
                            <c:forEach var="file" items="${attachmentList}">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <a href="/learning/student/board/download?fileNo=${file.fileNo}">
                                            ${file.fileNm}
                                    </a>
                                    <span class="text-muted small">${file.fileMg} bytes</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <div class="text-muted">첨부 없음</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card-body border-top">
                <div class="d-flex flex-wrap gap-2 justify-content-end">
                    <a href="javascript:history.back();" class="btn btn-outline-primary">목록</a>
                    <sec:authorize access="hasRole('ROLE_PROF')">
                        <a href="/learning/student/board/edit?no=${lectureBbsCtt.bbscttNo}" class="btn btn-primary">수정</a>
                        <form action="/learning/student/board/delete" method="post" class="d-inline"
                              onsubmit="return confirm('삭제하시겠습니까?');">
                            <input type="hidden" name="no" value="${lectureBbsCtt.bbscttNo}">
                            <button type="submit" class="btn btn-danger">삭제</button>
                        </form>
                    </sec:authorize>
                </div>
            </div>

            <div class="card-body border-top">
                <ul class="list-unstyled mb-0">
                    <li class="d-flex py-2">
                        <div class="text-muted me-3" style="width:70px;">이전 글</div>
                        <div>
                            <c:choose>
                                <c:when test="${not empty prevCtt}">
                                    <a href="/learning/student/board?no=${prevCtt.bbscttNo}">${prevCtt.bbscttSj}</a>
                                </c:when>
                                <c:otherwise><span class="text-muted">없음</span></c:otherwise>
                            </c:choose>
                        </div>
                    </li>
                    <li class="d-flex py-2">
                        <div class="text-muted me-3" style="width:70px;">다음 글</div>
                        <div>
                            <c:choose>
                                <c:when test="${not empty nextCtt}">
                                    <a href="/learning/student/board?no=${nextCtt.bbscttNo}">${nextCtt.bbscttSj}</a>
                                </c:when>
                                <c:otherwise><span class="text-muted">없음</span></c:otherwise>
                            </c:choose>
                        </div>
                    </li>
                </ul>
            </div>
        </div>

        <!-- CKEditor가 이미 정적 자산에 있으므로 필요시 주입 -->
        <script src="/assets/libs/@ckeditor/ckeditor5-build-classic/build/ckeditor.js"></script>
        <script>
            // 읽기 전용 CKEditor로 본문을 렌더해야 할 경우:
            // ClassicEditor.create(document.querySelector('.post-body'), { toolbar: [] })
            //     .then(editor => editor.isReadOnly = true)
            //     .catch(console.error);
        </script>
    </div>
</div>

<%@ include file="../../footer.jsp" %>
