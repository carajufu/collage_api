<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<c:set var="cPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <title>대덕대학교 메인 포털</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- 메인 index-header 전용 아이콘 -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" />

    <!-- velzon layout config -->
    <script src="${cPath}/assets/js/layout.js"></script>

    <!-- velzon CSS stack -->
    <link href="${cPath}/assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/icons.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/app.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/custom.min.css" rel="stylesheet" />

    <style>
        /* =========================================================
           HEADER / NAVBAR 공통 스타일
           - 좌측: 로고
           - 중앙: GNB 메뉴 (화면 기준 정중앙, 로그인 여부 무관)
           - 우측: 로그인 / 사용자 정보 / 학사포털 버튼
           ========================================================= */

        /* 상단 헤더 기본 상태: 약간 투명 + 블러 */
        .navbar-landing.main-header {
            background-color: rgba(5, 11, 24, 0.06);
            backdrop-filter: blur(7px);
            -webkit-backdrop-filter: blur(7px);
            transition:
                background-color 0.35s ease,
                box-shadow 0.35s ease;
        }

        /* 헤더 내부 레이아웃 컨테이너 */
        .dd-main-header-container {
            position: relative;          /* GNB 절대 중앙 배치를 위한 기준 */
            padding-inline: 2.5rem;
        }

        /* 로고 */
        .dd-main-header-logo {
            display: flex;
            align-items: center;
        }
        .dd-main-header-logo img {
            height: 75px;
        }

        /* GNB 공통 폰트/색상 */
        .main-header .nav-link {
            font-size: 1rem;
        }
        .navbar-landing .navbar-nav .nav-link {
            color: #ffffff !important;
        }
        .navbar-landing .navbar-nav .nav-link:hover,
        .navbar-landing .navbar-nav .nav-link:focus {
            color: #e5e7eb !important;
        }
        .navbar-landing .navbar-nav .nav-link.active {
            color: #ffffff !important;
            font-weight: 600;
        }

        /* 드롭다운 기본 caret(위 삼각형) 숨김 */
        .navbar-landing .navbar-nav .nav-link.dropdown-toggle::after {
            display: none !important;
        }
        /* 드롭다운 꺾쇠(ri-arrow-down-s-line) 아이콘 크기 */
        .navbar-landing .navbar-nav .nav-link .ri-arrow-down-s-line {
            font-size: 1.1rem;
        }

        /* ====== 중앙 GNB: 로그인 전/후 동일하게 "화면 기준" 센터 고정 ====== */
        .navbar-nav.dd-main-gnb {
            flex-direction: row;
            gap: 2.8rem;               /* 메뉴 간 간격 */
        }

        .dd-navbar-collapse {
            /* GNB는 absolute로 중앙, collapse 내부 flex는 우측 유틸을 오른쪽 끝으로 */
            justify-content: flex-end;
        }

        @media (min-width: 992px) {
            .navbar-nav.dd-main-gnb {
                position: absolute;
                left: 50%;
                top: 50%;
                transform: translate(-50%, -50%);
            }
        }

        @media (max-width: 991.98px) {
            /* 모바일/태블릿에선 기본 부트스트랩 접힘 레이아웃 사용 */
            .dd-main-header-container {
                padding-inline: 1.25rem;
            }
            .navbar-nav.dd-main-gnb {
                position: static;
                transform: none;
                width: 100%;
                padding-top: 0.75rem;
            }
            .dd-navbar-collapse {
                align-items: flex-start;
            }
            .navbar-util {
                width: 100%;
                margin-top: 0.75rem;
                justify-content: flex-start;
            }
        }

        /* 우측 유틸(로그인/사용자/학사포털) */
        .navbar-util {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-left: auto;  /* 항상 가장 오른쪽으로 밀기 */
        }
        .navbar-util .btn.btn-sm {
            font-size: 0.9rem;
            padding: 0.35rem 0.9rem;
            border-radius: 999px;
            white-space: nowrap;
        }
        .navbar-util .navbar-util-btn + .navbar-util-btn {
            margin-left: 0.35rem;
        }

        .navbar-util .text-white-50.small {
            font-size: 0.90rem;
            color: rgba(255,255,255,0.9);
            font-weight: 550;
        }

        .nav-user-dropdown .nav-user-trigger {
            color: #ffffff;
            text-decoration: none;
        }
        .nav-user-dropdown .navbar-user-name {
            font-weight: 600;
            font-size: 0.95rem;
        }

        .nav-user-menu {
            min-width: 260px;
            padding: 0.85rem 1rem;
            border-radius: 0.9rem;
            background: rgba(10, 18, 40, 0.98);
            color: #ffffff;
        }
        .nav-user-menu dt {
            width: 80px;
            font-weight: 500;
        }
        .nav-user-menu dd {
            margin-bottom: 0.15rem;
        }
        .nav-user-id-copy {
            cursor: pointer;
            text-decoration: underline;
            text-underline-offset: 2px;
        }
        .nav-user-menu .border-top .btn.btn-sm {
            font-size: 0.8rem;
            padding: 0.30rem 0.5rem;
            white-space: nowrap;
        }

        /* 회원가입/라이트 버튼 글자색 유지용 (필요 시) */
        .navbar-util-btn.btn-soft-light {
            color: #000 !important;
        }
        .navbar-util-btn.btn-soft-light:hover,
        .navbar-util-btn.btn-soft-light:focus {
            color: #000 !important;
        }

        /* ===== HERO 텍스트 공통 색/그림자 ===== */
        .hero-section {
            position: relative;
            color: #f9fafb;
        }
        .hero-section .hero-kicker,
        .hero-section .hero-title,
        .hero-section .hero-desc {
            color: #f9fafb;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.75);
        }

        /* 옵션: hero / how-it-works 영역 그대로 유지 */
        .hero-card .hero-section {
            min-height: 260px;
            background-size: cover;
            background-position: center center;
            background-repeat: no-repeat;
            transition: background-image 0.8s ease-in-out;
        }
        .hero-search-wrap .form-control {
            max-width: 360px;
        }
        .hero-visual {
            background: rgba(15,23,42,0.35);
            border-radius: 1rem;
        }
        .how-card .how-steps .border {
            border-style: dashed !important;
        }
        
        /*  헤더 폭 조절 */
		.navbar-landing .navbar-nav .nav-item .nav-link {
		    font-size: 15px !important;
		    padding: 0px;
		}
		.container, .container-fluid, .container-lg, .container-md, .container-sm, .container-xl, .container-xxl {
		    --bs-gutter-x: 1.0rem !important;
		    --bs-gutter-y: 0;
		    width: 100%;
		    padding-right: calc(var(--bs-gutter-x) * 2) !important;
		    padding-left: calc(var(--bs-gutter-x) * 4) !important;
		}
		
		/* ===========================
	   헤더 유저 드롭다운 카드 정리
	   - 배경: 다크 네이비, 흰 글자
	   - 그림자/모서리/여백 통일
	   =========================== */
		.nav-user-menu {
		    min-width: 250px !important;
		    padding: 1.2rem 1.2rem !important;
		    border-radius: 0.9rem;
		    border: 0;
		    background: rgba(15, 23, 42, 0.96) !important;  /* 카드 배경 고정 */
		    color: #f9fafb !important;
		    box-shadow: 0 18px 45px rgba(15, 23, 42, 0.55);
		    margin-top: 0.80rem;  /* 헤더랑 살짝 띄워줌 */
		}
		
		/* 제목/텍스트 정렬 */
		.nav-user-menu .fw-semibold {
		    font-size: 0.98rem;
		    margin-bottom: 0.15rem;
		}
		
		.nav-user-menu .small,
		.nav-user-menu dt,
		.nav-user-menu dd {
		    color: #e5e7eb;
		}
		
		/* 정의 리스트 레이아웃 */
		.nav-user-menu dl {
		    margin-bottom: 0.75rem;
		}
		
		.nav-user-menu dl > div {
		    margin-bottom: 0.15rem;
		}
		
		.nav-user-menu dt {
		    width: 80px;
		    font-weight: 500;
		    flex-shrink: 0;
		}
		
		/* 학번(교번) 복사 링크 */
		.nav-user-id-copy {
		    cursor: pointer;
		    text-decoration: underline;
		    text-underline-offset: 2px;
		    color: #facc15;   /* 노란색 포인트 */
		}
		
		/* 하단 버튼 영역 */
		.nav-user-menu .border-top {
		    border-color: rgba(148, 163, 184, 0.5) !important;
		}
		
		/* 두 버튼 공통: 글자/패딩 축소 */
		.nav-user-menu .border-top .btn.btn-sm {
		    font-size: 0.8rem;
		    padding: 0.3rem 0.5rem;
		    white-space: nowrap;
		}
		
		/* 왼쪽: 밝은 버튼 */
		.nav-user-menu .btn-light {
		    background-color: #f9fafb;
		    border-color: transparent;
		    color: #111827;
		}
		
		/* 오른쪽: 아웃라인 버튼도 글자 보이게 */
		.nav-user-menu .btn-outline-light {
		    border-color: rgba(156, 163, 175, 0.9);
		    color: #e5e7eb;
		}
		
		.nav-user-menu .btn-outline-light:hover {
		    background-color: rgba(156, 163, 175, 0.15);
		}
			
    </style>
</head>

<body data-layout="vertical" data-topbar="light" data-sidebar="light">

<div id="layout-wrapper">
    <!-- ================= HEADER (velzon landing navbar) ================ -->
    <nav class="navbar navbar-expand-lg navbar-landing fixed-top main-header" id="navbar">
        <div class="container-fluid dd-main-header-container">

            <!-- 좌측 로고 -->
            <a class="navbar-brand dd-main-header-logo" href="${cPath}/">
                <img src="${cPath}/img/logo/univ-logo-kor-vite-dark.png"
                     alt="대덕대학교"
                     class="card-logo card-logo-dark" />
            </a>

            <!-- 모바일 토글 -->
            <button class="navbar-toggler py-0 fs-20 text-body"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="#navbarSupportedContent"
                    aria-controls="navbarSupportedContent"
                    aria-expanded="false"
                    aria-label="Toggle navigation">
                <i class="mdi mdi-menu"></i>
            </button>

            <!-- 중앙 GNB + 우측 유틸 -->
            <div class="collapse navbar-collapse dd-navbar-collapse" id="navbarSupportedContent">

                <!-- 중앙 GNB -->
                <ul class="navbar-nav dd-main-gnb mt-3 mt-lg-0">
                    <li class="nav-item">
                        <a href="${cPath}/" class="nav-link active">홈</a>
                    </li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="javascript:void(0);"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            대학소개
                            <i class="ri-arrow-down-s-line align-middle ms-1"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${cPath}/about">대학개요</a></li>
                            <li><a class="dropdown-item" href="${cPath}/about/history">연혁</a></li>
                            <li><a class="dropdown-item" href="${cPath}/about/message">총장 인사말</a></li>
                            <li><a class="dropdown-item" href="${cPath}/about/campus-map">캠퍼스 안내</a></li>
                        </ul>
                    </li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="javascript:void(0);"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            학사안내
                            <i class="ri-arrow-down-s-line align-middle ms-1"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${cPath}/schedule/calendar">학사일정</a></li>
                            <li><a class="dropdown-item" href="${cPath}/schedule/major">전공·학과</a></li>
                            <li><a class="dropdown-item" href="${cPath}/academics/rule">학사 규정</a></li>
                        </ul>
                    </li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="javascript:void(0);"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            입학안내
                            <i class="ri-arrow-down-s-line align-middle ms-1"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${cPath}/admission/undergraduate">학부 입학</a></li>
                            <li><a class="dropdown-item" href="${cPath}/admission/graduate">대학원 입학</a></li>
                            <li><a class="dropdown-item" href="${cPath}/admission/transfer">편입학</a></li>
                            <li><a class="dropdown-item" href="${cPath}/admission/international">외국인·교환학생</a></li>
                        </ul>
                    </li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="javascript:void(0);"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            대학생활
                            <i class="ri-arrow-down-s-line align-middle ms-1"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${cPath}/campus-life/scholarship">장학·등록</a></li>
                            <li><a class="dropdown-item" href="${cPath}/campus-life/dormitory">기숙사</a></li>
                            <li><a class="dropdown-item" href="${cPath}/campus-life/club">동아리</a></li>
                            <li><a class="dropdown-item" href="${cPath}/library">도서관</a></li>
                        </ul>
                    </li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="javascript:void(0);"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            뉴스 · 공지
                            <i class="ri-arrow-down-s-line align-middle ms-1"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${cPath}/news/notice">학사공지</a></li>
                            <li><a class="dropdown-item" href="${cPath}/news/univ">대학뉴스</a></li>
                            <li><a class="dropdown-item" href="${cPath}/news/press">보도자료</a></li>
                            <li><a class="dropdown-item" href="${cPath}/news/event">행사·이벤트</a></li>
                        </ul>
                    </li>
                </ul>

                <!-- 우측 유틸 -->
                <div class="navbar-util mt-3 mt-lg-0">

                    <!-- 로그인 상태 -->
                    <sec:authorize access="isAuthenticated()">
                        <div class="d-none d-md-flex flex-column align-items-end me-2">
                            <div class="dropdown nav-user-dropdown text-end">
                                <button class="btn btn-link p-0 nav-user-trigger"
                                        type="button"
                                        id="navUserDropdown"
                                        data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                    <span class="navbar-user-name">
                                        <c:out value="${empty acntVO.user_nm ? '사용자' : acntVO.user_nm}" />
                                    </span>
                                    <span class="text-white-50 small ms-1">
                                        <c:choose>
                                            <c:when test="${not empty acntVO.authorVOList}">
                                                <c:forEach var="auth" items="${acntVO.authorVOList}">
                                                    <c:choose>
                                                        <c:when test="${auth.authorNm == 'ROLE_STUDENT'}">
                                                            학우님 반갑습니다.
                                                        </c:when>
                                                        <c:when test="${auth.authorNm == 'ROLE_PROF'}">
                                                            교수님 반갑습니다.
                                                        </c:when>
                                                        <c:when test="${auth.authorNm == 'ROLE_ADMIN'}">
                                                            관리자님 반갑습니다.
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${auth.authorNm}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                반갑습니다.
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </button>

                                <!-- 사용자 정보 드롭다운 카드 -->
                                <div class="dropdown-menu dropdown-menu-end nav-user-menu shadow-sm"
                                     aria-labelledby="navUserDropdown">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div>
                                            <div class="fw-semibold">
                                                <c:out value="${acntVO.user_nm}" /> 님
                                            </div>
                                            <div class="small text-white-50">
                                                <c:out value="${acntVO.userSubjctNm}" />
                                            </div>
                                        </div>
                                    </div>

                                    <dl class="mb-3 small">
                                        <div class="d-flex">
                                            <dt class="text-white-50">학적 상태</dt>
                                            <dd><c:out value="${acntVO.userSttusNm}" /></dd>
                                        </div>
                                        <div class="d-flex">
                                            <dt class="text-white-50">소속 학과</dt>
                                            <dd><c:out value="${acntVO.userSubjctNm}" /></dd>
                                        </div>
                                        <div class="d-flex">
                                            <dt class="text-white-50">
                                                <c:choose>
                                                    <c:when test="${not empty acntVO.authorVOList}">
                                                        <c:set var="idLabel" value="학번" />
                                                        <c:forEach var="auth" items="${acntVO.authorVOList}">
                                                            <c:if test="${auth.authorNm == 'ROLE_PROF'}">
                                                                <c:set var="idLabel" value="교번" />
                                                            </c:if>
                                                        </c:forEach>
                                                        ${idLabel}
                                                    </c:when>
                                                    <c:otherwise>
                                                        학번
                                                    </c:otherwise>
                                                </c:choose>
                                            </dt>
                                            <dd>
                                                <span class="nav-user-id-copy"
                                                      data-copy-text="${acntVO.userNo}">
                                                    <c:out value="${acntVO.userNo}" /> (복사)
                                                </span>
                                            </dd>
                                        </div>
                                    </dl>

                                    <div class="border-top pt-3 mt-2 d-flex gap-1">
                                        <a href="#"
                                           class="btn btn-sm btn-light flex-fill">
                                            개인정보관리
                                        </a>
                                        <a href="#"
                                           class="btn btn-sm btn-outline-light flex-fill">
                                            비밀번호관리
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 로그아웃 / 학사포털 버튼 -->
                        <form action="/logout"
                              method="get"
                              class="m-0">
                            <input type="hidden"
                                   name="${_csrf.parameterName}"
                                   value="${_csrf.token}" />
                            <button type="submit"
                                    class="btn btn-sm navbar-util-btn btn-outline-login btn-outline-light">
                                로그아웃
                            </button>
                        </form>

                        <sec:authorize access="hasRole('ROLE_STUDENT')">
                            <a href="/dashboard/student"
                               class="btn btn-sm navbar-util-btn btn-warning">
                                학사포털
                            </a>
                        </sec:authorize>
                        <sec:authorize access="hasRole('ROLE_PROF')">
                            <a href="/dashboard/prof"
                               class="btn btn-sm navbar-util-btn btn-warning">
                                학사포털
                            </a>
                        </sec:authorize>
                        <sec:authorize access="hasRole('ROLE_ADMIN')">
                            <a href="http://localhost:5173"
                               class="btn btn-sm navbar-util-btn btn-warning">
                                학사포털
                            </a>
                        </sec:authorize>
                    </sec:authorize>

                    <!-- 비로그인 상태 -->
                    <sec:authorize access="isAnonymous()">
                        <a href="/login"
                           class="btn btn-sm navbar-util-btn btn-outline-light">
                            로그인
                        </a>
                    </sec:authorize>
                </div>
            </div>
        </div>
    </nav>

    <script>
        // 스크롤에 따라 헤더 불투명도/블러/그림자 조정
        document.addEventListener("scroll", function () {
            var header = document.getElementById("navbar");
            if (!header) return;

            var maxScroll = 270;
            var y = window.scrollY || window.pageYOffset || 0;
            var t = y / maxScroll;
            if (t < 0) t = 0;
            if (t > 1) t = 1;

            var minAlpha = 0.12;
            var maxAlpha = 0.98;   // 거의 불투명
            var alpha = minAlpha + (maxAlpha - minAlpha) * t;

            // footer와 동일 RGB로 통일
            header.style.backgroundColor = "rgba(39, 42, 58, " + alpha + ")";
            header.style.backdropFilter = "blur(" + (10 + 4 * t) + "px)";
            header.style.webkitBackdropFilter = "blur(" + (10 + 4 * t) + "px)";

            if (alpha > 0.4) {
                header.style.boxShadow = "0 10px 24px rgba(0, 0, 0, 0.55)";
            } else {
                header.style.boxShadow = "none";
            }
        });
    </script>

    <c:if test="${param.logout eq '1'}">
        <script>
            // 실제 로그아웃 성공 후 페이지가 로드됐을 때만 실행
            alert('로그아웃 되었습니다.');
        </script>
    </c:if>
