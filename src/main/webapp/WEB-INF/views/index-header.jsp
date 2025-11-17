<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<header class="main-header">
    <div class="container d-flex align-items-center justify-content-between py-3">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand">
            <img src="${pageContext.request.contextPath}/images/logo/univ-logo-kor-vite-dark.svg"
                 alt="대덕대학교" style="height: 55px" />
        </a>

        <nav class="main-nav d-none d-md-flex">
            <ul class="nav">
                <!-- 단일 메뉴 -->
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/" class="nav-link active">홈</a>
                </li>

                <!-- 대학소개 드롭다운 -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle"
                       href="javascript:void(0);"
                       role="button"
                       data-bs-toggle="dropdown"
                       aria-expanded="false">
                        대학소개
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/about">대학개요</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/about/history">연혁</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/about/message">총장 인사말</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/about/campus-map">캠퍼스 안내</a></li>
                    </ul>
                </li>

                <!-- 학사안내 드롭다운 -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle"
                       href="javascript:void(0);"
                       role="button"
                       data-bs-toggle="dropdown"
                       aria-expanded="false">
                        학사안내
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/academics/calendar">학사일정</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/academics/major">전공·학과</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/academics/rule">학사 규정</a></li>
                    </ul>
                </li>

                <!-- 입학안내 드롭다운 -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle"
                       href="javascript:void(0);"
                       role="button"
                       data-bs-toggle="dropdown"
                       aria-expanded="false">
                        입학안내
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admission/undergraduate">학부 입학</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admission/graduate">대학원 입학</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admission/transfer">편입학</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admission/international">외국인·교환학생</a></li>
                    </ul>
                </li>

                <!-- 대학생활 드롭다운 -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle"
                       href="javascript:void(0);"
                       role="button"
                       data-bs-toggle="dropdown"
                       aria-expanded="false">
                        대학생활
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campus-life/scholarship">장학·등록</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campus-life/dormitory">기숙사</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/campus-life/club">동아리</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/library">도서관</a></li>
                    </ul>
                </li>

                <!-- 뉴스·공지 드롭다운 -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle"
                       href="javascript:void(0);"
                       role="button"
                       data-bs-toggle="dropdown"
                       aria-expanded="false">
                        뉴스·공지
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/news/notice">학사공지</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/news/univ">대학뉴스</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/news/press">보도자료</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/news/event">행사·이벤트</a></li>
                    </ul>
                </li>
            </ul>
        </nav>

        <!-- 우측 유틸 영역: 세션 보유 여부에 따라 분기 -->
        <div class="d-flex align-items-center gap-2 navbar-util">
            <!-- 세션 + acntVO 존재: 사용자 정보 + 로그아웃 + 학사포털 -->
            <c:choose>
                <c:when test="${not empty acntVO}">
                    <div class="d-none d-md-flex flex-column align-items-end me-2">
                        <span class="text-white-50 small">
                            <sec:authentication property="principal.username" /> 님
                        </span>
                        <span class="text-white-50 small">
                            <c:forEach var="auth" items="${acntVO.authorList}">
                                <c:out value="${auth.authorNm}" />&nbsp;
                            </c:forEach>
                        </span>
                    </div>

                    <sec:authorize access="isAuthenticated()">
                        <form action="${pageContext.request.contextPath}/logout"
                              method="post"
                              class="m-0">
                            <input type="hidden"
                                   name="${_csrf.parameterName}"
                                   value="${_csrf.token}" />
                            <button type="submit"
                                    class="btn btn-sm navbar-util-btn btn-outline-login">
                                로그아웃
                            </button>
                        </form>
                    </sec:authorize>

                    <a href="${pageContext.request.contextPath}/portal"
                       class="btn btn-sm navbar-util-btn btn-portal">
                        학사포털
                    </a>
                </c:when>

                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login"
                       class="btn btn-sm navbar-util-btn btn-outline-login">
                        로그인
                    </a>
                    <a href="${pageContext.request.contextPath}/signup"
                       class="btn btn-sm navbar-util-btn btn-outline-signup d-none d-lg-inline-flex">
                        회원가입
                    </a>
                    <a href="${pageContext.request.contextPath}/portal"
                       class="btn btn-sm navbar-util-btn btn-portal">
                        학사포털
                    </a>
                </c:otherwise>
            </c:choose> 
            <!-- 세션 + acntVO 존재: 끝 -->
        </div>
    </div>
</header>
