<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../../header.jsp" %>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", () => {
            const cards = Array.from(document.querySelectorAll(".card"));
            console.log("chkng cards > ", cards);

            cards.forEach(e => {
                e.addEventListener("click", e => {
                    const lecNo = e.currentTarget.dataset.lecNo;
                    console.log("chkng lecNo ", lecNo);

                    location.href = "/learning/student?lecNo=" + lecNo;
                });
            })
        })
    </script>

        <div class="row p-5">
            <div class="col-12">
                <div class="row row-cols-xxl-4 row-cols-lg-2 row-cols-1">
                    <c:forEach items="${lectureList}" var="lecture">
                    <div class="col">
                        <div class="card card-body rounded-3 shadow-sm" data-lec-no="${lecture.estbllctreCode}">
                                <h4 class="card-title">${lecture.lctreNm}</h4>
                                <h1>우리 반에 <br>
                                악마가 <br>
                                살고있어요</h1>
                                <p class="card-subtitle">${lecture.lctrum}</p>
                                <p class="card-subtitle">${lecture.sklstfNm}</p>
                        </div>
                    </div>
                    </c:forEach>

                </div>
            </div>
        </div>

<%@ include file="../../footer.jsp" %>