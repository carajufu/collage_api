package kr.ac.collage_api.security.service.impl;


import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;

/*
RequestTokenResolver

[코드 의도]
- HTTP 요청에서 액세스 토큰을 추출하는 단일 책임 컴포넌트.
- 우선순위 고정: Authorization 헤더(Bearer) > 폼 파라미터(formToken) > JSON 바디(bodyToken).
- 검증은 하지 않음. 순수 추출기. 유효성 검사는 상위(TokenProvider 등)가 수행.

[데이터 흐름(입력→가공→출력)]
- 입력: HttpServletRequest, formToken(선택), bodyToken(선택).
- 가공: 1) Authorization 헤더 값 검사 및 "Bearer " 접두 제거
        2) 비어 있지 않은 formToken 대체
        3) 비어 있지 않은 bodyToken 대체
- 출력: 추출된 토큰 문자열 또는 null.

[계약(전제/에러/성공조건)]
- 전제: Bearer 토큰 형식은 "Authorization: Bearer <JWT>".
- 성공: 첫 유효 소스에서 토큰 1개 반환.
- 실패: 세 소스 모두 비어 있으면 null 반환. 예외 던지지 않음.

[파라미터 명세]
- req: HttpServletRequest, 필수. 헤더 조회용. 외부에서 null 금지.
- formToken: String, 선택. 폼 필드나 쿼리 파라미터에서 이미 추출된 값. 빈 문자열 무시.
- bodyToken: String, 선택. JSON 바디에서 이미 추출된 값. 빈 문자열 무시.
- 반환값: String | null. 토큰 원문. 마스킹은 로그 시 호출자가 mask 사용.

[보안·안전 전제]
- 본 클래스는 토큰을 저장하지 않음(무상태).
- 로그 출력 금지: 토큰 원문은 절대 로그로 남기지 말 것. 제공된 mask로 마스킹 필요.
- 헤더 우선 정책은 중복 전달 시 명확성 확보 목적.
- 검증·권한 부여는 상위 계층(TokenProvider.getAuthentication 등)에서 수행.

[유지보수자 가이드]
- 우선순위 변경이 필요하면 resolve 내부 분기만 수정.
- Bearer 외 스킴을 지원하려면 접두 인식 분기 추가 후 테스트 케이스 동반.
- NPE 방지: req는 컨트롤러 진입 시점에 null 아님을 보장.

[전문용어 첫 등장 풀이]
- 베어러 토큰(Bearer token, HTTP 인증 토큰 전달 규격)
				: Authorization 헤더에 토큰을 담아 전송하는 방식.
- JWT(JSON Web Token, 서명된 클레임 토큰)
				: 서버가 서명한 JSON 클레임 집합. 여기서는 포맷만 가정하고 검증은 상위 계층이 수행.

[근거]
- HTTP Authorization 스킴 관례 및 베어러 토큰 사용 관례.
*/

@Component
public class RequestTokenResolver {

    /**
     * 토큰 추출기
     *
     * 입력 우선순위:
     * 1) Authorization 헤더가 "Bearer "로 시작하면 해당 토큰을 반환
     * 2) formToken이 비어 있지 않으면 반환
     * 3) bodyToken이 비어 있지 않으면 반환
     * 세 소스 모두 비어 있으면 null
     *
     * @param req        HttpServletRequest  필수. Authorization 헤더 조회에 사용
     * @param formToken  String | null       선택. 폼/쿼리에서 사전 추출된 토큰
     * @param bodyToken  String | null       선택. JSON 바디에서 사전 추출된 토큰
     * @return           String | null       추출된 토큰. 원문. 검증하지 않음
     *
     * 계약:
     * - 예외 미발생 원칙. 입력 부재 시 null 리턴로 정규화
     * - 검증은 호출자 책임(TokenProvider.validToken 또는 getAuthentication)
     *
     * 보안 주의:
     * - 반환값을 로그에 직접 쓰지 말 것. 필요 시 mask() 사용
     */
    public String resolve(HttpServletRequest req, String formToken, String bodyToken) {
        // 1) Authorization: Bearer <JWT>
        String h = req.getHeader("Authorization");
        if (h != null && h.startsWith("Bearer ")) {
            return h.substring(7);
        }
        // 2) formToken 우선 대체
        if (formToken != null && !formToken.isEmpty()) {
            return formToken;
        }
        // 3) bodyToken 최종 대체
        if (bodyToken != null && !bodyToken.isEmpty()) {
            return bodyToken;
        }
        // 4) 없음
        return null;
    }

    /**
     * 토큰 마스킹
     *
     * 형식: 앞 10글자 + ... + 뒤 6글자
     * 길이 20 이하 또는 null이면 "<null/short>" 반환
     *
     * @param token String | null  원문 토큰
     * @return      String         마스킹 문자열
     *
     * 사용처:
     * - 운영 로그, 감사 로그 등의 안전 출력 전용
     */
    public String mask(String token) {
        if (token == null || token.length() <= 20) return "<null/short>";
        return token.substring(0, 10) + "..." + token.substring(token.length() - 6);
    }
}
