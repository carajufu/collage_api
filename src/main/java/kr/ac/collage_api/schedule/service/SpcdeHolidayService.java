package kr.ac.collage_api.schedule.service;

import java.time.LocalDate;
import java.util.List;

import kr.ac.collage_api.schedule.vo.CalendarEventVO;

/**
 * 공휴일 조회 서비스
 *
 * 계약
 * - start, endInclusive: 모두 포함 범위 [start, endInclusive]
 * - start > endInclusive 이면 빈 리스트 반환.
 * - 반환: YYYY-MM-DD 형식 start 필드를 가진 공휴일 이벤트 목록.
 */
public interface SpcdeHolidayService {

    List<CalendarEventVO> getSpecialDays(LocalDate start, LocalDate endInclusive);

}
