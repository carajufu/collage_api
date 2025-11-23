package kr.ac.collage_api.common.util;

import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.config.RequestConfig;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.io.entity.StringEntity;
import org.apache.hc.core5.util.Timeout;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

/*
[코드 의도]
- EmailJS /email/send 호출 유틸. 인증코드 메일 전송을 캡슐화.

[데이터 흐름]
- 입력: 수신자 이메일(toEmail), 인증코드(authCode), 학교명(collageName), 요청시각(requestTime), 원본 IP(requestIpRaw), 연도(year)
- 가공: IP 마스킹 → JSON 페이로드 생성(이스케이프 처리) → HTTP POST 전송
- 출력: HTTP 2xx 수신 시 true, 그 외/예외 false

[계약]
- 전제: toEmail, authCode는 공백 불가. SERVICE_ID, TEMPLATE_ID, PUBLIC_KEY는 유효해야 함.
- 성공: EmailJS가 2xx 코드 반환
- 실패: 입력 위반, 네트워크 예외, 2xx 외 응답

[보안·안전 전제]
- 템플릿 변수는 escapeJson 처리
- IP는 최소 식별만 가능하도록 마스킹 후 전송
- X-Forwarded-For는 신뢰 프록시에서 온 헤더만 사용(첫 IP만)
- 퍼블릭키 하드코딩 유지(요구사항). 운영 전 실제 값으로 교체

[유지보수자 가이드]
- 타임아웃(CONNECT 5s, RESPONSE 8s)은 환경에 맞춰 조정
- printStackTrace는 운영 로거로 교체
- 템플릿 변수 추가 시 buildPayload에만 확장
*/
public final class EmailJSClient {

    // 하드코딩 상수처리
	private static final String SERVICE_ID  = "service_dhekibe";   // 유지
    private static final String TEMPLATE_ID = "template_u87rnrr";  // 실제 템플릿 ID 확인
    private static final String PUBLIC_KEY  = "_aJobt-qQXNG4QNkk"; // 유지
    private static final String API_URL     = "https://api.emailjs.com/api/v1.0/email/send";
    
    private static final Timeout CONNECT_TIMEOUT  = Timeout.ofSeconds(5);
    private static final Timeout RESPONSE_TIMEOUT = Timeout.ofSeconds(8);

    private EmailJSClient() {}

    /** 기존 시그니처 호환용(푸터 변수 미사용 템플릿에서만 사용 권장) */
    public static boolean sendVerificationEmail(String toEmail, String authCode) {
        return sendVerificationEmail(toEmail, authCode, "", "", "", "");
    }

    /** 확장 시그니처: 푸터 변수 포함 전송 */
    public static boolean sendVerificationEmail(
            String toEmail,
            String authCode,
            String collageName,
            String requestTime,
            String requestIpRaw,
            String year
    ) {
        if (isBlank(toEmail) || isBlank(authCode)) return false; // 계약 위반

        final String maskedIp = maskIp(requestIpRaw); // 최소 식별 마스킹

        final RequestConfig rc = RequestConfig.custom()
                .setConnectTimeout(CONNECT_TIMEOUT)
                .setResponseTimeout(RESPONSE_TIMEOUT)
                .build();

        try (CloseableHttpClient client = HttpClients.custom()
                .setDefaultRequestConfig(rc)
                .build()) {

            HttpPost req = new HttpPost(API_URL);
            req.setHeader("origin", "http://localhost"); // EmailJS 허용 도메인과 일치 필요
            req.setHeader("Accept", "application/json");
            req.setHeader("Content-Type", "application/json; charset=UTF-8");

            String payload = buildPayload(toEmail, authCode, collageName, requestTime, maskedIp, year);
            req.setEntity(new StringEntity(payload, ContentType.APPLICATION_JSON.withCharset(StandardCharsets.UTF_8)));

            try (CloseableHttpResponse res = client.execute(req)) {
                int code = res.getCode();
                return code >= 200 && code < 300;
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // JSON 페이로드 생성(이스케이프 필수). 템플릿 변수 키는 EmailJS 템플릿과 일치시킬 것.
    private static String buildPayload(
            String toEmail, String authCode, String collageName,
            String requestTime, String requestIpMasked, String year
    ) {
        return "{\n" +
                "  \"service_id\": \"" + SERVICE_ID + "\",\n" +
                "  \"template_id\": \"" + TEMPLATE_ID + "\",\n" +
                "  \"user_id\": \"" + PUBLIC_KEY + "\",\n" +
                "  \"template_params\": {\n" +
                "    \"to_email\": \"" + escapeJson(toEmail) + "\",\n" +
                "    \"auth_code\": \"" + escapeJson(authCode) + "\",\n" +
                "    \"collage_name\": \"" + escapeJson(collageName) + "\",\n" +
                "    \"request_time\": \"" + escapeJson(requestTime) + "\",\n" +
                "    \"request_ip\": \"" + escapeJson(requestIpMasked) + "\",\n" +
                "    \"year\": \"" + escapeJson(year) + "\"\n" +
                "  }\n" +
                "}";
    }

    // IPv4: 마지막 옥텟 마스킹 → a.b.c.xxx
    // IPv6: 좌측 4헥스텟 보존 + 나머지 **** → 2001:db8:85a3:8d3:****:****:****:**** 
    // X-Forwarded-For: 콤마 기준 첫 항목 사용(신뢰 프록시 가정)
    private static String maskIp(String ip) {
        if (ip == null) return "";
        String s = ip.trim();
        int comma = s.indexOf(',');
        if (comma > 0) s = s.substring(0, comma).trim(); // XFF 첫 IP
        int pct = s.indexOf('%');
        if (pct > 0) s = s.substring(0, pct);            // zone id 제거

        if (s.contains(":")) { // IPv6
            String[] tokens = s.split(":");
            StringBuilder sb = new StringBuilder();
            int kept = 0;
            for (String t : tokens) {
                if (t.isEmpty()) continue;
                if (kept < 4) {
                    if (sb.length() > 0) sb.append(':');
                    sb.append(t);
                    kept++;
                } else break;
            }
            if (kept == 0) sb.append("::");
            sb.append(":****:****:****:****");
            return sb.toString();
        } else { // IPv4
            String[] oct = s.split("\\.");
            if (oct.length == 4) {
                return oct[0] + "." + oct[1] + "." + oct[2] + ".xxx";
            }
            return "xxx.xxx.xxx.xxx";
        }
    }

    // 최소 JSON 이스케이프
    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
