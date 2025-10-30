package kr.ac.collage_api.learning.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TaskVO {
    private String taskNo;
    private String weekAcctoLrnNo;
    private String taskSj;
    private String taskCn;
    private String taskBeginDe;
    private String taskClosDe;
    private String registDt;
    private String updtDt;
}
