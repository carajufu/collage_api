<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!doctype html>
<html lang="ko" data-layout="vertical" data-sidebar-visibility="show" data-topbar="light" data-sidebar="light" data-sidebar-size="lg" data-sidebar-image="none" data-preloader="disable">
<head>
    <link rel="shortcut icon" href="#">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Collage</title>

    <!-- App favicon -->
    <link rel="shortcut icon" href="/favicon.ico">

    <!-- plugin css -->
    <link href="/assets/libs/jsvectormap/jsvectormap.min.css" rel="stylesheet" type="text/css" />

    <!-- Bootstrap Css -->
    <link href="/assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <!-- Icons Css -->
    <link href="/assets/css/icons.min.css" rel="stylesheet" type="text/css" />
    <!-- App Css-->
    <link href="/assets/css/app.min.css" rel="stylesheet" type="text/css" />
    <!-- custom Css-->
    <link href="/assets/css/custom.css" rel="stylesheet" type="text/css" />

    <!-- JAVASCRIPT -->
    <script src="/assets/libs/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/assets/js/pages/plugins/lord-icon-2.1.0.js"></script>
    <script src="/assets/js/plugins.js"></script>
    <script src="/assets/js/app.js" defer></script>
    <script src="/assets/js/layout.js"></script>

    <script src="/assets/libs/simplebar/simplebar.min.js"></script>
    <script src="/assets/libs/node-waves/waves.min.js"></script>

    <!-- jQuery-3.6.0.min -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

    <!-- axios -->
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <!--sweetalert2-->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.10.0/dist/sweetalert2.all.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.10.0/dist/sweetalert2.min.css">

</head>
<body>


    <div id="main-container" class="container-fluid">
        <div class="flex-grow-1 p-5 overflow-auto">

			<h2 class="section-title">실시간 화상 상담실 (Room: <span id="cnsltInnb">${cnsltInnb}</span>)</h2>

	        <div class="row g-4 mt-5">
				<div class="video-wrapper shadow-lg">
					<video id="remoteVideo" autoplay playsinline></video>
					<video id="localVideo" autoplay playsinline muted></video>
				</div>
				<div class="controls d-flex">
					<button id="enterBtn" class="btn btn-success justify-content-end" onclick="startConsultation()">
						상담 시작
					</button>
					<button id="exitBtn" class="btn btn-danger justify-content-end" onClick="endConsultation()" disabled>
						상담 종료
					</button>
				</div>

	        </div>

        </div>
    </div>


	<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script src="https://webrtc.github.io/adapter/adapter-latest.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/webRtc/webrtc_client.js"></script>



<%@ include file="../footer.jsp" %>
