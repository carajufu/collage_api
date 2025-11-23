package kr.ac.collage_api.schedule.vo;

import lombok.Data;

@Data
public class CalendarEventVO { // 캘린더 전용 VO
    private String title;     // 일정 제목
    private String start;     // YYYY-MM-DD
    private boolean allDay;   // 항상 true
    private String category;  // HOLIDAY / NATION / ANNIV / TERM24 / ETC
    private boolean holiday;  // 공공기관 휴무 여부(isHoliday == 'Y')
    private String color;     // 선택 (ex. 공휴일 전용 색)
}