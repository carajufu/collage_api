// src/lib/jwtProbe.js

/*
  [코드 의도]
  - 브라우저 환경에서 JWT(JSON Web Token, JSON 기반 토큰 포맷) 구조와 만료(exp), 발급(iat), 활성 시각(nbf) 등
    필수 클레임(claim, 토큰에 담기는 키-값)을 정적 분석하는 유틸리티.
  - 토큰 원문은 절대 콘솔 또는 UI에 그대로 노출하지 않고, mask()로 일부만 가려서 보여주도록 강제한다.
  - RFC 7519(JWT 표준) 규약을 전제로 초 단위 Unix time 기반으로 동작한다.

  [데이터 흐름]
  1) mask(token)
      - 토큰이 충분히 길면 앞/뒤 일부만 남기고 나머지는 "..." 로 마스킹해 표시용 문자열만 생성.
  2) parseJwt(token)
      - 토큰을 '.' 기준으로 3분할(header.payload.signature).
      - header, payload 부분을 Base64URL 디코딩 → JSON 파싱 → { header, payload } 구조 반환.
  3) probeJwt(token, opts)
      - parseJwt(token) 결과를 입력으로 받아 구조/필수 클레임/시간 관련 속성을 점검.
      - requiredKeys, 허용 시계 오차(skewSec)를 옵션으로 받음.
      - 결과로 ok(boolean), issues(문제 목록), header/payload, expRemainingSec, iatAgoSec, nbfInFutureSec 반환.

  [계약 (Contract)]
  - 토큰 형식
    - "헤더.페이로드.서명" 구조의 JWT 문자열만 유효 대상으로 본다.
    - exp, iat, nbf 클레임은 모두 초 단위 Unix time 정수라고 가정한다.
  - 클라이언트 사용 방식
    - probeJwt(token, { requiredKeys, skewSec }) 로 호출.
    - 반환된 issues 배열에 "expired", "missing:exp", "bad_alg" 등이 들어 있으면 해당 토큰을 신뢰하지 않는다.
  - 보안 원칙
    - 이 모듈은 분석만 수행하며, 토큰을 네트워크로 전송하지 않는다.
    - 토큰 원문을 콘솔 또는 UI에 그대로 출력하지 않고, mask() 결과만 사용해야 한다.

  [파라미터 명세]
  - token (string)
    - 의미: 검사 대상 JWT 문자열.
    - 허용 범위: "xxx.yyy.zzz" 형식 문자열. 그 외는 malformed 로 간주.
  - opts (object, 선택)
    - requiredKeys (string[])
      - 의미: payload 에 반드시 존재해야 하는 클레임 키 목록.
      - 기본값: REQUIRED_KEYS 상수(["iss", "sub", "exp"]).
    - skewSec (number)
      - 의미: 서버/클라이언트 시계 오차 허용 범위(초 단위).
      - 기본값: DEFAULT_SKEW_SEC (90).

  [보안·안전 전제]
  - 이 모듈은 토큰을 해석만 하며, 실제 인증/인가 판단은 서버 또는 상위 로직에서 해야 한다.
  - header.alg 가 "none" 이거나 비어 있으면 "bad_alg" 이슈를 추가해 위험 토큰으로 표시한다.
  - exp, iat, nbf 는 단순 시간 계산만 수행하고, 정책(예: 너무 오래된 토큰 차단)은 호출자가 판단해야 한다.

  [유지보수 가이드]
  - 필수 클레임 정책 변경 시 REQUIRED_KEYS 상수를 업데이트하거나 probeJwt 호출부에서 opts.requiredKeys 로 오버라이드할 것.
  - exp/iat/nbf 가 밀리초 단위 등 다른 스펙으로 바뀌면, nowSec 계산과 비교 방식(초 단위)을 함께 조정해야 한다.
  - Node.js 환경 등 atob/TextDecoder 가 없는 런타임에서 사용할 경우, b64urlToUtf8 구현을 환경에 맞게 교체해야 한다.
*/

const REQUIRED_KEYS = ["iss", "sub", "exp"]; // 기본 필수 클레임 목록 (발급자, 주체, 만료 시각)
const DEFAULT_SKEW_SEC = 90;                // 시계 오차 허용(90초)

// JWT 원문을 그대로 노출하지 않고 앞/뒤 일부만 보여주는 마스킹 함수
export function mask(token) {
  if (!token || token.length <= 20) return "<null/short>"; // 너무 짧으면 단순 태그 반환
  // 앞 10글자 + "..." + 뒤 6글자만 남김
  return token.slice(0, 10) + "..." + token.slice(-6);
}

// Base64URL 문자열을 UTF-8 문자열로 디코딩
function b64urlToUtf8(b64url) {
  // Base64URL → Base64 변환 (-, _ 치환)
  let b64 = b64url.replace(/-/g, "+").replace(/_/g, "/");
  // 길이가 4의 배수가 되도록 패딩('=' ) 추가
  const pad = b64.length % 4;
  if (pad) b64 += "=".repeat(4 - pad);
  try {
    // atob로 Base64 디코딩 → 바이너리 문자열
    const bytes = atob(b64);
    // 바이너리 문자열을 Uint8Array 로 변환
    const arr = Uint8Array.from(bytes, c => c.charCodeAt(0));
    // TextDecoder 로 UTF-8 문자열로 복원
    return new TextDecoder().decode(arr);
  } catch {
    // 디코딩 실패 시 null 반환
    return null;
  }
}

// JSON 파싱을 시도하고 실패 시 null 반환
function safeJson(str) {
  try {
    return JSON.parse(str);
  } catch {
    return null;
  }
}

// JWT 문자열을 header/payload 객체로 파싱
export function parseJwt(token) {
  if (!token || typeof token !== "string") return { header: null, payload: null };

  // 토큰을 '.' 기준으로 분할 (헤더, 페이로드, 서명)
  const parts = token.split(".");
  if (parts.length !== 3) return { header: null, payload: null };

  // 헤더/페이로드 부분을 Base64URL → UTF-8 → JSON 으로 파싱
  const h = safeJson(b64urlToUtf8(parts[0]));
  const p = safeJson(b64urlToUtf8(parts[1]));

  return { header: h, payload: p };
}

/**
 * probeJwt
 * - JWT 구조, 필수 클레임 존재 여부, 만료(exp), 발급(iat), 활성 시각(nbf)을 점검.
 * @param {string} token        검사할 JWT 문자열
 * @param {{requiredKeys?:string[], skewSec?:number}} opts
 *   - requiredKeys: payload 에 반드시 존재해야 하는 필수 클레임 키 목록
 *   - skewSec: 시계 오차 허용 범위(초 단위)
 * @returns {{
 *   ok:boolean, issues:string[], header:object|null, payload:object|null,
 *   expRemainingSec:number|null, iatAgoSec:number|null, nbfInFutureSec:number|null
 * }}
 */
export function probeJwt(token, opts = {}) {
  // 필수 클레임 목록: opts.requiredKeys 우선, 없으면 REQUIRED_KEYS 사용
  const required = opts.requiredKeys || REQUIRED_KEYS;
  // 시계 오차 허용: 유효한 숫자가 들어오면 사용, 아니면 기본값
  const skew = Number.isFinite(opts.skewSec) ? opts.skewSec : DEFAULT_SKEW_SEC;

  const issues = [];
  const { header, payload } = parseJwt(token);

  // 기본 구조(header/payload) 파싱 실패 시 즉시 malformed 판정
  if (!header || !payload) {
    return {
      ok: false,
      issues: ["malformed"],          // 구조 자체가 깨진 토큰
      header,
      payload,
      expRemainingSec: null,
      iatAgoSec: null,
      nbfInFutureSec: null,
    };
  }

  // 필수 클레임 존재 여부 점검
  for (const k of required) {
    if (!(k in payload)) issues.push(`missing:${k}`);
  }

  // 현재 시각(초 단위 Unix time)
  const nowSec = Math.floor(Date.now() / 1000);

  // exp(만료 시각) 점검
  let expRemainingSec = null;
  if (typeof payload.exp === "number") {
    // 만료까지 남은 시간 = exp - now
    expRemainingSec = payload.exp - nowSec;
    // expRemainingSec 가 음수이고, 허용 오차(skew)를 넘을 만큼 지났으면 expired
    if (expRemainingSec < -skew) issues.push("expired");
  } else {
    // exp 자체가 없으면 필수 만료 정보 누락으로 처리
    issues.push("missing:exp");
  }

  // iat(발급 시각) 점검
  let iatAgoSec = null;
  if (typeof payload.iat === "number") {
    // 발급 이후 경과 시간 = now - iat
    iatAgoSec = nowSec - payload.iat;
    // iat 가 현재보다 미래로 찍혀 있고, 허용 오차 이상이면 문제로 처리
    if (iatAgoSec < -skew) issues.push("iat_in_future");
  }

  // nbf(Not Before, 활성 시작 시각) 점검
  let nbfInFutureSec = null;
  if (typeof payload.nbf === "number") {
    // 활성까지 남은 시간 = nbf - now
    nbfInFutureSec = payload.nbf - nowSec;
    // nbf 가 현재보다 충분히 미래라면 아직 사용하면 안 되는 토큰
    if (nbfInFutureSec > skew) issues.push("nbf_in_future");
  }

  // alg 헤더 방어: "none" 또는 비어 있으면 위험 토큰으로 표시
  if (!header.alg || header.alg === "none") issues.push("bad_alg");

  // 이슈가 하나도 없으면 ok=true, 하나라도 있으면 ok=false
  const ok = issues.length === 0;

  return {
    ok,
    issues,
    header,
    payload,
    expRemainingSec,
    iatAgoSec,
    nbfInFutureSec,
  };
}
