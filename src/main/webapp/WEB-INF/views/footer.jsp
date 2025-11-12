<%-- =====================================================================

1) 코드 의도
   - 공통 푸터 UI만 제공. 세션(Session, 서버 상태 저장) 기반 JSP에서 재사용.
   - JWT(Json Web Token, 전자서명 토큰)와 localStorage(브라우저 저장소) 연동 금지.

2) 데이터 흐름(입력·가공·출력)
   - 입력: 서버측 동적 데이터 없음(정적 링크·표기만 사용).
   - 가공: 없음.
   - 출력: 네비게이션 링크 목록과 저작권 표기.

3) 계약(전제·에러·성공조건)
   - 전제: header.jsp 등 상위 레이아웃에서 Bootstrap 5 CSS가 이미 로드됨.
   - 에러: 동적 렌더링 없음으로 NPE 등 런타임 예외 발생 지점 없음.
   - 성공: 정적 메뉴와 저작권 표기가 항상 렌더링됨.

4) 보안·안전 전제
   - 폼 전송 없음 → CSRF(Cross-Site Request Forgery, 교차 사이트 요청 위조) 토큰 불요.
   - 쿠키·스토리지 접근 금지. 스크립트 삽입 금지.

5) 유지보수자 가이드
   - 메뉴 항목 추가/수정은 정적 링크로 유지. 민감 기능 연결 시 서버 세션 인증 전제.
   - 다국어 처리 필요 시 상위 레이아웃에서 JSTL fmt를 적용하고 여기서는 정적 표기 유지.
   - 저작권 연도 자동화가 필요하면 상위 컨트롤러에서 모델 속성으로 전달하고 여기서는 EL만 바인딩.

6) 근거
   - JSP 세션 모델: JSP는 서버 렌더링으로 상태는 세션이 관리하며 클라이언트 저장소 의존 금지.
   - Bootstrap 5 유틸리티 클래스로 레이아웃만 담당. 보안 로직과 분리.

파일 경로 예: jwt-demo/src/main/webapp/WEB-INF/views/footer.jsp
===================================================================== --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
       <%-- 페이지별 컨텐츠 영역 끝 --%>
        </main>
    </div> <%-- .layout --%>

    <footer class="page-footer border-top bg-light">
        <div class="container-fluid py-3 d-flex flex-wrap justify-content-between align-items-center">
            <ul class="nav mb-2 mb-md-0">
                <li class="nav-item">
                    <a href="#" class="nav-link px-2 text-body-secondary">Home</a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link px-2 text-body-secondary">Features</a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link px-2 text-body-secondary">Pricing</a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link px-2 text-body-secondary">FAQs</a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link px-2 text-body-secondary">About</a>
                </li>
            </ul>
            <p class="mb-0 text-body-secondary">© 2025 Company, Inc</p>
        </div>
    </footer>

</div> <%-- #wrapper --%>
</body>
</html>
