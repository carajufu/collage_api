<!-- /WEB-INF/views/account/reset-pw-modal.jsp -->
<%@ page contentType="text/html; charset=UTF-8" %>
<div class="modal fade" id="resetPwModal" tabindex="-1" aria-labelledby="resetPwLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-500x600">
    <form id="resetPwForm" class="modal-content needs-validation" method="post" action="/api/auth/password/reset" novalidate>
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      <div class="modal-header">
        <h5 class="modal-title" id="resetPwLabel">비밀번호 재설정</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
          <label for="rpwId" class="form-label">아이디</label>
          <input id="rpwId" name="acntId" type="text" class="form-control" required autocomplete="username" />
          <div class="invalid-feedback">아이디를 입력하세요</div>
        </div>
        <div class="mb-3">
          <label for="rpwEmail" class="form-label">이메일</label>
          <input id="rpwEmail" name="email" type="email" class="form-control" required autocomplete="email" />
          <div class="invalid-feedback">이메일을 입력하세요</div>
        </div>

        <div class="mb-3 d-grid gap-2">
          <button type="button" id="sendCodeBtn" class="btn btn-outline-primary">인증코드 발송</button>
        </div>

        <div class="mb-3">
          <label for="rpwCode" class="form-label">인증코드</label>
          <input id="rpwCode" name="code" type="text" class="form-control" inputmode="numeric" autocomplete="one-time-code" />
        </div>

        <div class="mb-3">
          <label for="newPw" class="form-label">새 비밀번호</label>
          <input id="newPw" name="newPassword" type="password" class="form-control" autocomplete="new-password" />
        </div>
        <div class="mb-1">
          <label for="newPw2" class="form-label">새 비밀번호 확인</label>
          <input id="newPw2" name="newPasswordConfirm" type="password" class="form-control" autocomplete="new-password" />
        </div>

        <div id="resetPwMsg" class="alert alert-info py-2 small d-none" role="status"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
        <button type="submit" class="btn btn-primary">재설정</button>
      </div>
    </form>
  </div>
</div>
