// src/routes/AdminHandover.jsx

/*
  [코드 의도]
  - Spring Security 세션 기반 관리자 로그인 이후,
    1회용 code를 사용해 JWT(Access Token, 액세스 토큰)를 발급받는 React 브릿지 화면.
  - /api/admin/exchange(POST JSON)와 통신해 토큰을 5173 오리진 localStorage에 저장하고,
    보호 라우트(/app)로 연결하는 “세션 세계 ↔ JWT 세계” 연결 지점.

  [데이터 흐름]
  1) 컴포넌트 마운트 시 URL 쿼리에서 code 추출 (?code=...)
  2) code가 있으면 /api/admin/exchange에 { code } JSON POST
  3) 응답에서 accessToken 추출 (text/plain 또는 application/json 모두 대응)
  4) localStorage["accessToken"]에 저장
  5) 저장 성공 시 /app으로 내비게이트
  6) 실패(code 없음, 교환 실패, 토큰 없음, 네트워크 오류)는 msg 상태를 통해 화면에 표시

  [계약 (Contract)]
  - 요청
    - URL: /api/admin/exchange
    - Method: POST
    - Headers: Content-Type: application/json;charset=UTF-8
    - Body: { "code": "<1회용 코드 문자열>" }
  - 응답
    - 성공 시
      - Content-Type: text/plain → 본문 전체가 토큰 문자열
      - 또는 Content-Type: application/json → { "accessToken": "..." } 또는 { "token": "..." }
    - 실패 시
      - HTTP 4xx/5xx → res.ok === false

  [보안·안전 전제]
  - accessToken은 localStorage(Web Storage, 브라우저 키-값 저장소)에 저장되므로,
    전체 프론트엔드에서 XSS(Cross-Site Scripting, 스크립트 삽입 공격)를 강하게 방어해야 함.
  - AdminHandover는 서버가 이미
    1) 세션 인증 성공
    2) 관리자 권한 검증
    3) AdminHandoverCodeStore.issue(...) 로 code 발급
    까지 끝낸 뒤 리다이렉트한 시점에만 접근된다는 전제를 가짐.
  - code는 서버 측에서 단 한 번만 consume 가능한 일회용 토큰이어야 하며,
    재사용 시 무효가 돼야 함.

  [유지보수 가이드]
  - /api/admin/exchange의 응답 포맷이 변경되면,
    아래 Content-Type 분기(ct.includes("application/json"))와 토큰 추출 부분을 함께 수정해야 함.
  - localStorage 키 이름("accessToken")을 변경하면,
    App.jsx, lib/auth.js 등에서 사용하는 키 이름도 반드시 같이 변경해야 함.
*/

import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function AdminHandover() {
  const nav = useNavigate();
  const [msg, setMsg] = useState("권한 교환 진행중..."); // 화면에 표시할 진행/오류 메시지

  useEffect(() => {
    // 1) 현재 URL 쿼리스트링에서 ?code=... 값 추출
    const p = new URLSearchParams(location.search);
    const code = p.get("code");

    // code가 없으면 교환 시나리오 자체가 성립하지 않으므로 즉시 에러 메시지 설정
    if (!code) {
      setMsg("code 없음");
      return;
    }

    // 2) 비동기 즉시 실행 함수로 /api/admin/exchange 호출
    (async () => {
      try {
        const res = await fetch("/api/admin/exchange", {
          method: "POST",
          headers: { "Content-Type": "application/json;charset=UTF-8" },
          // 서버 계약: { "code": "<1회용 코드>" } JSON 전달
          body: JSON.stringify({ code }),
        });

        // HTTP 레벨에서 실패한 경우 (4xx/5xx)
        if (!res.ok) {
          setMsg("교환 실패");
          return;
        }

        // 3) 응답 Content-Type에 따라 토큰 파싱 방식 분기
        //    - application/json: { accessToken: "..."} 또는 { token: "..." }
        //    - 그 외(text/plain 등): 본문 전체를 토큰 문자열로 간주
        let token;
        const ct = res.headers.get("Content-Type") || "";

        if (ct.includes("application/json")) {
          const j = await res.json();
          token = j?.accessToken ?? j?.token ?? null;
        } else {
          token = (await res.text()).trim();
        }

        // 토큰이 비어 있으면 논리적 실패로 간주
        if (!token) {
          setMsg("토큰 없음");
          return;
        }

        // 4) 5173(dev) 오리진의 localStorage에 accessToken 저장
        //    이후 App.jsx/AuthProvider + lib/auth.js 가 이 값을 읽어 인증 상태를 구성
        localStorage.setItem("accessToken", token);

        // 5) 보호 라우트(/app)로 이동
        nav("/app");
      } catch (e) {
        // 네트워크 오류, JSON 파싱 오류 등 모든 런타임 예외를 포괄 처리
        setMsg("네트워크 오류");
      }
    })();
  }, [nav]);

  // 진행/에러 상태만 텍스트로 보여주는 간단한 상태 화면
  return <div style={{ padding: 24 }}>{msg}</div>;
}
