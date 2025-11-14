// src/lib/auth.js

/*
  [코드 의도]
  - React SPA(5173)에서 JWT 기반 인증 상태를 관리하는 헬퍼 모듈.
  - 브라우저 저장소(localStorage)에 Access Token(액세스 토큰)을 읽고/쓰기/삭제하고,
    백엔드(/api/check2, /api/token/login)와의 통신으로 토큰 유효성 및 사용자 정보를 검증한다.
  - App.jsx 의 AuthProvider 가 이 모듈만 호출하면,
    “현재 토큰이 쓸 수 있는 상태인지 + 어떤 사용자 계정인지” 를 한 번에 알 수 있게 설계.

  [데이터 흐름]
  1) pickTokenFromHash()
      - URL 해시(#accessToken=...)에서 accessToken 값을 회수 → localStorage["accessToken"]에 저장
      - history.replaceState 로 해시 제거 (주소창에서 토큰 흔적 삭제)
  2) getToken()/setToken()/clearToken()
      - localStorage["accessToken"]에 접근하는 단일 경로 제공
  3) ensureAuth()
      - 1단계: pickTokenFromHash() 호출 (구 해시 방식 지원)
      - 2단계: getToken() 으로 토큰 존재 여부 확인
      - 3단계: isTokenValid() 로 /api/check2 에 유효성 검증 요청
      - 4단계: fetchUserByToken() 으로 /api/token/login 에서 사용자 정보(AcntVO JSON) 조회
      - 5단계: 중간에 실패 시 clearToken() 으로 토큰 폐기, 성공 시 { token, user } 반환

  [계약 (Contract)]
  - 저장소 계약
    - localStorage 키: "accessToken"
    - 값: JWT 문자열 (예: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
  - /api/check2
    - URL: http://localhost/api/check2
    - Method: POST
    - Request Body(JSON): { "barer": "<토큰 문자열>" }
    - Response: text/plain, "valid" 또는 그 외 문자열
  - /api/token/login
    - URL: http://localhost/api/token/login
    - Method: POST
    - Request Body(JSON): { "barer": "<토큰 문자열>" }
    - Response: 200 OK 시 AcntVO JSON (계정/권한 정보)

  [파라미터 명세]
  - API (상수)
    - 타입: string
    - 의미: 백엔드 서버의 베이스 URL (프론트 dev 환경에서 http://localhost:80 가정)
    - 허용 값: "http://localhost", "http://localhost:8085" 등 환경에 따라 변경 가능
  - LS_KEY (상수)
    - 타입: string
    - 의미: localStorage 저장 키 이름
    - 값: "accessToken"
  - token (함수 인자 공통)
    - 타입: string | null
    - 의미: JWT Access Token
    - 허용 범위: 빈 문자열이 아닌 유효한 JWT 포맷을 기대 (형식 검증은 서버에서 수행)
    - 저장 위치: localStorage["accessToken"], HTTP 요청 body.barer
    - 예시 값: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

  [보안·안전 전제]
  - JWT 를 localStorage에 저장하는 구조이므로,
    전체 프론트 코드에서 XSS(Cross-Site Scripting) 취약점이 생기면 토큰 탈취 위험이 있음.
  - /api/check2, /api/token/login 호출은 Access Token 검증 및 사용자 조회 용도에만 사용해야 하며,
    토큰을 콘솔에 직접 출력하거나 로그에 남기지 않아야 함.
  - 네트워크 구간은 HTTPS 를 전제로 삼아야 하며,
    실제 배포 환경에서는 API 베이스 URL(API 상수)을 https 로 설정해야 안전함.

  [유지보수 가이드]
  - 백엔드 엔드포인트 경로(/api/check2, /api/token/login)나 요청 형식(barer 필드 이름)이 바뀌면,
    isTokenValid(), fetchUserByToken() 의 body 및 응답 처리 부분을 함께 수정해야 한다.
  - Access Token 외에 Refresh Token 기반 구조를 도입할 경우,
    이 모듈은 “Access Token 상태 관리”에 집중시키고,
    Refresh Token 교환 로직은 별도 모듈/함수로 분리하는 것이 유지보수에 유리하다.
*/

const API = "http://localhost";          // 백엔드 베이스 URL (현재는 로컬 80 포트 기준)
const LS_KEY = "accessToken";            // localStorage 에서 사용할 토큰 저장 키

// localStorage 에서 Access Token 조회
export function getToken() {
  return localStorage.getItem(LS_KEY);
}

// localStorage 에 Access Token 저장
export function setToken(t) {
  if (t) localStorage.setItem(LS_KEY, t);
}

// localStorage 에서 Access Token 제거
export function clearToken() {
  localStorage.removeItem(LS_KEY);
}

// URL 해시에서 accessToken=... 값을 회수해 localStorage 에 이관
function pickTokenFromHash() {
  // 해시가 없으면 바로 종료
  if (!location.hash) return null;

  // '#accessToken=...' 에서 앞의 '#' 제거 후 쿼리 파라미터로 파싱
  const params = new URLSearchParams(location.hash.slice(1));

  // 'accessToken' 파라미터 값 추출 (JWT 문자열)
  const t = params.get("accessToken");

  if (t) {
    // 해시에서 얻은 토큰을 localStorage 로 저장
    localStorage.setItem(LS_KEY, t);

    // 주소창에서 '#accessToken=...' 부분 제거 (페이지 리로드 없이 정리)
    history.replaceState(null, "", location.pathname + location.search);
  }

  // 회수에 성공하면 토큰 문자열, 아니면 null
  return t;
}

// /api/check2 에 토큰 유효성 검증 요청
async function isTokenValid(token) {
  const res = await fetch(`${API}/api/check2`, {
    method: "POST",
    headers: { "Content-Type": "application/json;charset=UTF-8" },
    // 서버 계약: { "barer": "<토큰 문자열>" } 형식으로 전달
    body: JSON.stringify({ barer: token }),
  });

  // 응답 본문이 "valid" 문자열이면 유효, 아니면 무효로 판정
  return (await res.text()).trim() === "valid";
}

// /api/token/login 에 토큰을 전달해 사용자 정보(AcntVO JSON) 조회
async function fetchUserByToken(token) {
  const res = await fetch(`${API}/api/token/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json;charset=UTF-8" },
    // 마찬가지로 { "barer": "<토큰 문자열>" } 계약 유지
    body: JSON.stringify({ barer: token }),
  });

  // HTTP 레벨에서 실패한 경우 null 반환 (인증/계정 문제 등)
  if (!res.ok) return null;

  // 성공 시 AcntVO JSON (계정 정보) 반환
  return await res.json();
}

// 전체 인증 상태를 재구성하는 진입점
// - hash → localStorage 회수
// - 토큰 유효성 검사
// - 토큰으로 사용자 정보 조회
// - 최종적으로 { token, user } 또는 null 반환
export async function ensureAuth() {
  // 1) 구 방식(해시)으로 전달된 토큰이 있으면 localStorage 로 옮기고 URL 정리
  pickTokenFromHash();

  // 2) 현재 localStorage 에 저장된 토큰 조회
  const token = getToken();
  if (!token) return null; // 토큰이 없으면 인증 상태 없음

  try {
    // 3) /api/check2 로 토큰 유효성 검증
    const ok = await isTokenValid(token);
    if (!ok) {
      // 유효하지 않으면 토큰 삭제 후 인증 실패 처리
      clearToken();
      return null;
    }

    // 4) /api/token/login 으로 사용자 정보 조회
    const user = await fetchUserByToken(token);
    if (!user) {
      // 사용자 정보 조회 실패 시에도 토큰 폐기
      clearToken();
      return null;
    }

    // 5) 토큰과 사용자 정보를 함께 반환 (AuthProvider 가 컨텍스트에 저장)
    return { token, user };
  } catch {
    // 네트워크 오류 등 예외 발생 시 인증 실패로 처리 (토큰은 그대로 둘 수도 있지만,
    // 보수적으로 보려면 여기서 clearToken() 을 호출하는 것도 한 옵션임)
    return null;
  }
}
