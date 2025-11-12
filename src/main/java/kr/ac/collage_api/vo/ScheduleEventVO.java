package kr.ac.collage_api.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;
/**
 * FullCalendar 연동용 통합 이벤트 VO
 *
 * 매퍼 select*Events 계열의 resultType 대상.
 * ISO 8601 포맷(start, end)에 맞춰 컨트롤러/서비스에서 변환해서 사용.
 */
@Data
@Alias("ScheduleEvent")
public class ScheduleEventVO {
    private String id;       // 식별자 (문자열 통일)
    private String title;    // 표시 제목
    private String type;     // LECTURE / TASK / PROJECT / COUNSEL / ENROLL_REQ / ADMIN_...
    private String place;    // 장소(옵션)
    private String target;   // 대상 식별자(옵션, ADMIN용)
    private String memo;     // 부가 정보(옵션, 풀캘린더 상세 or 관리자 참고용)
    private String startDate;    // ISO8601 or yyyy-MM-ddTHH:mm
    private String endDate;      // 동일 포맷
    private boolean allDay;  // 종일 여부
}