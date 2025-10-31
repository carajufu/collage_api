package kr.ac.collage_api.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AuthorVO {
    private String acntId;
    private String authorId;
    private String alwncDe;
    private String authorNm;
    private String authorDc;
}
