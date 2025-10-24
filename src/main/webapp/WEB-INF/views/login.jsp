<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="header.jsp" %>

    <div id="main-container" class="container-fluid">
        <div class="flex-grow-1 p-1 overflow-auto">
            <form action="/login" method="POST">
                <div class="mb-3">
                    아이디
                    <label class="form-label text-white">Account id</label>
                    <input type="text" class="form-control" name="username" />
                </div>
                <div class="mb-3">
                    비밀번호
                    <label class="form-label text-white">Password</label>
                    <input type="password" class="form-control" name="password" />
                </div>
                <button type="submit" class="btn btn-primary">Login</button>
            </form>
        </div>
    </div>
</main>

<%@ include file="footer.jsp" %>