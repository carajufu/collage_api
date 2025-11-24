package kr.ac.collage_api.learning.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
public class LectureBbsCttVO {
    private int bbscttNo;
    private String acntId;
    private int bbsCode;
    private int parntsBbscttNo;
    private int fileGroupNo;
    private String bbscttSj;
    private String bbscttCn;
    private Date bbscttWritngDe;
    private int bbscttRdcnt;

    private int rownum;
    private String sklstfNm;
    private String stdntNm;
    private String role;
    private String name;
}
