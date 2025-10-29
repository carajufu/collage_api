<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../../header.jsp" %>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", () => {
            const cards = Array.from(document.querySelectorAll(".card"));
            console.log("chkng cards > ", cards);

            cards.forEach(e => {
                e.addEventListener("click", () => {
                   location.href = "/learning/student?lcNo=55";
                });
            })
        })
    </script>

    <div id="main-container" class="container-fluid">
        <div class="flex-grow-1 overflow-hidden mx-5">
            <h1>로그인성공</h1>
            <p>${lectureList}</p>
            <div class="row row-cols-4 px-3 gap-2">
            <c:forEach items="${lectureList}" var="lecture">
                    <div class="col card">
                        <div class="card-body" >
                            <h4 class="card-title">${lecture.lctreNm}</h4>
                            <p class="card-subtitle">${lecture.lctrum}</p>
                            <p class="card-subtitle">${lecture.sklstfNm}</p>
                        </div>
                    </div>
            </c:forEach>
            </div>
        </div>
    </div>
</main>

<%@ include file="../../footer.jsp" %>