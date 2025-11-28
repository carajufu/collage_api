package kr.ac.collage_api.learning.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class QuizPresentnVO {
    private String quizPresentnNo;
    private String stdntNo;
    private String quizCode;
    private String quizExCode;
    private String quizPresentnDe;
    private String presentnAt;

    private String stdntNm;
    private String week;
}
