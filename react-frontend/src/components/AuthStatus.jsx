// src/components/AuthStatus.jsx
import { useMemo } from "react";
import { mask, probeJwt } from "../lib/jwtProbe";

/**
 * [코드 의도]
 * - JWT 진단 결과를 한눈에 표시. 토큰 원문 노출 금지.
 *
 * [데이터 흐름]
 * 입력: props { token, user }
 * 가공: probeJwt(token) → 구조/만료/필수 클레임 점검
 * 출력: 마스크 토큰, 만료 잔여, 이슈 목록, 사용자 요약
 */
export default function AuthStatus({ token, user }) {
  const diag = useMemo(
    () => (token ? probeJwt(token, { requiredKeys: ["iss", "sub", "exp", "roles"], skewSec: 120 }) : null),
    [token]
  );

  if (!token || !diag) return null;

  const badge = diag.ok ? "valid" : "invalid";
  const remain = diag.expRemainingSec != null ? formatRemain(diag.expRemainingSec) : "-";
  const roles = Array.isArray(diag?.payload?.roles) ? diag.payload.roles.join(", ") : "(없음)";

  return (
    <div style={{ border: "1px solid #ddd", borderRadius: 12, padding: 16, marginTop: 16 }}>
      <div style={{ fontWeight: 600, marginBottom: 8 }}>JWT 상태</div>
      <div>토큰: {mask(token)}</div>
      <div>검증: {badge}</div>
      <div>만료 잔여: {remain}</div>
      <div>iss: {diag?.payload?.iss ?? "-"}</div>
      <div>sub: {diag?.payload?.sub ?? "-"}</div>
      <div>roles: {roles}</div>
      {!diag.ok && (
        <div style={{ color: "#b20000", marginTop: 8 }}>
          이슈: {diag.issues.join(", ")}
        </div>
      )}
      {user && (
        <>
          <div style={{ fontWeight: 600, marginTop: 12 }}>사용자</div>
          <div>acntId: {user.acntId}</div>
        </>
      )}
    </div>
  );
}

function formatRemain(sec) {
  const s = Number(sec);
  if (!Number.isFinite(s)) return "-";
  const sign = s < 0 ? "-" : "";
  const x = Math.abs(s);
  const h = Math.floor(x / 3600);
  const m = Math.floor((x % 3600) / 60);
  const r = Math.floor(x % 60);
  return `${sign}${h}h ${m}m ${r}s`;
}
