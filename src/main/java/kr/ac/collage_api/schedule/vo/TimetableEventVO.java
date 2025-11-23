package kr.ac.collage_api.schedule.vo;

import lombok.Data;

@Data
public class TimetableEventVO {

    // FullCalendar 기본 필드 매핑
    private String id;              // TIMETABLE_NO 또는 ESTBLLCTRE_CODE+슬롯 식별자
    private String title;           // 캘린더 셀에 노출 (과목명/강의실/인원 등)
    private String startDateTime;   // ISO 8601: 2025-11-03T09:00:00
    private String endDateTime;     // ISO 8601
    private String type;            // "STUDENT" or "PROF"

    // 공통 정보
    private String estblLctreCode;  // ESTBLLCTRE_CODE
    private String lectureCode;     // LCTRE_CODE (ALL_COURSE)
    private String lectureName;     // LCTRE_NM
    private String room;            // ESTBL_COURSE.LCTRUM
    private String year;            // ESTBL_YEAR
    private String semstr;          // ESTBL_SEMSTR

    // 학생 뷰용
    private String profName;        // SKLSTF_NM
    private String profDeptName;    // SUBJCT.SUBJCT_NM (교수 소속)

    // 교수 뷰용
    private Integer studentCount;   // 수강 인원 (ATNLC_REQST count)
    private Integer maxStudent;     // ESTBL_COURSE.ATNLC_NMPR

}