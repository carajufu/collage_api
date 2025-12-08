package kr.ac.collage_api.dashboard.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DashLectureVO {

    // 공통
    private String lctreNm;         // 강의명
    private String lctrum;          // 강의실
    private String estbllctreCode;  // 개설강의코드

    // 학생 화면 전용 (담당교수명)
    private String sklstfNm;        // 교직원명(교수명)

    // 교수 화면 전용 (수강 현황)
    private Integer currentCnt;     // 현재 수강인원
    private Integer capacityCnt;    // 정원
}
