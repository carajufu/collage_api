package kr.ac.collage_api.index.vo;

import lombok.Data;

@Data
public class IndexCalendarEventVO { // index.jsp 전용 일정 vo

    private String type;       // 예: "ADMIN_REGIST", "ADMIN_EVENT", "TASK" ...
    private String calGroup;   // "ACAD" / "REGI" / "EVENT"
    private String startDate;  // "YYYY-MM-DD"
    private String startLabel; // "MM.dd" (없으면 JS가 startDate에서 잘라씀)
    private String title;
    private String memo;
}
