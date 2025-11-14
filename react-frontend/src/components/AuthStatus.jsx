// src/components/AuthStatus.jsx

/*
  [코드 의도]
  - JWT 진단 결과를 관리자/개발자가 한눈에 확인할 수 있는 상태 패널 컴포넌트.
  - 토큰 구조, 만료(exp), 필수 클레임(iss, sub, exp, roles)과 문제(issues)를 시각적으로 확인.
  - 토큰 원문은 mask() 로 일부만 노출하고, 절대 전체 문자열을 UI에 그대로 출력하지 않음.

  [데이터 흐름]
  입력:
    - props.token: 현재 로그인 사용자의 JWT 문자열 (또는 null/undefined)
    - props.user: /api/token/login 응답으로 받은 사용자 정보(AcntVO JSON)
  가공:
    1) token 이 존재하면 probeJwt(token, {requiredKeys, skewSec}) 호출
    2) probeJwt 가 header/payload, expRemainingSec, issues 등을 계산
    3) roles, iss, sub 등의 값을 UI 표시용으로 문자열 가공
  출력:
    - 토큰 마스크(mask(token)), 검증 상태(valid/invalid), 만료 잔여(formatRemain),
      iss/sub/roles, 이슈 목록, 사용자 계정 요약(acntId)

  [계약 (Contract)]
  - token
    - 형식: "헤더.페이로드.서명" 구조의 JWT 문자열 또는 falsy 값
    - 토큰이 없으면 컴포넌트는 null 을 반환(렌더링하지 않음)
  - user
    - 구조 예시: { acntId: string, ... }
    - user 가 없으면 JWT 상태만 표시하고 사용자 섹션은 생략

  [파라미터 명세]
  - props.token: string | null | undefined
    - 의미: 검사 대상 JWT
    - 허용: RFC 7519 포맷 JWT, 또는 falsy
  - props.user: object | null | undefined
    - 의미: 로그인된 사용자 정보(백엔드 AcntVO 매핑)
    - 주요 필드: acntId (계정 아이디)

  [보안·안전 전제]
  - mask() 를 사용해 토큰 원문 전체 노출을 방지.
  - 이 컴포넌트는 디버깅/상태 표시용이며, probeJwt 결과가 ok 라고 해서
    실제 운영 상의 인증/인가 성공을 보장하는 것은 아님(최종 판단은 서버/상위 로직).
  - roles 정보는 단순 표시이며, UI에서 역할 이름으로 직접 권한 결정을 하지 않고,
    서버 측 판정 결과를 따르는 구조를 전제로 함.

  [유지보수 가이드]
  - 필수 클레임 목록이 변경되면 probeJwt 호출부(requiredKeys: ["iss","sub","exp","roles"])를 수정.
  - roles 구조가 배열이 아닌 문자열/객체로 바뀌면 roles 가공 부분을 함께 조정.
  - 스타일을 확장할 경우, inline style 대신 CSS 클래스(App.css 등)에 옮기는 것이 재사용에 유리.
*/

import { useMemo } from "react";
import { mask, probeJwt } from "../lib/jwtProbe";

export default function AuthStatus({ token, user }) {
  // token 이 바뀔 때만 JWT 진단을 다시 수행 (불필요한 재계산 방지)
  const diag = useMemo(
    () =>
      token
        ? probeJwt(token, {
            // 필수 클레임: iss(발급자), sub(주체), exp(만료), roles(권한/역할)
            requiredKeys: ["iss", "sub", "exp", "roles"],
            // 허용 시계 오차 120초 (서버/클라이언트 시간 차이 흡수)
            skewSec: 120,
          })
        : null,
    [token]
  );

  // 토큰이 없거나, 진단 결과가 없으면 아무 것도 렌더링하지 않음
  if (!token || !diag) return null;

  // 전체 진단 결과: 문제 이슈가 없으면 valid, 하나라도 있으면 invalid
  const badge = diag.ok ? "valid" : "invalid";

  // expRemainingSec 을 사람이 읽기 쉬운 h/m/s 포맷으로 변환
  const remain = diag.expRemainingSec != null ? formatRemain(diag.expRemainingSec) : "-";

  // payload.roles 가 배열이면 "role1, role2" 문자열로 합치고, 아니면 "(없음)"으로 표시
  const roles = Array.isArray(diag?.payload?.roles) ? diag.payload.roles.join(", ") : "(없음)";

  return (
    <div
      style={{
        border: "1px solid #ddd",
        borderRadius: 12,
        padding: 16,
        marginTop: 16,
      }}
    >
      <div style={{ fontWeight: 600, marginBottom: 8 }}>JWT 상태</div>

      {/* 토큰 원문 대신 mask() 결과만 노출 */}
      <div>토큰: {mask(token)}</div>

      {/* probeJwt 결과의 ok 여부를 valid/invalid 텍스트로 표시 */}
      <div>검증: {badge}</div>

      {/* 만료까지 남은 시간(h/m/s), 계산 불가 시 '-' */}
      <div>만료 잔여: {remain}</div>

      {/* 발급자(iss) / 주체(sub) 표시, 없으면 '-' */}
      <div>iss: {diag?.payload?.iss ?? "-"}</div>
      <div>sub: {diag?.payload?.sub ?? "-"}</div>

      {/* roles 배열을 쉼표로 연결해 표시 */}
      <div>roles: {roles}</div>

      {/* 이슈가 있을 경우 빨간색으로 문제 목록 출력 */}
      {!diag.ok && (
        <div style={{ color: "#b20000", marginTop: 8 }}>
          이슈: {diag.issues.join(", ")}
        </div>
      )}

      {/* user 정보가 있으면 계정 요약 섹션 추가 */}
      {user && (
        <>
          <div style={{ fontWeight: 600, marginTop: 12 }}>사용자</div>
          <div>acntId: {user.acntId}</div>
        </>
      )}
    </div>
  );
}

// expRemainingSec(초 단위)를 "±Hh Mm Ss" 문자열로 변환
function formatRemain(sec) {
  const s = Number(sec);
  if (!Number.isFinite(s)) return "-";

  // 음수면 '-' 접두어로 표시 (만료 경과 시간 의미)
  const sign = s < 0 ? "-" : "";
  const x = Math.abs(s);

  const h = Math.floor(x / 3600); // 시간
  const m = Math.floor((x % 3600) / 60); // 분
  const r = Math.floor(x % 60); // 초

  return `${sign}${h}h ${m}m ${r}s`;
}
