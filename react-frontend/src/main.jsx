// src/main.jsx 또는 src/index.jsx (Vite 기본 엔트리 파일)

/*
  [코드 의도]
  - 브라우저 DOM 의 #root 요소에 React 애플리케이션(App)을 마운트하는 엔트리 포인트.
  - React.StrictMode(개발 모드 엄격 모드)를 사용해 잠재적인 문제를 조기에 감지.
  - 전역 스타일(index.css)을 가장 먼저 로드해 전체 앱에 공통 CSS 적용.

  [데이터 흐름]
  1) document.getElementById("root") 로 루트 DOM 노드 조회
  2) createRoot(...) 로 React 18+용 Root 인스턴스 생성
  3) root.render(<StrictMode><App /></StrictMode>) 로 App 트리 렌더링
*/

import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css"; // 앱 전역에 적용되는 기본 CSS
import App from "./App.jsx"; // 인증/라우팅/레이아웃의 최상위 React 컴포넌트

// 브라우저 HTML 에 정의된 <div id="root"></div> 요소를 찾아 React 루트로 사용
const rootElement = document.getElementById("root");

// React 18 스타일의 createRoot 로 렌더링 엔트리 생성
createRoot(rootElement).render(
  // StrictMode:
  // - 개발 환경에서만 추가 검사/경고를 수행
  // - 두 번 렌더 등으로 부작용 있는 코드 감지에 도움
  <StrictMode>
    <App />
  </StrictMode>
);
