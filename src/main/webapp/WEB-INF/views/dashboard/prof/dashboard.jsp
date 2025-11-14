<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="../../header.jsp" %>

        <div class="flex-grow-1 p-1 overflow-auto">
            <sec:authentication property="principal.username"/>
            <h1>로그인성공</h1>
    </div>

<%@ include file="../../footer.jsp" %>