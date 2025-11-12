<%-- =====================================================================
[welcome.jsp — 세션 단독 디버그 렌더 리팩토링]

1) 코드 의도
   - JSP 구간은 세션(Session, 서버가 상태 저장)만 사용. JWT(Json Web Token, 전자서명 토큰) 제거.
   - 컨트롤러가 내려준 acntVO 기반으로 사용자 정보를 서버 렌더.
   - 화면 상단에 세션 상태만 디버그 표기. JWT 상태는 "사용 안 함"으로 고정 표기.

2) 데이터 흐름(입력·가공·출력)
   - 입력: model.addAttribute("acntVO", ...), Authentication(principal.username)
   - 가공: JSTL로 acntVO 존재 여부 분기, 권한 목록 렌더
   - 출력: 사용자 식별자, 권한, 디버그 상태, 로그아웃(POST), 증명서 발급 이동

3) 계약(전제·에러·성공조건)
   - 전제: AuthViewController.welcomePage()가 acntVO를 모델에 세팅, Spring Security가 세션 인증 완료
   - 에러: acntVO 없으면 "세션 정보 없음" 경고와 로그인 링크만 노출(클라이언트 리다이렉트 없음)
   - 성공: acntVO와 principal.username이 정상 렌더

4) 보안·안전 전제
   - localStorage 및 토큰 검증 호출 금지
   - /logout는 POST + CSRF 토큰 필수
   - 민감 기능 이동은 서버 세션 인증을 전제

5) 유지보수자 가이드
   - JSP에 토큰/스토리지 접근 JS 삽입 금지(디버그 로그는 세션 여부만 콘솔 출력)
   - 리다이렉트는 컨트롤러에서 처리. JSP는 상태 가시화만 담당

6) 근거
   - Spring Security 6: 세션 인증, CSRF 기본 활성
   - JSP/JSTL 3.0: jakarta.tags.* 사용
===================================================================== --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>

<section class="container mt-5">
  <h2>디버깅 페이지</h2>

  <!-- 디버그 패널: 세션만 표기 -->
  <div class="mb-4 p-3 border rounded bg-light">
    <h5>디버그 상태</h5>
    <p id="debugSessionStatus">
      <c:choose>
        <c:when test="${not empty acntVO}">
          세션 상태: OK (acntVO 모델 바인딩 존재)
        </c:when>
        <c:otherwise>
          세션 상태: 없음 (acntVO 미존재)
        </c:otherwise>
      </c:choose>
    </p>
    <p id="debugTokenStatus">JWT 상태: 사용 안 함(JSP 구간 폐지)</p>
  </div>

  <!-- 사용자 정보 렌더 -->
  <c:choose>
    <c:when test="${not empty acntVO}">
      <h4>세션 인증 사용자 정보</h4>
      <ul>
        <li>아이디: <c:out value="${acntVO.acntId}" /></li>
        <li>계정타입: <c:out value="${acntVO.acntTy}" /></li>
        <li>권한:
          <c:forEach var="auth" items="${acntVO.authorList}">
            <c:out value="${auth.authorNm}" />
          </c:forEach>
        </li>
        <li>Principal: <sec:authentication property="principal.username"/></li>
      </ul>
    </c:when>
    <c:otherwise>
      <div class="alert alert-warning" role="alert">
        세션 정보 없음. 다시 로그인 필요. <a href="/login" class="alert-link">/login</a>
      </div>
    </c:otherwise>
  </c:choose>

  <!-- 액션 영역 -->
  <div class="mt-4 d-flex gap-2">
	
	<%-- 인증 사용자에게만 로그아웃 버튼 노출, 디버깅 및 개발 편의성 --%>
	<sec:authorize access="isAuthenticated()">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<%-- 계약: 기본 Spring Security 6는 POST /logout. GET 링크 사용 시 SecurityConfig에서 허용 필요 --%>
		<a href="/logout"><button class="btn btn-outline-danger">로그아웃</button></a>
	</sec:authorize>
	
    <!-- 증명서 발급: GET 이동, 디버깅 및 개발 편의성 -->
    <form id="certDocxForm" action="/certificates/DocxForm" method="get" class="m-0">
      <button type="submit" class="btn btn-primary">증명서 발급</button>
    </form>
    <!-- 학사일정: GET 이동, 디버깅 및 개발 편의성 -->
    <form action="/schedule" method="get" class="m-0">
      <button type="submit" class="btn btn-info">학사일정</button>
    </form>
    <!-- 학사일정: GET 이동, 디버깅 및 개발 편의성 -->
    <form action="/schedule/timetable" method="get" class="m-0">
      <button type="submit" class="btn btn-outline-success">수강 시간표</button>
    </form>
  </div>
</section>

<%@ include file="../footer.jsp" %>

<script>
/* 디버그 콘솔 로그: 세션 여부만 기록. 토큰 접근 금지 */
(function(){
  var acntPresent = ${not empty acntVO ? 'true' : 'false'};
  console.log("[debuging.jsp] 세션 인증:", acntPresent ? "OK" : "없음");
})();
</script>
