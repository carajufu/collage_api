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

</head>
<body>
<script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function() {
        var STORAGE_KEY = "openSidebarMenu";
        var clearStoredMenuState = function () {
            localStorage.removeItem(STORAGE_KEY);
        };

        document.querySelectorAll(".nav-link.menu-link:not([data-bs-toggle='collapse'])")
            .forEach(function(link) {
                link.addEventListener("click", clearStoredMenuState);
            });

        document.querySelectorAll(".navbar-brand-box a.logo")
            .forEach(function(link) {
                link.addEventListener("click", clearStoredMenuState);
            });

        var logoutLink = document.querySelector("a[href='/logout']");
        if (logoutLink) {
            logoutLink.addEventListener("click", clearStoredMenuState);
        }

        document.querySelectorAll(".nav-link.menu-link[data-bs-toggle='collapse']")
            .forEach(function(link) {
                link.addEventListener("click", function() {
                    var target = link.getAttribute("href");
                    if(target && target.startsWith("#")) {
                        localStorage.setItem(STORAGE_KEY, target);
                    }
                });
            });

        var openId = localStorage.getItem(STORAGE_KEY);
        if(openId) {
            var collapse = document.querySelector(openId + ".collapse.menu-dropdown");
            var trigger = document.querySelector(".nav-link.menu-link[href='" + openId + "']");

            if(collapse) {
                collapse.classList.add("show");
            }
            if(trigger) {
                trigger.setAttribute("aria-expanded", "true");
            }
        }
    });
</script>
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
                        <button type="button" class="btn btn-icon btn-topbar btn-ghost-primary rounded-circle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <img id="header-lang-img" src="/assets/images/flags/kr.svg" alt="Header Language" height="20" class="rounded">
                        </button>
                        <div class="dropdown-menu dropdown-menu-end">

                            <a href="javascript:void(0);" class="dropdown-item notify-item language py-2" data-lang="kr" title="Korean">
                                <img src="/assets/images/flags/kr.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">한국어</span>
                            </a>

                            <a href="javascript:void(0);" class="dropdown-item notify-item language py-2" data-lang="en" title="English">
                                <img src="/assets/images/flags/us.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">English</span>
                            </a>

                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="sp" title="Spanish">
                                <img src="/assets/images/flags/spain.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">Española</span>
                            </a>

                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="gr" title="German">
                                <img src="/assets/images/flags/germany.svg" alt="user-image" class="me-2 rounded" height="18"> <span class="align-middle">Deutsche</span>
                            </a>

							<a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="jp" title="Japen">
                                <img src="/assets/images/flags/jp.svg" alt="user-image" class="me-2 rounded" height="18"> <span class="align-middle">日本語</span>
                            </a>

							<a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="vi" title="Vitenam">
                                <img src="/assets/images/flags/vi.svg" alt="user-image" class="me-2 rounded" height="18"> <span class="align-middle">Tiếng Việt</span>
                            </a>

							<a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="mn" title="Mongol">
                                <img src="/assets/images/flags/mn.svg" alt="user-image" class="me-2 rounded" height="18"> <span class="align-middle">Монгол хэл</span>
                            </a>

							<a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="ne" title="Nepal">
                                <img src="/assets/images/flags/ne.svg" alt="user-image" class="me-2 rounded" height="18"> <span class="align-middle">नेपाली</span>
                            </a>

                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="it" title="Italian">
                                <img src="/assets/images/flags/italy.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">Italiana</span>
                            </a>

                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="ru" title="Russian">
                                <img src="/assets/images/flags/russia.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">русский</span>
                            </a>

                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="ch" title="Chinese">
                                <img src="/assets/images/flags/china.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">中国人</span>
                            </a>

                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="fr" title="French">
                                <img src="/assets/images/flags/french.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">français</span>
                            </a>

                            <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="ar" title="Arabic">
                                <img src="/assets/images/flags/ae.svg" alt="user-image" class="me-2 rounded" height="18">
                                <span class="align-middle">Arabic</span>
                            </a>

                           <a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="km" title="Khmer">
							    <img src="/assets/images/flags/km.svg" alt="Cambodia flag" class="me-2 rounded" height="18">
							    <span class="align-middle">ភាសាខ្មែរ</span>
							</a>

							<a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="la" title="Lao">
							    <img src="/assets/images/flags/la.svg" alt="Laos flag" class="me-2 rounded" height="18">
							    <span class="align-middle">ລາວ</span>
							</a>

							<a href="javascript:void(0);" class="dropdown-item notify-item language" data-lang="th" title="Thai">
							    <img src="/assets/images/flags/th.svg" alt="Thailand flag" class="me-2 rounded" height="18">
							    <span class="align-middle">ไทย</span>
							</a>
                        </div>
                    </div>

                    <div class="ms-1 header-item d-none d-sm-flex">
                        <button type="button" class="btn btn-icon btn-topbar btn-ghost-primary rounded-circle light-dark-mode">
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
						                    <h6 class="m-0 fs-16 fw-semibold text-white" data-key="t-notification"> 알림함 </h6>
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
						                    <p class="text-muted mt-2" data-key="t-no-notification">새로운 알림이 없습니다.</p>
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
                            <h6 class="dropdown-header">${user.affiliation}</h6>
                            <h6 class="dropdown-header">${user.username}</h6>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="/stdnt/main/info"><i class="mdi mdi-account-circle text-muted fs-16 align-middle me-1"></i> <span class="align-middle" data-key="t-profile-info-edit">개인 정보 수정</span></a>
                            <a class="dropdown-item" href="apps-chat.html"><i class="mdi mdi-message-text-outline text-muted fs-16 align-middle me-1"></i> <span class="align-middle" data-key="t-message">메세지</span></a>
                            <a class="dropdown-item" href="apps-tasks-kanban.html"><i class="mdi mdi-calendar-check-outline text-muted fs-16 align-middle me-1"></i> <span class="align-middle" data-key="t-taskboard">Taskboard</span></a>
                            <a class="dropdown-item" href="pages-faqs.html"><i class="mdi mdi-lifebuoy text-muted fs-16 align-middle me-1"></i> <span class="align-middle" data-key="t-help">도움말</span></a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="/"><i class="mdi mdi-home text-muted fs-16 align-middle me-1"></i> <span class="align-middle" data-key="t-homepage">홈페이지</span></a>
                            <a class="dropdown-item" href="auth-lockscreen-basic.html"><i class="mdi mdi-lock text-muted fs-16 align-middle me-1"></i> <span class="align-middle" data-key="t-lock-screen-lock">화면 잠그기</span></a>
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

            </div></div></div><div class="app-menu navbar-menu">
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
                    <li class="menu-title"><span data-key="t-academic-info">학사 정보</span></li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarRegist" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarDashboards">
                            <i class="las la-compass"></i> <span data-key="t-registration">등록</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarRegist">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/payinfo/studentView/${user.username}" class="nav-link" data-key="t-payment-view">납부</a>
                                </li>
                                <li class="nav-item">
                                    <a href="/payinfo/stdnt/list" class="nav-link" data-key="t-payment-payment-log">납부내역</a>
                                </li>
                            </ul>
                        </div>
                    </li> <!-- end Dashboard Menu -->
                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarLecture" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarApps">
                            <i class="las la-book"></i> <span data-key="t-lecture-tab">수강</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarLecture">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/atnlc/submit" class="nav-link" data-key="t-apply-course">수강신청</a>
                                </li>
                                <li class="nav-item">
                                    <a href="/atnlc/cart" class="nav-link" data-key="t-cart-list">장바구니 강의</a>
                                </li>
                                <li class="nav-item">
                                    <a href="/atnlc/stdntLctreList" class="nav-link" data-key="t-applied-list">수강신청 내역</a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarGrade" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarLayouts">
                            <i class="las la-scroll"></i> <span data-key="t-grade">성적</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarGrade">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/stdnt/grade/main/All" class="nav-link" data-key="t-semester-grade">학기별 성적</a>
                                </li>
                                <li class="nav-item">
                                    <a href="/stdnt/lecture/main/All" class="nav-link" data-key="t-lecture-evaluation">강의 평가</a>
                                </li>
                            </ul>
                        </div>
                    </li> <!-- end Dashboard Menu -->

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarEnrollment" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarAuth">
                            <i class="las la-id-card"></i> <span data-key="t-enrollment-main">학적</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarEnrollment">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/enrollment/status" class="nav-link" data-key="t-enrollment-info">
                                        학적정보
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="/enrollment/change" class="nav-link" data-key="t-enrollment-change">
                                        휴학/복학 신청
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebargraduation" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarPages">
                            <i class="las la-graduation-cap"></i> <span data-key="t-graduation">졸업</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebargraduation">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/stdnt/gradu/main/All" class="nav-link" data-key="t-graduation-status"> 졸업 현황 </a>
                                </li>
                                <li class="nav-item">
                                    <a href="/compe/main" class="nav-link" data-key="t-selfInfo-helper"> 자기소개서 도우미 </a>
                                </li>
                                <li class="nav-item">
                                    <a href="/compe/detail" class="nav-link" data-key="t-selfInfo-list"> 자기소개서 목록 </a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarcertificate" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarLanding">
                            <i class="las la-certificate"></i> <span data-key="t-certificates">제증명 발급</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarcertificate">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/certificates/DocxForm" class="nav-link" data-key="t-issuance">발급</a>
                                </li>
                                <li class="nav-item">
                                    <a href="/certificates/DocxHistory" class="nav-link" data-key="t-document-box">발급 이력</a>
                                </li>
                            </ul>
                        </div>
                    </li>


                    <li class="menu-title"><span data-key="t-learning">학습</span></li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="/dashboard/student">
                            <i class="las la-university"></i> <span data-key="t-learning-management">학습 관리</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="/counsel/std">
                            <i class="las la-comments"></i> <span data-key="t-counseling">상담</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="/schedule/timetable">
                            <i class="las la-table"></i> <span data-key="t-timetable">시간표</span>
                        </a>
                    </li>

                    <li class="menu-title"><span data-key="t-campus-intro">학교 소개</span></li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="/schedule/calendar">
                            <i class="las la-calendar"></i> <span data-key="t-academic-schedule">학사일정</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="/info/campus/map">
                            <i class="las la-map-marked"></i> <span data-key="t-campus-map">캠퍼스맵</span>
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
                    <li class="menu-title"><span data-key="t-academic-info">학사 정보</span></li>
                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarLecture" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarDashboards">
                            <i class="las la-compass"></i> <span data-key="t-prof-lecture">강의</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarLecture">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/prof/lecture/list" class="nav-link" data-key="t-prof-my-lecture"> 나의 강의 </a>
                                </li>
                                <li class="nav-item">
                                    <a href="/prof/lecture/mng/list" class="nav-link" data-key="t-prof-syllabus">개설 강의 관리</a>
                                </li>
                                <li class="nav-item">
                                    <a href="/prof/lecture/main/All" class="nav-link" data-key="t-prof-lecture-evaluation">강의 평가</a>
                                </li>
                            </ul>
                        </div>
                    </li> <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarGrade" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarDashboards">
                            <i class="las la-scroll"></i> <span data-key="t-prof-grade">성적</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarGrade">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/prof/grade/main/All" class="nav-link" data-key="t-prof-grade-manage">성적 관리</a>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="#sidebarCounsel" data-bs-toggle="collapse" role="button" aria-expanded="false" aria-controls="sidebarDashboards">
                            <i class="las la-comments"></i> <span data-key="t-counseling">상담</span>
                        </a>
                        <div class="collapse menu-dropdown" id="sidebarCounsel">
                            <ul class="nav nav-sm flex-column">
                                <li class="nav-item">
                                    <a href="/counselprof/prof" class="nav-link" data-key="t-counseling-request">상담 요청</a>
                                </li>
                                <li class="nav-item">
                                    <a href="dashboard-crm.html" class="nav-link" data-key="t-counseling-management">상담 관리</a>
                                </li>
                            </ul>
                        </div>
                    </li> <!-- end Dashboard Menu -->

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="/schedule/calendar">
                            <i class="las la-calendar"></i> <span data-key="t-academic-calendar">학사일정</span>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link menu-link" href="/info/campus/map" data-key="">
                            <i class=" las la-map-marked"></i> <span data-key="t-campus-map">캠퍼스맵</span>
                        </a>
                    </li>
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




