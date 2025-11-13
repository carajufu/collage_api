<!-- /WEB-INF/views/account/find-id-modal.jsp -->
<%@ page contentType="text/html; charset=UTF-8" %>
<div class="modal fade" id="findIdModal" tabindex="-1" aria-labelledby="findIdLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-500x600">
    <form id="findIdForm" class="modal-content needs-validation" method="post" action="/api/auth/find-id" novalidate>
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      <div class="modal-header">
        <h5 class="modal-title" id="findIdLabel">아이디 찾기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
          <label for="userName" class="form-label">성명</label>
          <input id="userName" name="userName" type="text" class="form-control" required />
          <div class="invalid-feedback">성명을 입력하세요</div>
        </div>
        <div class="mb-3">
          <label for="birthDate" class="form-label">생년월일(YYYYMMDD)</label>
          <input id="birthDate" name="birthDate" type="text" class="form-control" inputmode="numeric" pattern="\\d{8}" placeholder="예: 19960415" required aria-describedby="bdHelp" />
          <div id="bdHelp" class="form-text">숫자 8자리</div>
          <div class="invalid-feedback">형식이 올바르지 않습니다</div>
        </div>
        <div id="findIdResult" class="alert alert-info py-2 small d-none" role="status"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
        <button type="submit" class="btn btn-primary">확인</button>
      </div>
    </form>
  </div>
</div>
