<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../../header.jsp" %>

<<<<<<< HEAD
        <div class="flex-grow-1 p-1 overflow-auto">
            <sec:authentication property="principal.username"/>
            <h1>로그인성공</h1>
    </div>
=======
    <div id="main-container" class="container-fluid">
        <div class="flex-grow-1 p-1 overflow-auto">
            <sec:authentication property="principal.username"/>
            <h1>로그인성공</h1>
        </div>
    </div>
</main>
>>>>>>> 26a4290 (please)

<%@ include file="../../footer.jsp" %>