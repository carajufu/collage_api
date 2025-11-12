<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>스마트 LMS</title>

    <!-- 기본 폰트 / Bootstrap / Icons -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/pretendard/dist/web/static/pretendard.css" />
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            type="text/javascript"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>

    <!-- 추가 공통 CSS 있으면 여기에 -->
    <link rel="stylesheet" href="<c:url value='/css/header-main.css'/>">

    <style>
        body {
            margin: 0;
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background-color: #f5f5f5;
        }

        #wrapper {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* 상단 헤더 */
        .top-header {
            background-color: #ffffff;
            border-bottom: 1px solid #dee2e6;
        }

        /* 레이아웃: 사이드바 + 컨텐츠 */
        .layout {
            flex: 1 0 auto;
            display: flex;
            min-height: 0;
        }

        #sidebar {
            width: 220px;
            flex: 0 0 220px;
            padding: 24px 16px;
            background: #0d6efd;
            color: #ffffff;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        #sidebar a {
            color: #ffffff;
            text-decoration: none;
            font-size: 14px;
            padding: 6px 8px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        #sidebar a.active,
        #sidebar a:hover {
            background-color: rgba(255, 255, 255, 0.15);
        }

        /* 실제 페이지가 그려질 영역 */
        #content {
            flex: 1 1 auto;
            padding: 24px 32px;
            background-color: #ffffff;
            overflow: auto;
        }
    </style>
</head>

<body>
<div id="wrapper">

    <!-- 상단 헤더 -->
    <header class="top-header">
        <div class="container-fluid d-flex justify-content-between align-items-center py-2 px-3">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-mortarboard-fill"></i>
                <span class="fw-semibold">스마트 LMS</span>
            </div>

            <div class="d-flex align-items-center gap-3">
                <i class="bi bi-bell"></i>
                <i class="bi bi-gear"></i>
                <sec:authorize access="isAuthenticated()">
                    <span class="d-inline-flex align-items-center gap-2">
                        <i class="bi bi-person-circle"></i>
                        <strong><sec:authentication property="principal.username"/></strong>
                    </span>
                </sec:authorize>
            </div>
        </div>
    </header>

    <!-- 메인 레이아웃: 사이드바 + 컨텐츠 -->
    <div class="layout">

        <!-- 공통 사이드바 -->
        <nav id="sidebar">
            <div class="mb-3 d-flex align-items-center gap-2">
                <i class="bi bi-list-task"></i>
                <span class="fw-semibold">Sidebar</span>
            </div>

            <!-- 필요한 링크로 교체 -->
            <a href="<c:url value='/'/>" class="active">
                <i class="bi bi-house-fill"></i> 사이드바_1
            </a>
            <a href="#">
                <i class="bi bi-speedometer2"></i> 사이드바_2
            </a>
            <a href="#">
                <i class="bi bi-file-earmark-text"></i> 사이드바_3
            </a>
            <a href="#">
                <i class="bi bi-clock-history"></i> 사이드바_4
            </a>

            <sec:authorize access="isAuthenticated()">
                <div class="mt-auto pt-3 border-top border-light-subtle small">
                    <div class="mb-1 text-light">로그인 사용자</div>
                    <div class="d-flex align-items-center gap-2">
                        <img src="https://github.com/mdo.png"
                             alt="" width="24" height="24" class="rounded-circle">
                        <strong><sec:authentication property="principal.username"/></strong>
                    </div>
                </div>
            </sec:authorize>
        </nav>

        <!-- 여기부터 각 JSP 화면 내용 -->
        <main id="content">
