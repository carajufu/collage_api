package kr.ac.collage_api.common.util;

import com.ibm.icu.text.Transliterator;

/**
 * KorNameTranUtil
 *
 * 역할:
 * - 학생 한글 이름을 증명서용 영문 표기 문자열로 만든다.
 *
 * 규칙:
 * 1) DB에 STDNT_NM_ENG 등 공식 영문명이 있으면 그 값을 그대로 사용.
 * 2) 없으면 한글 이름을 로마자화해서 fallback으로 사용.
 * 3) 결과는 전시용일 뿐 법적 영문명 아님.
 *
 * 보안:
 * - 개인정보라서 운영 로그에 그대로 찍지 말 것.
 */
public final class KorNameTranUtil {

    // 한글 -> 로마자(ASCII) 변환기
    private static final Transliterator KOR_TO_LATIN =
            Transliterator.getInstance("Any-Latin; Latin-ASCII");

    // 인스턴스화 금지
    private KorNameTranUtil() { }

    /**
     * korName    : 한글 이름 (필수, 예 "홍길동")
     * engNameDb  : DB 저장된 영문 이름 (없으면 null 또는 빈 문자열)
     *
     * return:
     *  - engNameDb가 유효하면 그 값
     *  - 아니면 korName을 로마자화한 값 (예 "Hong Gil Dong")
     */
    public static String resolveDisplayEngName(String korName, String engNameDb) {

        // 1) DB에 이미 등록된 영문명이 있으면 우선 사용
        if (engNameDb != null && !engNameDb.isBlank()) {
            return engNameDb.trim();
        }

        // 2) 없으면 한글 이름을 로마자 변환
        String romanized = KOR_TO_LATIN.transliterate(korName);

        // 3) "hong gil dong" -> "Hong Gil Dong" 식으로 가독성 정리
        return normalizeCapitalization(romanized);
    }

    // 내부 전용: 각 단어 첫 글자만 대문자
    private static String normalizeCapitalization(String raw) {
        if (raw == null || raw.isBlank()) {
            return "";
        }

        String[] parts = raw.toLowerCase().trim().split("\\s+");
        StringBuilder sb = new StringBuilder();

        for (String p : parts) {
            if (p.isEmpty()) continue;
            sb.append(Character.toUpperCase(p.charAt(0)))
              .append(p.substring(1))
              .append(" ");
        }

        return sb.toString().trim();
    }
}
