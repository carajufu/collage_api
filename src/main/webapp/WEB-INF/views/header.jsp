<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!doctype html>
<html lang="ko">
<head>
<link rel="shortcut icon" href="#">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Collage</title>

    <!-- 시스템 폰트 cdn 추가 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/pretendard/dist/web/static/pretendard.css"/>
    <!-- bootstrap5.css cdn 추가 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- bootstrap5 icon cdn 추가 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
    <!-- bootstrap5.js cdn 추가 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" type="text/javascript"></script>
    <!-- jquery cdn 추가 -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>

    <link rel="stylesheet" href="/css/main.css" />
</head>
<body>
<div id="wrapper">
    <header>
        <div class="topbar">
            <div class="brand"><i class="bi bi-mortarboard-fill"></i> 스마트 LMS</div>
            <div class="user-actions">
                <i class="bi bi-bell"></i>
                <i class="bi bi-gear"></i>
                <i class="bi bi-person-circle"></i>
            </div>
        </div>

        <!-- ✅ CHANGED: 토스트 -->
        <div id="toastContainer"></div>
    </header>

    <main class="d-flex">
        <div id="sidebar" class="d-flex flex-column flex-shrink-0 p-3 bg-primary bg-gradient">
            <a href="/" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-body-emphasis text-decoration-none">
                <svg class="bi pe-none me-2" width="40" height="32" aria-hidden="true"><use xlink:href="#bootstrap"></use></svg>
                <span class="fs-4">Sidebar</span>
            </a>
            <hr>
            <ul class="nav nav-pills flex-column mb-auto">
                <li class="nav-item">
                    <a href="#" class="nav-link active" aria-current="page">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true"><use xlink:href="#home"></use></svg>
                        Home
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link link-body-emphasis">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true"><use xlink:href="#speedometer2"></use></svg>
                        Dashboard
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link link-body-emphasis">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true"><use xlink:href="#table"></use></svg>
                        Orders
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link link-body-emphasis">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true"><use xlink:href="#grid"></use></svg>
                        Products
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link link-body-emphasis">
                        <svg class="bi pe-none me-2" width="16" height="16" aria-hidden="true"><use xlink:href="#people-circle"></use></svg>
                        Customers
                    </a>
                </li>
            </ul>
<%--            <hr>--%>
<%--            <div class="dropdown">--%>
<%--                <a href="#" class="d-flex align-items-center link-body-emphasis text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">--%>
<%--                    <img src="https://github.com/mdo.png" alt="" width="32" height="32" class="rounded-circle me-2">--%>
<%--                    <strong></strong>--%>
<%--                </a>--%>
<%--                <ul class="dropdown-menu text-small shadow">--%>
<%--                    <li>--%>
<%--                        <a class="dropdown-item" href="#">New project...</a>--%>
<%--                    </li>--%>
<%--                    <li>--%>
<%--                        <a class="dropdown-item" href="#">Settings</a>--%>
<%--                    </li>--%>
<%--                    <li>--%>
<%--                        <a class="dropdown-item" href="#">Profile</a>--%>
<%--                    </li>--%>
<%--                    <li>--%>
<%--                        <hr class="dropdown-divider">--%>
<%--                    </li>--%>
<%--                    <li>--%>
<%--                        <a class="dropdown-item" href="#">Sign out</a>--%>
<%--                    </li>--%>
<%--                </ul>--%>
<%--            </div>--%>
        </div>





