package kr.ac.collage_api.service.impl;

import kr.ac.collage_api.service.SpcdeHolidayService;
import kr.ac.collage_api.vo.CalendarEventVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * 공공데이터포털 특일 API 연동 구현체.
 *
 * 설계 요약 (현업 기준 타당성 확보용):
 *
 * 1) 단일 책임:
 *    - 외부 공개 API(SpcdeInfoService) 호출
 *    - 응답 → CalendarEventVO 변환
 *    - 같은 날 의미 중복 이벤트 정제
 *
 * 2) 퍼포먼스:
 *    - 연/월/카테고리 단위 캐시 (monthCache) 사용
 *    - 동일 월 재조회 시 외부 API 재호출 방지
 *    - FullCalendar 월 이동 시 느려지는 문제 최소화
 *
 * 3) 도메인 정합성:
 *    - [start, endInclusive] 범위만 필터링
 *    - 공휴일/기념일 중복 제거 규칙 명시:
 *      a) 같은 날짜, 숫자 패턴 동일(예: 610) → 하나로 병합
 *      b) 같은 날짜, 정규화 제목 유사도 >= 50% → 하나로 병합
 *      c) 병합 시 우선순위:
 *         - isHoliday = true 우선
 *         - category = "HOLIDAY" 우선
 *         - 나머지는 먼저 선택된 이벤트 유지
 *
 * 4) 뷰 연계:
 *    - CalendarEventVO.start: "YYYY-MM-DD"
 *    - allDay = true
 *    - end는 컨트롤러에서 FullCalendar 규약에 맞게 처리
 */
@Service
@RequiredArgsConstructor
public class SpcdeHolidayServiceImpl implements SpcdeHolidayService {

    // 실서비스에서는 설정 externalization 필요. 데모용 하드코딩.
    private final String serviceKey =
            "8b06d70a444d1b1af808900fb7944cd5973d3c6c7acb6cc1415c4c43bc6a237e";

    private final RestTemplate restTemplate = new RestTemplate();

    private static final String BASE =
            "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService";

    /**
     * 월/카테고리 단위 캐시.
     *
     * key: "YYYYMM|CATEGORY"
     * val: 해당 조건의 원본 CalendarEventVO 목록(불변 리스트)
     *
     * 이유:
     * - 공휴일 데이터는 자주 안 바뀜.
     * - FullCalendar는 같은 월을 반복 조회.
     * - 매번 외부 API 부르면 /api/schedule/events 체감 지연 발생.
     */
    private final ConcurrentMap<String, List<CalendarEventVO>> monthCache =
            new ConcurrentHashMap<>();

    @Override
    public List<CalendarEventVO> getSpecialDays(LocalDate start, LocalDate endInclusive) {
        List<CalendarEventVO> raw = new ArrayList<>();

        // 잘못된 입력 방어
        if (start == null || endInclusive == null || start.isAfter(endInclusive)) {
            return raw;
        }

        // [1] 범위 내 YearMonth 순회, 캐시 활용 수집
        YearMonth ym = YearMonth.from(start);
        YearMonth endYm = YearMonth.from(endInclusive);

        while (!ym.isAfter(endYm)) {
            int year = ym.getYear();
            String month = String.format("%02d", ym.getMonthValue());

            raw.addAll(fetchWithCache(BASE + "/getRestDeInfo", year, month, "HOLIDAY")); 
            // 법정 공휴일
            //------------------------------------------------------------
            // raw.addAll(fetchWithCache(BASE + "/getHoliDeInfo", year, month, "NATION"));  
            // 국경일
            // raw.addAll(fetchWithCache(BASE + "/getAnniversaryInfo", year, month, "ANNIV")); 
            // 기념일

            ym = ym.plusMonths(1);
        }

        // [2] 요청 기간 [start, endInclusive]로 필터
        List<CalendarEventVO> inRange = raw.stream()
                .filter(e -> {
                    LocalDate d = LocalDate.parse(e.getStart());
                    return !d.isBefore(start) && !d.isAfter(endInclusive);
                })
                .toList();

        // [3] 날짜 기준 의미 중복 병합
        // 데이터량 제한적이라 O(n^2) 로직으로도 충분. 유지보수성 우선.
        List<CalendarEventVO> merged = new ArrayList<>();

        for (CalendarEventVO cur : inRange) {
            int sameIdx = -1;

            for (int i = 0; i < merged.size(); i++) {
                CalendarEventVO ex = merged.get(i);

                // 다른 날짜는 비교 불필요
                if (!ex.getStart().equals(cur.getStart())) {
                    continue;
                }

                // "같은 날 + 같은 맥락" 판단:
                // 1) 숫자 패턴 동일
                // 2) 정규화 제목 유사도 >= 0.5
                if (sameNumberPattern(ex, cur)
                        || similarTitle(ex.getTitle(), cur.getTitle(), 0.5)) {
                    sameIdx = i;
                    break;
                }
            }

            if (sameIdx < 0) {
                merged.add(cur);
            } else {
                merged.set(sameIdx, pickPreferred(merged.get(sameIdx), cur));
            }
        }

        return merged;
    }

    /**
     * 캐시 + 실제 호출 래퍼.
     * 동일 (YYYYMM, CATEGORY)에 대해 최초 1회만 fetch 수행.
     */
    private List<CalendarEventVO> fetchWithCache(
            String url, int year, String month, String category) {

        String key = year + month + "|" + category;

        List<CalendarEventVO> cached = monthCache.get(key);
        if (cached != null) {
            return cached;
        }

        List<CalendarEventVO> fetched = fetch(url, year, month, category);
        List<CalendarEventVO> immutable = List.copyOf(fetched);
        monthCache.putIfAbsent(key, immutable);
        return monthCache.get(key);
    }

    /**
     * 공공데이터포털 API 호출 및 CalendarEventVO 매핑.
     *
     * 실패 시 빈 리스트 반환. 상위 로직이 그대로 동작하도록 방어.
     */
    @SuppressWarnings("unchecked")
    private List<CalendarEventVO> fetch(
            String url, int year, String month, String category) {

        String reqUrl = url
                + "?ServiceKey=" + serviceKey
                + "&_type=json"
                + "&pageNo=1&numOfRows=100"
                + "&solYear=" + year
                + "&solMonth=" + month;

        Object res = restTemplate.getForObject(reqUrl, Map.class);
        if (!(res instanceof Map<?, ?> top)) return List.of();

        Map<String, Object> response = (Map<String, Object>) top.get("response");
        if (response == null) return List.of();

        Map<String, Object> body = (Map<String, Object>) response.get("body");
        if (body == null) return List.of();

        Object itemsObj = body.get("items");
        if (!(itemsObj instanceof Map<?, ?> items)) return List.of();

        Object itemObj = items.get("item");
        if (itemObj == null) return List.of();

        List<Map<String, Object>> rows = new ArrayList<>();

        if (itemObj instanceof List<?>) {
            for (Object o : (List<?>) itemObj) {
                if (o instanceof Map<?, ?> m) {
                    rows.add((Map<String, Object>) m);
                }
            }
        } else if (itemObj instanceof Map<?, ?> m) {
            rows.add((Map<String, Object>) m);
        }

        List<CalendarEventVO> list = new ArrayList<>();

        for (Map<String, Object> it : rows) {
            Object loc = it.get("locdate");
            if (loc == null) continue;

            String date = String.valueOf(loc);
            if (date.length() != 8) continue;

            String y = date.substring(0, 4);
            String m2 = date.substring(4, 6);
            String d = date.substring(6, 8);

            String dateName = String.valueOf(it.getOrDefault("dateName", ""));
            String isHoliday = String.valueOf(it.getOrDefault("isHoliday", "N"));
            boolean holiday = "Y".equalsIgnoreCase(isHoliday);

            CalendarEventVO e = new CalendarEventVO();
            e.setTitle(dateName);
            e.setStart(y + "-" + m2 + "-" + d); // ISO_LOCAL_DATE
            e.setAllDay(true);
            e.setCategory(category);
            e.setHoliday(holiday);
            e.setColor(holiday ? "#f87171" : "#60a5fa");

            list.add(e);
        }

        return list;
    }

    // ========= 중복 판단 및 선택 유틸 =========

    /**
     * 같은 날짜 이벤트의 숫자 패턴 비교.
     * 예: "6·10민주항쟁", "6·10만세운동" → "610" 동일 → true.
     */
    private boolean sameNumberPattern(CalendarEventVO a, CalendarEventVO b) {
        String da = extractDigits(a.getTitle());
        String db = extractDigits(b.getTitle());
        if (da.isEmpty() || db.isEmpty()) return false;
        return da.equals(db);
    }

    private String extractDigits(String s) {
        if (s == null) return "";
        return s.replaceAll("\\D", "");
    }

    /**
     * 제목 유사도 체크.
     *
     * normalizeTitle:
     *  - 공백 제거
     *  - 구두점/중점 제거
     *  - 소문자화
     *
     * 유사도:
     *  - 앞에서부터 같은 인덱스 문자의 비율 = same / maxLen
     *  - threshold(기본 0.5) 이상이면 같은 맥락으로 본다.
     *
     * 공휴일/기념일 텍스트 규모 기준으로 간단하지만 충분한 근사.
     */
    private boolean similarTitle(String a, String b, double threshold) {
        String na = normalizeTitle(a);
        String nb = normalizeTitle(b);
        if (na.isEmpty() || nb.isEmpty()) return false;

        int maxLen = Math.max(na.length(), nb.length());
        int minLen = Math.min(na.length(), nb.length());
        if (maxLen == 0) return false;

        int same = 0;
        for (int i = 0; i < minLen; i++) {
            if (na.charAt(i) == nb.charAt(i)) same++;
        }

        double ratio = (double) same / maxLen;
        return ratio >= threshold;
    }

    private String normalizeTitle(String s) {
        if (s == null) return "";
        return s
                .replaceAll("\\s+", "")
                .replaceAll("[\\p{Punct}·]", "")
                .toLowerCase();
    }

    /**
     * 같은 날짜·같은 맥락 이벤트 중 우선 노출할 하나 선택.
     *
     * 우선순위:
     * 1) isHoliday = true
     * 2) category = "HOLIDAY"
     * 3) 그 외: 기존 값 유지 (결과 안정성)
     */
    private CalendarEventVO pickPreferred(CalendarEventVO ex, CalendarEventVO cur) {
        if (!ex.isHoliday() && cur.isHoliday()) return cur;
        if (ex.isHoliday() && !cur.isHoliday()) return ex;

        boolean exHolidayCat = "HOLIDAY".equalsIgnoreCase(ex.getCategory());
        boolean curHolidayCat = "HOLIDAY".equalsIgnoreCase(cur.getCategory());
        if (!exHolidayCat && curHolidayCat) return cur;
        if (exHolidayCat && !curHolidayCat) return ex;

        return ex;
    }
}
