// src/routes/AdminHandover.jsx
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function AdminHandover(){
  const nav = useNavigate();
  const [msg, setMsg] = useState("권한 교환 진행중...");
  useEffect(() => {
    const p = new URLSearchParams(location.search);
    const code = p.get("code");
    if(!code){ setMsg("code 없음"); return; }
    (async ()=>{
      try{
        const res = await fetch("/api/admin/exchange", {
          method:"POST",
          headers:{ "Content-Type":"application/json;charset=UTF-8" },
          body: JSON.stringify({ code })
        });
        if(!res.ok){ setMsg("교환 실패"); return; }
        // 서버가 text/plain 토큰만 줄 수도 있으니 양쪽 처리
        let token;
        const ct = res.headers.get("Content-Type")||"";
        if(ct.includes("application/json")){
          const j = await res.json();
          token = j?.accessToken ?? j?.token ?? null;
        }else{
          token = (await res.text()).trim();
        }
        if(!token){ setMsg("토큰 없음"); return; }
        localStorage.setItem("accessToken", token); // ← 5173 오리진에 저장
        nav("/app"); // 또는 /app/admin
      }catch(e){
        setMsg("네트워크 오류");
      }
    })();
  },[]);
  return <div style={{padding:24}}>{msg}</div>;
}
