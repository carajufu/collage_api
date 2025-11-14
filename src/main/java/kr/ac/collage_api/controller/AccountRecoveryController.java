package kr.ac.collage_api.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import kr.ac.collage_api.mapper.DitAccountMapper;
import kr.ac.collage_api.util.EmailJSClient;

import java.security.SecureRandom;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.Year;
import java.time.format.DateTimeFormatter;

/*
  [AccountRecoveryController 공통 주석]

  1) 컨트롤러 전체 의도
     - 계정 복구 플로우 전용 엔드포인트를 한 곳에 모은 컨트롤러.
     - 아이디 찾기(lookupId), 비밀번호 재설정 단계 전체(sendResetCodeEmail, verifyResetCode, resetPassword)를 담당.
     - JSP 팝업 뷰와 REST API를 명확히 분리하고, 세션에 인증 상태를 유지하는 패턴.

  2) 전체 데이터 흐름 시퀀스
     1단계: 아이디 찾기 (선택적)
       - 클라이언트
         POST /account/find-id (form)
           파라미터: userName, birthDate(YYYYMMDD)
       - 서버
         DitAccountMapper.findByNameAndBirth 호출
          => 결과를 JSP(account/find-id-ok.jsp)로 전달

     2단계: 비밀번호 재설정 - 인증코드 발송
       - 클라이언트
         fetch("/api/account/email/send", POST JSON { email, acntId })
       - 서버
         1) email, acntId 공백/형식 검증
         2) DitAccountMapper.existsByAcntIdAndEmail 로 계정 존재 확인
         3) generateAuthCode 로 인증코드 생성
         4) EmailJSClient.sendVerificationEmail 로 메일 발송
         5) 세션에 이메일, 아이디, 인증코드, 발급시각 저장
         6) "OK" 반환 (200)

     3단계: 비밀번호 재설정 - 인증코드 정합 확인
       - 클라이언트
         fetch("/api/account/email/verify", POST JSON { email, acntId, code })
          => 응답이 OK 이면 UI 상 "인증 완료" 표시
       - 서버
         1) 세션의 RESET_* 값 조회
         2) TTL 초과 여부 확인
         3) email, acntId 컨텍스트 일치 여부 확인
         4) code 일치 여부 확인
          => OK / INVALID_PARAM / MISMATCH_CONTEXT / INVALID_CODE / CODE_EXPIRED 반환

     4단계: 비밀번호 재설정 - 실제 비밀번호 변경
       - 클라이언트
         reset-pw.jsp 에서 form POST
           action="/api/account/password/reset"
           method="post"
           Content-Type: application/x-www-form-urlencoded;charset=UTF-8
           필드: email, acntId, code, newPassword
         필요 시 추후 JSON 기반 API로 변경할 수 있으나,
         현재 구현 기준은 JSP form submit 이 단일 진실임.
       - 서버
         1) 폼 파라미터 바인딩 + Bean Validation 검사
         2) 비밀번호 정책(isValidPasswordPolicy) 검증
         3) 세션 RESET_* 재검증(TTL, 컨텍스트, 코드)
         4) DitAccountMapper.existsByAcntIdAndEmail 로 계정 재확인
         5) PasswordEncoder 로 비밀번호 해시 후 updatePasswordByAcntIdAndEmail
         6) 세션 RESET_* 정리 후 OK 반환

  3) 공통 계약 요약
     - /account/find-id
       요청: x-www-form-urlencoded, userName, birthDate
       응답: JSP "account/find-id-ok", model.resultMessage

     - /api/account/email/send
       요청: JSON { email, acntId }
       응답:
         200 OK           "OK"                 정상 발송
         400 BAD_REQUEST  "INVALID_PARAM"     필수값 누락
         404 NOT_FOUND    "NO_MATCH"          계정 없음
         500 SERVER_ERROR "MAIL_SEND_FAILED"  메일 발송 실패

     - /api/account/email/verify
       요청: JSON { email, acntId, code }
       응답:
         200 OK           "OK"                정합성 통과
         400 BAD_REQUEST  "INVALID_PARAM"     필수값 누락
         400 BAD_REQUEST  "MISMATCH_CONTEXT"  세션 컨텍스트 불일치
         400 BAD_REQUEST  "INVALID_CODE"      코드 불일치
         410 GONE         "CODE_EXPIRED"      TTL 초과 또는 세션 정보 없음

     - /api/account/password/reset
       요청: x-www-form-urlencoded { email, acntId, code, newPassword }
       응답:
         200 OK           "OK"                   성공
         400 BAD_REQUEST  "INVALID_PARAM"        필수값 누락 또는 바인딩 오류
         400 BAD_REQUEST  "INVALID_PASSWORD_RULE" 비밀번호 정책 위반
         400 BAD_REQUEST  "MISMATCH_CONTEXT"     세션 컨텍스트 불일치
         400 BAD_REQUEST  "INVALID_CODE"         코드 불일치
         404 NOT_FOUND    "NO_MATCH"             계정 없음
         410 GONE         "CODE_EXPIRED"         TTL 초과 또는 세션 정보 없음
         500 SERVER_ERROR "UPDATE_FAIL"          DB 업데이트 실패

  4) 공통 보안 전제
     - 인증코드, 이메일, 아이디는 세션에만 저장, DB에는 인증코드를 남기지 않음.
     - 비밀번호는 PasswordEncoder를 통해 해시 후 저장.
     - IP는 완전 노출 대신 maskIpForLog 로 일부 마스킹.
     - 브루트포스 방지를 위한 시도 횟수 제한, 레이트 리밋은 상위 레이어에서 추가 가능.

  5) 유지보수자 가이드
     - DitAccountMapper 쿼리 및 시그니처 변경 시 이 컨트롤러의 계약을 먼저 확인.
     - JSP / JS에서 호출 URL, 파라미터, 응답코드를 바꿀 경우 본 클래스 주석의 계약 섹션도 같이 갱신.
     - 세션 키 상수(SESSION_RESET_*)를 변경하면 clearResetSession와 verify, reset 영역 모두 동기화 필요.
 */
@Slf4j
@Validated
@RequiredArgsConstructor
@Controller
public class AccountRecoveryController {

	// 세션 키 상수
	private static final String SESSION_RESET_EMAIL     = "RESET_EMAIL";
	private static final String SESSION_RESET_ACNT_ID   = "RESET_ACNT_ID";
	private static final String SESSION_RESET_AUTH_CODE = "RESET_AUTH_CODE";
	private static final String SESSION_RESET_AUTH_AT   = "RESET_AUTH_AT";

	// 인증코드 유효 시간(초) – 10분
	private static final long RESET_CODE_TTL_SECONDS = 600L;

	private final DitAccountMapper ditAccountMapper;
	// private final PasswordEncoder passwordEncoder; 
	// =>> bCryptPasswordEncoder 으로 대체 일관성 확보
    private final BCryptPasswordEncoder bCryptPasswordEncoder; 
    // BCryptPasswordEncoder(전문용어(단방향 해시 알고리즘 구현체))


	/* ======================================================================
	 * 요청 DTO 정의
	 * ==================================================================== */

	/*
      [EmailSendRequest DTO]

      1) 코드 의도
         - /api/account/email/send 로 들어오는 JSON 바디를 캡슐화하는 컨테이너.
         - 프론트엔드에서 넘어오는 필드명을 명확히 고정하여 컨트롤러 파라미터를 단순화.

      2) 데이터 흐름
         - 클라이언트
           fetch("/api/account/email/send", {
             method: "POST",
             headers: { "Content-Type": "application/json" },
             body: JSON.stringify({ email, acntId })
           })
         - 서버
           @RequestBody EmailSendRequest requestBody 로 역직렬화
            => sendResetCodeEmail 메서드 내부에서 email, acntId 추출 후 검증 및 DB 조회에 사용

      3) 필드 계약
         - email
           타입     String
           제약     @NotBlank, @Email
           의미     계정에 등록된 이메일 주소
         - acntId
           타입     String
           제약     @NotBlank
           의미     로그인 계정 아이디

      4) 유지보수자 가이드
         - JSON 키(email, acntId)를 변경하면 프론트 fetch 호출과 이 DTO 필드명을 동시에 변경해야 함.
         - 검증 애노테이션 추가/변경 시 BAD_REQUEST 처리 범위가 바뀌므로 주석 상 계약도 업데이트 필요.
	 */
	public static class EmailSendRequest {

		@NotBlank
		@Email
		private String email;

		@NotBlank
		private String acntId;

		public String getEmail() {
			return email;
		}
		public void setEmail(String email) {
			this.email = email;
		}

		public String getAcntId() {
			return acntId;
		}
		public void setAcntId(String acntId) {
			this.acntId = acntId;
		}
	}

	/*
      [ResetPasswordRequest DTO]

      1) 코드 의도
         - /api/account/password/reset 에서 JSP form 으로 넘어오는 파라미터를 묶는 DTO.
         - 이메일, 아이디, 인증코드, 새 비밀번호를 한 번에 검증하고 resetPassword 메서드에 전달.

      2) 데이터 흐름
         - 클라이언트 (reset-pw.jsp 예시)
           <form id="resetPwForm" method="post" action="/api/account/password/reset">
             <input type="hidden" name="email" value="사용자 이메일">
             <input type="hidden" name="acntId" value="계정 아이디">
             <input type="text"   name="code">
             <input type="password" name="newPassword">
           </form>
         - 서버
           @Valid ResetPasswordRequest form 파라미터로 바인딩
            => resetPassword 메서드에서 Bean Validation + 추가 정책 검증 후 사용

      3) 필드 계약
         - email
           타입     String
           제약     @NotBlank, @Email
           의미     계정에 등록된 이메일
         - acntId
           타입     String
           제약     @NotBlank
           의미     로그인 계정 아이디
         - code
           타입     String
           제약     @NotBlank
           의미     메일로 발행된 인증코드
         - newPassword
           타입     String
           제약     @NotBlank, @Size(8~20)
           의미     새 비밀번호(구체 정책은 isValidPasswordPolicy와 동기화)

      4) 유지보수자 가이드
         - PASSWORD_RULE_TEXT(JSP), isValidPasswordPolicy, @Size(min,max) 세 군데가 서로 같은 정책을 표현해야 함.
           한 곳만 바꾸면 정책이 분리돼 버그와 사용자 혼란 발생.
         - JSON 기반 API로 전환하고 싶으면
           1) resetPassword 파라미터에 @RequestBody 추가
           2) 클라이언트를 fetch(JSON) 방식으로 변경
           3) 클래스 상단 공통 주석과 이 DTO 주석의 계약을 함께 수정할 것.
	 */
	public static class ResetPasswordRequest {

		@NotBlank
		@Email
		private String email;

		@NotBlank
		private String acntId;

		@NotBlank
		private String code;

		@NotBlank
		@Size(min = 8, max = 20)
		private String newPassword;

		public String getEmail() {
			return email;
		}
		public void setEmail(String email) {
			this.email = email;
		}

		public String getAcntId() {
			return acntId;
		}
		public void setAcntId(String acntId) {
			this.acntId = acntId;
		}

		public String getCode() {
			return code;
		}
		public void setCode(String code) {
			this.code = code;
		}

		public String getNewPassword() {
			return newPassword;
		}
		public void setNewPassword(String newPassword) {
			this.newPassword = newPassword;
		}
	}

	/*
      [VerifyCodeRequest DTO]

      1) 코드 의도
         - /api/account/email/verify 호출에서 JSON 바디를 받는 DTO.
         - "인증코드 일치 여부만" 빠르게 판별하는 중간 단계에서 사용.

      2) 데이터 흐름
         - 클라이언트
           fetch("/api/account/email/verify", {
             method: "POST",
             headers: { "Content-Type": "application/json" },
             body: JSON.stringify({ email, acntId, code })
           })
         - 서버
           @RequestBody VerifyCodeRequest body 로 역직렬화
            => verifyResetCode 메서드에서 세션 값과 비교

      3) 필드 계약
         - email  : @NotBlank, @Email, 등록 이메일
         - acntId : @NotBlank, 계정 아이디
         - code   : @NotBlank, 이메일로 발송된 인증코드

      4) 유지보수자 가이드
         - 프론트 reset-pw.jsp 의 fetch body 키(email, acntId, code)와 필드명을 항상 동일하게 유지.
         - 여기서 필드가 늘어나면 verifyResetCode 로직과 주석의 계약 섹션도 같이 수정.
	 */
	public static class VerifyCodeRequest {

		@NotBlank
		@Email
		private String email;

		@NotBlank
		private String acntId;

		@NotBlank
		private String code;

		public String getEmail() {
			return email;
		}
		public void setEmail(String email) {
			this.email = email;
		}

		public String getAcntId() {
			return acntId;
		}
		public void setAcntId(String acntId) {
			this.acntId = acntId;
		}

		public String getCode() {
			return code;
		}
		public void setCode(String code) {
			this.code = code;
		}
	}

	/* ======================================================================
	 * 1. 아이디 찾기 (이름 + 생년월일)
	 * ==================================================================== */

	/*
      [lookupId 메서드]

      1) 메서드 의도
         - 학생의 성명 + 생년월일(YYYYMMDD)을 기반으로 계정 아이디를 검색.
         - 결과를 JSP 팝업(account/find-id-ok.jsp)에 넘겨, UI에서 "아이디" 또는 "없음"을 표시하게 함.

      2) 데이터 흐름
         입력
           - URL       POST /account/find-id
           - 파라미터 userName(성명), birthDate(YYYYMMDD)
         가공
           1) trim 처리, 형식 검증(생년월일 8자리 숫자)
           2) DitAccountMapper.findByNameAndBirth(name, birth) 호출
         출력
           - Model
             resultMessage = null      일치하는 계정 없음
             resultMessage = "ACNTID"  계정 존재
           - View 이름
             "account/find-id-ok"

      3) 계약
         - 성공/실패 모두 동일 JSP로 포워딩, JSP에서 resultMessage null 여부로 분기.
         - 이 메서드는 REST 응답이 아니라 서버사이드 렌더링(JSP) 전용.

      4) 보안·안전 전제
         - 반환 값은 아이디 문자열 한 개뿐, 추가 개인정보 노출 금지.
         - 존재 여부 노출 자체도 공격 표면이 될 수 있으므로,
           실제 운영 시에는 캡차, 레이트 리밋 등 보조 장치를 고려.

      5) 유지보수자 가이드
         - 이름/생년월일 컬럼명이 바뀌면 DitAccountMapper.findByNameAndBirth 쿼리부터 갱신.
         - resultMessage 대신 별도 필드명을 쓰고 싶다면 JSP와 이 메서드의 model 키를 동시 변경.
	 */
	@PostMapping("/account/find-id")
	public String lookupId(
			@RequestParam("userName") String userName,
			@RequestParam("birthDate") String birthDate,
			org.springframework.ui.Model model
	) {

		String name  = userName == null ? "" : userName.trim();
		String birth = birthDate == null ? "" : birthDate.trim();

		if (name.isEmpty() || !birth.matches("\\d{8}")) {
			model.addAttribute("resultMessage", null);
			log.warn("[AccountRecoveryController] lookupId :: INVALID_PARAM name='{}', birth='{}'", name, birth);
			return "account/find-id-ok";
		}

		String acnt = ditAccountMapper.findByNameAndBirth(name, birth);

		if (acnt == null) {
			log.info("[AccountRecoveryController] lookupId :: NO_MATCH name='{}', birth='{}'", name, birth);
			model.addAttribute("resultMessage", null);
		} else {
			log.info("[AccountRecoveryController] lookupId :: FOUND name='{}', birth='{}', acntId='{}'",
					name, birth, acnt);
			model.addAttribute("resultMessage", acnt);
		}

		return "account/find-id-ok";
	}

	/* ======================================================================
	 * 2. 비밀번호 재설정용 인증 이메일 발송
	 * ==================================================================== */

	/*
      [sendResetCodeEmail 메서드]

      1) 메서드 의도
         - 비밀번호 재설정 플로우의 첫 단계로, "이메일 + 아이디 조합이 유효한 계정인지" 검증하고
           인증코드를 이메일로 발송 후 세션에 저장.

      2) 데이터 흐름
         입력
           - URL   POST /api/account/email/send
           - Body  JSON EmailSendRequest { email, acntId }
         가공
           1) email, acntId trim 및 공백 검증
           2) ditAccountMapper.existsByAcntIdAndEmail(acntId, email) 로 계정 존재 확인
              반환값 0이면 404 NO_MATCH
           3) generateAuthCode(6)로 6자리 영문+숫자 코드 생성
           4) resolveClientIp 로 클라이언트 IP 추출
           5) maskIpForLog 로 메일/로그용 마스킹 IP 생성
           6) requestTime, year, collageName 세팅
           7) EmailJSClient.sendVerificationEmail(email, authCode, collageName, requestTime, requestIpMasked, year) 호출
           8) 성공 시 세션에 이메일/아이디/코드/발급시각(Instant.now()) 저장
         출력
           - 200 OK, Body "OK"             정상
           - 400 BAD_REQUEST, "INVALID_PARAM" 필수값 누락
           - 404 NOT_FOUND, "NO_MATCH"       계정 없음
           - 500 SERVER_ERROR, "MAIL_SEND_FAILED" 메일 발송 실패

      3) 보안·안전 전제
         - 인증코드는 세션에만 저장, DB에 남기지 않음.
         - IP는 마스킹된 형태만 메일에 실어 최소한의 추적만 가능하게 유지.
         - authCode는 로그에 debug 레벨로만 남김, 운영 환경에서는 레벨 조정 고려.

      4) 유지보수자 가이드
         - 인증코드 길이나 문자 집합을 바꾸려면 generateAuthCode와 메일 템플릿 안내문을 함께 수정.
         - collageName, year, requestTime 등 템플릿 변수 추가/삭제 시 EmailJSClient 시그니처와 함께 조정.
	 */
	@PostMapping("/api/account/email/send")
	@ResponseBody
	public ResponseEntity<String> sendResetCodeEmail(
			@RequestBody @Valid EmailSendRequest requestBody,
			HttpServletRequest request,
			HttpSession session
	) {

		String email  = requestBody.getEmail() == null ? "" : requestBody.getEmail().trim();
		String acntId = requestBody.getAcntId() == null ? "" : requestBody.getAcntId().trim();

		if (email.isEmpty() || acntId.isEmpty()) {
			log.warn("[AccountRecoveryController] sendResetCodeEmail :: INVALID_PARAM email='{}', acntId='{}'",
					email, acntId);
			return ResponseEntity.badRequest().body("INVALID_PARAM");
		}

		int matchCount = ditAccountMapper.existsByAcntIdAndEmail(acntId, email);
		if (matchCount == 0) {
			log.info("[AccountRecoveryController] sendResetCodeEmail :: NO_MATCH acntId='{}', email='{}'",
					acntId, email);
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body("NO_MATCH");
		}

		// 영문 대/소문자 + 숫자 포함 6자리 랜덤 코드
		String authCode = generateAuthCode(6);
		log.debug("[AccountRecoveryController] sendResetCodeEmail :: generated authCode='{}' for acntId='{}'",
				authCode, acntId);

		String requestIpRaw    = resolveClientIp(request);
		String requestIpMasked = maskIpForLog(requestIpRaw);
		String requestTime     = LocalDateTime.now()
				.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		String year            = String.valueOf(Year.now().getValue());
		String collageName     = "대한민국대학교";

		boolean sent = EmailJSClient.sendVerificationEmail(
				email,
				authCode,
				collageName,
				requestTime,
				requestIpMasked,
				year
		);

		if (!sent) {
			log.warn("[AccountRecoveryController] sendResetCodeEmail :: MAIL_SEND_FAILED email='{}', acntId='{}'",
					email, acntId);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("MAIL_SEND_FAILED");
		}

		log.info("[AccountRecoveryController] sendResetCodeEmail :: MAIL_SENT email='{}', acntId='{}', ip='{}({})'",
				email, acntId, requestIpRaw, requestIpMasked);

		session.setAttribute(SESSION_RESET_EMAIL, email);
		session.setAttribute(SESSION_RESET_ACNT_ID, acntId);
		session.setAttribute(SESSION_RESET_AUTH_CODE, authCode);
		session.setAttribute(SESSION_RESET_AUTH_AT, Instant.now());

		return ResponseEntity.ok("OK");
	}

	/* ======================================================================
	 * 2-1. 비밀번호 재설정용 인증코드 검증 (프론트에서 입력한 인증 코드 대조)
	 * ==================================================================== */

	/*
      [verifyResetCode 메서드]

      1) 메서드 의도
         - 프론트엔드 JSP에서 사용자가 입력한 인증코드가
           세션에 저장된 코드와 일치하는지 "미리" 확인하는 전용 API.
         - 비밀번호 변경 전에 UI에서 즉시 피드백을 줄 수 있도록 분리.

      2) 데이터 흐름
         입력
           - URL   POST /api/account/email/verify
           - Body  JSON VerifyCodeRequest { email, acntId, code }
         가공
           1) 필수값 공백 검증
           2) 세션에서 RESET_EMAIL, RESET_ACNT_ID, RESET_AUTH_CODE, RESET_AUTH_AT 조회
           3) 세션 값 타입 검증 실패 시 CODE_EXPIRED 처리
           4) 발급시각 + TTL 과 현재 시각 비교, 초과 시 CODE_EXPIRED + 세션 초기화
           5) 요청 email, acntId 와 세션 email, acntId 비교, 다르면 MISMATCH_CONTEXT
           6) 요청 code 와 세션 code 비교, 다르면 INVALID_CODE
         출력
           - 200 OK          "OK"                정합성 통과
           - 400 BAD_REQUEST "INVALID_PARAM"     필수값 누락
           - 400 BAD_REQUEST "MISMATCH_CONTEXT"  세션 컨텍스트 불일치
           - 400 BAD_REQUEST "INVALID_CODE"      코드 불일치
           - 410 GONE        "CODE_EXPIRED"      TTL 초과 또는 세션 없음

      3) 프론트 처리 예
         - "코드 발송" 버튼 1차 클릭: /api/account/email/send
         - 2차 클릭 이후: /api/account/email/verify 호출
           응답값이
             "OK"             => "인증코드가 확인되었습니다." 녹색 메시지
             "INVALID_CODE"   => "인증코드가 올바르지 않습니다." 빨간 메시지
             "CODE_EXPIRED"   => "인증코드 유효 시간이 만료되었습니다." 알림 후 재발송 유도

      4) 보안·안전 전제
         - 여기서는 비밀번호 변경을 하지 않고, 오직 인증코드 일치 여부만 판단.
         - resetPassword 에서도 동일한 세션 값으로 재검증하여 "verify 우회"를 방지.

      5) 유지보수자 가이드
         - 세션 키 상수 이름 변경 시 이 메서드와 resetPassword, clearResetSession 세 군데를 함께 수정.
	 */
	@PostMapping("/api/account/email/verify")
	@ResponseBody
	public ResponseEntity<String> verifyResetCode(
			@RequestBody @Valid VerifyCodeRequest body,
			HttpSession session
	) {

		String email  = body.getEmail() == null ? "" : body.getEmail().trim();
		String acntId = body.getAcntId() == null ? "" : body.getAcntId().trim();
		String code   = body.getCode() == null ? "" : body.getCode().trim();

		if (email.isEmpty() || acntId.isEmpty() || code.isEmpty()) {
			log.warn("[AccountRecoveryController] verifyResetCode :: INVALID_PARAM email='{}', acntId='{}'",
					email, acntId);
			return ResponseEntity.badRequest().body("INVALID_PARAM");
		}

		Object emailInSessionObj = session.getAttribute(SESSION_RESET_EMAIL);
		Object acntInSessionObj  = session.getAttribute(SESSION_RESET_ACNT_ID);
		Object codeInSessionObj  = session.getAttribute(SESSION_RESET_AUTH_CODE);
		Object issuedAtObj       = session.getAttribute(SESSION_RESET_AUTH_AT);

		if (!(emailInSessionObj instanceof String) ||
				!(acntInSessionObj instanceof String) ||
				!(codeInSessionObj instanceof String) ||
				!(issuedAtObj instanceof Instant)) {

			log.warn("[AccountRecoveryController] verifyResetCode :: CODE_EXPIRED_OR_MISSING acntId='{}'", acntId);
			return ResponseEntity.status(HttpStatus.GONE).body("CODE_EXPIRED");
		}

		String emailInSession = ((String) emailInSessionObj).trim();
		String acntInSession  = ((String) acntInSessionObj).trim();
		String codeInSession  = ((String) codeInSessionObj).trim();
		Instant issuedAt      = (Instant) issuedAtObj;

		Instant now = Instant.now();
		if (now.isAfter(issuedAt.plusSeconds(RESET_CODE_TTL_SECONDS))) {
			log.warn("[AccountRecoveryController] verifyResetCode :: CODE_EXPIRED acntId='{}'", acntId);
			clearResetSession(session);
			return ResponseEntity.status(HttpStatus.GONE).body("CODE_EXPIRED");
		}

		if (!email.equals(emailInSession) || !acntId.equals(acntInSession)) {
			log.warn("[AccountRecoveryController] verifyResetCode :: MISMATCH_CONTEXT req(acntId='{}', email='{}') session(acntId='{}', email='{}')",
					acntId, email, acntInSession, emailInSession);
			return ResponseEntity.badRequest().body("MISMATCH_CONTEXT");
		}

		if (!code.equals(codeInSession)) {
			log.warn("[AccountRecoveryController] verifyResetCode :: INVALID_CODE acntId='{}'", acntId);
			return ResponseEntity.badRequest().body("INVALID_CODE");
		}

		log.info("[AccountRecoveryController] verifyResetCode :: SUCCESS acntId='{}', email='{}'",
				acntId, email);

		// 비밀번호 변경 단계에서 재검증을 위해 세션 값은 유지
		return ResponseEntity.ok("OK");
	}

	/* ======================================================================
	 * 3. 비밀번호 재설정
	 * ==================================================================== */

	/*
    [resetPassword]

    1) 코드 의도
       - 이메일 + 아이디 + 인증코드 + 새 비밀번호를 입력받아
         세션에 저장된 인증정보와 비교 검증하고 비밀번호 정책을 통과한 경우
         ACNT 테이블의 비밀번호를 업데이트.

    2) 데이터 흐름
       - 입력: POST /api/account/password/reset (form-urlencoded)
           email       : 등록 이메일
           acntId      : 계정 아이디
           code        : 메일로 받은 인증코드
           newPassword : 새 비밀번호
       - 처리:
           1. Bean Validation(@Valid) 바인딩 에러 검사
           2. 공백/trim 후 필수값 재검증
           3. isValidPasswordPolicy 로 비밀번호 정책 확인
           4. 세션에 저장된 (EMAIL, ACNT_ID, AUTH_CODE, AUTH_AT) 조회
           5. TTL(10분) 초과 여부 확인
           6. 이메일/아이디 컨텍스트 일치 확인
           7. 인증코드 일치 여부 확인
           8. DB 상 이메일+아이디 조합 재확인
           9. PasswordEncoder 로 암호화 후 DitAccountMapper.updatePasswordByAcntIdAndEmail 호출

       - 출력:
           200 OK            : "OK"
           400 BAD_REQUEST   : "INVALID_PARAM"         폼 바인딩/필수값 오류
                             : "INVALID_PASSWORD_RULE" 정책 위반
                             : "INVALID_CODE"         인증코드 불일치
                             : "MISMATCH_CONTEXT"     세션 컨텍스트 불일치
           404 NOT_FOUND     : "NO_MATCH"
           410 GONE          : "CODE_EXPIRED"
           500 SERVER_ERROR  : "UPDATE_FAIL"

    3) 계약
       - URL       : POST /api/account/password/reset
       - 요청 타입 : application/x-www-form-urlencoded;charset=UTF-8
       - 요청 파라미터: email, acntId, code, newPassword
       - 응답 바디 : 위 상태코드에 대응하는 문자열 코드
       - 프론트 reset-pw.jsp 는 이 문자열 코드에 맞춰 메시지/동작을 분기해야 함.

    4) 보안 전제
       - 비밀번호는 항상 PasswordEncoder 로 암호화 후 저장.
       - 세션 인증정보는 성공/만료 시 clearResetSession 으로 즉시 삭제.

    5) 유지보수자 가이드
       - JSON 기반 API로 바꾸고 싶다면
         1) 파라미터에 @RequestBody 추가
         2) 클라이언트 fetch(JSON)로 변경
         3) 본 메서드 주석과 클래스 상단 공통 계약을 함께 수정할 것.
	 */
	@PostMapping("/api/account/password/reset")
	@ResponseBody
	public ResponseEntity<String> resetPassword(
			@Valid ResetPasswordRequest form,
			BindingResult bindingResult,
			HttpSession session
	) {

		// Bean Validation 레벨에서 걸린 에러를 컨트롤러 수준의 "INVALID_PARAM"으로 통합
		if (bindingResult.hasErrors()) {
			log.warn("[AccountRecoveryController] resetPassword :: INVALID_PARAM(binding) errorCount={}",
					bindingResult.getErrorCount());
			return ResponseEntity.badRequest().body("INVALID_PARAM");
		}

		String email       = form.getEmail() == null ? "" : form.getEmail().trim();
		String acntId      = form.getAcntId() == null ? "" : form.getAcntId().trim();
		String code        = form.getCode() == null ? "" : form.getCode().trim();
		String newPassword = form.getNewPassword() == null ? "" : form.getNewPassword().trim();

		if (email.isEmpty() || acntId.isEmpty() || code.isEmpty() || newPassword.isEmpty()) {
			log.warn("[AccountRecoveryController] resetPassword :: INVALID_PARAM email='{}', acntId='{}'",
					email, acntId);
			return ResponseEntity.badRequest().body("INVALID_PARAM");
		}

		if (!isValidPasswordPolicy(newPassword)) {
			log.warn("[AccountRecoveryController] resetPassword :: INVALID_PASSWORD_RULE acntId='{}'", acntId);
			return ResponseEntity.badRequest().body("INVALID_PASSWORD_RULE");
		}

		Object emailInSessionObj = session.getAttribute(SESSION_RESET_EMAIL);
		Object acntInSessionObj  = session.getAttribute(SESSION_RESET_ACNT_ID);
		Object codeInSessionObj  = session.getAttribute(SESSION_RESET_AUTH_CODE);
		Object issuedAtObj       = session.getAttribute(SESSION_RESET_AUTH_AT);

		if (!(emailInSessionObj instanceof String) ||
				!(acntInSessionObj instanceof String) ||
				!(codeInSessionObj instanceof String) ||
				!(issuedAtObj instanceof Instant)) {

			log.warn("[AccountRecoveryController] resetPassword :: CODE_EXPIRED_OR_MISSING acntId='{}'", acntId);
			return ResponseEntity.status(HttpStatus.GONE).body("CODE_EXPIRED");
		}

		String emailInSession = ((String) emailInSessionObj).trim();
		String acntInSession  = ((String) acntInSessionObj).trim();
		String codeInSession  = ((String) codeInSessionObj).trim();
		Instant issuedAt      = (Instant) issuedAtObj;

		Instant now = Instant.now();
		if (now.isAfter(issuedAt.plusSeconds(RESET_CODE_TTL_SECONDS))) {
			log.warn("[AccountRecoveryController] resetPassword :: CODE_EXPIRED acntId='{}'", acntId);
			clearResetSession(session);
			return ResponseEntity.status(HttpStatus.GONE).body("CODE_EXPIRED");
		}

		if (!email.equals(emailInSession) || !acntId.equals(acntInSession)) {
			log.warn("[AccountRecoveryController] resetPassword :: MISMATCH_CONTEXT req(acntId='{}', email='{}') session(acntId='{}', email='{}')",
					acntId, email, acntInSession, emailInSession);
			return ResponseEntity.badRequest().body("MISMATCH_CONTEXT");
		}

		if (!code.equals(codeInSession)) {
			log.warn("[AccountRecoveryController] resetPassword :: INVALID_CODE acntId='{}'", acntId);
			return ResponseEntity.badRequest().body("INVALID_CODE");
		}

		int matchCount = ditAccountMapper.existsByAcntIdAndEmail(acntId, email);
		if (matchCount == 0) {
			log.warn("[AccountRecoveryController] resetPassword :: NO_MATCH acntId='{}', email='{}'",
					acntId, email);
			clearResetSession(session);
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body("NO_MATCH");
		}
		
		String encoded = bCryptPasswordEncoder.encode(newPassword);
		log.info("[AccountRecoveryController] encoded(resetPassword) :: "+ encoded);
		
		int updated = ditAccountMapper.updatePasswordByAcntIdAndEmail(acntId, email, encoded);
		if (updated <= 0) {
			log.error("[AccountRecoveryController] resetPassword :: UPDATE_FAIL acntId='{}', email='{}'",
					acntId, email);
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("UPDATE_FAIL");
		}

		log.info("[AccountRecoveryController] resetPassword :: SUCCESS acntId='{}', email='{}'",
				acntId, email);

		clearResetSession(session);

		return ResponseEntity.ok("OK");
	}


	/* ======================================================================
	 * 헬퍼 메서드
	 * ==================================================================== */

	/*
      [generateAuthCode 헬퍼]

      1) 의도
         - 비밀번호 재설정용 인증코드를 생성하는 공통 유틸.
         - 영문 대소문자 + 숫자를 섞어 length 길이의 랜덤 문자열 반환.

      2) 데이터 흐름
         입력
           - length: int, 1 이상
         가공
           - "A-Z a-z 0-9" 총 62자 중 하나를 SecureRandom 으로 매번 선택
           - StringBuilder 에 차곡차곡 append
         출력
           - length 길이의 랜덤 문자열

      3) 보안 전제
         - SecureRandom 사용으로 예측 난이도 확보.
         - 코드 재사용은 세션에서만 허용, 플로우 종료 시 clearResetSession 으로 제거.

      4) 유지보수자 가이드
         - 문자 집합을 제한/확장할 경우 이메일 템플릿 안내, UX 문구도 함께 변경.
	 */
	private String generateAuthCode(int length) {
		final String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		SecureRandom random = new SecureRandom();
		StringBuilder sb = new StringBuilder(length);
		for (int i = 0; i < length; i++) {
			int idx = random.nextInt(alphabet.length());
			sb.append(alphabet.charAt(idx));
		}
		return sb.toString();
	}

	/*
      [isValidPasswordPolicy 헬퍼]

      1) 의도
         - 새 비밀번호가 프로젝트에서 정한 최소 정책을 만족하는지 확인.

      2) 정책
         - 길이: 8 이상 20 이하
         - 문자 종류: 다음 세 그룹 중 최소 2종 이상 포함
           1) 영문자 (대/소문자 구분 없이 한 그룹)
           2) 숫자 (0~9)
           3) 기타 문자 (특수문자 포함)

      3) 데이터 흐름
         입력
           - password: 검증 대상 문자열
         가공
           - null / 길이 범위 검사
           - 루프를 돌며 hasLetter, hasDigit, hasSpecial 플래그 세팅
           - 플래그 true 개수(kinds) 계산
         출력
           - kinds >= 2 이면 true, 아니면 false

      4) 유지보수자 가이드
         - 정책 강화(특정 특수문자만 허용 등)를 할 경우
           이 메서드와 JSP PASSWORD_RULE_TEXT, ResetPasswordRequest 제약을 동시에 변경해야 함.
	 */
	private boolean isValidPasswordPolicy(String password) {
		if (password == null) return false;
		int len = password.length();
		if (len < 8 || len > 20) return false;

		boolean hasLetter = false;
		boolean hasDigit = false;
		boolean hasSpecial = false;

		for (char c : password.toCharArray()) {
			if (Character.isLetter(c)) {
				hasLetter = true;
			} else if (Character.isDigit(c)) {
				hasDigit = true;
			} else {
				hasSpecial = true;
			}
		}

		int kinds = 0;
		if (hasLetter)  kinds++;
		if (hasDigit)   kinds++;
		if (hasSpecial) kinds++;

		return kinds >= 2;
	}

	/*
      [resolveClientIp 헬퍼]

      1) 의도
         - 실제 클라이언트의 IP를 최대한 정확하게 얻기 위한 헬퍼.
         - 프록시, 로드밸런서를 거친 경우 X-Forwarded-For 헤더를 우선 활용.

      2) 데이터 흐름
         입력
           - HttpServletRequest
         가공
           - X-Forwarded-For 헤더가 있으면 첫 번째 값을 사용
           - 없으면 request.getRemoteAddr() 사용
         출력
           - 추정된 클라이언트 IP 문자열

      3) 유지보수자 가이드
         - 인프라에서 X-Real-IP, Forwarded 헤더를 사용한다면 해당 헤더도 함께 고려하도록 확장 가능.
	 */
	private String resolveClientIp(HttpServletRequest request) {
		String xff = request.getHeader("X-Forwarded-For");
		if (xff != null && !xff.isBlank()) {
			int comma = xff.indexOf(',');
			return (comma > -1) ? xff.substring(0, comma).trim() : xff.trim();
		}
		return request.getRemoteAddr();
	}

	/*
      [maskIpForLog 헬퍼]

      1) 의도
         - IP 전체를 노출하지 않고 일부만 보여주기 위한 마스킹 헬퍼.
         - 메일 템플릿과 로그 메시지에서 Privacy 최소한 보호.

      2) 정책
         - IPv4 "A.B.C.D"  => "A.B.*.*"
         - 그 외 형식(IPV6 등)은 변형 없이 그대로 반환

      3) 유지보수자 가이드
         - 마스킹 수준을 더 강하게/약하게 조정하고 싶으면 여기만 수정.
	 */
	private String maskIpForLog(String ip) {
		if (ip == null || ip.isBlank()) return "";
		String[] parts = ip.split("\\.");
		if (parts.length != 4) return ip;
		return parts[0] + "." + parts[1] + ".*.*";
	}

	/*
      [clearResetSession 헬퍼]

      1) 의도
         - 비밀번호 재설정 플로우에서 사용한 인증 관련 세션 값을 정리.
         - 코드 만료, 비밀번호 변경 완료 등 더 이상 인증 정보가 필요 없을 때 호출.

      2) 데이터 흐름
         입력
           - HttpSession
         가공
           - SESSION_RESET_EMAIL, SESSION_RESET_ACNT_ID,
             SESSION_RESET_AUTH_CODE, SESSION_RESET_AUTH_AT 세션 키 제거
         출력
           - 없음

      3) 유지보수자 가이드
         - RESET_* 상수를 추가/삭제하면 이 메서드에서 함께 관리해야 함.
         - 세션 정리 누락 시, 오래된 인증코드가 남아있어 오동작 가능성이 생김.
	 */
	private void clearResetSession(HttpSession session) {
		session.removeAttribute(SESSION_RESET_EMAIL);
		session.removeAttribute(SESSION_RESET_ACNT_ID);
		session.removeAttribute(SESSION_RESET_AUTH_CODE);
		session.removeAttribute(SESSION_RESET_AUTH_AT);
	}
}
