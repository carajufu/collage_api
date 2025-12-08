<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="header.jsp" %>

    <div id="main-container" class="container-fluid">
        <div class="flex-grow-1 p-1 overflow-auto">


        <h2 class="border-bottom pb-3 mb-4">게시글 상세 보기</h2>

        <div class="card shadow-sm">

            <div class="card-header bg-light p-3">
                <h4 class="card-title mb-0">글 제목 : ${bbsVO.bbscttSj}</h4>
            </div>

            <div class="card-body pb-2">
                <div class="d-flex justify-content-between align-items-center">
                    <span class="text-muted">
                        <i class="bi bi-person-fill"></i> 작성자: <strong>${bbsVO.sklstfNm}</strong>
                    </span>
                    <span class="text-muted">
                        <i class="bi bi-clock-history"></i> 작성일:
                        <fmt:formatDate value="${bbsVO.bbscttWritngDe}" pattern="yyyy-MM-dd" />
                    </span>
                </div>
            </div>

            <hr class="my-0">

            <div class="card-body">
                <pre class="card-text" style="min-height: 200px; font-family: inherit; font-size: 1rem;">${bbsVO.bbscttCn}</pre>
            </div>

            <div class="card-body border-top">
                <h6><i class="bi bi-paperclip"></i> 첨부파일</h6>

                <c:choose>
                    <%-- fileList가 비어있지 않다면 --%>
                    <c:when test="${not empty fileList}">
                        <ul class="list-group list-group-flush">
                            <c:forEach var="file" items="${fileList}">
                                <li class="list-group-item">
                                    <a href="${file.fileStreplace}">${file.fileNm}</a>
                                    <span class="text-muted small ms-2">(${file.fileMg} bytes)</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <%-- fileList가 비어있다면 --%>
                    <c:otherwise>

                        <p class="text-muted mb-0">첨부파일이 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

        </div> <div class="mt-4 d-flex justify-content-between">
            <div>
                <a href="/bbs/list" class="btn btn-success">
                    <i class="bi bi-list-ul"></i> 목록으로
                </a>
            </div>
            <%-- <div>
                <a href="/bbs/detail?bbscttNo=${bbsVO.bbscttNo}" class="btn btn-warning me-2">
                    <i class="bi bi-pencil-square"></i> 수정
                </a>

                <form id="deleteForm" action="/bbs/delete" method="Post" class="d-inline"
                      onsubmit="return confirm('정말로 이 글을 삭제하시겠습니까?');">



                    <input type="hidden" name="id" value="${bbsVO.bbscttNo}">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash3-fill"></i> 삭제
                    </button>
                </form>
            </div> --%>
        </div>

    </div>
        </div>

<%@ include file="footer.jsp" %>