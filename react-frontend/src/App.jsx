// src/App.jsx
// [코드 의도] React 19.1.1 + react-router-dom 7.9.4 기준
// - 5173(dev) ↔ /app(prod) 경로 차이를 basename 으로 흡수
// - 로그인 상태를 전역 컨텍스트(AuthCtx)로 제공
// - /admin-handover 에서 저장된 토큰을 부트스트랩해 보호 라우트(/app)로 연결
// - 서버 계약: /api/check2(text/plain), /api/token/login(POST JSON)
// - 로그아웃 및 비로그인 상태는 모두 http://localhost(포트번호)/login(JSP) 로 완전 이동
// - [Debug] : 디버깅용 AuthStatus 컴포넌트를 Shell 하단에 연결해 jwtProbe.js 도 실사용

// [데이터 흐름]
// 1) 초기 마운트 → ensureAuth() → { token, user } 또는 null
// 2) 성공 시 AuthContext 갱신 → ProtectedRoute 통과 → Shell + Outlet + AuthStatus 렌더
// 3) 실패 또는 로그아웃 시 토큰 제거 → RedirectToLogin → http://localhost/login 으로 전체 리다이렉트

// [계약·보안]
// - localStorage 키: accessToken (5173 오리진에 저장됨)
// - 토큰 원문 콘솔 / UI 직접 노출 금지 (AuthStatus 에서도 mask() 사용)
// - 로그인/로그아웃/비로그인 진입 모두 JSP /login URL 을 단일 진입점으로 사용

import {
  createContext,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import {
  createBrowserRouter,
  RouterProvider,
  Outlet,
  Navigate,
  Link,
} from "react-router-dom";
import AdminHandover from "./routes/AdminHandover.jsx";
import { ensureAuth, getToken, clearToken } from "./lib/auth.js";
import AuthStatus from "./components/AuthStatus.jsx"; // [Debug] : JWT 상태 디버깅용 컴포넌트

// JSP 로그인 페이지(URL 은 환경에 맞게 포트만 조정)
const LOGIN_URL = "http://localhost/login"; // 예: http://localhost:8085/login 으로 변경 가능

// 인증 상태 전역 컨텍스트(토큰, 사용자, setAuth, signOut 제공)
const AuthCtx = createContext({
  token: null,
  user: null,
  setAuth: () => {},
  signOut: () => {},
});
export const useAuth = () => useContext(AuthCtx);

function AuthProvider({ children }) {
  const [token, setToken] = useState(null); // 현재 Access Token
  const [user, setUser] = useState(null);   // 현재 사용자 정보(AcntVO)
  const [ready, setReady] = useState(false); // 초기 인증 체크 완료 여부

  useEffect(() => {
    // 마운트 시 한 번만 실행: localStorage + /api/check2 + /api/token/login 으로 인증 상태 재구성
    (async () => {
      const a = await ensureAuth(); // hash → localStorage 픽업 + 토큰 유효성 검증 + 사용자 조회
      if (a) {
        // 인증 성공 시 토큰/사용자 상태 반영
        setToken(a.token);
        setUser(a.user);
      } else {
        // 실패 시 토큰/사용자 상태 초기화
        setToken(null);
        setUser(null);
      }
      setReady(true); // 초기 로딩 완료
    })();
  }, []);

  const value = useMemo(
    () => ({
      token,
      user,
      // 필요 시 외부에서 { token, user } 를 한 번에 세팅할 수 있는 헬퍼
      setAuth: ({ token: t, user: u }) => {
        setToken(t);
        setUser(u);
      },
      // 로그아웃 처리: 토큰 폐기 + JSP 로그인으로 전체 리다이렉트
      signOut: () => {
        clearToken();          // localStorage 에서 accessToken 제거
        setToken(null);        // 컨텍스트 토큰 초기화
        setUser(null);         // 컨텍스트 사용자 정보 초기화
        window.location.href = LOGIN_URL; // 백엔드 JSP 로그인으로 완전 이동
      },
    }),
    [token, user]
  );

  // 초기 인증 상태 확인이 끝나기 전에는 단순 로딩 표시
  if (!ready) return <div style={{ padding: 24 }}>로딩 중...</div>;

  // 이후 모든 하위 트리에서 useAuth() 로 인증 상태 접근 가능
  return <AuthCtx.Provider value={value}>{children}</AuthCtx.Provider>;
}

// 비로그인/토큰 없음 상태에서 JSP 로그인 페이지로 바로 보내는 컴포넌트
function RedirectToLogin() {
  useEffect(() => {
    window.location.href = LOGIN_URL; // React Router 를 우회하고 서버 렌더 로그인 화면으로 이동
  }, []);
  return null; // 렌더링할 UI 없음
}

// 보호 라우트: 토큰 없으면 즉시 JSP 로그인으로 내보냄
function ProtectedRoute() {
  const { token } = useAuth();
  if (!token) return <RedirectToLogin />; // 인증 실패 → JSP /login
  return <Outlet />;                      // 인증 성공 → 하위 라우트 렌더링
}

// 간단한 레이아웃 및 페이지
function Shell() {
  // 글로벌 인증 컨텍스트: 토큰, 사용자, 로그아웃 함수
  const { token, user, signOut } = useAuth();

  return (
    <div
      style={{
        display: "grid",
        gridTemplateColumns: "200px 1fr",
        minHeight: "100vh",
      }}
    >
      {/* 좌측 사이드바: 기본 네비게이션 */}
      <aside style={{ padding: 16, borderRight: "1px solid #eee" }}>
        <h3>스마트 LMS</h3>
        <nav style={{ display: "grid", gap: 8 }}>
          {/* /app 는 index 라우트(Home), /app/dashboard 는 Dashboard */}
          <Link to="/app">Home</Link>
          <Link to="/app/dashboard">Dashboard</Link>
        </nav>
      </aside>

      {/* 우측 메인 영역 */}
      <main style={{ padding: 24 }}>
        {/* 상단 바: 사용자 인사 + 로그아웃 버튼 */}
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            marginBottom: 16,
          }}
        >
          <div>{user ? `안녕하세요, ${user.acntId}` : "비로그인"}</div>
          {user && (
            <button type="button" onClick={signOut}>
              로그아웃
            </button>
          )}
        </div>

        {/* 실제 페이지 내용 출력 영역 */}
        <Outlet />

        {/* [Debug] : 현재 JWT / 사용자 상태 디버깅 패널 (jwtProbe.js, AuthStatus.jsx 실사용) */}
        <AuthStatus token={token} user={user} />
      </main>
    </div>
  );
}

// 단순 테스트용 홈/대시보드 페이지
function Home() {
  return <div>홈</div>;
}
function Dashboard() {
  return <div>대시보드</div>;
}

// 5173(dev) 면 '/', 배포(백엔드 서빙) 면 '/app' 을 basename 으로 사용
const BASENAME = window.location.origin.includes(":5173") ? "/" : "/app";

// 라우터 정의
const router = createBrowserRouter(
  [
    // 관리자 핸드오버: 백엔드에서 code 를 넘겨받아 /api/admin/exchange 로 토큰 교환 후 /app 으로 이동
    { path: "/admin-handover", element: <AdminHandover /> },

    // 보호 구역: /app 이하 경로는 모두 JWT 기반 인증 필요
    {
      path: "/app",
      element: <ProtectedRoute />, // 토큰 없으면 RedirectToLogin
      children: [
        {
          element: <Shell />, // 레이아웃 + 상단바 + AuthStatus
          children: [
            { index: true, element: <Home /> },            // /app
            { path: "dashboard", element: <Dashboard /> }, // /app/dashboard
          ],
        },
      ],
    },

    // 루트 접근(/ 또는 basename 기준 루트) 시
    // - 토큰 있으면 /app 으로 바로 진입
    // - 토큰 없으면 JSP 로그인으로 이동
    {
      path: "/",
      element: <Gate />,
    },
  ],
  { basename: BASENAME }
);

// 루트 진입 판단용 Gate 컴포넌트
function Gate() {
  const t = getToken(); // localStorage 에 저장된 accessToken 직접 조회
  if (t) return <Navigate to="/app" replace />; // 토큰 있으면 보호 구역으로 바로 이동
  return <RedirectToLogin />;                   // 없으면 JSP 로그인으로
}

// 앱 엔트리 포인트
export default function App() {
  return (
    <AuthProvider>
      <RouterProvider router={router} />
    </AuthProvider>
  );
}
