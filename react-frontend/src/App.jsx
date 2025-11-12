// src/App.jsx
// [코드 의도] React 19.1.1 + react-router-dom 7.9.4 기준
// - 5173(dev)↔/app(prod) 경로 차이를 basename으로 흡수
// - 로그인 상태를 전역 컨텍스트로 제공
// - /admin-handover에서 저장된 토큰을 부트스트랩해 보호 라우트로 연결
// - 서버와의 계약: /api/check2(text/plain), /api/token/login(POST JSON)

// [데이터 흐름]
// 1) 초기 마운트 → ensureAuth() → {token,user} 또는 null
// 2) 성공 시 AuthContext 갱신 → 보호 라우트 통과
// 3) 실패 시 토큰 제거 → /login로 유도(여기선 백엔드 JSP 사용하므로 안내만)

// [계약·보안]
// - localStorage 키: accessToken (5173 오리진에 저장됨)
// - 토큰 원문 콘솔 출력 금지

import { createContext, useContext, useEffect, useMemo, useState } from "react";
import { createBrowserRouter, RouterProvider, Outlet, Navigate, Link } from "react-router-dom";
import AdminHandover from "./routes/AdminHandover.jsx";
import { ensureAuth, getToken, clearToken } from "./lib/auth.js";

const AuthCtx = createContext({ token: null, user: null, setAuth: () => {}, signOut: () => {} });
export const useAuth = () => useContext(AuthCtx);

function AuthProvider({ children }) {
  const [token, setToken] = useState(null);
  const [user, setUser] = useState(null);
  const [ready, setReady] = useState(false);

  useEffect(() => {
    (async () => {
      const a = await ensureAuth(); // hash→LS 픽업 + /api/check2 + /api/token/login
      if (a) { setToken(a.token); setUser(a.user); }
      else { setToken(null); setUser(null); }
      setReady(true);
    })();
  }, []);

  const value = useMemo(() => ({
    token, user,
    setAuth: ({ token: t, user: u }) => { setToken(t); setUser(u); },
    signOut: () => { clearToken(); setToken(null); setUser(null); }
  }), [token, user]);

  if (!ready) return <div style={{ padding: 24 }}>로딩 중...</div>;
  return <AuthCtx.Provider value={value}>{children}</AuthCtx.Provider>;
}

function ProtectedRoute() {
  const { token } = useAuth();
  if (!token) return <Navigate to="/login-bridge" replace />;
  return <Outlet />;
}

// 간단한 레이아웃 및 페이지
function Shell() {
  const { user, signOut } = useAuth();
  return (
    <div style={{ display: "grid", gridTemplateColumns: "200px 1fr", minHeight: "100vh" }}>
      <aside style={{ padding: 16, borderRight: "1px solid #eee" }}>
        <h3>스마트 LMS</h3>
        <nav style={{ display: "grid", gap: 8 }}>
          <Link to="/app">Home</Link>
          <Link to="/app/dashboard">Dashboard</Link>
        </nav>
      </aside>
      <main style={{ padding: 24 }}>
        <div style={{ display: "flex", justifyContent: "space-between", marginBottom: 16 }}>
          <div>{user ? `안녕하세요, ${user.acntId}` : "비로그인"}</div>
          {user && <button onClick={signOut}>로그아웃</button>}
        </div>
        <Outlet />
      </main>
    </div>
  );
}

function Home() { return <div>홈</div>; }
function Dashboard() { return <div>대시보드</div>; }

// 백엔드 JSP 로그인으로 유도하는 더미 페이지
function LoginBridge() {
  return (
    <div style={{ padding: 24 }}>
      <p>로그인이 필요합니다.</p>
      <a href="/login">/login 이동</a>
    </div>
  );
}

// 5173(dev)면 '/', 배포(백엔드 서빙)면 '/app'
const BASENAME = window.location.origin.includes(":5173") ? "/" : "/app";

const router = createBrowserRouter(
  [
    // 관리자 핸드오버: 5173 오리진에 토큰 저장 후 내부 라우팅
    { path: "/admin-handover", element: <AdminHandover /> },

    // 보호 구역
    {
      path: "/app",
      element: <ProtectedRoute />, // 토큰 없으면 /login-bridge
      children: [
        {
          element: <Shell />,
          children: [
            { index: true, element: <Home /> },
            { path: "dashboard", element: <Dashboard /> },
          ],
        },
      ],
    },

    // 로그인 브리지
    { path: "/login-bridge", element: <LoginBridge /> },

    // 루트 접근 시 토큰 있으면 /app, 없으면 /login-bridge
    {
      path: "/",
      element: <Gate />,
    },
  ],
  { basename: BASENAME }
);

function Gate() {
  const t = getToken();
  return t ? <Navigate to="/app" replace /> : <Navigate to="/login-bridge" replace />;
}

export default function App() {
  return (
    <AuthProvider>
      <RouterProvider router={router} />
    </AuthProvider>
  );
}
