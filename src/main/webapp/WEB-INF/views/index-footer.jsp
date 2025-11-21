<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<style>
/* 푸터 영역 강제 센터 정렬 */
footer.custom-footer {
  display: flex;
  justify-content: center;   /* 안쪽 컨텐츠 가로 중앙 */
}

/* 안쪽 폭 제한 + 가운데 배치 */
footer.custom-footer .container,
footer.custom-footer .container-fluid {
  max-width: 1250px;         /* 필요 시 조절 */
  width: 100%;
  margin: 0 auto;
}
</style>

<footer class="custom-footer bg-dark text-white-50 py-5 mt-5 position-relative" id="footer">
    <div class="container">
        <div class="row">
            <!-- 좌측: 로고 + 학교 소개 + 주소/연락처 -->
            <div class="col-lg-4 col-md-6">
                <div class="mb-4">
                    <a href="/"
                       class="d-flex align-items-center mb-3">
                        <img src="${pageContext.request.contextPath}/images/logo/univ-logo-kor-vite-dark.svg"
                             alt="대덕대학교 로고"
                             height="40"
                             class="me-2" />
                    </a>
                    <p class="mb-2">
                        미래를 여는 스마트 캠퍼스, 대덕대학교 메인 포털입니다.
                    </p>
                    <p class="mb-1">
                        (00000) 대전광역시 ○○구 ○○로 123, 대덕대학교
                    </p>
                    <p class="mb-1">
                        TEL : 042-000-0000&nbsp;&nbsp;&nbsp;FAX : 042-000-0001
                    </p>
                    <p class="mb-0">
                        E-mail : info@ddc.ac.kr
                    </p>
                </div>
            </div>

            <!-- 빠른 메뉴: 대학소개 / 학사안내 -->
            <div class="col-lg-2 col-md-6">
                <div class="mb-4">
                    <h6 class="text-white text-uppercase mb-3">대학소개</h6>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">대학개요</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">연혁</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">총장 인사말</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">캠퍼스 안내</a>
                        </li>
                    </ul>
                </div>

                <div class="mb-4">
                    <h6 class="text-white text-uppercase mb-3">학사안내</h6>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">학사일정</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">전공·학과</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">학사 규정</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">학사포털</a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- 빠른 메뉴: 입학안내 / 대학생활 -->
            <div class="col-lg-2 col-md-6">
                <div class="mb-4">
                    <h6 class="text-white text-uppercase mb-3">입학안내</h6>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">학부 입학</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">대학원 입학</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">편입학</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">외국인·교환학생</a>
                        </li>
                    </ul>
                </div>

                <div class="mb-4">
                    <h6 class="text-white text-uppercase mb-3">대학생활</h6>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">장학·등록</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">기숙사</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">동아리</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">도서관</a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- 빠른 메뉴: 뉴스·공지 / 문의 -->
            <div class="col-lg-4 col-md-6">
                <div class="mb-4">
                    <h6 class="text-white text-uppercase mb-3">뉴스·공지</h6>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">학사공지</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">대학뉴스</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">보도자료</a>
                        </li>
                        <li class="mb-2">
                            <a href="#"
                               class="text-white-50 text-decoration-none">행사·이벤트</a>
                        </li>
                    </ul>
                </div>

                <div class="mb-0">
                    <h6 class="text-white text-uppercase mb-3">문의</h6>
                    <p class="mb-1">
                        입학 상담 : 042-000-1000
                    </p>
                    <p class="mb-1">
                        행정 문의 : 042-000-2000
                    </p>
                    <p class="mb-0">
                        온라인 문의 :
                        <a href="#"
                           class="text-white-50 text-decoration-underline">
                            문의하기
                        </a>
                    </p>
                </div>
            </div>
        </div>

        <!-- 하단 바: 저작권 + 소셜 링크 -->
        <div class="row mt-4 pt-4 border-top border-top-dashed border-secondary">
            <div class="col-md-6">
                <p class="mb-0">
                    Copyright ©
                    <script>document.write(new Date().getFullYear())</script>
                    대덕대학교. All rights reserved.
                </p>
            </div>
            <div class="col-md-6">
                <ul class="list-inline mb-0 text-md-end mt-3 mt-md-0">
                    <li class="list-inline-item">
                        <a href="#"
                           class="text-white-50 text-decoration-none">개인정보처리방침</a>
                    </li>
                    <li class="list-inline-item">
                        <a href="#"
                           class="text-white-50 text-decoration-none">이용약관</a>
                    </li>
                    <li class="list-inline-item">
                        <a href="https://www.facebook.com"
                           target="_blank" rel="noopener noreferrer"
                           class="text-white-50 fs-5">
                            <i class="ri-facebook-fill"></i>
                        </a>
                    </li>
                    <li class="list-inline-item">
                        <a href="https://www.instagram.com"
                           target="_blank" rel="noopener noreferrer"
                           class="text-white-50 fs-5">
                            <i class="ri-instagram-line"></i>
                        </a>
                    </li>
                    <li class="list-inline-item">
                        <a href="https://www.youtube.com"
                           target="_blank" rel="noopener noreferrer"
                           class="text-white-50 fs-5">
                            <i class="ri-youtube-fill"></i>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</footer>
