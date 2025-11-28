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

    <!-- velzon layout config -->
    <script src="${cPath}/assets/js/layout.js"></script>

    <!-- velzon CSS stack -->
    <link href="${cPath}/assets/css/bootstrap.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/icons.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/app.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/custom.min.css" rel="stylesheet" />
    <link href="${cPath}/assets/css/app.css" rel="stylesheet" />
    
    <style>
        /* ====== HEADER / NAVBAR 튜닝 ====== */
        .navbar-util {
            gap: 0.75rem;
        }
        .navbar-util .text-white-50.small {
            font-size: 0.90rem;
            color: rgba(255,255,255,0.9);
            font-weight: 550;
        }
        .navbar-util .btn.btn-sm {
            font-size: 0.9rem;
            padding: 0.35rem 0.9rem;
            border-radius: 999px;
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

        /* ====== HERO 섹션 (velzon card 배경) ====== */
        .hero-card .hero-section {
            position: relative;
            min-height: 260px;
            color: #fff;
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

        /* how-it-works 섹션 카드 */
        .how-card .how-steps .border {
            border-style: dashed !important;
        }
        
        /* 헤더 기본 상태: 약간만 투명 + 블러 */
		.navbar-landing.main-header {
		    background-color: rgba(5, 11, 24, 0.06); /* 처음엔 살짝 비침 */
		    backdrop-filter: blur(7px);
		    -webkit-backdrop-filter: blur(7px);
		    transition:
		        background-color 0.35s ease,
		        box-shadow 0.35s ease;
		}
		/* ===== HERO 텍스트 공통 색/그림자 고정 ===== */
		.hero-section {
		    position: relative;
		    color: #f9fafb; /* 항상 거의 흰색으로 고정 */
		}
		
		.hero-section .hero-kicker,
		.hero-section .hero-title,
		.hero-section .hero-desc {
		    color: #f9fafb;
		    text-shadow: 0 2px 8px rgba(0, 0, 0, 0.75); /* 밝은 배경에서도 윤곽 유지 */
		}
		/* GNB 텍스트 색상 강제 흰색 */
		.navbar-landing .navbar-nav .nav-link {
		    color: #ffffff !important;
		}
		
		/* hover/active 시 살짝 강조 */
		.navbar-landing .navbar-nav .nav-link:hover,
		.navbar-landing .navbar-nav .nav-link:focus {
		    color: #e5e7eb !important; /* 연한 흰색 */
		}
		
		.navbar-landing .navbar-nav .nav-link.active {
		    color: #ffffff !important;
		    font-weight: 600;
		}
		
		/* 드롭다운 기본 caret(위 삼각형) 숨김, 너무 구림 */
		.navbar-landing .navbar-nav .nav-link.dropdown-toggle::after {
		    display: none !important;
		}
		
		/* 드롭다운 꺾쇠(ri-arrow-down-s-line) 크기 살짝 확대 */
		.navbar-landing .navbar-nav .nav-link .ri-arrow-down-s-line {
		    font-size: 2rem; /* 기존 13px보다 약간 크게 */
		}
		/* 드롭다운 하단 버튼(개인정보관리 / 비밀번호관리) 폰트·패딩 축소 */
		.nav-user-menu .border-top .btn.btn-sm {
		    font-size: 0.8rem;       /* 글자 크기 조금 줄임 */
		    padding: 0.30rem 0.5rem;  /* 세로/가로 패딩 축소 */
		    white-space: nowrap;      /* 줄바꿈 방지 */
		}
		/* 회원가입 버튼 글자색 검정으로 고정 */
		.navbar-util-btn.btn-soft-light {
		    color: #000 !important;
		}
		
		/* 호버 시에도 검정 유지 */
		.navbar-util-btn.btn-soft-light:hover,
		.navbar-util-btn.btn-soft-light:focus {
		    color: #000 !important;
		}
		/* 회원가입: 옅은 배경 버튼 */
		.btn-outline-signup {
		    border: 1.1px solid transparent;
		    background-color: rgba(248, 250, 252, 0.12);
		    color: #f9fafb;
		}
    </style>
</head>

<body data-layout="vertical" data-topbar="light" data-sidebar="light">

<div id="layout-wrapper">

    <!-- ================= HEADER (velzon landing navbar) ================ -->
    <nav class="navbar navbar-expand-lg navbar-landing fixed-top main-header" id="navbar">
        <div class="container-fluid custom-container">
            <!-- 로고 -->
            <a class="navbar-brand me-3" href="/">
                <img src="${cPath}/images/logo/univ-logo-kor-vite-dark.svg"
                     alt="대덕대학교" height="55"
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

            <!-- 메뉴 + 우측 유틸 -->
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <!-- GNB -->
                <ul class="navbar-nav mx-auto mt-3 mt-lg-0">
                    <li class="nav-item">
                        <a href="/" class="nav-link active">홈</a>
                    </li>
    				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <!-- 간격 조율 -->
                    <!-- 대학소개 -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="javascript:void(0);"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            대학소개
                            <i class="ri-arrow-down-s-line align-middle ms-1 fs-13"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">대학개요</a></li>
                            <li><a class="dropdown-item" href="#">연혁</a></li>
                            <li><a class="dropdown-item" href="#">총장 인사말</a></li>
                            <li><a class="dropdown-item" href="#">캠퍼스 안내</a></li>
                        </ul>
                    </li>

                    <!-- 학사안내 -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="javascript:void(0);"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            학사안내
                            <i class="ri-arrow-down-s-line align-middle ms-1 fs-13"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="/schedule/calendar">학사일정</a></li>
                            <li><a class="dropdown-item" href="#">전공·학과</a></li>
                            <li><a class="dropdown-item" href="#">학사 규정</a></li>
                        </ul>
                    </li>

                    <!-- 입학안내 -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="javascript:void(0);"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            입학안내
                            <i class="ri-arrow-down-s-line align-middle ms-1 fs-13"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">학부 입학</a></li>
                            <li><a class="dropdown-item" href="#">대학원 입학</a></li>
                            <li><a class="dropdown-item" href="#">편입학</a></li>
                            <li><a class="dropdown-item" href="#">외국인·교환학생</a></li>
                        </ul>
                    </li>

                    <!-- 대학생활 -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="javascript:void(0);"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            대학생활
                            <i class="ri-arrow-down-s-line align-middle ms-1 fs-13"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">장학·등록</a></li>
                            <li><a class="dropdown-item" href="#">기숙사</a></li>
                            <li><a class="dropdown-item" href="#">동아리</a></li>
                            <li><a class="dropdown-item" href="#">도서관</a></li>
                        </ul>
                    </li>

                    <!-- 뉴스·공지 -->
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                           href="javascript:void(0);"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            뉴스 · 공지
                            <i class="ri-arrow-down-s-line align-middle ms-1 fs-13"></i>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="#">학사공지</a></li>
                            <li><a class="dropdown-item" href="#">대학뉴스</a></li>
                            <li><a class="dropdown-item" href="#">보도자료</a></li>
                            <li><a class="dropdown-item" href="#">행사·이벤트</a></li>
                        </ul>
                    </li>
                </ul>

                <!-- 우측 유틸 -->
                <div class="d-flex align-items-center navbar-util mt-3 mt-lg-0">

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

								<!-- 드롭다운 카드 -->
								<div class="dropdown-menu dropdown-menu-end nav-user-menu shadow-sm"
								     aria-labelledby="navUserDropdown">
								
								    <%
								        // 상단 이름/소속 영역은 공통
								    %>
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
								
								    <%-- 1. ROLE_PROF 여부 플래그 한 번만 계산 --%>
								    <c:set var="isProf" value="false" />
								    <c:if test="${not empty acntVO.authorVOList}">
								        <c:forEach var="auth" items="${acntVO.authorVOList}">
								            <c:if test="${auth.authorNm == 'ROLE_PROF'}">
								                <c:set var="isProf" value="true" />
								            </c:if>
								        </c:forEach>
								    </c:if>
								
								    <dl class="mb-3 small">
								
								        <%-- 2. 학적 상태 / 재직 상태 라벨 통일 처리 --%>
								        <div class="d-flex">
								            <dt class="text-white-50">
								                <c:choose>
								                    <c:when test="${isProf}">
								                        재직 상태
								                    </c:when>
								                    <c:otherwise>
								                        학적 상태
								                    </c:otherwise>
								                </c:choose>
								            </dt>
								            <dd>
								                <c:out value="${acntVO.userSttusNm}" />
								            </dd>
								        </div>
								
								        <%-- 3. 소속 학과 (학생/교수 공통) --%>
								        <div class="d-flex">
								            <dt class="text-white-50">소속 학과</dt>
								            <dd><c:out value="${acntVO.userSubjctNm}" /></dd>
								        </div>
								
								        <%-- 4. 학번 / 교번 라벨 통일 처리 --%>
								        <div class="d-flex">
								            <dt class="text-white-50">
								                <c:choose>
								                    <c:when test="${isProf}">
								                        교번
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
                              class="m-0 ms-2">
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
                           class="btn btn-sm navbar-util-btn btn-warning ms-1">
                            학사포털
                        </a>
                        </sec:authorize>
                        <sec:authorize access="hasRole('ROLE_PROF')">
                        <a href="/dashboard/prof"
                           class="btn btn-sm navbar-util-btn btn-warning ms-1">
                            학사포털
                        </a>
                        </sec:authorize>
                        <sec:authorize access="hasRole('ROLE_ADMIN')">
                        <a href="http://localhost:5173"
                           class="btn btn-sm navbar-util-btn btn-warning ms-1">
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
document.addEventListener("scroll", function () {
	  var header = document.getElementById("navbar");
	  if (!header) return;

	  var maxScroll = 280;
	  var y = window.scrollY || window.pageYOffset || 0;
	  var t = y / maxScroll;
	  if (t < 0) t = 0;
	  if (t > 1) t = 1;

	  var minAlpha = 0.15;
	  var maxAlpha = 0.95;   // 거의 불투명
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