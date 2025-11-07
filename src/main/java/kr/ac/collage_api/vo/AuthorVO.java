package kr.ac.collage_api.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class AuthorVO {
    private String acntId;
<<<<<<< HEAD
    private String authorId; //권한ID(PK)	AUTHOR_ID(PK)
    private String alwncDe; //부여일자	ALWNC_DE
    private String authorNm; //권한_명	AUTHOR_NM
    private String authorDc; //권한_설명	AUTHOR_DC
=======
    private String authorId;
    private String alwncDe;
    private String authorNm;
    private String authorDc;
>>>>>>> 26a4290 (please)
}
