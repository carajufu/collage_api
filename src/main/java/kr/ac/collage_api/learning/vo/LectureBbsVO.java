package kr.ac.collage_api.learning.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class LectureBbsVO {
    private String estbllctreCode;
    private String bbsNm;
    private String bbsDc;
    private int bbsCode;

    private List<LectureBbsCttVO> lectureBbsCttVOList;
}
