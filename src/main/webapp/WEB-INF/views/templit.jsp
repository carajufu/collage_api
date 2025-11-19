<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- author : 김성환 -->

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>대덕공과대학교 :: </title>
   <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/user_main.css">
   <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/user_header.css">
   <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/resources/css/user_myside.css">
   
</head>
<body>
    <%@ include file="/WEB-INF/views/user/user_header.jsp" %><!-- 상단 네비게이션 바 -->
   
    <!-- 사이드바 + 메인 콘텐츠 영역 -->
    <div class="container">
        <!-- 왼쪽 프로필 사이드바 -->
       	<div class="sidebar">
	       	<%@ include file="/WEB-INF/views/user/user_myside.jsp" %><!-- 상단 네비게이션 바 -->
	       	<!-- 사이드 메뉴 적는 란 -->
	       
	       	
	      
		</div>
        <!-- 오른쪽 콘텐츠 영역 -->
        <div class="content">
            <h1>CONTENT</h1>
            <p class="notify">notify할 내용들</p>
            <p class="sub-notify">(학사일정, 수강조정일, etc...)</p>
            <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
            <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
            <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
            <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
            <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
        </div>
    </div>
</body>
</html>
