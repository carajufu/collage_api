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
    <script src="/assets/js/app.js"></script>
    <script src="/assets/js/layout.js"></script>

    <script src="/assets/libs/simplebar/simplebar.min.js"></script>
    <script src="/assets/libs/node-waves/waves.min.js"></script>

    <!-- jQuery-3.6.0.min -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>

</head>
<body>
<!-- Begin page -->
<div id="layout-wrapper">

    <header id="page-topbar">
        <div class="layout-width">
            <div class="navbar-header">
                <div class="d-flex">
                    <button type="button" class="btn btn-sm px-3 fs-16 header-item vertical-menu-btn topnav-hamburger" id="topnav-hamburger-icon">
                    <span class="hamburger-icon">
                        <span></span>
                        <span></span>
                        <span></span>
                    </span>
                    </button>
                </div>

                <sec:authorize access="isAuthenticated()">
                    <sec:authentication property="principal" var="user" />
                <div class="d-flex align-items-center">

                    <div class="dropdown ms-1 topbar-head-dropdown header-item">
                        <button type="button" class="btn btn-icon btn-topbar btn-ghost-secondary rounded-circle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <img id="header-lang-img" src="/assets/images/flags/kr.svg" alt="Header Language" height="20" class="rounded">
                        </button>
                        <div class="dropdown-menu dropdown-menu-end">

                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item language py-2" data-lang="kr" title="Korean">
                                <img src="/assets/images/flags/kr.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">한국어</span>
                            </a>

                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item language py-2" data-lang="en" title="English">
                                <img src="/assets/images/flags/us.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">English</span>
                            </a>

                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="sp" title="Spanish">
                                <img src="/assets/images/flags/spain.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">Española</span>
                            </a>

                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="gr" title="German">
                                <img src="/assets/images/flags/germany.svg" alt="user-image" class="me-2 rounded" height="18"> <span class="align-middle">Deutsche</span>
                            </a>

                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="it" title="Italian">
                                <img src="/assets/images/flags/italy.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">Italiana</span>
                            </a>

                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="ru" title="Russian">
                                <img src="/assets/images/flags/russia.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">русский</span>
                            </a>

                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="ch" title="Chinese">
                                <img src="/assets/images/flags/china.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">中国人</span>
                            </a>

                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="fr" title="French">
                                <img src="/assets/images/flags/french.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">français</span>
                            </a>

                            <!-- item-->
                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="ar" title="Arabic">
                                <img src="/assets/images/flags/ae.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">Arabic</span>
                            </a>
                        </div>
                    </div>

                    <div class="ms-1 header-item d-none d-sm-flex">
                        <button type="button" class="btn btn-icon btn-topbar btn-ghost-secondary rounded-circle light-dark-mode">
                            <i class='bx bx-moon fs-22'></i>
                        </button>
                    </div>

                    <div class="dropdown topbar-head-dropdown ms-1 header-item" id="notificationDropdown">
                        <button type="button" class="btn btn-icon btn-topbar btn-ghost-secondary rounded-circle" id="page-header-notifications-dropdown" data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-haspopup="true" aria-expanded="false">
                            <i class='bx bx-bell fs-22' id="notification-icon"></i>
                            <span id="notification-badge" class="position-absolute topbar-badge fs-10 translate-middle badge rounded-pill bg-danger">0<span class="visually-hidden">unread messages</span></span>
                        </button>
                        <div class="dropdown-menu dropdown-menu-lg dropdown-menu-end p-0" aria-labelledby="page-header-notifications-dropdown">

                            <div class="dropdown-head bg-primary bg-pattern rounded-top">
						        <div class="p-3">
						            <div class="row align-items-center">
						                <div class="col">
						                    <h6 class="m-0 fs-16 fw-semibold text-white"> 알림함 </h6>
						                </div>
						                <div class="col-auto dropdown-tabs">
						                    <span class="badge bg-light-subtle text-body fs-13">New</span>
						                </div>
						            </div>
						        </div>
						    </div>


                             <div class="tab-content position-relative" id="notificationItemsTabContent">
						        <div class="tab-pane fade show active py-2 ps-2" id="all-noti-tab" role="tabpanel">

						            <div data-simplebar style="max-height: 300px;" class="pe-2" id="my-notification-list">

						                <div class="text-center empty-notification-elem mt-3">
						                    <div class="avatar-md w-auto">
						                         <span class="avatar-title bg-light-subtle text-body rounded-circle fs-24">
						                             <i class="bi bi-bell-slash"></i>
						                         </span>
						                    </div>
						                    <p class="text-muted mt-2">새로운 알림이 없습니다.</p>
						                </div>

						                </div>
						        </div>
						    </div>



                        </div>
                    </div>

                    <div class="dropdown ms-sm-3 header-item topbar-user ">
                        <button type="button" class="btn btn-ghost-primary" id="page-header-user-dropdown" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="width: 300px">
                        <span class="d-flex align-items-center">
                            <img class="rounded-circle header-profile-user" src="/assets/images/users/user-dummy-img.jpg" alt="Header Avatar">
                            <span class="text-start ms-xl-2">
                                <span class="d-none d-xl-inline-block ms-3 fw-medium fs-5 user-name-text">${user.name}</span>
                            </span>
                        </span>
                        </button>
                        <div class="dropdown-menu dropdown-menu-end" style="width: 300px">
                            <!-- item-->
                            <h6 class="dropdown-header">${user.affiliation}</h6>
                            <h6 class="dropdown-header">${userc.username}</h6>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="pages-profile.html"><i class="mdi mdi-account-circle text-muted fs-16 align-middle me-1"></i> <span class="align-middle">개인 정보 수정</span></a>
                            <a class="dropdown-item" href="apps-chat.html"><i class="mdi mdi-message-text-outline text-muted fs-16 align-middle me-1"></i> <span class="align-middle">메세지</span></a>
                            <a class="dropdown-item" href="apps-tasks-kanban.html"><i class="mdi mdi-calendar-check-outline text-muted fs-16 align-middle me-1"></i> <span class="align-middle">Taskboard</span></a>
                            <a class="dropdown-item" href="pages-faqs.html"><i class="mdi mdi-lifebuoy text-muted fs-16 align-middle me-1"></i> <span class="align-middle">도움말</span></a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="pages-profile-settings.html"><span class="badge bg-success-subtle text-success mt-1 float-end">New</span><i class="mdi mdi-cog-outline text-muted fs-16 align-middle me-1"></i> <span class="align-middle">설정</span></a>
                            <a class="dropdown-item" href="auth-lockscreen-basic.html"><i class="mdi mdi-lock text-muted fs-16 align-middle me-1"></i> <span class="align-middle">화면 잠그기</span></a>
                            <a class="dropdown-item" href="/logout"><i class="mdi mdi-logout text-muted fs-16 align-middle me-1"></i> <span class="align-middle" data-key="t-logout">로그아웃</span></a>
                        </div>
                    </div>
                </div>
                </sec:authorize>
            </div>
        </div>
    </header>

    <!-- removeNotificationModal -->
    <div id="removeNotificationModal" class="modal fade zoomIn" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" id="NotificationModalbtn-close"></button>
                </div>
                <div class="modal-body">
                    <div class="mt-2 text-center">
                        <lord-icon src="https://cdn.lordicon.com/gsqxdxog.json" trigger="loop" colors="primary:#f7b84b,secondary:#f06548" style="width:100px;height:100px"></lord-icon>
                        <div class="mt-4 pt-2 fs-15 mx-4 mx-sm-5">
                            <h4>Are you sure ?</h4>
                            <p class="text-muted mx-4 mb-0">Are you sure you want to remove this Notification ?</p>
                        </div>
                    </div>
                    <div class="d-flex gap-2 justify-content-center mt-4 mb-2">
                        <button type="button" class="btn w-sm btn-light" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn w-sm btn-danger" id="delete-notification">Yes, Delete It!</button>
                    </div>
                </div>

            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <!-- ========== App Menu ========== -->
    <div class="app-menu navbar-menu">
        <!-- LOGO -->
        <div class="navbar-brand-box">
            <!-- Dark Logo-->
            <a href="/student/welcome" class="logo logo-dark">
                    <span class="logo-sm">
                        <img src="/assets/images/logo-sm.png" alt="" height="22">
                    </span>
                <span class="logo-lg">
                        <img src="/assets/images/logo-dark.png" alt="" height="17">
                    </span>
            </a>
            <!-- Light Logo-->
            <a href="/student/welcome" class="logo logo-light">
                    <span class="logo-sm">
                        <img src="/assets/images/logo-sm.png" alt="" height="22">
                    </span>
                <span class="logo-lg">
                        <img src="/assets/images/logo-light.png" alt="" height="17">
                    </span>
            </a>
            <button type="button" class="btn btn-sm p-0 fs-20 header-item float-end btn-vertical-sm-hover" id="vertical-hover">
                <i class="ri-record-circle-line"></i>
            </button>
        </div>

        <sec:authorize access="hasRole('ROLE_STUDENT')">
        <div id="scrollbar">
            <div class="container-fluid">
                <div id="two-column-menu">
                </div>
                <ul class="navbar-nav" id="navbar-nav">
                    <li class="menu-title"><span data-key="">학사 행정</span></li>
                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarRegist" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarDashboards">
                            <i class="las la-compass"></i> <span data-key="">등록</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarRegist">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="dashboard-analytics.html" class="nav-link" data-key=""> 납부 </a>
                                </li>
                                <li class="nav-item">
                                    <a href="dashboard-crm.html" class="nav-link" data-key=""> 납부 내역 조회 </a>
                                </li>
                            </ul>
                        </div>
                    </li> <!-- end Dashboard Menu -->
                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarLecture" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarApps">
                            <i class="las la-book"></i> <span data-key="">수강</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarLecture">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/atnlc/submit" class="nav-link" data-key="">
                                        수강 신청
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="/atnlc/cart" class="nav-link" data-key="">
                                        장바구니
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="/atnlc/stdntLctreList" class="nav-link" data-key="">
                                        신청 내역 조회
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarGrade" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarLayouts">
                            <i class="las la-scroll"></i> <span data-key="">성적</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarGrade">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/stdnt/grade/main/All" class="nav-link" data-key="">학기별 성적</a>
                                </li>
                                <li class="nav-item">
                                    <a href="/stdnt/lecture/main/All" class="nav-link" data-key="">강의 평가</a>
                                </li>
                            </ul>
                        </div>
                    </li> <!-- end Dashboard Menu -->

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarEnrollment" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarAuth">
                            <i class="las la-id-card"></i> <span data-key="">학적</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarEnrollment">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/enrollment/status" class="nav-link" data-key="">
                                        학적 관리
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="/enrollment/change" class="nav-link" data-key="">
                                        휴학/복학 신청
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebargraduation" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarPages">
                            <i class="las la-graduation-cap"></i> <span data-key="">졸업</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebargraduation">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="pages-starter.html" class="nav-link" data-key=""> 졸업 현황 </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarcertificate" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarLanding">
                            <i class="las la-certificate"></i> <span data-key="">제증명 발급</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarcertificate">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="landing.html" class="nav-link" data-key="">발급</a>
                                </li>
                                <li class="nav-item">
                                    <a href="nft-landing.html" class="nav-link" data-key="">문서함</a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="menu-title"><span data-key="">학습</span></li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="ui-alerts.html" data-key="">
                            <i class="las la-university"></i> <span data-key="">학습 관리</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="/counsel/std">
                            <i class="las la-comments"></i> <span data-key="">상담</span>
                        </a>
                    </li>
                </ul>
            </div>
            <!-- Sidebar -->
        </div>
        </sec:authorize>

        <sec:authorize access="hasRole('ROLE_PROF')">
        <div id="scrollbar">
            <div class="container-fluid">
                <div id="two-column-menu">
                </div>
                <ul class="navbar-nav" id="navbar-nav">
                    <li class="menu-title"><span data-key="">학사 행정</span></li>
                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarLecture" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarDashboards">
                            <i class="las la-compass"></i> <span data-key="">강의</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarLecture">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="dashboard-analytics.html" class="nav-link" data-key=""> 나의 강의 </a>
                                </li>
                                <li class="nav-item">
                                    <a href="dashboard-crm.html" class="nav-link" data-key="">강의 계획서 제출</a>
                                </li>
                            </ul>
                        </div>
                    </li> <!-- end Dashboard Menu -->
                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarCounsel" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarDashboards">
                            <i class="las la-comments"></i> <span data-key="">상담</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarCounsel">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="dashboard-analytics.html" class="nav-link" data-key="">상담 요청</a>
                                </li>
                                <li class="nav-item">
                                    <a href="dashboard-crm.html" class="nav-link" data-key="">상담 관리</a>
                                </li>
                            </ul>
                        </div>
                    </li> <!-- end Dashboard Menu -->
                </ul>
            </div>
        </div>
        </sec:authorize>

        <div class="sidebar-background"></div>
    </div>
    <!-- Left Sidebar End -->
    <!-- Vertical Overlay-->
    <div class="vertical-overlay"></div>

    <!-- ============================================================== -->
    <!-- Start right Content here -->
    <!-- ============================================================== -->
    <div class="main-content">

        <div class="page-content">
            <div id="main-container" class="container-fluid">

                <%--<div id="wrapper">--%>
                <%--    <header class="header">--%>
                <%--        <div class="container-fluid d-flex justify-content-between align-items-center gap-3">--%>
                <%--            <div class="brand"><i class="bi bi-mortarboard-fill"></i> 스마트 LMS</div>--%>
                <%--            <div class="user-actions">--%>
                <%--                <i class="bi bi-bell p-2"></i>--%>
                <%--                <i class="bi bi-gear p-2"></i>--%>
                <%--                <i class="bi bi-person-circle p-2"></i>--%>
                <%--            </div>--%>
                <%--            <sec:authorize access="isAuthenticated()">--%>
                <%--                <a href="/logout"><button class="btn btn-outline-danger">로그아웃</button></a>--%>
                <%--            </sec:authorize>--%>
                <%--        </div>--%>

                <%--        <!-- ✅ CHANGED: 토스트 -->--%>
                <%--        <div id="toastContainer"></div>--%>
                <%--    </header>--%>

                <%--    <main class="d-flex">--%>
                <%--        <div id="sidebar" class="d-flex flex-column flex-shrink-0 p-3 bg-primary bg-gradient">--%>
                <%--            <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-body-emphasis text-decoration-none">--%>
                <%--                <svg class="bi pe-none me-2" width="40" height="32" aria-hidden="true"><use xlink:href="#bootstrap"></use></svg>--%>
                <%--                <span class="fs-4">Sidebar</span>--%>
                <%--            </a>--%>
                <%--            <hr>--%>
                <%--            <ul class="nav nav-pills flex-column mb-auto">--%>
                <%--                <li class="nav-item">--%>
                <%--                    <a href="#" class="nav-link active" aria-current="page">--%>
                <%--                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true"><use xlink:href="#home"></use></svg>--%>
                <%--                        Home--%>
                <%--                    </a>--%>
                <%--                </li>--%>
                <%--                <li>--%>
                <%--                    <a href="#" class="nav-link link-body-emphasis">--%>
                <%--                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true"><use xlink:href="#speedometer2"></use></svg>--%>
                <%--                        Dashboard--%>
                <%--                    </a>--%>
                <%--                </li>--%>
                <%--                <li>--%>
                <%--                    <a href="#" class="nav-link link-body-emphasis">--%>
                <%--                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true"><use xlink:href="#table"></use></svg>--%>
                <%--                        Orders--%>
                <%--                    </a>--%>
                <%--                </li>--%>
                <%--                <li>--%>
                <%--                    <a href="#" class="nav-link link-body-emphasis">--%>
                <%--                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true"><use xlink:href="#grid"></use></svg>--%>
                <%--                        Products--%>
                <%--                    </a>--%>
                <%--                </li>--%>
                <%--                <li>--%>
                <%--                    <a href="#" class="nav-link link-body-emphasis">--%>
                <%--                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true"><use xlink:href="#people-circle"></use></svg>--%>
                <%--                        Customers--%>
                <%--                    </a>--%>
                <%--                </li>--%>
                <%--            </ul>--%>
                <%--            <sec:authorize access="isAuthenticated()">--%>
                <%--                <hr>--%>
                <%--                <div class="dropdown">--%>
                <%--                    <a href="#" class="d-flex align-items-center link-body-emphasis text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">--%>
                <%--                        <img src="https://github.com/mdo.png" alt="" width="32" height="32" class="rounded-circle me-2">--%>
                <%--                        <strong><sec:authentication property="principal.username"/></strong>--%>
                <%--                    </a>--%>
                <%--                    <ul class="dropdown-menu text-small shadow">--%>
                <%--                        <li>--%>
                <%--                            <a class="dropdown-item" href="#">New project...</a>--%>
                <%--                        </li>--%>
                <%--                        <li>--%>
                <%--                            <a class="dropdown-item" href="#">Settings</a>--%>
                <%--                        </li>--%>
                <%--                        <li>--%>
                <%--                            <a class="dropdown-item" href="#">Profile</a>--%>
                <%--                        </li>--%>
                <%--                        <li>--%>
                <%--                            <hr class="dropdown-divider">--%>
                <%--                        </li>--%>
                <%--                        <li>--%>
                <%--                            <a class="dropdown-item" href="#">Sign out</a>--%>
                <%--                        </li>--%>
                <%--                    </ul>--%>
                <%--                </div>--%>
                <%--            </sec:authorize>--%>
                <%--        </div>--%>
                <%--        <div id="main-container" class="container-fluid">--%>




