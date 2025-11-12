// 목적: 브라우저에서 JWT 구조·만료·필수 클레임을 점검
// 보안: 토큰 원문 콘솔 출력 금지. mask()로만 노출
// 계약: RFC 7519 기준. exp, iat, nbf 초 단위 가정

const REQUIRED_KEYS = ["iss", "sub", "exp"]; // 필요 시 ["roles"] 등 추가
const DEFAULT_SKEW_SEC = 90; // 시계 오차 허용

export function mask(token) {
  if (!token || token.length <= 20) return "<null/short>";
  return token.slice(0, 10) + "..." + token.slice(-6);
}

function b64urlToUtf8(b64url) {
  // 패딩 보정
  let b64 = b64url.replace(/-/g, "+").replace(/_/g, "/");
  const pad = b64.length % 4;
  if (pad) b64 += "=".repeat(4 - pad);
  try {
    const bytes = atob(b64);
    // UTF-8 디코드
    const arr = Uint8Array.from(bytes, c => c.charCodeAt(0));
    return new TextDecoder().decode(arr);
  } catch {
    return null;
  }
}

function safeJson(str) {
  try { return JSON.parse(str); } catch { return null; }
}

export function parseJwt(token) {
  if (!token || typeof token !== "string") return { header: null, payload: null };
  const parts = token.split(".");
  if (parts.length !== 3) return { header: null, payload: null };
  const h = safeJson(b64urlToUtf8(parts[0]));
  const p = safeJson(b64urlToUtf8(parts[1]));
  return { header: h, payload: p };
}

/**
 * probeJwt
 * - 구조, 필수 클레임, 만료, 유효시점 점검
 * @param {string} token
 * @param {{requiredKeys?:string[], skewSec?:number}} opts
 * @returns {{
 *   ok:boolean, issues:string[], header:object|null, payload:object|null,
 *   expRemainingSec:number|null, iatAgoSec:number|null, nbfInFutureSec:number|null
 * }}
 */
export function probeJwt(token, opts = {}) {
  const required = opts.requiredKeys || REQUIRED_KEYS;
  const skew = Number.isFinite(opts.skewSec) ? opts.skewSec : DEFAULT_SKEW_SEC;

  const issues = [];
  const { header, payload } = parseJwt(token);
  if (!header || !payload) {
    return { ok: false, issues: ["malformed"], header, payload,
             expRemainingSec: null, iatAgoSec: null, nbfInFutureSec: null };
  }

  // 필수 클레임
  for (const k of required) {
    if (!(k in payload)) issues.push(`missing:${k}`);
  }

  const nowSec = Math.floor(Date.now() / 1000);

  // exp 만료
  let expRemainingSec = null;
  if (typeof payload.exp === "number") {
    expRemainingSec = payload.exp - nowSec;
    if (expRemainingSec < -skew) issues.push("expired");
  } else {
    issues.push("missing:exp");
  }

  // iat 발급 시각
  let iatAgoSec = null;
  if (typeof payload.iat === "number") {
    iatAgoSec = nowSec - payload.iat;
    if (iatAgoSec < -skew) issues.push("iat_in_future");
  }

  // nbf 활성 시각
  let nbfInFutureSec = null;
  if (typeof payload.nbf === "number") {
    nbfInFutureSec = payload.nbf - nowSec;
    if (nbfInFutureSec > skew) issues.push("nbf_in_future");
  }

  // alg 헤더 방어
  if (!header.alg || header.alg === "none") issues.push("bad_alg");

  const ok = issues.length === 0;
  return { ok, issues, header, payload, expRemainingSec, iatAgoSec, nbfInFutureSec };
}
