package kr.ac.collage_api.learning.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class QuizVO {
    private String quizCode;
    private String weekAcctoLrnNo;
    private String quesCn;

    private List<QuizExVO> quizeExVOList;
}
