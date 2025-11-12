<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="header.jsp" %>

<script type="text/javascript" src="/js/jquery-3.6.0.js"></script>

<!--
signup.jsp
역할:
 - 신규 사용자 가입 폼 렌더링
 - POST /signup 으로 계정 생성 요청 전송
 - 성공 시 컨트롤러가 redirect:/login 으로 돌려보냄

보안/정합 포인트:
 - CSRF: 현재 Spring Security 설정에서 csrf().disable() 상태라 토큰은 안 씀
 - 비밀번호 필드 name 은 "password" 여야 한다.
   이유:
     AuthViewController.signup(AcntVO acntVO)가 AcntVO로 바인딩
     DitAccountServiceImpl.userSave() 는 acntVO.getPassword()를 읽어서 BCrypt 처리
   만약 name="accountPassword" 로 보내면 acntVO.password 가 null로 바인딩됨 → DB에 빈 비번 저장 위험
-->

<section class="d-flex vh-100">
  <div class="container-fluid row justify-content-center align-content-center">
    <div class="card bg-dark" style="border-radius: 1rem;">
      <div class="card-body p-5 text-center">
        <h2 class="text-white">SIGN UP</h2>
        <p class="text-white-50 mt-2 mb-5">서비스 사용을 위한 회원 가입</p>

        <div class="mb-2">
          <!--
            요청 URI    : /signup
            요청 방식   : POST
            전송 필드   : acntId, password
            바인딩 대상 : AcntVO.acntId / AcntVO.password
            처리 로직   : DitAccountServiceImpl.userSave()
                          - BCrypt 해시 → ACNT INSERT → AUTHOR INSERT
                          - redirect:/login
          -->
          <form action="/signup" method="POST" autocomplete="off">
            <%-- CSRF 토큰은 현재 비활성화 상태(csrf.disable())라 불필요
                 추후 CSRF 활성화 시 주석 해제
            <input type="hidden" name="${_csrf?.parameterName}" value="${_csrf?.token}" />
            --%>

            <div class="mb-3">
              <label class="form-label text-white">아이디</label>
              <!-- AcntVO.setAcntId(...) 으로 바인딩됨 -->
              <input type="text"
                     class="form-control"
                     name="acntId"
                     placeholder="아이디"
                     required />
            </div>

            <div class="mb-3">
              <label class="form-label text-white">비밀번호</label>
              <!-- AcntVO.setPassword(...) 으로 바인딩됨
                   DitAccountServiceImpl.userSave() 가 BCrypt 인코딩 후 DB PASSWORD 컬럼에 저장
              -->
              <input type="password"
                     class="form-control"
                     name="password"
                     placeholder="비밀번호"
                     required />
            </div>

            <button type="submit" class="btn btn-primary">회원가입 확인</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</section>
<%@ include file="footer.jsp" %>