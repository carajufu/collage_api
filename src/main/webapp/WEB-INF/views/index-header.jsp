<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<style>
/* 우측 유틸 영역 전체 튜닝 */
.navbar-util {
    gap: 0.75rem; /* 버튼 사이 살짝 여유 */
}

/* 이름/역할 텍스트 키우기 */
.navbar-util .text-white-50.small {
    font-size: 0.90rem;     /* 기본 small(0.875rem)보다 한 단계 ↑ */
    color: rgba(255,255,255,0.9); /* 너무 흐리지 않게 */
    font-weight: 550;       /* 살짝 굵게 */
}

/* 로그아웃 / 학사포털 버튼 키우기 */
.navbar-util .btn.btn-sm {
    font-size: 0.9rem;          /* 글자 키움 */
    padding: 0.35rem 0.9rem;    /* 세로·가로 여유 */
    border-radius: 999px;       /* pill 형태 */
}

/* 사용자 드롭다운 영역 */
.nav-user-dropdown .nav-user-trigger {
    color: #ffffff;
    text-decoration: none;
}

.nav-user-dropdown .navbar-user-name {
    font-weight: 600;
    font-size: 0.95rem;
}

/* 드롭다운 카드 */
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

/* 학번 클릭 복사 영역 */
.nav-user-id-copy {
    cursor: pointer;
    text-decoration: underline;
    text-underline-offset: 2px;
}
</style>
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
                        <li><a class="dropdown-item" href="/schedule/calendar">학사일정</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/schedule/major">전공·학과</a></li>
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
       <div class="d-flex align-items-center navbar-util">
            <!-- 로그인 상태 -->
            <sec:authorize access="isAuthenticated()">
                <div class="d-none d-md-flex flex-column align-items-end me-2">

                    <!-- 이름 + 인사말 + 드롭다운 트리거 -->
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
                                    <c:when test="${not empty acntVO.authorList}">
                                        <c:forEach var="auth" items="${acntVO.authorList}">
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

                        <!-- 드롭다운 카드: 학적 상태 / 학과 / 학번 클릭 복사 + 메뉴 -->
                        <div class="dropdown-menu dropdown-menu-end nav-user-menu shadow-sm"
                             aria-labelledby="navUserDropdown">
                            <!-- 상단: 이름 + (로그아웃 버튼은 오른쪽에 두고 싶으면 여기로 이동 가능) -->
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

                            <!-- 정보 라인 -->
                            <dl class="mb-2 small">
                                <div class="d-flex">
                                    <dt class="text-white-50">학적 상태</dt>
                                    <dd>
                                        <c:out value="${acntVO.userSttusNm}" />
                                    </dd>
                                </div>
                                <div class="d-flex">
                                    <dt class="text-white-50">소속 학과</dt>
                                    <dd>
                                        <c:out value="${acntVO.userSubjctNm}" />
                                    </dd>
                                </div>
                                <div class="d-flex">
                                    <dt class="text-white-50">학번</dt>
                                    <dd>
                                        <span class="nav-user-id-copy"
                                              data-copy-text="${acntVO.userNo}">
                                            <c:out value="${acntVO.userNo}" /> (복사)
                                        </span>
                                    </dd>
                                </div>
                            </dl>

                            <!-- 하단 메뉴 -->
                            <div class="border-top pt-2 mt-2 d-flex gap-2">
                                <a href="#" class="btn btn-sm btn-light flex-fill">
                                    개인정보관리
                                </a>
                                <a href="#" class="btn btn-sm btn-outline-light flex-fill">
                                    비밀번호관리
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 로그아웃 / 학사포털 버튼 (기존 유지) -->
                <form action="${pageContext.request.contextPath}/logout"
                      method="post"
                      class="m-0 ms-2">
                    <input type="hidden"
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}" />
                    <button type="submit"
                            class="btn btn-sm navbar-util-btn btn-outline-login">
                        로그아웃
                    </button>
                </form>

                <a href="${pageContext.request.contextPath}/portal"
                   class="btn btn-sm navbar-util-btn btn-portal ms-1">
                    학사포털
                </a>
            </sec:authorize>

            <!-- 비로그인 상태 -->
            <sec:authorize access="isAnonymous()">
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
            </sec:authorize>
        </div>
    </div>
</header>

<script>
/**
 * 학번(또는 교번) 클릭 시 클립보드 복사
 * - data-copy-text 속성 우선 사용, 없으면 텍스트 노드 기준
 */
document.addEventListener('DOMContentLoaded', function () {
    document.addEventListener('click', function (e) {
        var target = e.target.closest('[data-copy-text]');
        if (!target) return;

        var text = target.getAttribute('data-copy-text') || target.textContent.trim();
        if (!text) return;

        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(text);
        } else {
            var ta = document.createElement('textarea');
            ta.value = text;
            document.body.appendChild(ta);
            ta.select();
            document.execCommand('copy');
            document.body.removeChild(ta);
        }
    });
});
</script>