// src/lib/auth.js
const API = "http://localhost";          // 백엔드 80
const LS_KEY = "accessToken";

export function getToken() { return localStorage.getItem(LS_KEY); }
export function setToken(t) { if (t) localStorage.setItem(LS_KEY, t); }
export function clearToken() { localStorage.removeItem(LS_KEY); }

function pickTokenFromHash() {
  if (!location.hash) return null;
  const params = new URLSearchParams(location.hash.slice(1));
  const t = params.get("accessToken");
  if (t) {
    localStorage.setItem(LS_KEY, t);
    history.replaceState(null, "", location.pathname + location.search);
  }
  return t;
}

async function isTokenValid(token) {
  const res = await fetch(`${API}/api/check2`, {
    method: "POST",
    headers: { "Content-Type": "application/json;charset=UTF-8" },
    body: JSON.stringify({ barer: token }),
  });
  return (await res.text()).trim() === "valid";
}

async function fetchUserByToken(token) {
  const res = await fetch(`${API}/api/token/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json;charset=UTF-8" },
    body: JSON.stringify({ barer: token }),
  });
  if (!res.ok) return null;
  return await res.json();
}

export async function ensureAuth() {
  pickTokenFromHash();
  const token = getToken();
  if (!token) return null;

  try {
    if (!(await isTokenValid(token))) { clearToken(); return null; }
    const user = await fetchUserByToken(token);
    if (!user) { clearToken(); return null; }
    return { token, user };
  } catch { return null; }
}
