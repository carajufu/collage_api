package kr.ac.collage_api.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import kr.ac.collage_api.security.AdminHandoverCodeStore;
import kr.ac.collage_api.service.TokenService;
import kr.ac.collage_api.vo.CreateAccessTokenResponseVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/*
AdminExchangeController — JWT 교환 브릿지

[코드 의도]
- 세션 로그인 완료 후(ROLE_ADMIN 등) SPA에 JWT를 단발 코드(code)로 안전 이관.
- 기존 JSON 교환(uI=false) 보존. uI=true일 때 임시 HTML 브릿지 제공.
- 오리진 분리(80 ↔ 5173) 환경에서 토큰을 URL 해시(#accessToken=...)로 전달. 서버 전송 없음.

[데이터 흐름]
입력: GET /api/admin/exchange?code=...&ui=(true|false)&target=(옵션)
가공:
  - ui=false: codeStore.consume(code) → tokenService.issueAccessToken(acntId)
  - ui=true : 브라우저 스크립트가 위 JSON 교환을 호출 후, target으로
             location.replace(frontendBase or target + "#accessToken=...") 이동
출력:
  - ui=false: { "accessToken": "..." }
  - ui=true : HTML(임시 페이지). 성공 시 즉시 리다이렉트

[계약]
- 프런트는 초기 부팅시 location.hash에서 accessToken을 읽어
  localStorage.setItem("accessToken", token) 저장 후 hash 제거 필요.
- JSON 교환 응답 스키마는 CreateAccessTokenResponseVO(accessToken) 고정.

[파라미터 명세]
- code: String, 필수, 단발용 핸드오버 코드. 재사용 시 401
- ui: boolean, 선택. true면 HTML 브릿지, false면 JSON
- target: String, 선택. 절대 URL(http/https) 권장. 미지정 시 frontend.base로 이동
- 헤더: 없음 필수. 캐시 금지

[보안·안전 전제]
- codeStore.consume은 재사용 불가 보장
- 토큰 로그 마스킹
- 해시는 서버로 전송되지 않음. location.replace로 히스토리에 남기지 않음
- 오픈 리다이렉트 위험을 피하려면 운영 단계에서 frontend.base 화이트리스트 관리

[유지보수 가이드]
- 프런트 오리진 변경 시 application.yml의 frontend.base만 수정
- 계약 변경 시: 해시 키 이름(accessToken)과 JSON 필드 동기화 필수

[근거]
- URL Fragment는 HTTP 요청에 포함되지 않음. 브라우저 내 전달에 적합
*/

@Slf4j
@RestController
@RequiredArgsConstructor
public class AdminExchangeController {

    private final AdminHandoverCodeStore codeStore;
    private final TokenService tokenService;

    // 기본 프런트 이동 대상. 운영 환경에서 yml로 오버라이드 권장.
    // 예) frontend.base=https://admin.example.com/app
    @Value("${frontend.base:http://localhost:5173/app}")
    private String frontendBase;

    @GetMapping(value = "/api/admin/exchange")
    public ResponseEntity<?> exchange(
            @RequestParam(required = false) String code,
            @RequestParam(required = false, defaultValue = "false") boolean ui,
            @RequestParam(required = false) String target
    ) {
        if (code == null || code.isBlank()) {
            log.info("[/api/admin/exchange] missing code");
            return ResponseEntity.badRequest().build();
        }

        // 1) HTML 브릿지 모드: 동일 오리진 JSON 교환 
        //						→ 해시로 토큰 전달 
        //							→ 프런트로 이동
        if (ui) {
            final String redirectBase = resolveTarget(target);
            final String html = """
                <!doctype html><meta charset="utf-8">
                <title>handover</title>
                <script>
                (async () => {
                  const text = (m) => document.body && (document.body.textContent = m);
                  try {
                    const params = new URLSearchParams(location.search);
                    const code = params.get("code");
                    if (!code) { text("missing code"); return; }

                    // 동일 오리진(JSON) 교환 호출. 토큰 수신.
                    const res  = await fetch("/api/admin/exchange?code=" + encodeURIComponent(code));
                    if (!res.ok) { text("exchange failed: " + res.status); return; }
                    const data = await res.json();
                    if (!data || !data.accessToken) { text("no token in response"); return; }

                    // 해시 프래그먼트에 토큰을 담아 프런트 오리진으로 이관.
                    // 서버로 전송되지 않으며, replace로 히스토리에도 남기지 않음.
                    const targetUrl = new URL(%s);
                    // 기존 해시가 있다면 보존하지 않고 교체. 필요 시 병합 로직 삽입 가능.
                    targetUrl.hash = "accessToken=" + encodeURIComponent(data.accessToken);
                    location.replace(targetUrl.toString());
                  } catch(e) {
                    text("handover failed: " + e);
                  }
                })();
                </script>
                """.formatted(toJsStringLiteral(redirectBase));

            return ResponseEntity.ok()
                    .contentType(MediaType.TEXT_HTML)
                    .cacheControl(CacheControl.noStore())
                    .body(html);
        }

        // 2) JSON 교환 모드: 코드 소비 → 액세스 토큰 발급
        final String acntId = codeStore.consume(code);
        if (acntId == null) {
            log.info("[/api/admin/exchange] invalid or consumed code");
            return ResponseEntity.status(401).build();
        }

        final String accessToken = tokenService.issueAccessToken(acntId);
        log.info("[/api/admin/exchange] issued accessToken(masked)={}", mask(accessToken));
        return ResponseEntity.ok(new CreateAccessTokenResponseVO(accessToken));
    }

    /* ===================== 내부 유틸 ===================== */

    // target이 절대 URL이면 우선 사용. 없으면 frontendBase 사용.
    private String resolveTarget(String target) {
        if (target == null || target.isBlank()) return frontendBase;
        final String t = target.trim();
        if (t.startsWith("http://") || t.startsWith("https://")) return t;
        // 상대경로가 들어오면 frontendBase로 대체. 보수적으로 처리.
        return frontendBase;
    }

    private String mask(String token) {
        if (token == null || token.length() <= 20) return "<null/short>";
        return token.substring(0, 10) + "..." + token.substring(token.length() - 6);
    }

    private String toJsStringLiteral(String s) {
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"") + "\"";
    }
}
