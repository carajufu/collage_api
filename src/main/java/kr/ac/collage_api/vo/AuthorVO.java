package kr.ac.collage_api.vo;

import lombok.Data;

@Data
public class AuthorVO { // 권한 테이블
    private String alwncDe;   // 허용일자 등 도메인 의미. 문자열(yyyymmdd 등)
    private String authorId;  // 권한/역할 ID 또는 식별자
    private String authorNm;  // 권한/역할 이름
    private String authorDc;  // 권한/역할 설명
    private String acntId;    // 소유 계정 ID (ACNT.ACNT_ID)
}
